//
//  ProductDetailViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/7.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductDetailCell.h"
#import "SubmitOrderViewController.h"
#import "LoginViewController.h"

//购物车相关
#import "ShoppingCartCell.h"
#import "OverlayView.h"
#import "ShoppingCartView.h"
#import "BadgeView.h"
#import "CartInfoDAL.h"
#import "CartInfoEntity.h"

//分享
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "ShareMenuView.h"

#define SECTION_HEIGHT 40.0*SCALE
#define TIPS_HEIGHT 30.0*SCALE

@interface ProductDetailViewController ()<UITableViewDataSource, UITableViewDelegate, ZFReOrderTableViewDelegate, ShoppingCartViewDelegate, CAAnimationDelegate> {
    UITableView *contentView;
    
    //商品详情数据
    NSDictionary *jsonDic;
    
    //购物车相关
    NSUInteger totalOrders;
    CALayer *dotLayer;
    UIBezierPath *path;
    CGFloat endPointX;
    CGFloat endPointY;
    ShoppingCartView *ShopCartView;
    NSMutableArray *ordersArray;
    
    //购物车展开提示促销信息
    UIView *tipsViewWithShopCartView;
    UILabel *tipsLabelWithShopCartView;
    
    //购物车关闭提示促销信息
    UIView *tipsViewWithoutShopCartView;
    UILabel *tipsLabelWithoutShopCartView;
    
    ShareMenuView *shareMenuView;
    UIView *closeView;
}

@end

@implementation ProductDetailViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.backgroundColor = [UIColor clearColor];
        
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_bg"] forState:UIControlStateNormal];
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.shareButton setBackgroundImage:[UIImage imageNamed:@"navigation_share_bg"] forState:UIControlStateNormal];
        [navigationBar.shareButton setHidden:NO];
        [navigationBar.rightButton setBackgroundImage:[UIImage imageNamed:@"navigation_unfavorite_bg"] forState:UIControlStateNormal];
        [navigationBar.rightButton setHidden:NO];
        
        contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
        
        contentView.delegate = self;
        
        contentView.dataSource = self;
        
        contentView.separatorStyle = NO;
        
        contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        //去除底部多余分割线
        contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        contentView.estimatedRowHeight = 0;
        contentView.estimatedSectionHeaderHeight = 0;
        contentView.estimatedSectionFooterHeight = 0;
        
        [self.view addSubview:contentView];
        
        //购物车展开提示促销信息
        tipsViewWithShopCartView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TIPS_HEIGHT)];
        tipsLabelWithShopCartView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TIPS_HEIGHT)];
        
        //购物车关闭提示促销信息
        tipsLabelWithoutShopCartView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TIPS_HEIGHT)];
        tipsLabelWithoutShopCartView.textAlignment = NSTextAlignmentCenter;
        tipsLabelWithoutShopCartView.textColor = [UIColor darkGrayColor];
        tipsLabelWithoutShopCartView.font = [UIFont systemFontOfSize:9.5*SCALE];
        
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
        
        if (@available(iOS 11.0, *)) {
            contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            ShopCartView.OrderList.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        [self.view addSubview:ShopCartView];
        
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
        
        [self.view bringSubviewToFront:navigationBar];
        
        //购物车数据初始化
        ordersArray = [NSMutableArray array];
        
        //入参数
        _paramDictionary = [[NSMutableDictionary alloc] init];
        
        shareMenuView = [[ShareMenuView alloc] init];
        
        __block ProductDetailViewController *blockSelf = self;
        shareMenuView.shareButtonClickBlock = ^(NSInteger index)
        {
            switch (index) {
                case 0:
                    [blockSelf wxBtn];
                    break;
                    
                case 1:
                    [blockSelf qqBtn];
                    break;
                    
                case 2:
                    [blockSelf friendBtn];
                    break;
                    
                default:
                    break;
            }
        };
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [contentView setHidden:YES];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self requesetData];
    
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
}

- (void)requesetData {
    
    [self showLoadHUDMsg:@"努力加载中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_paramDictionary[@"product_no"], @"product_no", [[UserDefaults service] getStoreId], @"cvs_no", nil];
    
    [HttpClientService requestProductinfo:paramDic success:^(id responseObject) {
        
        jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
           
            if ([jsonDic[@"is_in_wish"] isEqualToString:@"1"]) {
                [navigationBar.rightButton setBackgroundImage:[UIImage imageNamed:@"navigation_favorite_bg"] forState:UIControlStateNormal];
              
                navigationBar.rightButton.selected = YES;
            }else {
                [navigationBar.rightButton setBackgroundImage:[UIImage imageNamed:@"navigation_unfavorite_bg"] forState:UIControlStateNormal];
                
                navigationBar.rightButton.selected = NO;
            }
            [contentView setHidden:NO];
            
            [contentView reloadData];
            
            [self hideLoadHUD:YES];
            
            
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
        
        NSLog(@"请求商品详情失败");
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == contentView) {
        
        return 1;
    }else {
        return 1;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == contentView) {
        return 1;
    }else {
        return [ordersArray count];//购物车
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myCellIdentifier1 = @"MyCellIdentifier1";
    static NSString *myCellIdentifier3 = @"MyCellIdentifier3";
    
    UITableViewCell *cell = nil;
    
    if (tableView == contentView) {
        //        if (indexPath.section == 0) {
        
        ProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier1];
        
        if (!cell) {
            cell = [[ProductDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier1];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([jsonDic[@"product_url"] count] > 0) {
            [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:jsonDic[@"product_url"][0][@"url"]]
                                   placeholderImage:[UIImage imageNamed:@""]
                                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                              //TODO
                                              if ([jsonDic[@"stock_qty"] intValue] > 0) {
                                                  //hidden
                                                  [cell.rightImageView2 setHidden:YES];
                                              }else {
                                                  //show
                                                  [cell.rightImageView2 setHidden:NO];
                                              }
                                          }];
        }else {
            cell.rightImageView.image = [UIImage imageNamed:@""];
        }
        
        if ([@"11" isEqualToString:jsonDic[@"l_kind_code"]]) {
        
            [cell.rightImageView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
            [cell.rightImageView2 setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
            [cell.rightTitle setFrame:CGRectMake(10*SCALE, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT+10*SCALE, SCREEN_WIDTH-20*SCALE, 20*SCALE)];
            
        }else {
            
            [cell.rightImageView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
            [cell.rightImageView2 setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
            [cell.rightTitle setFrame:CGRectMake(10*SCALE, CGRectGetMaxY(cell.rightImageView.frame)+10*SCALE, SCREEN_WIDTH-20*SCALE, 20*SCALE)];
        }
        
        
        cell.rightTitle.text = jsonDic[@"description"];//商品名
        cell.rightSubTitle.text = jsonDic[@"capacity_description"];//规格
        
        cell.rate.text = [NSString stringWithFormat:@"好评数：%@", jsonDic[@"praise_count"]];
        cell.info.text = jsonDic[@"product_description"];;//
        
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        float newPrice = [jsonDic[@"dis_price"] floatValue];//价格
        NSString *newPriceStr = [formatter stringFromNumber:[NSNumber numberWithFloat:newPrice]];
        NSMutableAttributedString *newPriceString =[[NSMutableAttributedString alloc]initWithString:newPriceStr
                                                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.f*SCALE],NSForegroundColorAttributeName:[UIColor redColor]}];
        [newPriceString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:NSMakeRange(0, 1)];
        [cell.price setAttributedText:newPriceString];
        
        cell.oldPrice = [jsonDic[@"sa_price"] floatValue];
        
        if ([jsonDic[@"dis_price"] isEqualToString:jsonDic[@"sa_price"]]) {
            [cell.oldPriceLabel setHidden:YES];
        }else {
            [cell.oldPriceLabel setHidden:NO];
        }
        
        
        if ([[UserDefaults service] getOperatingState] == YES) {
            [cell.plus setHidden:NO];
            if ([jsonDic[@"stock_qty"] intValue] > 0) {
                if ([jsonDic[@"on_sale"] isEqualToString:@"1"]) {
                    [cell.plus setSelected:YES];

                }else {
                    [cell.plus setSelected:NO];
                }
                
            }else {
                //show
                [cell.plus setSelected:NO];
            }
        }else {
            [cell.plus setHidden:YES];
        }
        
        for (NSMutableDictionary *dic1 in ordersArray) {
            if ([jsonDic[@"promo_product"] count] > 0) {
                if ([dic1[@"product_no"] isEqualToString:[NSString stringWithFormat:@"%@,%@", jsonDic[@"product_no"], jsonDic[@"promo_product"][0][@"product_no"]]]){
                    NSInteger nCount = [dic1[@"orderCount"] integerValue];
                    cell.amount2 = nCount;
                }
            }
            
        }
        
//        __weak __typeof(&*cell)weakCell =cell;
        weakify(cell);
        cell.plusBlock = ^(NSInteger nCount,BOOL animated)
        {
            strongify(cell);
            if ([jsonDic[@"stock_qty"] intValue] > 0) {

                if ([jsonDic[@"on_sale"] isEqualToString:@"1"]) {

                    CGRect parentRect = [cell convertRect:cell.plus.frame toView:self.view];

                    if (animated==NO) {

                        if ([cell.orderCount.text integerValue] <= cell.amount2) {
                            //副品
                            NSMutableDictionary *dic2 = [jsonDic[@"promo_product"][0] mutableCopy];

                            [dic2 setObject:[NSString stringWithFormat:@"%@,%@", jsonDic[@"product_no"], jsonDic[@"promo_product"][0][@"product_no"]] forKey:@"product_no"];

                            [self storeOrders:dic2 isAdded:animated];

                            if (animated) {
                                [self JoinCartAnimationWithRect:parentRect];

                                totalOrders ++;
                            }else {

                                totalOrders --;
                            }
                        }
                    }

                    NSMutableDictionary *dic = [jsonDic mutableCopy];

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

                    [contentView reloadData];
                }else {
                    [self showDetailMsg:@"该商品售卖时间有限，暂时无法购买"];
                }
            }else {
                [self showMsg:@"该商品已售罄"];
            }
            
            
        };
        
        //刷新父列表(需要强化测试)
        if (ordersArray.count > 0) {
            cell.amount = 0;
          
            for (NSMutableDictionary *dic in ordersArray) {
                
                if ([dic[@"product_no"] isEqualToString:jsonDic[@"product_no"]]){
                    
                    NSInteger nCount = [dic[@"orderCount"] integerValue];
                    cell.amount = nCount;
                }
            }
            
            return cell;
        }else {
            cell.amount = 0;
            return cell;
        }
        
        return cell;
        
    }else if (tableView == ShopCartView.OrderList.tableView) {
        
        ShoppingCartCell *cell = (ShoppingCartCell *)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier3];
        
        if (!cell) {
            cell=[[ShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier3];
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
        
//        __weak __typeof(&*cell)weakCell =cell;
        weakify(self);
        weakify(cell);
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
                                //刷新父列表
                                [contentView reloadData];
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
                            //刷新父列表
                            [contentView reloadData];
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
                        //刷新父列表
                        [contentView reloadData];
                        //
                        [self setCartImage];
                        [self setTotalMoney];

                        if (totalOrders ==0) {
                            [ShopCartView dismissAnimated:YES];
                        }
                        
                        if (plus == NO) {
                            //减掉副品
                            for (NSMutableDictionary *dicc in ordersArray) {
                                
                                NSArray *array = [dicc[@"product_no"] componentsSeparatedByString:@","];
                                if ([array count] == 2) {
                                    if ([array[0] isEqualToString:dic[@"product_no"]]) {
                                        
                                        if ([dic[@"orderCount"] integerValue] <= [dicc[@"orderCount"] integerValue]) {
                                            
                                            [self storeOrders:dicc isAdded:plus];
                                            
                                            totalOrders = plus ? ++totalOrders : --totalOrders;
                                            
                                            ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)totalOrders];
                                            //刷新父列表
                                            [contentView reloadData];
                                            
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
        
    }
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:contentView]) {
        if (indexPath.section == 0) {
           
            return SCREEN_HEIGHT;
        }else {
            return 40*SCALE;//评论区高度
        }
        
    }else {
        return 40*SCALE;//购物车
    }
}


// 设置section的高度
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
        
        [contentView reloadData];
        
    }];
    
    [storeExistAlert addAction:OKButton];
    
    [storeExistAlert addAction:NOButton];
    
    [self presentViewController:storeExistAlert animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - 动画
#pragma mark -加入购物车动画
-(void) JoinCartAnimationWithRect:(CGRect)rect {
    
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
     
    }else {
        [ShopCartView setCartImage:@"cart_empty"];
        [tipsViewWithoutShopCartView setHidden:YES];
        CartInfoDAL *dal = [[CartInfoDAL alloc] init];
        [dal deleteGift];
     
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
            //            NSLog(@"输出最小值在数组中的下标---->>>%d",min_index);
            //            NSLog(@"输出数组中最小值---->>>>%f",min_number);
            
            
            
            tipsLabelWithShopCartView.text = [NSString stringWithFormat:@"再买%.2f元,%@", min_number, [[self test] objectAtIndex:min_index][@"result"]];
            [contentView reloadData];
            
            tipsLabelWithoutShopCartView.text = [NSString stringWithFormat:@"再买%.2f元,%@", min_number, [[self test] objectAtIndex:min_index][@"result"]];
            
        }else if (min_number == INFINITY) {
            tipsLabelWithShopCartView.text = [NSString stringWithFormat:@"已满%.2f元,%@", max_number, [[self test] objectAtIndex:max_index][@"result"]];
            [contentView reloadData];
            
            tipsLabelWithoutShopCartView.text = [NSString stringWithFormat:@"已满%.2f元,%@", max_number, [[self test] objectAtIndex:max_index][@"result"]];
        }
        
    }
    
    
    
    
    //    tipslabel.text
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
                    //更新DB
                    [dic setObject:@"0" forKey:@"orderCount"];
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


#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}

- (void)shareBtnClick:(id)sender {
    [shareMenuView show];
}

- (void)rightBtnClick:(id)sender {
    
    if ([[UserDefaults service] getLoginStatus] == YES) {
        
        if (navigationBar.rightButton.selected == YES) {
            //取消收藏
            NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:jsonDic[@"product_no"], @"product_no", nil];
            
            [HttpClientService requestWishlistdelete:paramDic success:^(id responseObject) {
                
                NSDictionary *jsonDic2 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                int status = [[jsonDic2 objectForKey:@"status"] intValue];
                
                if (status == 0) {
                    
                    [navigationBar.rightButton setBackgroundImage:[UIImage imageNamed:@"navigation_unfavorite_bg"] forState:UIControlStateNormal];
                    
                    [self hideLoadHUD:YES];
                    [self showMsg:@"取消收藏成功"];
                    
                    navigationBar.rightButton.selected = NO;
                }
                
            } failure:^(NSError *error) {
                
                [self hideLoadHUD:YES];
                
            }];
        }else {
            
            NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:jsonDic[@"product_no"], @"product_no", nil];
            
            [HttpClientService requestWishlistadd:paramDic success:^(id responseObject) {
                
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                int status = [[jsonDic objectForKey:@"status"] intValue];
                
                if (status == 0) {
                    
                    [navigationBar.rightButton setBackgroundImage:[UIImage imageNamed:@"navigation_favorite_bg"] forState:UIControlStateNormal];
                    
                    [self hideLoadHUD:YES];
                    [self showMsg:@"收藏成功"];
                    navigationBar.rightButton.selected = YES;
                }
                
            } failure:^(NSError *error) {
                
                [self hideLoadHUD:YES];
                
            }];
        }
    }else {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        PUSH(loginViewController);
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

- (void)wxBtn {
    //TODO DELETE
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
    
    WXMediaMessage * message = [WXMediaMessage message];
    message.title = jsonDic[@"description"];
    message.description = jsonDic[@"product_description"];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:jsonDic[@"product_url"][0][@"url"]]];
    UIImage *image =  [UIImage imageWithData:data];
    [message setThumbImage:image];
    
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = jsonDic[@"product_url"][0][@"url"];//TODO 分享链接
    message.mediaObject = webObj;
    
    sendReq.message = message;
    
    [WXApi sendReq:sendReq];
    
    //微信小程序 TODO OPEN
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:jsonDic[@"product_url"][0][@"url"]]];
//    //    UIImage *image =  [UIImage imageWithData:data];
//
//    WXMiniProgramObject *wxMiniObject = [WXMiniProgramObject object];
//    wxMiniObject.webpageUrl = @"http://www.baidu.com";//兼容低版本的网页链接
//    wxMiniObject.userName = @"gh_6abae9bfd689";//小程序的原始ID
//    wxMiniObject.path = @"/pages/detail/index";//小程序页面的路径
//    wxMiniObject.hdImageData = data;//小程序节点高清大图，小于128k
//
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = jsonDic[@"description"];
//    message.description = jsonDic[@"product_description"];
//    message.mediaObject = wxMiniObject;
//    //    message.messageExt = nil;
//    //    message.messageAction = nil;
//    message.thumbData = nil;
//    //    message.mediaTag
//
//    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
//    req.message = message;
//    req.bText = NO;
//    req.scene = WXSceneSession;
//
//    [WXApi sendReq:req];
}

- (void)friendBtn {
    
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = 1;//0 = 好友列表 1 = 朋友圈 2 = 收藏
    
    WXMediaMessage * message = [WXMediaMessage message];
    message.title = jsonDic[@"description"];
    message.description = jsonDic[@"product_description"];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:jsonDic[@"product_url"][0][@"url"]]];
    UIImage *image =  [UIImage imageWithData:data];
    [message setThumbImage:image];
    
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = jsonDic[@"product_url"][0][@"url"];//TODO 分享链接
    message.mediaObject = webObj;
    
    sendReq.message = message;
    
    [WXApi sendReq:sendReq];
}

- (void)qqBtn {
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:jsonDic[@"product_url"][0][@"url"]]];
    
    NSURL *url = [NSURL URLWithString:jsonDic[@"product_url"][0][@"url"]];//TODO 分享链接
    
    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url
                                                    title:[jsonDic objectForKey:@"description"]
                                              description:[jsonDic objectForKey:@"product_description"]
                                         previewImageData:data];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:img];
    [QQApiInterface sendReq:req];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

