//
//  CategoryViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/1.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "CategoryViewController.h"
#import "SubmitOrderViewController.h"
#import "ProductDetailViewController.h"
#import "SearchViewController.h"
#import "StoreSalesCell.h"
#import "LiuXSegmentView.h"
#import "LeftCell.h"
#import "RightBannerCell.h"
#import "RightCell.h"
#import "RightCigaretteCell.h"
#import "ShoppingCartCell.h"
#import "OverlayView.h"
#import "ShoppingCartView.h"
#import "BadgeView.h"
#import "CartInfoDAL.h"
#import "CartInfoEntity.h"
#import "LoginViewController.h"
#import "CategoryDiscountProductCell.h"
#import "MJChiBaoZiHeader.h"
#import "MJChiBaoZiFooter.h"
#import "MJChiBaoZiFooter2.h"
#import "MJDIYHeader.h"
#import "MJDIYAutoFooter.h"
#import "MJDIYBackFooter.h"
#import "ProtocolViewController.h"


#define SALES_COLOR  UIColorFromRGB(76,76,76)
#define SECTION_HEIGHT 40.0*SCALE
#define TIPS_HEIGHT 30.0*SCALE

@interface CategoryViewController ()<UITableViewDelegate, UITableViewDataSource, ZFReOrderTableViewDelegate, ShoppingCartViewDelegate, CAAnimationDelegate> {
    UIScrollView *contentView;
    UITableView *storeSalesTableView;
    UITableView *leftTableView;
    UITableView *rightTableView;
    
    LiuXSegmentView *tabView;
    
    //购物车相关
    NSUInteger totalOrders;
    CALayer *dotLayer;
    UIBezierPath *path;
    CGFloat endPointX;
    CGFloat endPointY;
    ShoppingCartView *ShopCartView;
    //已选数组
    NSMutableArray *ordersArray;
    
    //数据
    NSArray *level1Array;
    NSString *level1String;
    NSString *level2String;
    
    
    BOOL isOpen;
    
    NSInteger pageNumber;
    NSInteger pageLen;

    //购物车展开提示促销信息
    UIView *tipsViewWithShopCartView;
    UILabel *tipsLabelWithShopCartView;
    
    //购物车关闭提示促销信息
    UIView *tipsViewWithoutShopCartView;
    UILabel *tipsLabelWithoutShopCartView;
    
    NSString *notice;
    NSString *bannerImageUrl;
    
    UIImageView *bg;
    
    UIView *closeView;
}
@property(nonatomic, strong) NSMutableArray *productArray;

@end


@implementation CategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_BAR_HEIGHT + STATUS_BAR_HEIGHT +[[[UserDefaults service] getStoreSales] count]*STORE_CELL_HEIGHT+15*SCALE)];
        bg.image = [UIImage imageNamed:@"salesBg"];
        [self.view addSubview:bg];
        
        navigationBar.backgroundColor = [UIColor clearColor];
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_white"] forState:UIControlStateNormal];
        
        //标题
        UILabel *halfTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44*SCALE + 0*SCALE, STATUS_BAR_HEIGHT, 130*SCALE, NAV_BAR_HEIGHT)];
        halfTitleLabel.textColor = [UIColor whiteColor];
        [halfTitleLabel setFont:[UIFont systemFontOfSize:18*SCALE]];
        halfTitleLabel.text = @"商品分类";
        halfTitleLabel.textAlignment = NSTextAlignmentCenter;
        [navigationBar addSubview:halfTitleLabel];
        
        //搜索背景
        UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(halfTitleLabel.frame) + 0*SCALE, STATUS_BAR_HEIGHT, SCREEN_WIDTH - 44*SCALE - 130*SCALE-10*SCALE, NAV_BAR_HEIGHT)];
        searchImageView.image = [UIImage imageNamed:@"navigation_product_search"];
        [navigationBar addSubview:searchImageView];
        
        //搜索框
        UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(halfTitleLabel.frame) + 30*SCALE, STATUS_BAR_HEIGHT, SCREEN_WIDTH - 44*SCALE - 130*SCALE-10*SCALE-30*SCALE, NAV_BAR_HEIGHT)];
        searchLabel.text = @"请输入关键字";
        searchLabel.textColor = [UIColor grayColor];
        searchLabel.font = [UIFont systemFontOfSize:14*SCALE];
        [navigationBar addSubview:searchLabel];
        
        
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchBtn setFrame:CGRectMake(CGRectGetMaxX(halfTitleLabel.frame) + 0*SCALE, STATUS_BAR_HEIGHT, SCREEN_WIDTH - 44*SCALE - 130*SCALE-10*SCALE, NAV_BAR_HEIGHT)];
        [searchBtn addTarget:self action:@selector(searchBtn) forControlEvents:UIControlEventTouchUpInside];
        [navigationBar addSubview:searchBtn];
        
        //商家促销信息
        storeSalesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT+10*SCALE, SCREEN_WIDTH, STORE_CELL_HEIGHT+5*SCALE) style:UITableViewStylePlain];
        storeSalesTableView.delegate = self;
        storeSalesTableView.dataSource = self;
        storeSalesTableView.showsVerticalScrollIndicator = NO;
        storeSalesTableView.separatorStyle = NO;
        storeSalesTableView.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:storeSalesTableView];
        
        contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(storeSalesTableView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_BAR_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT-10*SCALE)];
        contentView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:contentView];
        
        leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 80*SCALE, SCREEN_HEIGHT-BOTTOM_BAR_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT-STORE_CELL_HEIGHT) style:UITableViewStylePlain];
        leftTableView.delegate = self;
        leftTableView.dataSource = self;
        leftTableView.showsVerticalScrollIndicator = NO;
        leftTableView.separatorStyle = NO;
        //        leftTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        leftTableView.backgroundColor = UIColorFromRGB(248,248,248);
        leftTableView.estimatedRowHeight = 0;
        leftTableView.estimatedSectionHeaderHeight = 0;
        leftTableView.estimatedSectionFooterHeight = 0;
        [contentView addSubview:leftTableView];
        
        //TODO tab高度为40
        rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(leftTableView.frame.size.width, 45*SCALE, SCREEN_WIDTH-leftTableView.frame.size.width, SCREEN_HEIGHT-BOTTOM_BAR_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT-45*SCALE-STORE_CELL_HEIGHT) style:UITableViewStylePlain];
        rightTableView.delegate = self;
        rightTableView.dataSource = self;
        rightTableView.showsVerticalScrollIndicator = NO;
        //        rightTableView.separatorStyle = NO;
        [rightTableView setSeparatorColor:UIColorFromRGB(240,240,240)];
        rightTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        rightTableView.mj_footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        rightTableView.estimatedRowHeight = 0;
        rightTableView.estimatedSectionHeaderHeight = 0;
        rightTableView.estimatedSectionFooterHeight = 0;

        [contentView addSubview:rightTableView];
        
        [self.view bringSubviewToFront:navigationBar];
        
        tipsViewWithShopCartView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TIPS_HEIGHT)];
        tipsLabelWithShopCartView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TIPS_HEIGHT)];
        
        //购物车展开提示促销信息
        tipsLabelWithoutShopCartView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TIPS_HEIGHT)];
        tipsLabelWithoutShopCartView.textAlignment = NSTextAlignmentCenter;
        tipsLabelWithoutShopCartView.textColor = [UIColor darkGrayColor];
        tipsLabelWithoutShopCartView.font = [UIFont systemFontOfSize:9.5*SCALE];
        
        //购物车关闭提示促销信息
        tipsViewWithoutShopCartView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - BOTTOM_BAR_HEIGHT2-TIPS_HEIGHT, SCREEN_WIDTH, TIPS_HEIGHT)];
        tipsViewWithoutShopCartView.backgroundColor = UIColorFromRGB(255, 241, 213);
        [tipsViewWithoutShopCartView addSubview:tipsLabelWithoutShopCartView];
        [tipsViewWithoutShopCartView setHidden:YES];
        [self.view addSubview:tipsViewWithoutShopCartView];
        
        //购物车区
        ShopCartView = [[ShoppingCartView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - BOTTOM_BAR_HEIGHT2, SCREEN_WIDTH, BOTTOM_BAR_HEIGHT) inView:self.view withObjects:nil];
        ShopCartView.delegate = self;
        ShopCartView.parentView = self.view;
        ShopCartView.OrderList.delegate = self;
        ShopCartView.OrderList.tableView.delegate = self;
        ShopCartView.OrderList.tableView.dataSource = self;
        ShopCartView.OrderList.tableView.estimatedRowHeight = 0;
        ShopCartView.OrderList.tableView.estimatedSectionHeaderHeight = 0;
        ShopCartView.OrderList.tableView.estimatedSectionFooterHeight = 0;
        
        [self.view addSubview:ShopCartView];
        
        if (@available(iOS 11.0, *)) {
            leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            rightTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            ShopCartView.OrderList.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        closeView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - BOTTOM_BAR_HEIGHT2, SCREEN_WIDTH, BOTTOM_BAR_HEIGHT)];
        closeView.backgroundColor = UIColorFromRGB(76,76,76);
        closeView.alpha = 0.9;
        [self.view addSubview:closeView];
        
        UILabel *closeTips = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BOTTOM_BAR_HEIGHT)];
        closeTips.text = @"外卖打烊啦    店铺24h营业";
        closeTips.textAlignment = NSTextAlignmentCenter;
        closeTips.font = [UIFont systemFontOfSize:18*SCALE];
        closeTips.textColor = [UIColor whiteColor];
        [closeView addSubview:closeTips];
        
        
        
        CGRect rect = [self.view convertRect:ShopCartView.shoppingCartBtn.frame fromView:ShopCartView];
        endPointX = rect.origin.x + 25;
        endPointY = rect.origin.y + 20;
        
        //商家促销信息初始化关
        isOpen = NO;
        
        _orderDictionary = [[NSMutableDictionary alloc] init];
        
        [bg setHidden:YES];
        [storeSalesTableView setHidden:YES];
        //        [contentView setHidden:YES];
        
        weakify(self);
        self.emptyView.reloadBlock = ^()
        {
            strongify(self);
            [self reloadBtnEvent];
            
        };
        
        [contentView setHidden:YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnect) name:@"ssy" object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    //购物车数据初始化
    ordersArray = [NSMutableArray array];
    totalOrders = 0;
    
    if ([[UserDefaults service] getOperatingState] == YES) {
        //取DB最新
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
            
            totalOrders += [entity.orderCount integerValue];
        }
        ordersArray = tempArray;
    }
    
    
    ShopCartView.OrderList.objects = ordersArray;
    [ShopCartView.OrderList.tableView reloadData];
    
    ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)totalOrders];
    [self setCartImage];
    [self setTotalMoney];
    if (totalOrders <=0) {
        [ShopCartView dismissAnimated:YES];
    }
    
    if ([[_orderDictionary objectForKey:@"isUp"] isEqualToString:@"0"]) {
        //TODO
    }else {
        [ShopCartView clickCartBtn];
        //重置购物车开启状态
        [_orderDictionary setObject:@"0" forKey:@"isUp"];
    }
    
    [rightTableView reloadData];
    
    if ([self networkStatus] == YES) {
        
    }else {
        [self disconnect];
    }
}

- (void)disconnect {
    [bg setHidden:YES];
    [contentView setHidden:YES];
    
    [self showEmptyViewWithStyle:EmptyViewStyleNetworkUnreachable];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //请求一级菜单
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"0", @"class_id", nil];
    
    [HttpClientService requestLevel:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            level1Array = [NSArray arrayWithArray:[jsonDic objectForKey:@"category"]];
            
            [leftTableView reloadData];
            //初始化选中第一行
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [leftTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            
            //初始化二级菜单
            [self reloadLevel2:0];
            [self hideLoadHUD:YES];
            
            //TODO 刷新主列表
            level1String = [level1Array firstObject][@"id"];
            [self reloadBtnEvent];
            
        }else if (status == 202) {
            [self showMsg:@"您的登录状态失效，请重新登录"];
            [self hideLoadHUD:YES];
            sleep(1.0);
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
            
        }else {
//            [self showMsg:@"服务器异常"];
            [self hideLoadHUD:YES];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == leftTableView) {
        return level1Array.count;
    }else if (tableView == rightTableView) {
        return _productArray.count+1;
    }else if ([tableView isEqual:ShopCartView.OrderList.tableView]) {
        return [ordersArray count];
    }else if (tableView == storeSalesTableView) {//店铺活动
        if (isOpen == YES) {
            return [[[UserDefaults service] getStoreSales] count];
        }else {
            return 1;
        }
        
    }else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == leftTableView) {
        return 45*SCALE;
    }else if (tableView == rightTableView){
        
        if (indexPath.row == 0) {
            if (notice.length > 0) {
                return 120*SCALE;
            }else {
                return 100*SCALE;
            }
            
        }else {
            if ([_productArray[indexPath.row-1][@"promo_product"] count] > 0) {
                return (138+2)*SCALE;//折扣商品
            }else {
                return 82*SCALE;//正常商品
            }
        }
    }else if ([tableView isEqual:ShopCartView.OrderList.tableView]) {
        return 40*SCALE;
    }else if (tableView == storeSalesTableView) {
        if (isOpen == YES) {
            return STORE_CELL_HEIGHT;
        }else {
            return STORE_CELL_HEIGHT+5*SCALE;
        }
        
    }else {
        return 100*SCALE;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myCellIdentifier1 = @"MyCellIdentifier1";
    static NSString *myCellIdentifier2 = @"MyCellIdentifier2";
    static NSString *myCellIdentifier3 = @"MyCellIdentifier3";
    static NSString *myCellIdentifier4 = @"MyCellIdentifier4";
    static NSString *myCellIdentifier5 = @"MyCellIdentifier5";
    static NSString *myCellIdentifier6 = @"MyCellIdentifier6";
    static NSString *myCellIdentifier7 = @"MyCellIdentifier7";
    
    UITableViewCell *cell = nil;
    weakify(self);
    
    if (tableView == leftTableView) {
        LeftCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier1];
        
        if (!cell) {
            cell = [[LeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier1];
        }
        
        //TODO只是满足客户需求
        if (indexPath.row == 0) {
            cell.leftTitle.numberOfLines = 2;
            cell.leftTitle.text = @"熟食·炸鸡·快餐";
        }else {
            cell.leftTitle.text = [level1Array objectAtIndex:indexPath.row][@"name"];
        }
        
        cell.contentView.backgroundColor = UIColorFromRGB(248,248,248);
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = ICON_COLOR;
        
        return cell;
    }else if (tableView == rightTableView) {
        
        if (indexPath.row == 0) {
            RightBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier2];
            
            if (!cell) {
                cell = [[RightBannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier2];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (notice.length > 0) {
                [cell.tipsLabel setHidden:NO];
                [cell.icon setHidden:NO];
                [cell.tipsBtn setHidden:NO];
                cell.tipsLabel.text = notice;
                [cell.bannerImageView setFrame:CGRectMake(10*SCALE, 30*SCALE, SCREEN_WIDTH-100*SCALE, 80*SCALE)];
            }else {
                [cell.tipsLabel setHidden:YES];
                [cell.icon setHidden:YES];
                [cell.tipsBtn setHidden:YES];
                [cell.bannerImageView setFrame:CGRectMake(10*SCALE, 10*SCALE, SCREEN_WIDTH-100*SCALE, 80*SCALE)];
            }
            
            
            [cell.bannerImageView sd_setImageWithURL:[NSURL URLWithString:bannerImageUrl]
                                    placeholderImage:[UIImage imageNamed:@"test_category"]
                                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                               //TODO
                                           }];
            
            //            __weak __typeof(&*cell)weakCell =cell;
            cell.plusBlock = ^()
            {
                ProtocolViewController *protocolViewController = [[ProtocolViewController alloc] init];
                PUSH(protocolViewController);
                
            };
            
            return cell;
            
        }else {
            
            //判断是否是第二件折扣商品
            if ([_productArray[indexPath.row-1][@"promo_product"] count] > 0) {
                
                CategoryDiscountProductCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier6];
                
                if (!cell) {
                    cell = [[CategoryDiscountProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier6];
                }
              
                weakify(cell);
                //商品区
                [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:_productArray[indexPath.row-1][@"product_url"]]
                                       placeholderImage:[UIImage imageNamed:@""]
                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                  strongify(self);
                                                  strongify(cell);
                                                  if ([self.productArray[indexPath.row-1][@"stock_qty"] intValue] > 0) {
                                                      //hidden
                                                      [cell.rightImageView2 setHidden:YES];
                                                  }else {
                                                      //show
                                                      [cell.rightImageView2 setHidden:NO];
                                                  }
                                              }];
                
                cell.rightTitle.text = _productArray[indexPath.row-1][@"description"];//商品名
                cell.rightSubTitle.text = _productArray[indexPath.row-1][@"capacity_description"];//规格
                cell.salesArray = _productArray[indexPath.row-1][@"promo_list"];//促销类型数组
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterCurrencyStyle;
                float nTotal = [_productArray[indexPath.row-1][@"dis_price"] floatValue];//价格
                NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:nTotal]];
                cell.priceLabel1.text = price;
                
                //赠品区
                if ([_productArray[indexPath.row-1][@"promo_product"][0][@"type"] isEqualToString:@"5"]) {
                    cell.giftLabel.text = [NSString stringWithFormat:@"第二件%@折", _productArray[indexPath.row-1][@"promo_product"][0][@"sa_ratio"]];
                    [cell.plus2 setHidden:NO];
                }else if ([_productArray[indexPath.row-1][@"promo_product"][0][@"type"] isEqualToString:@"4"]) {
                    if ([_productArray[indexPath.row-1][@"promo_product"][0][@"buy_count"] isEqualToString:@"1"] && [_productArray[indexPath.row-1][@"promo_product"][0][@"give_count"] isEqualToString:@"1"]) {
                        cell.giftLabel.text = @"买赠";
                    }else {
                        cell.giftLabel.text = [NSString stringWithFormat:@"买%@赠%@", _productArray[indexPath.row-1][@"promo_product"][0][@"buy_count"], _productArray[indexPath.row-1][@"promo_product"][0][@"give_count"]];
                    }
                }
                
                [cell.giftImageView sd_setImageWithURL:[NSURL URLWithString:_productArray[indexPath.row-1][@"promo_product"][0][@"product_url"]]
                                      placeholderImage:[UIImage imageNamed:@""]
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                 //TODO
                                                 strongify(self);
                                                 strongify(cell);
                                                 if ([self.productArray[indexPath.row-1][@"promo_product"][0][@"stock_qty"] intValue] > 0) {
                                                     //hidden
                                                     [cell.giftImageView2 setHidden:YES];
                                                 }else {
                                                     //show
                                                     [cell.giftImageView2 setHidden:NO];
                                                 }
                                             }];
                
                cell.giftTitle.text = _productArray[indexPath.row-1][@"promo_product"][0][@"description"];
                cell.giftSubTitle.text = _productArray[indexPath.row-1][@"promo_product"][0][@"cap_description"];
                cell.newPrice = [_productArray[indexPath.row-1][@"promo_product"][0][@"dis_price"] floatValue];
                cell.oldPrice = [_productArray[indexPath.row-1][@"promo_product"][0][@"sa_price"] floatValue];
                
                if ([_productArray[indexPath.row-1][@"promo_product"][0][@"dis_price"] isEqualToString:_productArray[indexPath.row-1][@"promo_product"][0][@"sa_price"]]) {
                    [cell.giftOldPrice setHidden:YES];
                }else {
                    [cell.giftOldPrice setHidden:NO];
                }
                
                if ([[UserDefaults service] getOperatingState] == YES) {
                    if ([_productArray[indexPath.row-1][@"stock_qty"] intValue] > 0) {
                        
                        if ([_productArray[indexPath.row-1][@"on_sale"] isEqualToString:@"1"]) {
                            [cell.plus setSelected:YES];
                            [cell.packageBtn setEnabled:YES];
                            
                            if ([_productArray[indexPath.row-1][@"box_unit"] intValue] > 1) {
                                [cell.packageBtn setHidden:NO];
                            }else {
                                [cell.packageBtn setHidden:YES];
                            }
                        }else {
                            [cell.plus setSelected:NO];
                            [cell.packageBtn setEnabled:NO];
                        }
                        
                    }else {
                      
                        [cell.plus setSelected:NO];
                        [cell.packageBtn setEnabled:NO];
                    }
                }else {
                    [cell.plus setHidden:YES];
                    [cell.plus2 setHidden:YES];
                    [cell.packageBtn setHidden:YES];
                }
                
//                __weak __typeof(&*cell)weakCell =cell;
                
                cell.plusBlock = ^(NSInteger nCount,BOOL animated)
                {
                    strongify(self);
                    strongify(cell);
                    if ([self.productArray[indexPath.row-1][@"stock_qty"] intValue] > 0) {
                    
                    if ([self.productArray[indexPath.row-1][@"on_sale"] isEqualToString:@"1"]) {
                        
                        CGRect parentRect = [cell convertRect:cell.plus.frame toView:self.view];
                        
                        if (animated==NO) {
                            if ([cell.orderCount.text integerValue] <= [cell.orderCount2.text integerValue]) {
                                //副品
                                NSMutableDictionary *dic2 = [self.productArray[indexPath.row-1][@"promo_product"][0] mutableCopy];
                                
                                [dic2 setObject:[NSString stringWithFormat:@"%@,%@", self.productArray[indexPath.row-1][@"product_no"], self.productArray[indexPath.row-1][@"promo_product"][0][@"product_no"]] forKey:@"product_no"];
                                
                                [self storeOrders:dic2 isAdded:animated];
                                
                                if (animated) {
                                    [self JoinCartAnimationWithRect:parentRect];
                                    totalOrders ++;
                                }
                                else
                                {
                                    totalOrders --;
                                }
                            }
                        }
                        
                        
                        
                        NSMutableDictionary *dic = [self.productArray[indexPath.row-1] mutableCopy];
                        
                        [self storeOrders:dic isAdded:animated];
                        
                        
                        
                        if (animated) {
                            [self JoinCartAnimationWithRect:parentRect];
                            totalOrders ++;
                        }
                        else
                        {
                            totalOrders --;
                        }
                        
                        ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)totalOrders];
                        [self setCartImage];
                        [self setTotalMoney];
                        
                        [rightTableView reloadData];
                    }else {
                        [self showDetailMsg:@"该商品售卖时间有限，暂时无法购买"];
                    }
                    }else {
                        [self showMsg:@"该商品已售罄"];
                    }
                };
                
                //成箱
                cell.packageBlock = ^(NSInteger nCount,BOOL animated)
                {
                    strongify(self);
                    strongify(cell);
                    cell.amount += [self.productArray[indexPath.row-1][@"box_unit"] integerValue];
                    
                    NSMutableDictionary *dic = [self.productArray[indexPath.row-1] mutableCopy];
                    
                    [self storePackageOrders:dic boxUnit:[self.productArray[indexPath.row-1][@"box_unit"] intValue] isAdded:animated];
                    
                    CGRect parentRect = [cell convertRect:cell.plus.frame toView:self.view];
                    
                    if (animated) {
                        [self JoinCartAnimationWithRect:parentRect];
                        totalOrders += [self.productArray[indexPath.row-1][@"box_unit"] integerValue];
                    }
                    
                    ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)totalOrders];
                    [self setCartImage];
                    [self setTotalMoney];
                    
                    [rightTableView reloadData];
                    
                };
                
                //第二件商品折扣 同品的情况
                if ([_productArray[indexPath.row-1][@"product_no"] isEqualToString:_productArray[indexPath.row-1][@"promo_product"][0][@"product_no"]]) {
                    
                    [cell.giftSubTitle setHidden:YES];
                    
                    cell.plusBlock2 = ^(NSInteger nCount,BOOL animated, BOOL show)
                    {
                        strongify(self);
                        strongify(cell);
                        if ([self.productArray[indexPath.row-1][@"promo_product"][0][@"on_sale"] isEqualToString:@"1"]) {
                            
                            if (show == NO) {
                                
                                NSMutableDictionary *dic = [self.productArray[indexPath.row-1][@"promo_product"][0] mutableCopy];
                                
                                [dic setObject:[NSString stringWithFormat:@"%@,%@", self.productArray[indexPath.row-1][@"product_no"], self.productArray[indexPath.row-1][@"promo_product"][0][@"product_no"]] forKey:@"product_no"];
                                
                                [self storeOrders:dic isAdded:animated];
                                
                                CGRect parentRect = [cell convertRect:cell.plus2.frame toView:self.view];
                                
                                if (animated) {
                                    [self JoinCartAnimationWithRect:parentRect];
                                    totalOrders ++;
                                }
                                else
                                {
                                    totalOrders --;
                                }
                                ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)totalOrders];
                                [self setCartImage];
                                [self setTotalMoney];
                                
                                [rightTableView reloadData];
                            }else {
                                [self showDetailMsg:@"第二件同品商品不能超过主商品，您需再订购主商品。"];
                            }
                            
                        }else {
                            [self showDetailMsg:@"该商品售卖时间有限，暂时无法购买"];
                        }
                    };
                    
                    
                    if ([_productArray[indexPath.row-1][@"promo_product"][0][@"type"] isEqualToString:@"5"] && [[UserDefaults service] getOperatingState] == YES) {
                        [cell.orderCount2 setHidden:NO];
                        [cell.plus2 setHidden:NO];
                        [cell.minus2 setHidden:NO];
                    }else {
                        [cell.orderCount2 setHidden:YES];
                        [cell.plus2 setHidden:YES];
                        [cell.minus2 setHidden:YES];
                    }
                    
                    //不同品的情况 刷新父列表
                    if (ordersArray.count > 0) {
                        cell.amount = 0;
                        cell.amount2 = 0;
                        
                        for (NSMutableDictionary *dic1 in ordersArray) {
                            
                            if ([dic1[@"product_no"] isEqualToString:_productArray[indexPath.row-1][@"product_no"]]){
                                
                                NSInteger nCount = [dic1[@"orderCount"] integerValue];
                                cell.amount = nCount;
                            }else if ([dic1[@"product_no"] isEqualToString:[NSString stringWithFormat:@"%@,%@", _productArray[indexPath.row-1][@"product_no"], _productArray[indexPath.row-1][@"promo_product"][0][@"product_no"]]]){
                                NSInteger nCount = [dic1[@"orderCount"] integerValue];
                                cell.amount2 = nCount;
                            }
                        }
                        
                        return cell;
                    }else {
                        cell.amount = 0;
                        cell.amount2 = 0;
                        return cell;
                    }
                    
                }else {
                    //不同品的情况
                    [cell.giftSubTitle setHidden:YES];
                    
                    if ([_productArray[indexPath.row-1][@"promo_product"][0][@"type"] isEqualToString:@"5"] && [[UserDefaults service] getOperatingState] == YES) {
                        [cell.orderCount2 setHidden:NO];
                        [cell.plus2 setHidden:NO];
                        [cell.minus2 setHidden:NO];
                    }else {
                        [cell.orderCount2 setHidden:YES];
                        [cell.plus2 setHidden:YES];
                        [cell.minus2 setHidden:YES];
                    }
                    
                    
                    cell.plusBlock2 = ^(NSInteger nCount,BOOL animated, BOOL show)
                    {
                        strongify(self);
                        strongify(cell);
                        if ([self.productArray[indexPath.row-1][@"promo_product"][0][@"on_sale"] isEqualToString:@"1"]) {
                            
                            if (show == NO) {
                                
                                NSMutableDictionary *dic = [self.productArray[indexPath.row-1][@"promo_product"][0] mutableCopy];
                                
                                [dic setObject:[NSString stringWithFormat:@"%@,%@", self.productArray[indexPath.row-1][@"product_no"], self.productArray[indexPath.row-1][@"promo_product"][0][@"product_no"]] forKey:@"product_no"];
                                
                                [self storeOrders:dic isAdded:animated];
                                
                                CGRect parentRect = [cell convertRect:cell.plus2.frame toView:self.view];
                                
                                if (animated) {
                                    [self JoinCartAnimationWithRect:parentRect];
                                    totalOrders ++;
                                }
                                else
                                {
                                    totalOrders --;
                                }
                                ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)totalOrders];
                                [self setCartImage];
                                [self setTotalMoney];
                                
                                [rightTableView reloadData];
                            }else {
                                [self showDetailMsg:@"第二件折扣商品不能超过主商品，您需再订购主商品。"];
                            }
                        }else {
                            [self showDetailMsg:@"该商品售卖时间有限，暂时无法购买"];
                        }
                    };
                    
                    //不同品的情况 刷新父列表
                    if (ordersArray.count > 0) {
                        cell.amount = 0;
                        cell.amount2 = 0;
                        for (NSMutableDictionary *dic1 in ordersArray) {
                            
                            if ([dic1[@"product_no"] isEqualToString:_productArray[indexPath.row-1][@"product_no"]]){
                                
                                NSInteger nCount = [dic1[@"orderCount"] integerValue];
                                cell.amount = nCount;
                            }else if ([dic1[@"product_no"] isEqualToString:[NSString stringWithFormat:@"%@,%@", _productArray[indexPath.row-1][@"product_no"], _productArray[indexPath.row-1][@"promo_product"][0][@"product_no"]]]){
                                NSInteger nCount = [dic1[@"orderCount"] integerValue];
                                cell.amount2 = nCount;
                            }
                        }
                        
                        return cell;
                    }else {
                        cell.amount = 0;
                        cell.amount2 = 0;
                        return cell;
                    }
                }
                
                return cell;
                
            }else {
                //香烟
                if ([level1String isEqualToString:@"11"]) {
                    
                    RightCigaretteCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier7];
                    
                    if (!cell) {
                        cell = [[RightCigaretteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier7];
                    }
                
                    weakify(cell);
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.rightTitle.text = _productArray[indexPath.row-1][@"description"];//商品名
                    cell.rightSubTitle.text = _productArray[indexPath.row-1][@"capacity_description"];//规格
                    
                    cell.salesArray = _productArray[indexPath.row-1][@"promo_list"];//促销类型
                    
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
                    float nTotal = [_productArray[indexPath.row-1][@"dis_price"] floatValue];//价格
                    NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:nTotal]];
                    cell.price.text = price;
                    
                    cell.oldPrice = [_productArray[indexPath.row-1][@"sa_price"] floatValue];
                    
                    if ([_productArray[indexPath.row-1][@"dis_price"] isEqualToString:_productArray[indexPath.row-1][@"sa_price"]]) {
                        [cell.oldPriceLabel setHidden:YES];
                    }else {
                        [cell.oldPriceLabel setHidden:NO];
                    }
                    
                    if ([[UserDefaults service] getOperatingState] == YES) {
                        
                        if ([_productArray[indexPath.row-1][@"stock_qty"] intValue] > 0) {
                            
                            if ([_productArray[indexPath.row-1][@"on_sale"] isEqualToString:@"1"]) {
                                [cell.soldOut setHidden:YES];
                                [cell.plus setSelected:YES];
                                [cell.packageBtn setEnabled:YES];
                                
                                if ([_productArray[indexPath.row-1][@"box_unit"] intValue] > 1) {
                                    [cell.packageBtn setHidden:NO];
                                }else {
                                    [cell.packageBtn setHidden:YES];
                                }
                            }else {
                                [cell.soldOut setHidden:NO];
                                [cell.plus setSelected:NO];
                                [cell.packageBtn setEnabled:NO];
                            }
                        }else {
                            //show
                            [cell.soldOut setHidden:NO];
                            [cell.plus setSelected:NO];
                            [cell.packageBtn setEnabled:NO];
                        }
                    }else {
                        [cell.plus setHidden:YES];
                        [cell.packageBtn setHidden:YES];
                    }
                    
//                    __weak __typeof(&*cell)weakCell =cell;
                    cell.plusBlock = ^(NSInteger nCount,BOOL animated)
                    {
                        strongify(self);
                        strongify(cell);
                        if ([self.productArray[indexPath.row-1][@"stock_qty"] intValue] > 0) {
                        
                        if ([self.productArray[indexPath.row-1][@"on_sale"] isEqualToString:@"1"]) {
                            NSMutableDictionary *dic = [self.productArray[indexPath.row-1] mutableCopy];
                            
                            [self storeOrders:dic isAdded:animated];
                            
                            CGRect parentRect = [cell convertRect:cell.plus.frame toView:self.view];
                            
                            if (animated) {
                                [self JoinCartAnimationWithRect:parentRect];
                                totalOrders ++;
                            }
                            else
                            {
                                totalOrders --;
                            }
                            ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)totalOrders];
                            [self setCartImage];
                            [self setTotalMoney];
                            
                            [rightTableView reloadData];
                        }else {
                            [self showDetailMsg:@"该商品售卖时间有限，暂时无法购买"];
                        }
                        }else {
                            [self showMsg:@"该商品已售罄"];
                        }
                    };
                    
                    //成箱
                    cell.packageBlock = ^(NSInteger nCount,BOOL animated)
                    {
                        strongify(self);
                        strongify(cell);
                        cell.amount += [self.productArray[indexPath.row-1][@"box_unit"] integerValue];
                        
                        NSMutableDictionary *dic = [self.productArray[indexPath.row-1] mutableCopy];
                        
                        [self storePackageOrders:dic boxUnit:[self.productArray[indexPath.row-1][@"box_unit"] intValue] isAdded:animated];
                        
                        CGRect parentRect = [cell convertRect:cell.plus.frame toView:self.view];
                        
                        if (animated) {
                            [self JoinCartAnimationWithRect:parentRect];
                            totalOrders += [self.productArray[indexPath.row-1][@"box_unit"] integerValue];
                        }
                        
                        ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)totalOrders];
                        [self setCartImage];
                        [self setTotalMoney];
                        
                        [rightTableView reloadData];
                        
                    };
                    
                    //没有第二件商品 刷新父列表(需要强化测试)
                    if (ordersArray.count > 0) {
                        NSMutableDictionary *dic = _productArray[indexPath.row-1];
                        for (dic in ordersArray) {
                            
                            if ([dic[@"product_no"] isEqualToString:_productArray[indexPath.row-1][@"product_no"]]){
                                
                                NSInteger nCount = [dic[@"orderCount"] integerValue];
                                cell.amount = nCount;
                                return cell;
                            }
                        }
                        cell.amount = 0;
                        return cell;
                    }else {
                        cell.amount = 0;
                        return cell;
                    }
                    
                }else {
                    RightCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier3];
                    
                    if (!cell) {
                        cell = [[RightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier3];
                    }
                    
                  
                    weakify(cell);
                    
                    [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:_productArray[indexPath.row-1][@"product_url"]]
                                           placeholderImage:[UIImage imageNamed:@""]
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                      //TODO
                                                      strongify(self);
                                                      strongify(cell);
                                                      if ([self.productArray[indexPath.row-1][@"stock_qty"] intValue] > 0) {
                                                          //hidden
                                                          [cell.rightImageView2 setHidden:YES];
                                                      }else {
                                                          //show
                                                          [cell.rightImageView2 setHidden:NO];
                                                      }
                                                      
                                                  }];
                    
                    cell.rightTitle.text = _productArray[indexPath.row-1][@"description"];//商品名
                    cell.rightSubTitle.text = _productArray[indexPath.row-1][@"capacity_description"];//规格
                    cell.salesArray = _productArray[indexPath.row-1][@"promo_list"];//促销类型
                    
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
                    float nTotal = [_productArray[indexPath.row-1][@"dis_price"] floatValue];//价格
                    NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:nTotal]];
                    cell.price.text = price;
                    
                    cell.oldPrice = [_productArray[indexPath.row-1][@"sa_price"] floatValue];
                    
                    if ([_productArray[indexPath.row-1][@"dis_price"] isEqualToString:_productArray[indexPath.row-1][@"sa_price"]]) {
                        [cell.oldPriceLabel setHidden:YES];
                    }else {
                        [cell.oldPriceLabel setHidden:NO];
                    }
                    
                    if ([[UserDefaults service] getOperatingState] == YES) {
                        if ([_productArray[indexPath.row-1][@"stock_qty"] intValue] > 0) {
                            
                            if ([_productArray[indexPath.row-1][@"on_sale"] isEqualToString:@"1"]) {
                                [cell.plus setSelected:YES];
                                [cell.packageBtn setEnabled:YES];
                                if ([_productArray[indexPath.row-1][@"box_unit"] intValue] > 1) {
                                    [cell.packageBtn setHidden:NO];
                                }else {
                                    [cell.packageBtn setHidden:YES];
                                }
                            }else {
                                [cell.plus setSelected:NO];
                                [cell.packageBtn setEnabled:NO];
                            }
                            
                        }else {
                            //show
                            [cell.plus setSelected:NO];
                            [cell.packageBtn setEnabled:NO];
                        }
                    }else {
                        [cell.plus setHidden:YES];
                        [cell.packageBtn setHidden:YES];
                    }
                    
//                    __weak __typeof(&*cell)weakCell =cell;
                    cell.plusBlock = ^(NSInteger nCount,BOOL animated)
                    {
                        strongify(self);
                        strongify(cell);
                        if ([self.productArray[indexPath.row-1][@"stock_qty"] intValue] > 0) {
                        
                        if ([self.productArray[indexPath.row-1][@"on_sale"] isEqualToString:@"1"]) {
                            NSMutableDictionary *dic = [self.productArray[indexPath.row-1] mutableCopy];
                            
                            [self storeOrders:dic isAdded:animated];
                            
                            CGRect parentRect = [cell convertRect:cell.plus.frame toView:self.view];
                            
                            if (animated) {
                                [self JoinCartAnimationWithRect:parentRect];
                                totalOrders ++;
                            }
                            else
                            {
                                totalOrders --;
                            }
                            ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)totalOrders];
                            [self setCartImage];
                            [self setTotalMoney];
                            
                            [rightTableView reloadData];
                        }else {
                            [self showDetailMsg:@"该商品售卖时间有限，暂时无法购买"];
                        }
                        }else {
                            [self showMsg:@"该商品已售罄"];
                        }
                    };
                    
                    //成箱
                    cell.packageBlock = ^(NSInteger nCount,BOOL animated)
                    {
                        strongify(self);
                        strongify(cell);
                        cell.amount += [self.productArray[indexPath.row-1][@"box_unit"] integerValue];
                        
                        NSMutableDictionary *dic = [self.productArray[indexPath.row-1] mutableCopy];
                        
                        [self storePackageOrders:dic boxUnit:[self.productArray[indexPath.row-1][@"box_unit"] intValue] isAdded:animated];
                        
                        CGRect parentRect = [cell convertRect:cell.plus.frame toView:self.view];
                        
                        if (animated) {
                            [self JoinCartAnimationWithRect:parentRect];
                            totalOrders += [self.productArray[indexPath.row-1][@"box_unit"] integerValue];
                        }
                        ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)totalOrders];
                        [self setCartImage];
                        [self setTotalMoney];
                        
                        [rightTableView reloadData];
                        
                    };
                    
                    //没有第二件商品 刷新父列表(需要强化测试)
                    if (ordersArray.count > 0) {
                        NSMutableDictionary *dic = self.productArray[indexPath.row-1];
                        for (dic in ordersArray) {
                            
                            if ([dic[@"product_no"] isEqualToString:self.productArray[indexPath.row-1][@"product_no"]]){
                                
                                NSInteger nCount = [dic[@"orderCount"] integerValue];
                                cell.amount = nCount;
                                return cell;
                            }
                        }
                        cell.amount = 0;
                        return cell;
                    }else {
                        cell.amount = 0;
                        return cell;
                    }
                    
                }
            }
            return cell;
        }
        
        return cell;
        
    }else if (tableView == ShopCartView.OrderList.tableView) {
        
        ShoppingCartCell *cell = (ShoppingCartCell *)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier4];
        
        if (!cell) {
            cell=[[ShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier4];
        }
        
        NSArray *array = [ordersArray[indexPath.row][@"product_no"] componentsSeparatedByString:@","];
        if ([array count] == 2) {
            cell.nameLabel.text = [NSString stringWithFormat:@"%@(第二件)", ordersArray[indexPath.row][@"description"]];
        }else {
            cell.nameLabel.text = ordersArray[indexPath.row][@"description"];
        }
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        float nTotal = [ordersArray[indexPath.row][@"dis_price"] floatValue];
        NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:nTotal]];
        cell.priceLabel.text = price;
        
        NSInteger count = [ordersArray[indexPath.row][@"orderCount"] integerValue];
        cell.number = count;
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
     
        weakify(cell);
//        __weak __typeof(&*cell)weakCell =cell;
        cell.operationBlock = ^(NSUInteger nCount,BOOL plus)
        {
            strongify(self);
            strongify(cell);
            NSMutableDictionary *dic = [ordersArray[indexPath.row] mutableCopy];
            
            for (NSMutableDictionary *dicc in ordersArray) {
                
                NSArray *array = [dic[@"product_no"] componentsSeparatedByString:@","];
                if ([array count] == 2) {
                    if ([array[0] isEqualToString:dicc[@"product_no"]]) {
                        
                        if (plus==YES) {
                            if ([dic[@"orderCount"] integerValue] < [dicc[@"orderCount"] integerValue]) {
                                [self storeOrders:dic isAdded:plus];
                                
                                totalOrders = plus ? ++totalOrders : --totalOrders;
                                
                                ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)totalOrders];
                                //            //刷新父列表
                                [rightTableView reloadData];
                                //
                                [self setCartImage];
                                [self setTotalMoney];
                                if (totalOrders ==0) {
                                    [ShopCartView dismissAnimated:YES];
                                }
                            }else {
                                cell.number = nCount -1;
                                [cell showNumber:nCount-1];
                                [self showDetailMsg:@"第二件折扣商品不能超过主商品，您需再订购主商品。"];
                            }
                        }else {
                            
                            [self storeOrders:dic isAdded:plus];
                            
                            totalOrders = plus ? ++totalOrders : --totalOrders;
                            
                            ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)totalOrders];
                            //            //刷新父列表
                            [rightTableView reloadData];
                            //
                            [self setCartImage];
                            [self setTotalMoney];
                            
                            if (totalOrders ==0) {
                                [ShopCartView dismissAnimated:YES];
                            }
                            
                            return;
                            
                        }
                    }
                }else {
                    //主品
                    if ([dic[@"product_no"] isEqualToString:dicc[@"product_no"]]) {
                        [self storeOrders:dic isAdded:plus];
                        
                        totalOrders = plus ? ++totalOrders : --totalOrders;
                        
                        ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)totalOrders];
                        //            //刷新父列表
                        [rightTableView reloadData];
                        //
                        [self setCartImage];
                        [self setTotalMoney];
                        
                        if (totalOrders ==0) {
                            [ShopCartView dismissAnimated:YES];
                        }
                        
                        if (plus == NO) {
                            //减掉副品
                            for (NSMutableDictionary *dicc2 in ordersArray) {
                                
                                NSArray *array = [dicc2[@"product_no"] componentsSeparatedByString:@","];
                                if ([array count] == 2) {
                                    if ([array[0] isEqualToString:dic[@"product_no"]]) {
                                        
                                        if ([dic[@"orderCount"] integerValue] <= [dicc2[@"orderCount"] integerValue]) {
                                            
                                            [self storeOrders:dicc2 isAdded:plus];
                                            
                                            totalOrders = plus ? ++totalOrders : --totalOrders;
                                            
                                            ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)totalOrders];
                                            //            //刷新父列表
                                            [rightTableView reloadData];
                                            //
                                            [self setCartImage];
                                            [self setTotalMoney];
                                            
                                            if (totalOrders ==0) {
                                                [ShopCartView dismissAnimated:YES];
                                            }
                                            
                                            return;
                                        }
                                    }
                                }
                            }
                        }
                        return;
                    }
                }
            }
        };
        
        return cell;
    }else if (tableView == storeSalesTableView) {
        StoreSalesCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier5];
        
        if (!cell) {
            cell=[[StoreSalesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier5];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = [UIColor clearColor];
        
        if (![[[UserDefaults service] getStoreSales] isKindOfClass:[NSNull class]] && [[UserDefaults service] getStoreSales].count > 0) {
            NSString *temp = [[[UserDefaults service] getStoreSales] objectAtIndex:indexPath.row][@"ptag"];
            cell.salesImageView.image = [UIImage imageNamed:temp];
            cell.salesText.text = [[[UserDefaults service] getStoreSales] objectAtIndex:indexPath.row][@"info"];
            
            if (indexPath.row == 0) {
                
                [cell.salesEtc setHidden:NO];
                
                if ([[UserDefaults service] getStoreSales].count > 1 ) {
                    cell.salesEtc.text = [NSString stringWithFormat:@"等%lu个活动", (unsigned long)[[UserDefaults service] getStoreSales].count];
                    [cell.open setHidden:NO];
                }else {
                    cell.salesEtc.text = [NSString stringWithFormat:@"%lu个活动", (unsigned long)[[UserDefaults service] getStoreSales].count];
                    [cell.open setHidden:YES];
                }
                
            }else {
                [cell.salesEtc setHidden:YES];
                [cell.open setHidden:YES];
            }
            
     
            weakify(cell);
//            __weak __typeof(&*cell)weakCell = cell;
            cell.openBlock = ^() {
                strongify(self);
                strongify(cell);
                if (cell.open.selected == YES) {
                    isOpen = NO;
                    cell.open.selected = NO;
                    [cell.salesEtc setHidden:NO];
                    [UIView animateWithDuration:0.2 animations:^{
                        
                        [storeSalesTableView setFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT+10*SCALE, SCREEN_WIDTH, STORE_CELL_HEIGHT+5*SCALE)];
                        [contentView setFrame:CGRectMake(0, CGRectGetMaxY(storeSalesTableView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_BAR_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT-10*SCALE)];
                       
                    }completion:^(BOOL finished) {
                        
                        [storeSalesTableView reloadData];
                        [cell.open setBackgroundImage:[UIImage imageNamed:@"sales_down"] forState:UIControlStateNormal];
                        
                    }];
                    
                }else {
                    isOpen = YES;
                    cell.open.selected=YES;
                    [cell.salesEtc setHidden:YES];
                    [UIView animateWithDuration:0.3 animations:^{
                        
                        [storeSalesTableView setFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT+10*SCALE, SCREEN_WIDTH, [[UserDefaults service] getStoreSales].count*STORE_CELL_HEIGHT+5*SCALE)];
                        [contentView setFrame:CGRectMake(0, CGRectGetMaxY(storeSalesTableView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_BAR_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT-10*SCALE)];
                        [storeSalesTableView reloadData];
                    }completion:^(BOOL finished) {
                        
                        [cell.open setBackgroundImage:[UIImage imageNamed:@"sales_up"] forState:UIControlStateNormal];
                        
                    }];
                }
            };
        }
        return cell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == leftTableView) {
        
        level1String = [level1Array objectAtIndex:indexPath.row][@"id"];
        
        [self reloadLevel2:indexPath.row];
        
        [self reloadBtnEvent];
    }
    
    if (tableView == rightTableView) {
        
        //香烟类暂时无法查看详情
        if (![level1String isEqualToString:@"11"]) {
            [rightTableView deselectRowAtIndexPath:indexPath animated:NO];
            
            ProductDetailViewController *productDetailViewController = [[ProductDetailViewController alloc] init];
            [productDetailViewController.paramDictionary setObject:_productArray[indexPath.row-1][@"product_no"] forKey:@"product_no"];
            PUSH(productDetailViewController);
        }

    }
    
    NSLog(@"点击了第%ld行", (long)indexPath.row);
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if ([tableView isEqual:ShopCartView.OrderList.tableView])
    {
        return SECTION_HEIGHT+TIPS_HEIGHT;
    }
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if ([tableView isEqual:ShopCartView.OrderList.tableView])
    {
        return SECTION_HEIGHT/2;
    }
    else
        return 0;
}

#pragma mark - 购物车
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SECTION_HEIGHT+TIPS_HEIGHT)];
    
    tipsViewWithShopCartView.backgroundColor = UIColorFromRGB(255, 241, 213);
    [view addSubview:tipsViewWithShopCartView];
    
    tipsLabelWithShopCartView.textAlignment = NSTextAlignmentCenter;
    tipsLabelWithShopCartView.textColor = [UIColor darkGrayColor];
    tipsLabelWithShopCartView.font = [UIFont systemFontOfSize:9.5*SCALE];
    [tipsViewWithShopCartView addSubview:tipsLabelWithShopCartView];
    
    UILabel *leftLine = [[UILabel alloc] initWithFrame:CGRectMake(0, TIPS_HEIGHT, 3, SECTION_HEIGHT)];
    leftLine.backgroundColor = ICON_COLOR;
    [view addSubview:leftLine];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, TIPS_HEIGHT+13*SCALE, 14*SCALE, 14*SCALE)];
    iconImageView.image = [UIImage imageNamed:@"cart_icon"];
    [view addSubview:iconImageView];
    
    
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(30*SCALE, TIPS_HEIGHT, 100*SCALE, SECTION_HEIGHT)];
    headerTitle.text = @"购物车";
    headerTitle.textColor = [UIColor darkGrayColor];
    headerTitle.font = [UIFont systemFontOfSize:13*SCALE];
    [view addSubview:headerTitle];
    
    if (section == 0) {
        
        UIImageView *clearImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 104*SCALE, TIPS_HEIGHT+13*SCALE, 14*SCALE, 14*SCALE)];
        clearImageView.image = [UIImage imageNamed:@"cart_clear"];
        [view addSubview:clearImageView];
        
        UIButton *clear = [UIButton buttonWithType:UIButtonTypeCustom];
        clear.frame= CGRectMake(SCREEN_WIDTH - 100*SCALE, TIPS_HEIGHT, 100*SCALE, SECTION_HEIGHT);
        [clear setTitle:@"清空购物车" forState:UIControlStateNormal];
        [clear setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        clear.titleLabel.textAlignment = NSTextAlignmentCenter;
        clear.titleLabel.font = [UIFont systemFontOfSize:13*SCALE];
        [clear addTarget:self action:@selector(clearShoppingCart) forControlEvents:UIControlEventTouchUpInside];

        [view addSubview:clear];
    }
    
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (void)clearShoppingCart {
    UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否清空购物车内所有商品?" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *NOButton = [UIAlertAction actionWithTitle:@"清空" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        CartInfoDAL *dal = [[CartInfoDAL alloc] init];
        
        [dal cleanCartInfo];
        
        [ordersArray removeAllObjects];
        
        totalOrders = 0;
        
        ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)totalOrders];
        
        [self setTotalMoney];
        
        [self setCartImage];
        
        [ShopCartView dismissAnimated:YES];
        
        [rightTableView reloadData];
        
    }];
    
    [storeExistAlert addAction:OKButton];
    
    [storeExistAlert addAction:NOButton];
    
    [self presentViewController:storeExistAlert animated:YES completion:nil];
}

#pragma mark -  菜单处理
- (void)reloadLevel2:(NSInteger)index {
    
    [tabView removeFromSuperview];
    
    NSArray *titleArray = [NSArray arrayWithArray:[level1Array objectAtIndex:index][@"category2"]];
    NSMutableArray *level2Array = [NSMutableArray array];
    for (NSDictionary *dic in titleArray) {
        [level2Array addObject:dic[@"name"]];
    }
    level2String = [titleArray firstObject][@"id"];
    
    pageNumber = 0;
    [rightTableView.mj_footer resetNoMoreData];
    
    tabView = [[LiuXSegmentView alloc] initWithFrame:CGRectMake(leftTableView.frame.size.width, 0, SCREEN_WIDTH - leftTableView.frame.size.width, 45*SCALE) titles:level2Array clickBlick:^void(NSInteger index) {
        
        level2String = [titleArray objectAtIndex:index-1][@"id"];
        
        pageNumber = 0;
        [rightTableView.mj_footer resetNoMoreData];
        
        //TODO 刷新主列表
        [self reloadBtnEvent];
        
        
    }];
    [contentView addSubview:tabView];
    [contentView sendSubviewToBack:tabView];
}

- (void)reloadBtnEvent {
    
    [contentView setHidden:YES];
    [self hideEmptyView];
    
    pageNumber = 0;
    
    [rightTableView setHidden:YES];
    
    if (isOpen==YES) {
        
        [bg setFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_BAR_HEIGHT + STATUS_BAR_HEIGHT +[[[UserDefaults service] getStoreSales] count]*STORE_CELL_HEIGHT+15*SCALE)];
    }else {
        [bg setFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_BAR_HEIGHT + STATUS_BAR_HEIGHT +STORE_CELL_HEIGHT+15*SCALE)];
    }
    
    [self showLoadHUDMsg:@"努力加载中..."];
    
    //TODO需要修改成动态店铺
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:level1String, @"category_level1", level2String, @"category_level2", @"0", @"type", [NSString stringWithFormat:@"%ld", (long)pageNumber], @"page", [[UserDefaults service] getStoreId], @"cvs_no", nil];
    weakify(self);
    [HttpClientService requestProduct:paramDic success:^(id responseObject) {
        
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            [rightTableView setHidden:NO];
            
            self.productArray = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"product"]];
            
            notice = [jsonDic objectForKey:@"notice"];
            bannerImageUrl = [jsonDic objectForKey:@"advert_url"];
            
            pageNumber++;
            
            [bg setHidden:NO];
            [bg setFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_BAR_HEIGHT + STATUS_BAR_HEIGHT +[[[UserDefaults service] getStoreSales] count]*STORE_CELL_HEIGHT+15*SCALE)];
            [storeSalesTableView setHidden:NO];
            [contentView setHidden:NO];
            
            [self hideEmptyView];
            
            [rightTableView reloadData];
            
            [rightTableView setContentOffset:CGPointMake(0,0) animated:YES];
            
            [self hideLoadHUD:YES];
        }
        
    } failure:^(NSError *error) {
        strongify(self);
        [self hideLoadHUD:YES];
        [contentView setHidden:YES];
        [self showEmptyViewWithStyle:EmptyViewStyleNetworkUnreachable];
    }];
}

- (void)loadMoreData {
    
    pageLen = 20;
    
    [self showLoadHUDMsg:@"努力加载中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:level1String, @"category_level1", level2String, @"category_level2", @"0", @"type", [NSString stringWithFormat:@"%ld", (long)pageNumber], @"page", [[UserDefaults service] getStoreId], @"cvs_no", nil];
    
    [HttpClientService requestProduct:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"product"]];
            
            if (array.count == 0) {
                
                [self hideLoadHUD:YES];
                
                [self showMsg:@"没有更多商品了"];
                
                [rightTableView.mj_footer endRefreshingWithNoMoreData];
                
            }else if (array.count > 0 && array.count < pageLen) {
                
                for (int i = 0; i<array.count; i++) {
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    
                    dic = [array objectAtIndex:i];
                    
                    [_productArray addObject:dic];
                }
                
                [rightTableView reloadData];
                
                [self hideLoadHUD:YES];
                
                [rightTableView.mj_footer endRefreshingWithNoMoreData];
                
                
            }else {
                
                for (int i = 0; i<array.count; i++) {
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    
                    dic = [array objectAtIndex:i];
                    
                    [_productArray addObject:dic];
                }
                pageNumber++;
                
                [rightTableView reloadData];
                
                [self hideLoadHUD:YES];
                
                [rightTableView.mj_footer endRefreshing];
                
            }
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
        [rightTableView.mj_footer endRefreshing];
    }];
}



#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}

- (void)rightBtnClick:(id)sender {
    NSLog(@"分享");
}

#pragma mark - 动画
#pragma mark -加入购物车动画
- (void) JoinCartAnimationWithRect:(CGRect)rect {
    
    CGFloat startX = rect.origin.x;
    CGFloat startY = rect.origin.y;
    
    path= [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(startX, startY)];
    //三点曲线
    [path addCurveToPoint:CGPointMake(endPointX, endPointY)
            controlPoint1:CGPointMake(startX, startY)
            controlPoint2:CGPointMake(startX - 180, startY - 100)];
    
    dotLayer = [CALayer layer];
    dotLayer.backgroundColor = [UIColor redColor].CGColor;
    dotLayer.frame = CGRectMake(0, 0, 15, 15);
    dotLayer.cornerRadius = (15 + 15) /4;
    [self.view.layer addSublayer:dotLayer];
    [self groupAnimation];
    
}
#pragma mark - 组合动画
- (void)groupAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
    alphaAnimation.duration = 0.25f;
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.1];
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,alphaAnimation];
    groups.duration = 0.4f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [groups setValue:@"groupsAnimation" forKey:@"animationName"];
    [dotLayer addAnimation:groups forKey:nil];
    
    [self.view bringSubviewToFront:ShopCartView];
    
    [self performSelector:@selector(removeFromLayer:) withObject:dotLayer afterDelay:0.4f];
    
}

- (void)removeFromLayer:(CALayer *)layerAnimation {
    
    [layerAnimation removeFromSuperlayer];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if ([[anim valueForKey:@"animationName"]isEqualToString:@"groupsAnimation"]) {
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:1.2];
        shakeAnimation.toValue = [NSNumber numberWithFloat:0.9];
        //        shakeAnimation.autoreverses = YES;
        [ShopCartView.shoppingCartBtn.layer addAnimation:shakeAnimation forKey:nil];
    }
    
}

- (void)setCartImage {
    if ([[UserDefaults service] getOperatingState] == YES) {
        
        [ShopCartView setHidden:NO];
        [closeView setHidden:YES];
        if (totalOrders > 0) {
        
            [ShopCartView setCartImage:@"cart_full"];
            [tipsViewWithoutShopCartView setHidden:NO];
            //        ShopCartView.backgroundColor = [UIColor whiteColor];
        }else {
            [ShopCartView setCartImage:@"cart_empty"];
            [tipsViewWithoutShopCartView setHidden:YES];
            CartInfoDAL *dal = [[CartInfoDAL alloc] init];
            [dal deleteGift];
            //        ShopCartView.backgroundColor = [UIColor darkGrayColor];
        }
    }else {
        [ShopCartView setHidden:YES];
        [closeView setHidden:NO];
    }
}

- (void)setTotalMoney {
    
    float nTotal = 0;
    for (NSMutableDictionary *dic in ordersArray) {
        nTotal += [dic[@"orderCount"] integerValue] * [dic[@"dis_price"] floatValue];
    }
    [ShopCartView setTotalMoney:nTotal];
    
    NSMutableArray *monyArray = [NSMutableArray array];
    NSMutableArray *monyArray2 = [NSMutableArray array];
    NSMutableArray *monyArray3 = [self test];
    for (int i=0; i<[[self test] count]; i++) {
        [monyArray addObject:([NSNumber numberWithFloat:[[[self test] objectAtIndex:i][@"if"] floatValue]-nTotal])];
        [monyArray2 addObject:[NSNumber numberWithFloat:[[[self test] objectAtIndex:i][@"if"] floatValue]]];
    }
    
    if ([monyArray count] > 0) {
        float min_number = INFINITY;   //最小值
        int min_index = 0;           //最小值下标
        
        for (int ii=0; ii<monyArray.count; ii++)
        {
            
            //取最小值和最小值对应的下标
            float b = [monyArray[ii] floatValue];
            
            if (b > 0) {
                if (b < min_number)
                {
                    min_index = ii;
                }
                min_number = b > min_number ? min_number : b;
                
                //                NSLog(@"输出最小值在数组中的下标---->>>%d",min_index);
                //                NSLog(@"输出数组中最小值---->>>>%f",min_number);
            }
            
        }
        
        
        float max_number = 0;          //最大值
        int max_index = 0;           //最大值的下标
        
        
        for (int iii=0; iii<monyArray2.count; iii++)
        {
            
            //取最大值和最大值的对应下标
            float a = [monyArray2[iii] intValue];
            if (a > max_number)
            {
                max_index = iii;
            }
            max_number = a > max_number ? a : max_number;
            
            
        }
        
        
        
        
        
        if (min_number>0 && min_number != INFINITY) {
            //        NSLog(@"输出最小值在数组中的下标---->>>%d",min_index);
            //        NSLog(@"输出数组中最小值---->>>>%f",min_number);
            
            
            
            tipsLabelWithShopCartView.text = [NSString stringWithFormat:@"再买%.2f元,%@", min_number, [[self test] objectAtIndex:min_index][@"result"]];
            [rightTableView reloadData];
            
            tipsLabelWithoutShopCartView.text = [NSString stringWithFormat:@"再买%.2f元,%@", min_number, [[self test] objectAtIndex:min_index][@"result"]];
            
        }else if (min_number == INFINITY) {
            tipsLabelWithShopCartView.text = [NSString stringWithFormat:@"已满%.2f元,%@", max_number, [[self test] objectAtIndex:max_index][@"result"]];
            [rightTableView reloadData];
            
            tipsLabelWithoutShopCartView.text = [NSString stringWithFormat:@"已满%.2f元,%@", max_number, [[self test] objectAtIndex:max_index][@"result"]];
        }
    }
}

- (NSArray *)test {
    NSArray *tempArr1 = [NSArray arrayWithArray:[[UserDefaults service] getStoreSales]];
    
    NSMutableArray *tipsArr = [NSMutableArray array];
    
    for (int i=0; i<tempArr1.count; i++) {
        NSDictionary *dic1 = [tempArr1 objectAtIndex:i];
        if ([dic1[@"ptag"] isEqualToString:@"jian"]) {
            //满减
            NSArray *array = [dic1[@"info"] componentsSeparatedByString:@"/"];
            
            for (int ii =0; ii<array.count; ii++) {
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                NSString * numStr = [array objectAtIndex:ii];
                NSScanner * scanner = [NSScanner scannerWithString:numStr];
                NSCharacterSet * numSet = [NSCharacterSet decimalDigitCharacterSet];
                int num = 0;
                while (NO == [scanner isAtEnd]) {
                    if ([scanner scanUpToCharactersFromSet:numSet intoString:NULL]) {
                        
                        if (num == 0) {
                            if ([scanner scanInt:&num]) {
                                [dic setObject:[NSString stringWithFormat:@"%d", num] forKey:@"if"];
                                //                                NSLog(@"num : %d",num);
                            }
                        }else {
                            if ([scanner scanInt:&num]) {
                                [dic setObject:[NSString stringWithFormat:@"可减%d元", num] forKey:@"result"];
                                //                                NSLog(@"num : %d",num);
                            }
                        }
                        
                    }
                }
                [dic setObject:@"jian" forKey:@"type"];
                
                [tipsArr addObject:dic];
                num = 0;
            }
            
            
        }else if ([dic1[@"ptag"] isEqualToString:@"song"]) {
            //满赠
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            NSArray *arr = [dic1[@"info"] componentsSeparatedByString:@"赠送"];
            
            NSScanner * scanner = [NSScanner scannerWithString:arr[0]];
            NSCharacterSet * numSet = [NSCharacterSet decimalDigitCharacterSet];
            while (NO == [scanner isAtEnd]) {
                if ([scanner scanUpToCharactersFromSet:numSet intoString:NULL]) {
                    int num;
                    if ([scanner scanInt:&num] && (num != 1)) {
                        [dic setObject:[NSString stringWithFormat:@"%d", num] forKey:@"if"];
                        
                        [dic setObject:[NSString stringWithFormat:@"可获赠%@", arr[1]] forKey:@"result"];
                        [dic setObject:@"song" forKey:@"type"];
                        
                        //                        NSLog(@"num : %d"，num);
                    }
                }
            }
            
            [tipsArr addObject:dic];
        }else if ([dic1[@"ptag"] isEqualToString:@"tudo"]) {
            //满送优惠劵
        }else if ([dic1[@"ptag"] isEqualToString:@"huan"]) {
            //换购
            NSArray *array = [dic1[@"info"] componentsSeparatedByString:@"或"];
            
            for (int iii =0; iii<array.count; iii++) {
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                NSString * numStr = [array objectAtIndex:iii];
                NSScanner * scanner = [NSScanner scannerWithString:numStr];
                NSCharacterSet * numSet = [NSCharacterSet decimalDigitCharacterSet];
                int num = 0;
                while (NO == [scanner isAtEnd]) {
                    if ([scanner scanUpToCharactersFromSet:numSet intoString:NULL]) {
                        
                        if ([scanner scanInt:&num]) {
                            [dic setObject:[NSString stringWithFormat:@"%d", num] forKey:@"if"];
                            
                            [dic setObject:@"可参加换购活动" forKey:@"result"];
                            //                                NSLog(@"num : %d",num);
                        }
                    }
                }
                [dic setObject:@"huan" forKey:@"type"];
                
                [tipsArr addObject:dic];
            }
        }
    }
    return tipsArr;
    
}

#pragma mark - store orders 存放订单
- (void)storeOrders:(NSMutableDictionary *)dictionary isAdded:(BOOL)added {
    
    if (added) {
        //存入商品 dictionary
        for (NSMutableDictionary *dic in ordersArray) {
            
            if ([dic[@"product_no"] isEqualToString:dictionary[@"product_no"]]){
                //购物车内有选择的商品
                NSInteger nCount = [dic[@"orderCount"] integerValue];
                nCount = nCount+1;
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)nCount] forKey:@"orderCount"];
                
                //更新DB
                [self updateDB:dic];
                
                ShopCartView.OrderList.objects = ordersArray;
                [ShopCartView.OrderList.tableView reloadData];
                return;
            }
        }
        
        //购物车内没有商品
        [dictionary setObject:@"1" forKey:@"orderCount"];
        [ordersArray addObject:dictionary];
    
        //更新DB
        [self updateDB:dictionary];
        
        ShopCartView.OrderList.objects = ordersArray;
        [ShopCartView.OrderList.tableView reloadData];
        return;
        
    }else {
        //减法的时候
        for (NSMutableDictionary *dic in ordersArray) {
            
            if ([dic[@"product_no"] isEqualToString:dictionary[@"product_no"]]){
                
                NSInteger nCount = [dic[@"orderCount"] integerValue];
                
                nCount = nCount-1;
                
                if (nCount==0) {
                    
                    [dic setObject:@"0" forKey:@"orderCount"];
                    //更新DB
                    [self updateDB:dic];
                    
                    [ordersArray removeObject:dic];
                    
                    ShopCartView.OrderList.objects = ordersArray;
                    [ShopCartView updateFrame:ShopCartView.OrderList];
                    [ShopCartView.OrderList.tableView reloadData];
                    return;
                }else{
                    //更新
                    [dic setObject:[NSString stringWithFormat:@"%ld",(long)nCount] forKey:@"orderCount"];
                    
                    //更新DB
                    [self updateDB:dic];
                    
                    ShopCartView.OrderList.objects = ordersArray;
                    [ShopCartView.OrderList.tableView reloadData];
                    return;
                }
            }
        }
    }
}


- (void)storePackageOrders:(NSMutableDictionary *)dictionary boxUnit:(int)boxUnit isAdded:(BOOL)added {
    
    if (added) {
        //存入商品 dictionary
        for (NSMutableDictionary *dic in ordersArray) {
            
            if ([dic[@"product_no"] isEqualToString:dictionary[@"product_no"]]){
                //购物车内有选择的商品
                NSInteger nCount = [dic[@"orderCount"] integerValue];
                nCount = nCount + boxUnit;
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)nCount] forKey:@"orderCount"];
                
                //更新DB
                //更新DB
                [self updateDB:dic];

                ShopCartView.OrderList.objects = ordersArray;
                [ShopCartView.OrderList.tableView reloadData];
                return;
            }
        }
        
        //购物车内没有商品
        [dictionary setObject:[NSString stringWithFormat:@"%d", boxUnit] forKey:@"orderCount"];
        [ordersArray addObject:dictionary];
        
        //更新DB
        [self updateDB:dictionary];
        
        ShopCartView.OrderList.objects = ordersArray;
        [ShopCartView.OrderList.tableView reloadData];
        return;
        
    }
}

//更新DB
- (void)updateDB:(NSMutableDictionary *)dic {
    CartInfoDAL *dal = [[CartInfoDAL alloc] init];
    CartInfoEntity *entity = [[CartInfoEntity alloc] init];
    entity.product_no = [dic objectForKey:@"product_no"];
    entity.cvs_no = [[UserDefaults service] getStoreId];
    entity.orderCount = [dic objectForKey:@"orderCount"];
    entity.descriptionn = [dic objectForKey:@"description"];
    entity.dis_price = [dic objectForKey:@"dis_price"];
    entity.gift_flag = @"0";
    [dal insertIntoTable:entity];
}


#pragma mark ShoppingCartViewDelegate Methods
- (void)cashBtnClick:(id)sender {
    
    if ([[UserDefaults service] getLoginStatus] == YES) {
        SubmitOrderViewController *submitOrderViewController = [[SubmitOrderViewController alloc] init];
        
        [self.navigationController pushViewController:submitOrderViewController animated:YES];
    }else {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        PUSH(loginViewController);
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBtn {
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
    PUSH(searchViewController);
}

@end

