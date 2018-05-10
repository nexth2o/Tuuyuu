//
//  HomeViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/5/8.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "HomeViewController.h"
#import "SDCycleScrollView.h"
#import "BannerCell.h"
#import "ButtonCell.h"
#import "SeckillCell.h"
#import "PopularCell.h"
#import "SingleProductTitleCell.h"
#import "SingleProductCell.h"
#import "SearchStoreViewController.h"
#import "NotificationViewController.h"
#import "SearchViewController.h"
#import "CategoryViewController.h"
#import "ProductViewController.h"
#import "SaleProductViewController.h"
#import "DiscountProductViewController.h"
#import "ProductDetailViewController.h"
#import "MineFavoriteViewController.h"
#import "BonusViewController.h"
#import "TPayViewController.h"
#import "PopView.h"
#import "LoginViewController.h"
#import "CartInfoDAL.h"
#import "CartInfoEntity.h"
#import "BadgeView.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, SeckillCellDelegate> {
    
    CGFloat bannerHeight;
    
    CGFloat buttonHeight;
    
    NSArray *seckillArray;
    
    UIView *popContentView;
    
    UIImageView *signImage;
}

@property (nonatomic, strong) UITableView *contentView;
@property (nonatomic, strong) NSDictionary *homeDic;
@property (nonatomic, strong) UIButton *cartBtn;
@property (nonatomic, strong) UILabel *closeTips;
@property (nonatomic) NSUInteger totalOrders;
@property (nonatomic, strong) dispatch_source_t payTimer;
@property (nonatomic, strong) BadgeView *badge;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {

        navigationBar.backgroundColor = [UIColor colorWithRed:(255)/255.0 green:(184)/255.0 blue:(63)/255.0 alpha:0.0];
        navigationBar.locationLabel.text = @"";
        [navigationBar.locationLabel setHidden:NO];
        [navigationBar.locationButton setHidden:NO];
        [navigationBar.searchButton setHidden:NO];
        [navigationBar.rightButton setBackgroundImage:[UIImage imageNamed:@"home_notice"] forState:UIControlStateNormal];
        [navigationBar.rightButton setHidden:NO];
        
        //广告栏高度
        bannerHeight = 200*SCALE;
        
        //按钮高度
        buttonHeight = 190*SCALE;
        
        _contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.separatorStyle = NO;
        _contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:_contentView];
        _contentView.contentInset = UIEdgeInsetsMake(0, 0, -10*SCALE, 0);
        
        _contentView.estimatedRowHeight = 0;
        _contentView.estimatedSectionHeaderHeight = 0;
        _contentView.estimatedSectionFooterHeight = 0;
        
        if (@available(iOS 11.0, *)) {
            _contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
           self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        popContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 202*SCALE, 280*SCALE)];
        popContentView.backgroundColor = [UIColor clearColor];
        signImage = [[UIImageView alloc]initWithFrame:popContentView.bounds];
        [popContentView addSubview:signImage];
        
        [self.view bringSubviewToFront:navigationBar];
        
        _closeTips = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -120*SCALE, SCREEN_HEIGHT-60*SCALE-0*SCALE-BOTTOM_BAR_HEIGHT, 100*SCALE, 40*SCALE)];
        _closeTips.text = @"外卖打烊啦";
        _closeTips.layer.backgroundColor = UIColorFromRGB(76,76,76).CGColor;
        _closeTips.alpha = 0.9;
        _closeTips.textAlignment = NSTextAlignmentCenter;
        _closeTips.font = [UIFont systemFontOfSize:16*SCALE];
        _closeTips.textColor = [UIColor whiteColor];
        _closeTips.layer.cornerRadius = 8;
        [_closeTips setHidden:YES];
        [self.view addSubview:_closeTips];
        
        _cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cartBtn setFrame:CGRectMake(SCREEN_WIDTH -60*SCALE, SCREEN_HEIGHT-60*SCALE-0*SCALE-BOTTOM_BAR_HEIGHT, 60*SCALE, 60*SCALE)];
        [_cartBtn setBackgroundImage:[UIImage imageNamed:@"home_air_cart"] forState:UIControlStateNormal];//默认空车
        _cartBtn.titleLabel.font = [UIFont systemFontOfSize:13.0*SCALE];
        [_cartBtn addTarget:self action:@selector(cartBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cartBtn];
        
        //设置角标位置
        _badge = [[BadgeView alloc] initWithFrame:CGRectMake(_cartBtn.frame.size.width - 22*SCALE, 4*SCALE, 15*SCALE, 15*SCALE) withString:nil];
        [_cartBtn addSubview:_badge];
        
        weakify(self);
        self.emptyView.reloadBlock = ^()
        {
            strongify(self);
            [self reloadBtnEvent];
            
        };
        
        [_contentView setHidden:YES];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnect) name:@"ssy" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadStore) name:@"reloadStore" object:nil];
    
    if ([[UserDefaults service] getSelectedViewController] == YES) {
        [self.tabBarController setSelectedIndex:2];
        [[UserDefaults service] updatesSelectedViewController:NO];
    }
    
    navigationBar.locationLabel.text = [[UserDefaults service] getStoreName];

    if ([self networkStatus] == YES) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self checkVersion];
        });
        
        [self reloadStore];
    }else {
        [self disconnect];
    }
}

- (void)reloadStore {
   
    [self hideLoadHUD:YES];
    
    if ([[UserDefaults service] relocation] == YES) {
        [self reloadBtnEvent];
    }else {
        [self reloadData];
    }
}

- (void)checkVersion {
    
    NSDictionary *paramDic = [[NSDictionary alloc] init];
    
    [HttpClientService requestCheckVersion:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *storeVersion = jsonDic[@"results"][0][@"version"];

        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                                                              
        if (appVersion.length > 0 && storeVersion.length > 0) {
            if (![appVersion isEqualToString:storeVersion]) {
//                [self updateAlert];
            }
        }
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
    }];

}

- (void)updateAlert {
    UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:@"更新提醒" message:@"有新的版本发布，是否更新？" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *NOButton = [UIAlertAction actionWithTitle:@"更新" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@", APPID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }];
    
    [storeExistAlert addAction:OKButton];
    
    [storeExistAlert addAction:NOButton];
    
    [self presentViewController:storeExistAlert animated:YES completion:nil];
}

- (void)disconnect {
    [_closeTips setHidden:YES];
    [_cartBtn setHidden:YES];
    
    [_contentView setHidden:YES];
    [self showEmptyViewWithStyle:EmptyViewStyleNetworkUnreachable];
}


- (void)reloadBtnEvent {
    [_contentView setHidden:YES];
    [self hideEmptyView];
    
    [self showLoadHUDMsg:@"努力定位中..."];
    
    NSString *lat = @"";
    NSString *log = @"";
    if ([[UserDefaults service] getLatitude] && [[UserDefaults service] getLongitude]) {
        lat = [[UserDefaults service] getLatitude];
        log = [[UserDefaults service] getLongitude];
    }else {
        //河畔二期店 经纬度
        lat = @"41.652875";
        log = @"123.333189";
    }
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:lat, @"latitude", log, @"longitude", nil];
 
    [HttpClientService requestStoreaddress:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            [self hideLoadHUD:YES];

            //如果有推荐
            int recommended = [[jsonDic objectForKey:@"rec_flag"] intValue];
            if (recommended == 1) {
                [[UserDefaults service] updateStoreId:[jsonDic objectForKey:@"rec_cvs_no"]];
                [[UserDefaults service] updateStoreName:[jsonDic objectForKey:@"rec_cvs_name"]];
                [[UserDefaults service] updateStoreLatitude:[jsonDic objectForKey:@"rec_latitude"]];
                [[UserDefaults service] updateStoreLongitude:[jsonDic objectForKey:@"rec_longitude"]];
                
                [self reloadData];
                
            }else {
                if ([[UserDefaults service] getStoreId].length > 0) {
                    [self reloadData];
                }else {
                    [self outSideAddress];
                }
            }
        }
        
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        [self showEmptyViewWithStyle:EmptyViewStyleNetworkUnreachable];
    }];
}

- (void)outSideAddress {
    
    UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前位置两公里范围内没有配送店铺，请选择浏览店铺。" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        SearchStoreViewController *searchStoreViewController = [[SearchStoreViewController alloc] init];
        PUSH(searchStoreViewController);
    }];
    
    [storeExistAlert addAction:OKButton];
    
    [self presentViewController:storeExistAlert animated:YES completion:nil];
}

- (void)reloadData {
    [_contentView setHidden:YES];
    [self showLoadHUDMsg:@"努力加载中..."];
    
    navigationBar.locationLabel.text = [[UserDefaults service] getStoreName];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:[[UserDefaults service] getStoreId], @"cvs_no", nil];
    weakify(self);
    [HttpClientService requestIndex:paramDic success:^(id responseObject) {
        
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            [self.contentView setHidden:NO];
            [self hideEmptyView];
            
            self.homeDic = [[NSDictionary alloc] initWithDictionary:jsonDic];
            
            [self.contentView setHidden:NO];
            
            [self.contentView reloadData];
            
            //存店铺活动
            [[UserDefaults service] updateStoreSales:[NSMutableArray arrayWithArray:[jsonDic objectForKey:@"promo_list"]]];
            
            if ([[jsonDic objectForKey:@"is_opening"] isEqualToString:@"0"]) {
                [[UserDefaults service] updateOperatingState:NO];
            }else {
                [self.closeTips setHidden:YES];
                [self.cartBtn setHidden:NO];
                [[UserDefaults service] updateOperatingState:YES];
            }
            
            [self hideLoadHUD:YES];
            
            [[UserDefaults service] updateRelocation:NO];
            
        }else if (status == 202) {
            [self showMsg:@"您的登录状态失效，请重新登录"];
            [self hideLoadHUD:YES];
            sleep(1.0);
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
            
        }else {
            [self hideLoadHUD:YES];
        }
        
    } failure:^(NSError *error) {
        strongify(self);
        [self hideLoadHUD:YES];
        [self.closeTips setHidden:YES];
        [self.cartBtn setHidden:YES];
        
        [self.contentView setHidden:YES];
        [self showEmptyViewWithStyle:EmptyViewStyleNetworkUnreachable];
        
    }];
    
    _totalOrders = 0;
    
    //取DB最新
    CartInfoDAL *dal = [[CartInfoDAL alloc] init];
    NSMutableArray *entityArray = [dal queryCartInfo];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < entityArray.count; i++) {
        CartInfoEntity *entity = [[CartInfoEntity alloc] init];
        entity = entityArray[i];
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
        
        [tempDic setObject:entity.product_no forKey:@"product_no"];
        [tempDic setObject:entity.cvs_no forKey:@"cvs_no"];
        [tempDic setObject:entity.orderCount forKey:@"orderCount"];
        [tempDic setObject:entity.descriptionn forKey:@"description"];
        [tempDic setObject:entity.dis_price forKey:@"dis_price"];
        
        [tempArray addObject:tempDic];
        
        _totalOrders += [entity.orderCount integerValue];
    }
    
    _badge.badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)_totalOrders];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 1;
    }else if (section == 2) {
        return 1;
    }else if (section == 3) {
        return 1;
    }else {
        if ([_homeDic[@"special_goods"] count] > 0) {
            return [_homeDic[@"special_goods"] count]/2 + 1;
        }else {
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return bannerHeight;
    }else if (indexPath.section == 1) {
        return buttonHeight;
    }else if (indexPath.section == 2) {
        
        if ([_homeDic[@"seckill"] count] > 0 || [_homeDic[@"sp_offer"] count] > 0) {
            return 180*SCALE+250*SCALE;
        }else {
            return 250*SCALE;
        }
        
    }else if (indexPath.section == 3) {
        return 280*SCALE;
    }else {
        if ([_homeDic[@"special_goods"] count] > 0) {
            if (indexPath.row == 0) {
                return 30*SCALE;
            }else{
                return 250*SCALE;
            }
        }else {
            return 0*SCALE;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myCellIdentifier1 = @"MyCellIdentifier1";
    static NSString *myCellIdentifier2 = @"MyCellIdentifier2";
    static NSString *myCellIdentifier3 = @"MyCellIdentifier3";
    static NSString *myCellIdentifier4 = @"MyCellIdentifier4";
    static NSString *myCellIdentifier5 = @"MyCellIdentifier5";
    static NSString *myCellIdentifier6 = @"MyCellIdentifier6";
    
    UITableViewCell *cell = nil;
    
    
    if (indexPath.section == 0) {
        BannerCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier1];
        
        if (!cell) {
            cell = [[BannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cycleScrollView.delegate = self;
        
        //TODO 改善性能
        NSMutableArray *imageUrls = [NSMutableArray array];
        
        NSArray *bannerArray = [NSArray arrayWithArray:_homeDic[@"home_show"]];
        for (int i = 0; i < bannerArray.count; i++) {
            [imageUrls addObject:[bannerArray objectAtIndex:i][@"img_url"]];
        }
        
        [cell.cycleScrollView setImageURLStringsGroup:imageUrls];
        
        return cell;
    }else if (indexPath.section == 1) {
        ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier2];
        
        if (!cell) {
            cell = [[ButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier2];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //按钮区
        cell.categoryBtnEvent = ^() {
            NSLog(@"商品分类");
            CategoryViewController *categoryViewController = [[CategoryViewController alloc] initWithNibName:nil bundle:nil];
            [categoryViewController.orderDictionary setObject:@"0" forKey:@"isUp"];
            PUSH(categoryViewController);
        };
        
        cell.friedBtnEvent = ^() {
//            NSLog(@"炸鸡美食");
            ProductViewController *productViewController = [[ProductViewController alloc] initWithNibName:nil bundle:nil];
            [productViewController.paramDictionary setObject:@"炸鸡美食" forKey:@"title"];
            [productViewController.paramDictionary setObject:@"5" forKey:@"type"];
            
            PUSH(productViewController);
        };
        
        cell.fastBtnEvent = ^() {
//            NSLog(@"熟食快餐");
            ProductViewController *productViewController = [[ProductViewController alloc] initWithNibName:nil bundle:nil];
            [productViewController.paramDictionary setObject:@"熟食快餐" forKey:@"title"];
            [productViewController.paramDictionary setObject:@"6" forKey:@"type"];
            
            PUSH(productViewController);
        };
        
        cell.couponBtnEvent = ^() {
//            NSLog(@"领劵中心");
            ProductViewController *productViewController = [[ProductViewController alloc] initWithNibName:nil bundle:nil];
            [productViewController.paramDictionary setObject:@"烘培面包" forKey:@"title"];
            [productViewController.paramDictionary setObject:@"7" forKey:@"type"];
            
            PUSH(productViewController);
        };
        
        cell.bonusBtnEvent = ^() {
//            NSLog(@"邀请奖励");
            if ([[UserDefaults service] getLoginStatus] == YES) {
                BonusViewController *bonusViewController = [[BonusViewController alloc] init];
                PUSH(bonusViewController);
            }else {
                LoginViewController *loginViewController = [[LoginViewController alloc] init];
                PUSH(loginViewController);
            }
            
        
        };
        
        cell.pointBtnEvent = ^() {
//            NSLog(@"兔币支付");
            if ([[UserDefaults service] getLoginStatus] == YES) {
                TPayViewController *tPayViewController = [[TPayViewController alloc] init];
                PUSH(tPayViewController);
            }else {
                LoginViewController *loginViewController = [[LoginViewController alloc] init];
                PUSH(loginViewController);
            }
            
            
        };
        
        cell.signBtnEvent = ^() {
//            NSLog(@"我的签到");
            if ([[UserDefaults service] getLoginStatus] == YES) {
                [self requesetSignin];
            }else {
                LoginViewController *loginViewController = [[LoginViewController alloc] init];
                PUSH(loginViewController);
            }
            
        };
        
        cell.favoriteBtnEvent = ^() {
//            NSLog(@"我的收藏");
            if ([[UserDefaults service] getLoginStatus] == YES) {
                MineFavoriteViewController *mineFavoriteViewController = [[MineFavoriteViewController alloc] init];
                PUSH(mineFavoriteViewController);
            }else {
                LoginViewController *loginViewController = [[LoginViewController alloc] init];
                PUSH(loginViewController);
            }
            
        };
        
        return cell;
    }else if (indexPath.section == 2) {
        SeckillCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier3];
//        
//        if (!cell) {
            cell = [[SeckillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier3];
//        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        if ([_homeDic[@"seckill"] count] > 0) {
            cell.productArray = _homeDic[@"seckill"];
            seckillArray = [NSArray arrayWithArray:_homeDic[@"seckill"]];
            cell.seckillLabel.text = @"兔悠秒杀";
            [cell.hourLabel setHidden:NO];
            [cell.minuteLabel setHidden:NO];
            [cell.secondLabel setHidden:NO];
            [cell.timeImageView setHidden:NO];
        }else if ([_homeDic[@"sp_offer"] count] > 0){
            cell.productArray = _homeDic[@"sp_offer"];
            seckillArray = [NSArray arrayWithArray:_homeDic[@"sp_offer"]];
            cell.seckillLabel.text = @"惊爆价";
            [cell.hourLabel setHidden:YES];
            [cell.minuteLabel setHidden:YES];
            [cell.secondLabel setHidden:YES];
            [cell.timeImageView setHidden:YES];
        }
        
        
        //倒计时
//        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        
//        //    NSDate *endDate = [dateFormatter dateFromString:[self getyyyymmdd]];
//        NSDate *startDate = [NSDate date];
//        NSDate *endDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([startDate timeIntervalSinceReferenceDate] + 60*60)];//60分钟
//        
//        NSTimeInterval timeInterval =[endDate timeIntervalSinceDate:startDate];
        
        //如果是秒杀只需要替换 timeInterval
        if (_payTimer==nil) {
            __block int timeout = [_homeDic[@"seckill_time"] intValue]; //倒计时时间
            
            if (timeout!=0) {
                weakify(self);
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                _payTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                dispatch_source_set_timer(_payTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                dispatch_source_set_event_handler(_payTimer, ^{
                    strongify(self);
                    if(timeout<=0){ //倒计时结束，关闭
                        dispatch_source_cancel(self.payTimer);
                        self.payTimer = nil;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //                        self.dayLabel.text = @"";
                            cell.hourLabel.text = @"00";
                            cell.minuteLabel.text = @"00";
                            cell.secondLabel.text = @"00";
                        });
                    }else {
                        
                        int hour = (int)(timeout/3600);
                        int minute = (int)((timeout%3600)/60);
                        int second = (int)((timeout%3600)%60);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (hour<10) {
                                
                                cell.hourLabel.text = [NSString stringWithFormat:@"0%d",hour];
                            }else{
                                
                                cell.hourLabel.text = [NSString stringWithFormat:@"%d",hour];
                            }
                            
                            if (minute<10) {
                                
                                cell.minuteLabel.text = [NSString stringWithFormat:@"0%d",minute];
                            }else{
                                
                                cell.minuteLabel.text = [NSString stringWithFormat:@"%d",minute];
                            }
                            if (second<10) {
                                
                                cell.secondLabel.text = [NSString stringWithFormat:@"0%d",second];
                            }else{
                                cell.secondLabel.text = [NSString stringWithFormat:@"%d",second];
                            }
                            
                        });
                        timeout--;
                    }
                });
                dispatch_resume(_payTimer);
            }
        }
        
        [cell.saleImage sd_setImageWithURL:[NSURL URLWithString:_homeDic[@"specialarea"]]
                              placeholderImage:[UIImage imageNamed:@""]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     }];
        
        [cell.halfImage sd_setImageWithURL:[NSURL URLWithString:_homeDic[@"second"]]
                          placeholderImage:[UIImage imageNamed:@""]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 }];
        
        [cell.freeImage sd_setImageWithURL:[NSURL URLWithString:_homeDic[@"give"]]
                          placeholderImage:[UIImage imageNamed:@""]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 }];
        
        [cell.nnewImage sd_setImageWithURL:[NSURL URLWithString:_homeDic[@"new"]]
                          placeholderImage:[UIImage imageNamed:@""]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 }];

        
        cell.saleBtnEvent = ^() {
            ProductViewController *productViewController = [[ProductViewController alloc] initWithNibName:nil bundle:nil];
            [productViewController.paramDictionary setObject:@"特价专区" forKey:@"title"];
            [productViewController.paramDictionary setObject:@"2" forKey:@"type"];
            PUSH(productViewController);
        };
        
        cell.halfBtnEvent = ^() {
            DiscountProductViewController *discountProductViewController = [[DiscountProductViewController alloc] initWithNibName:nil bundle:nil];
            [discountProductViewController.paramDictionary setObject:@"第二件折扣" forKey:@"title"];
            [discountProductViewController.paramDictionary setObject:@"4" forKey:@"type"];
            PUSH(discountProductViewController);
        };
        
        cell.freeBtnEvent = ^() {
            SaleProductViewController *saleProductViewController = [[SaleProductViewController alloc] initWithNibName:nil bundle:nil];
            [saleProductViewController.paramDictionary setObject:@"买赠区" forKey:@"title"];
            [saleProductViewController.paramDictionary setObject:@"3" forKey:@"type"];
            PUSH(saleProductViewController);
        };
        
        cell.newBtnEvent = ^() {
            ProductViewController *productViewController = [[ProductViewController alloc] initWithNibName:nil bundle:nil];
            [productViewController.paramDictionary setObject:@"新品悠荐" forKey:@"title"];
            [productViewController.paramDictionary setObject:@"1" forKey:@"type"];
            PUSH(productViewController);
        };
        
        
        return cell;
    }else if (indexPath.section == 3) {
        PopularCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier4];
        
        if (!cell) {
            cell = [[PopularCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier4];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.friedImage sd_setImageWithURL:[NSURL URLWithString:_homeDic[@"checken2"]]
                          placeholderImage:[UIImage imageNamed:@""]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 }];
        
        [cell.fastImage sd_setImageWithURL:[NSURL URLWithString:_homeDic[@"fastfood2"]]
                           placeholderImage:[UIImage imageNamed:@""]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  }];
        
        [cell.breadImage sd_setImageWithURL:[NSURL URLWithString:_homeDic[@"bood"]]
                           placeholderImage:[UIImage imageNamed:@""]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  }];
        
        [cell.juiceImage sd_setImageWithURL:[NSURL URLWithString:_homeDic[@"freshorange"]]
                           placeholderImage:[UIImage imageNamed:@""]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  }];
        
        [cell.fruitImage sd_setImageWithURL:[NSURL URLWithString:_homeDic[@"fresh2"]]
                           placeholderImage:[UIImage imageNamed:@""]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  }];
        
        [cell.healthImage sd_setImageWithURL:[NSURL URLWithString:_homeDic[@"buity"]]
                           placeholderImage:[UIImage imageNamed:@""]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  }];
        
        cell.friedBtnEvent = ^() {
            ProductViewController *productViewController = [[ProductViewController alloc] initWithNibName:nil bundle:nil];
            [productViewController.paramDictionary setObject:@"炸鸡美食" forKey:@"title"];
            [productViewController.paramDictionary setObject:@"5" forKey:@"type"];
            
            PUSH(productViewController);
        };
        cell.fastBtnEvent = ^() {
            ProductViewController *productViewController = [[ProductViewController alloc] initWithNibName:nil bundle:nil];
            [productViewController.paramDictionary setObject:@"熟食快餐" forKey:@"title"];
            [productViewController.paramDictionary setObject:@"6" forKey:@"type"];
            
            PUSH(productViewController);
        };
        cell.breadBtnEvent = ^() {
            ProductViewController *productViewController = [[ProductViewController alloc] initWithNibName:nil bundle:nil];
            [productViewController.paramDictionary setObject:@"烘培面包" forKey:@"title"];
            [productViewController.paramDictionary setObject:@"7" forKey:@"type"];
            
            PUSH(productViewController);
        };
        cell.juiceBtnEvent = ^() {
            ProductViewController *productViewController = [[ProductViewController alloc] initWithNibName:nil bundle:nil];
            [productViewController.paramDictionary setObject:@"鲜榨果汁" forKey:@"title"];
            [productViewController.paramDictionary setObject:@"8" forKey:@"type"];
            
            PUSH(productViewController);
        };
        cell.fruitBtnEvent = ^() {
            ProductViewController *productViewController = [[ProductViewController alloc] initWithNibName:nil bundle:nil];
            [productViewController.paramDictionary setObject:@"水果" forKey:@"title"];
            [productViewController.paramDictionary setObject:@"9" forKey:@"type"];
            
            PUSH(productViewController);
        };
        cell.healthBtnEvent = ^() {
            ProductViewController *productViewController = [[ProductViewController alloc] initWithNibName:nil bundle:nil];
            [productViewController.paramDictionary setObject:@"美妆保健" forKey:@"title"];
            [productViewController.paramDictionary setObject:@"10" forKey:@"type"];
            
            PUSH(productViewController);
        };
        
        return cell;
    }else {
        if (indexPath.row == 0) {
            SingleProductTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier5];
            
            if (!cell) {
                cell = [[SingleProductTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier5];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            SingleProductCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier6];
            
            if (!cell) {
                cell = [[SingleProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier6];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:_homeDic[@"special_goods"][(indexPath.row-1)*2][@"product_url"]]
                                  placeholderImage:[UIImage imageNamed:@""]
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                             //TODO
                                             if ([self.homeDic[@"special_goods"][(indexPath.row-1)*2][@"stock_qty"] intValue] > 0) {
                                                 //hidden
                                                 [cell.leftImageView2 setHidden:YES];
                                             }else {
                                                 //show
                                                 [cell.leftImageView2 setHidden:NO];
                                             }
                                         }];
            cell.leftTitle.text = _homeDic[@"special_goods"][(indexPath.row-1)*2][@"description"];
            cell.leftPrice = [_homeDic[@"special_goods"][(indexPath.row-1)*2][@"dis_price"] floatValue];
            
            [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:_homeDic[@"special_goods"][(indexPath.row-1)*2+1][@"product_url"]]
                                  placeholderImage:[UIImage imageNamed:@""]
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                             //TODO
                                             if ([self.homeDic[@"special_goods"][(indexPath.row-1)*2+1][@"stock_qty"] intValue] > 0) {
                                                 //hidden
                                                 [cell.rightImageView2 setHidden:YES];
                                             }else {
                                                 //show
                                                 [cell.rightImageView2 setHidden:NO];
                                             }
                                         }];
            
            cell.rightTitle.text = _homeDic[@"special_goods"][(indexPath.row-1)*2+1][@"description"];
            cell.rightPrice = [_homeDic[@"special_goods"][(indexPath.row-1)*2+1][@"dis_price"] floatValue];
            
            cell.leftBtnEvent = ^() {
                ProductDetailViewController *productDetailViewController = [[ProductDetailViewController alloc] init];
                [productDetailViewController.paramDictionary setObject:self.homeDic[@"special_goods"][(indexPath.row-1)*2][@"product_no"] forKey:@"product_no"];
                PUSH(productDetailViewController);
            };
            
            cell.rightBtnEvent = ^() {
                ProductDetailViewController *productDetailViewController = [[ProductDetailViewController alloc] init];
                [productDetailViewController.paramDictionary setObject:self.homeDic[@"special_goods"][(indexPath.row-1)*2+1][@"product_no"] forKey:@"product_no"];
                PUSH(productDetailViewController);

            };
            weakify(self);
            cell.leftCartBtnEvent = ^() {
                strongify(self);
                if ([[UserDefaults service] getOperatingState] == YES) {
                    if ([self.homeDic[@"special_goods"][(indexPath.row-1)*2][@"on_sale"] isEqualToString:@"1"]) {
                        self.totalOrders ++;
                        self.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.totalOrders];
                        
                        [self updateDB:[self.homeDic[@"special_goods"][(indexPath.row-1)*2] mutableCopy]];
                    }else {
                        [self showDetailMsg:@"该商品售卖时间有限，暂时无法购买"];
                    }
                }else {
                    [self showMsg:@"外卖打烊啦 店铺24h营业"];
                }
            };
            
            cell.rightCartBtnEvent = ^() {
                strongify(self);
                if ([[UserDefaults service] getOperatingState] == YES) {
                    
                    if ([self.homeDic[@"special_goods"][(indexPath.row-1)*2+1][@"on_sale"] isEqualToString:@"1"]) {
                        self.totalOrders ++;
                        self.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.totalOrders];
                        [self updateDB:[self.homeDic[@"special_goods"][(indexPath.row-1)*2+1] mutableCopy]];
                    }else {
                        [self showDetailMsg:@"该商品售卖时间有限，暂时无法购买"];
                    }
                    
                }else {
                    [self showMsg:@"外卖打烊啦 店铺24h营业"];
                }
            };
            
            return cell;
        }
    }
    return cell;
}

//去粘性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= 0) {
        //上滑
        CGFloat minUpAlphaOffset = 0;//- 64;
        CGFloat maxUpAlphaOffset = 400*SCALE;
        CGFloat offset = scrollView.contentOffset.y;
        CGFloat upAlpha = (offset - minUpAlphaOffset) / (maxUpAlphaOffset - minUpAlphaOffset);
        navigationBar.backgroundColor = [UIColor colorWithRed:(255)/255.0 green:(168)/255.0 blue:(26)/255.0 alpha:upAlpha];
    }else {
        //下滑
        CGFloat minAlphaOffset = 0;//- 64;
        CGFloat maxAlphaOffset = 200*SCALE;
        CGFloat offset = scrollView.contentOffset.y;
        CGFloat alpha = (offset - minAlphaOffset) / (minAlphaOffset - maxAlphaOffset);
        navigationBar.backgroundColor = [UIColor colorWithRed:(86)/255.0 green:(86)/255.0 blue:(86)/255.0 alpha:alpha];
    }

    //去掉UItableview的section的footerview粘性
    if (scrollView == _contentView) {
        CGFloat sectionFooterHeight = 10*SCALE;
        if (scrollView.contentOffset.y<=sectionFooterHeight && scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, -sectionFooterHeight, 0);
        } else if (scrollView.contentOffset.y>=sectionFooterHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, -sectionFooterHeight, 0);
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第%ld行", (long)indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==1 || section==2 || section==3 || section==4) {
        return 10*SCALE;
    }else {
        return 0*SCALE;
    }
    
}

#pragma mark - SeckillScrollViewDelegate
- (void)didSelectItemAtIndex:(NSInteger)index {
    NSDictionary *dic = [seckillArray objectAtIndex:index];

    ProductDetailViewController *productDetailViewController = [[ProductDetailViewController alloc] init];
    [productDetailViewController.paramDictionary setObject:dic[@"product_no"] forKey:@"product_no"];
    PUSH(productDetailViewController);
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"---点击了第%ld张图片", (long)index);
}

//滚动到第几张图回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    //     NSLog(@">>>>>> 滚动到第%ld张图", (long)index);
}

#pragma mark TitleViewDelegate Methods
- (void)locationBtnClick:(id)sender {
    SearchStoreViewController *searchStoreViewController = [[SearchStoreViewController alloc] init];
    PUSH(searchStoreViewController);
}
- (void)searchBtnClick:(id)sender {
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
    PUSH(searchViewController);
}
- (void)rightBtnClick:(id)sender {
    NotificationViewController *notificationViewController = [[NotificationViewController alloc] init];
    PUSH(notificationViewController);
}

//签到
- (void)requesetSignin {
    
    NSDictionary *paramDic = [[NSDictionary alloc] init];
    
    [HttpClientService requestSingin:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            [self popSignViewShow];
        }else if (status == 121) {
            [self popSignedViewShow];
        }else if (status == 202) {
            [self showMsg:@"您的登录状态失效，请重新登录"];
            [self hideLoadHUD:YES];
            sleep(1.0);
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
            
        }else {
            [self showMsg:@"服务器异常"];
            [self hideLoadHUD:YES];
        }
        
    } failure:^(NSError *error) {
        [self hideLoadHUD:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popSignViewShow {
    signImage.image = [UIImage imageNamed:@"home_sign_bg"];
    
    [PopView sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [PopView sharedInstance].closeButtonType = ButtonPositionTypeRight;
    [[PopView sharedInstance] showWithPresentView:popContentView animated:YES];
    
}

- (void)popSignedViewShow {
    signImage.image = [UIImage imageNamed:@"home_signed_bg"];
    
    [PopView sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [PopView sharedInstance].closeButtonType = ButtonPositionTypeRight;
    [[PopView sharedInstance] showWithPresentView:popContentView animated:YES];
    
}

//更新DB
- (void)updateDB:(NSMutableDictionary *)dictionary {
    CartInfoDAL *dal = [[CartInfoDAL alloc] init];
    NSMutableArray *entityArray = [dal queryCartInfo];
    
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < entityArray.count; i++) {
        CartInfoEntity *entity = [[CartInfoEntity alloc] init];
        entity = entityArray[i];
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
        
        [tempDic setObject:entity.product_no forKey:@"product_no"];
        [tempDic setObject:entity.orderCount forKey:@"orderCount"];
        [tempDic setObject:entity.descriptionn forKey:@"description"];
        [tempDic setObject:entity.dis_price forKey:@"dis_price"];
        
        [tempArray addObject:tempDic];
    }
    
    for (NSMutableDictionary *dic in tempArray) {
        
        if ([dic[@"product_no"] isEqualToString:dictionary[@"product_no"]]){
            //购物车内有选择的商品
            NSInteger nCount = [dic[@"orderCount"] integerValue];
            nCount = nCount+1;
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)nCount] forKey:@"orderCount"];
            //更新DB
            [self updateDB2:dic];
        
            return;
        }
    }
    
    //购物车内没有商品
    [dictionary setObject:@"1" forKey:@"orderCount"];
    
    //更新DB
    [self updateDB2:dictionary];
    
}

- (void)updateDB2:(NSMutableDictionary *)dic {
    
    CartInfoDAL *dal = [[CartInfoDAL alloc] init];
    CartInfoEntity *entity = [[CartInfoEntity alloc] init];
    entity.product_no = [dic objectForKey:@"product_no"];
    entity.cvs_no = [[UserDefaults service] getStoreId];
    entity.orderCount = [dic objectForKey:@"orderCount"];
    entity.descriptionn = [dic objectForKey:@"description"];
    entity.dis_price = [dic objectForKey:@"dis_price"];
    entity.gift_flag = @"0";
    [dal insertIntoTable:entity];
    
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    shakeAnimation.duration = 0.25f;
    shakeAnimation.fromValue = [NSNumber numberWithFloat:1.6];
    shakeAnimation.toValue = [NSNumber numberWithFloat:1.0];
    shakeAnimation.autoreverses = YES;
    [_cartBtn.layer addAnimation:shakeAnimation forKey:nil];
    
    [_cartBtn setBackgroundImage:[UIImage imageNamed:@"home_air_cart"] forState:UIControlStateNormal];
}

- (void)cartBtnClick {
    
    if ([[UserDefaults service] getOperatingState] == YES) {
        [_closeTips setHidden:YES];
        [_cartBtn setHidden:NO];
        
        CategoryViewController *categoryViewController = [[CategoryViewController alloc] init];
        [categoryViewController.orderDictionary setObject:@"1" forKey:@"isUp"];
        PUSH(categoryViewController);
    }else {
        [_closeTips setHidden:NO];
        [_cartBtn setHidden:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ssy" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadStore" object:nil];
    
    [self hideLoadHUD:YES];
}

@end

