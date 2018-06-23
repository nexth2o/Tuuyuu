//
//  SaleProductViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/18.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SaleProductViewController.h"
#import "ProductDetailViewController.h"
#import "SubmitOrderViewController.h"
#import "StoreSalesCell.h"
#import "SaleProductCell.h"
#import "SearchViewController.h"
#import "LoginViewController.h"

//购物车相关
#import "ShoppingCartCell.h"
#import "OverlayView.h"
#import "ShoppingCartView.h"
#import "BadgeView.h"
#import "CartInfoDAL.h"
#import "CartInfoEntity.h"

// 自定义的header
#import "MJChiBaoZiHeader.h"
#import "MJChiBaoZiFooter.h"
#import "MJChiBaoZiFooter2.h"
#import "MJDIYHeader.h"
#import "MJDIYAutoFooter.h"
#import "MJDIYBackFooter.h"



#define SALES_COLOR  UIColorFromRGB(76,76,76)
#define SECTION_HEIGHT 40.0*SCALE
#define TIPS_HEIGHT 30.0*SCALE

@interface SaleProductViewController ()<UITableViewDataSource, UITableViewDelegate, ZFReOrderTableViewDelegate, ShoppingCartViewDelegate, CAAnimationDelegate> {
    
    UILabel *halfTitleLabel;
    
    //购物车相关
    CALayer *dotLayer;
    UIBezierPath *path;
    CGFloat endPointX;
    CGFloat endPointY;
    
    //购物车展开提示促销信息
    UIView *tipsViewWithShopCartView;
    UILabel *tipsLabelWithShopCartView;
    
    //购物车关闭提示促销信息
    UIView *tipsViewWithoutShopCartView;
    UILabel *tipsLabelWithoutShopCartView;
    
    UIView *closeView;
}

@property(nonatomic, assign) NSInteger pageNumber;
@property(nonatomic, assign) NSInteger pageLen;
@property(nonatomic, strong) NSMutableArray *productArray;
@property(nonatomic, strong) UITableView *productView;

@property(nonatomic, strong) UIScrollView *contentView;
@property(nonatomic, strong) UITableView *storeSalesTableView;

//购物车相关
@property(nonatomic, assign) NSUInteger totalOrders;
@property(nonatomic, strong) ShoppingCartView *ShopCartView;
@property(nonatomic, strong) NSMutableArray *ordersArray;

//商家促销
@property(nonatomic, assign) BOOL isOpen;

@end

@implementation SaleProductViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bg.image = [UIImage imageNamed:@"salesBg"];
        [self.view addSubview:bg];
        
        navigationBar.backgroundColor = [UIColor clearColor];
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_white"] forState:UIControlStateNormal];
        
        //标题
        halfTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44*SCALE + 0*SCALE, STATUS_BAR_HEIGHT, 130*SCALE, NAV_BAR_HEIGHT)];
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
        
        _storeSalesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT+10*SCALE, SCREEN_WIDTH, STORE_CELL_HEIGHT+5*SCALE) style:UITableViewStylePlain];
        _storeSalesTableView.delegate = self;
        _storeSalesTableView.dataSource = self;
        _storeSalesTableView.showsVerticalScrollIndicator = NO;
        _storeSalesTableView.separatorStyle = NO;
        _storeSalesTableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_storeSalesTableView];
        
        
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_storeSalesTableView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_BAR_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT-STORE_CELL_HEIGHT-5*SCALE)];
        [self.view addSubview:_contentView];
        
        _productView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT-BOTTOM_BAR_HEIGHT-STORE_CELL_HEIGHT-5*SCALE) style:UITableViewStylePlain];
        
        _productView.delegate = self;
        
        _productView.dataSource = self;
        
        _productView.separatorStyle = NO;
        
        _productView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _productView.estimatedRowHeight = 0;
        _productView.estimatedSectionHeaderHeight = 0;
        _productView.estimatedSectionFooterHeight = 0;
        
        //去除底部多余分割线
        _productView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        // 纯动画 无状态和时间
        MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        // 设置header
        _productView.mj_header = header;
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        _productView.mj_header.automaticallyChangeAlpha = YES;
        
        
        // 上拉刷新
        _productView.mj_footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        [_contentView addSubview:_productView];
        
        [self.view bringSubviewToFront:navigationBar];
        
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
        _ShopCartView = [[ShoppingCartView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - BOTTOM_BAR_HEIGHT2, SCREEN_WIDTH, BOTTOM_BAR_HEIGHT) inView:self.view withObjects:nil];
        
        _ShopCartView.delegate = self;
        
        _ShopCartView.parentView = self.view;
        
        _ShopCartView.OrderList.delegate = self;
        
        _ShopCartView.OrderList.tableView.delegate = self;
        
        _ShopCartView.OrderList.tableView.dataSource = self;
        
        _ShopCartView.OrderList.tableView.estimatedRowHeight = 0;
        _ShopCartView.OrderList.tableView.estimatedSectionHeaderHeight = 0;
        _ShopCartView.OrderList.tableView.estimatedSectionFooterHeight = 0;
        
        if (@available(iOS 11.0, *)) {
            _productView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _ShopCartView.OrderList.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        [self.view addSubview:_ShopCartView];
        
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
        
        CGRect rect = [self.view convertRect:_ShopCartView.shoppingCartBtn.frame fromView:_ShopCartView];
        
        endPointX = rect.origin.x + 25;
        
        endPointY = rect.origin.y + 20;
        
        //购物车数据初始化
        _ordersArray = [NSMutableArray array];
        
        //入参数
        _paramDictionary = [[NSMutableDictionary alloc] init];
        
        _isOpen = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self requesetData];
    
    //购物车数据初始化
    _ordersArray = [NSMutableArray array];
    _totalOrders = 0;
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
        
        _totalOrders += [entity.orderCount integerValue];
    }
    _ordersArray = tempArray;
    }
    _ShopCartView.OrderList.objects = _ordersArray;
    [_ShopCartView.OrderList.tableView reloadData];
    
    
    
    
    _ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)_totalOrders];
    [self setCartImage];
    [self setTotalMoney];
    if (_totalOrders <=0) {
        [_ShopCartView dismissAnimated:YES];
    }
    
    [_productView reloadData];
}

- (void)requesetData {
    halfTitleLabel.text = _paramDictionary[@"title"];
    
    [self showLoadHUDMsg:@"努力加载中..."];
    
    _pageNumber = 0;
    _pageLen = 20;
    
    //TODO需要修改成动态店铺
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_paramDictionary[@"type"], @"type", [NSString stringWithFormat:@"%ld", (long)_pageNumber], @"page", [[UserDefaults service] getStoreId], @"cvs_no", nil];
    weakify(self);
    [HttpClientService requestSpecialProduct:paramDic success:^(id responseObject) {
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            self.productArray = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"special_goods"]];
            
            [self.productView reloadData];
            
            [self hideLoadHUD:YES];
            
            self.pageNumber++;
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

- (void)loadNewData {
    
    [self showLoadHUDMsg:@"努力加载中..."];
    
    _pageNumber = 0;
    
    _pageLen = 20;
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_paramDictionary[@"type"], @"type", [NSString stringWithFormat:@"%ld", (long)_pageNumber], @"page", [[UserDefaults service] getStoreId], @"cvs_no", nil];
    weakify(self);
    [HttpClientService requestSpecialProduct:paramDic success:^(id responseObject) {
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            self.productArray = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"special_goods"]];
            
            [self.productView reloadData];
            
            [self.productView.mj_header endRefreshing];
            [self.productView.mj_footer endRefreshing];
            
            [self hideLoadHUD:YES];
            
            self.pageNumber++;
        }
        
    } failure:^(NSError *error) {
        strongify(self);
        [self.productView.mj_header endRefreshing];
        
        [self hideLoadHUD:YES];
    }];
    
}


- (void)loadMoreData {
    
    [self showLoadHUDMsg:@"努力加载中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_paramDictionary[@"type"], @"type", [NSString stringWithFormat:@"%ld", (long)_pageNumber], @"page", [[UserDefaults service] getStoreId], @"cvs_no", nil];
    
    weakify(self);
    [HttpClientService requestSpecialProduct:paramDic success:^(id responseObject) {
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"special_goods"]];
            
            if (array.count == 0) {
                
                [self hideLoadHUD:YES];
                
                [self showMsg:@"没有更多商品了"];
                
                [self.productView.mj_footer endRefreshingWithNoMoreData];
                
            }else if (array.count > 0 && array.count < self.pageLen) {
                
                for (int i = 0; i<array.count; i++) {
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    
                    dic = [array objectAtIndex:i];
                    
                    [self.productArray addObject:dic];
                }
                
                [self.productView reloadData];
                
                [self hideLoadHUD:YES];
                
                [self.productView.mj_footer endRefreshingWithNoMoreData];
                
                
            }else {
                
                for (int i = 0; i<array.count; i++) {
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    
                    dic = [array objectAtIndex:i];
                    
                    [self.productArray addObject:dic];
                }
                self.pageNumber++;
                
                [self.productView reloadData];
                
                [self hideLoadHUD:YES];
                
                [self.productView.mj_footer endRefreshing];
            }
        }
        
    } failure:^(NSError *error) {
        strongify(self);
        [self hideLoadHUD:YES];
        
        [self.productView.mj_footer endRefreshing];
        
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _productView) {
        return _productArray.count;
    }else if (tableView == _storeSalesTableView) {//店铺活动
        if (_isOpen == YES) {
            return [[[UserDefaults service] getStoreSales] count];
        }else {
            return 1;
        }
    }else {
        return [_ordersArray count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myCellIdentifier3 = @"MyCellIdentifier3";
    static NSString *myCellIdentifier4 = @"MyCellIdentifier4";
    static NSString *myCellIdentifier5 = @"MyCellIdentifier5";
    
    UITableViewCell *cell = nil;
    
    if (tableView == _productView) {
        
        
        SaleProductCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier3];
        
        if (!cell) {
            cell = [[SaleProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier3];
        }
        
        weakify(self);
        [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:_productArray[indexPath.row][@"product_url"]]
                               placeholderImage:[UIImage imageNamed:@"loading_Image"]
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                          strongify(self);
                                          if ([self.productArray[indexPath.row][@"stock_qty"] intValue] > 0) {
                                              //hidden
                                              [cell.rightImageView2 setHidden:YES];
                                          }else {
                                              //show
                                              [cell.rightImageView2 setHidden:NO];
                                          }
                                      }];
        
        cell.rightTitle.text = _productArray[indexPath.row][@"description"];//商品名
        cell.rightSubTitle.text = _productArray[indexPath.row][@"capacity_description"];//规格
        cell.salesArray = _productArray[indexPath.row][@"promo_list"];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        float nTotal = [_productArray[indexPath.row][@"dis_price"] floatValue];//价格
        NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:nTotal]];
        cell.priceLabel.text = price;
        
        cell.oldPrice = [_productArray[indexPath.row][@"sa_price"] floatValue];
        
        if ([_productArray[indexPath.row][@"dis_price"] isEqualToString:_productArray[indexPath.row][@"sa_price"]]) {
            [cell.oldPriceLabel setHidden:YES];
        }else {
            [cell.oldPriceLabel setHidden:NO];
        }
        
        cell.giftOldPrice = [_productArray[indexPath.row][@"promo_product"][0][@"sa_price"] floatValue];
        if ([_productArray[indexPath.row][@"promo_product"][0][@"dis_price"] isEqualToString:_productArray[indexPath.row][@"promo_product"][0][@"sa_price"]]) {
            [cell.giftOldPriceLabel setHidden:YES];
        }else {
            [cell.giftOldPriceLabel setHidden:NO];
        }
        
        //赠品区
        [cell.giftImageView sd_setImageWithURL:[NSURL URLWithString:_productArray[indexPath.row][@"promo_product"][0][@"product_url"]]
                               placeholderImage:[UIImage imageNamed:@"loading_Image"]
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                          strongify(self);
                                          if ([self.productArray[indexPath.row][@"promo_product"][0][@"stock_qty"] intValue] > 0) {
                                              //hidden
                                              [cell.giftImageView2 setHidden:YES];
                                          }else {
                                              //show
                                              [cell.giftImageView2 setHidden:NO];
                                          }
                                      }];
        if ([_productArray[indexPath.row][@"promo_product"][0][@"buy_count"] isEqualToString:@"1"] && [_productArray[indexPath.row][@"promo_product"][0][@"give_count"] isEqualToString:@"1"]) {
            cell.giftLabel.text = @"买赠";
        }else {
            cell.giftLabel.text = [NSString stringWithFormat:@"买%@赠%@", _productArray[indexPath.row][@"promo_product"][0][@"buy_count"], _productArray[indexPath.row][@"promo_product"][0][@"give_count"]];
        }
        
        cell.giftTitle.text = _productArray[indexPath.row][@"promo_product"][0][@"description"];
        cell.giftSubTitle.text = _productArray[indexPath.row][@"promo_product"][0][@"cap_description"];
        cell.newPrice = [_productArray[indexPath.row][@"promo_product"][0][@"dis_price"] floatValue];
        cell.oldPrice = [_productArray[indexPath.row][@"promo_product"][0][@"sa_price"] floatValue];
        
        if ([[UserDefaults service] getOperatingState] == YES) {
            if ([_productArray[indexPath.row][@"stock_qty"] intValue] > 0) {
                if ([_productArray[indexPath.row][@"on_sale"] isEqualToString:@"1"]) {
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
        
//        __weak __typeof(&*cell)weakCell =cell;
        weakify(cell);
        cell.plusBlock = ^(NSInteger nCount,BOOL animated)
        {
            strongify(self);
            strongify(cell);
            if ([self.productArray[indexPath.row][@"stock_qty"] intValue] > 0) {
            if ([self.productArray[indexPath.row][@"on_sale"] isEqualToString:@"1"]) {
                NSMutableDictionary *dic = [self.productArray[indexPath.row] mutableCopy];
                
                [self storeOrders:dic isAdded:animated];
                
                CGRect parentRect = [cell convertRect:cell.plus.frame toView:self.view];
                
                if (animated) {
                    [self JoinCartAnimationWithRect:parentRect];
                    self.totalOrders ++;
                }
                else
                {
                    self.totalOrders --;
                }
                self.ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.totalOrders];
                [self setCartImage];
                [self setTotalMoney];
                
                [self.productView reloadData];
            }else {
                [self showDetailMsg:@"该商品售卖时间有限，暂时无法购买"];
            }
            
            }else {
                [self showMsg:@"该商品已售罄"];
            }
            
        };
        
        //刷新父列表(需要强化测试)
        if (_ordersArray.count > 0) {
            cell.amount = 0;
            for (NSMutableDictionary *dic in _ordersArray) {
                
                if ([dic[@"product_no"] isEqualToString:_productArray[indexPath.row][@"product_no"]]){
                    
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
        
    }else if (tableView == _ShopCartView.OrderList.tableView) {
        
        ShoppingCartCell *cell = (ShoppingCartCell *)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier4];
        
        if (!cell) {
            cell=[[ShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier4];
        }
        NSArray *array = [_ordersArray[indexPath.row][@"product_no"] componentsSeparatedByString:@","];
        if ([array count] == 2) {
            cell.nameLabel.text = [NSString stringWithFormat:@"%@(第二件)", _ordersArray[indexPath.row][@"description"]];
        }else {
            cell.nameLabel.text = _ordersArray[indexPath.row][@"description"];
        }
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        float nTotal = [_ordersArray[indexPath.row][@"dis_price"] floatValue];
        NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:nTotal]];
        cell.priceLabel.text = price;
        
        NSInteger count = [_ordersArray[indexPath.row][@"orderCount"] integerValue];
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
            NSMutableDictionary *dic = [self.ordersArray[indexPath.row] mutableCopy];
            
            for (NSMutableDictionary *dicc in self.ordersArray) {
                
                NSArray *array = [dic[@"product_no"] componentsSeparatedByString:@","];
                if ([array count] == 2) {
                    if ([array[0] isEqualToString:dicc[@"product_no"]]) {
                        
                        if (plus==YES) {
                            if ([dic[@"orderCount"] integerValue] < [dicc[@"orderCount"] integerValue]) {
                                [self storeOrders:dic isAdded:plus];
                                
                                self.totalOrders = plus ? ++self.totalOrders : --self.totalOrders;
                                
                                self.ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.totalOrders];
                                //刷新父列表
                                [self.productView reloadData];
                                //
                                [self setCartImage];
                                [self setTotalMoney];

                                if (self.totalOrders ==0) {
                                    [self.ShopCartView dismissAnimated:YES];
                                }
                            }else {
                                cell.number = nCount -1;
                                [cell showNumber:nCount-1];
                                [self showDetailMsg:@"第二件折扣商品不能超过主商品，您需再订购主商品。"];
                            }
                        }else {
                            
                            [self storeOrders:dic isAdded:plus];
                            
                            self.totalOrders = plus ? ++self.totalOrders : --self.totalOrders;
                            
                            self.ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.totalOrders];
                            //刷新父列表
                            [self.productView reloadData];
                            //
                            [self setCartImage];
                            [self setTotalMoney];
                            
                            if (self.totalOrders ==0) {
                                [self.ShopCartView dismissAnimated:YES];
                            }
                            
                            return;
                            
                        }
                    }
                }else {
                    //主品
                    if ([dic[@"product_no"] isEqualToString:dicc[@"product_no"]]) {
                        [self storeOrders:dic isAdded:plus];
                        
                        self.totalOrders = plus ? ++self.totalOrders : --self.totalOrders;
                        
                        self.ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.totalOrders];
                        //刷新父列表
                        [self.productView reloadData];
                        
                        [self setCartImage];
                        [self setTotalMoney];
                        
                        if (self.totalOrders ==0) {
                            [self.ShopCartView dismissAnimated:YES];
                        }
                        
                        if (plus == NO) {
                            //减掉副品
                            for (NSMutableDictionary *dicc in self.ordersArray) {
                                
                                NSArray *array = [dicc[@"product_no"] componentsSeparatedByString:@","];
                                if ([array count] == 2) {
                                    if ([array[0] isEqualToString:dic[@"product_no"]]) {
                                        
                                        if ([dic[@"orderCount"] integerValue] <= [dicc[@"orderCount"] integerValue]) {
                                            
                                            [self storeOrders:dicc isAdded:plus];
                                            
                                            self.totalOrders = plus ? ++self.totalOrders : --self.totalOrders;
                                            
                                            self.ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.totalOrders];
                                            //刷新父列表
                                            [self.productView reloadData];
                                            //
                                            [self setCartImage];
                                            [self setTotalMoney];
                                            
                                            if (self.totalOrders ==0) {
                                                [self.ShopCartView dismissAnimated:YES];
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

    }else if (tableView == _storeSalesTableView) {
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
            
//            __weak __typeof(&*cell)weakCell = cell;
            weakify(self);
            weakify(cell);
            cell.openBlock = ^() {
                strongify(self);
                strongify(cell);
                if (cell.open.selected == YES) {
                    self.isOpen = NO;
                    cell.open.selected = NO;
                    [cell.salesEtc setHidden:NO];
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        [self.storeSalesTableView setFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT+10*SCALE, SCREEN_WIDTH, STORE_CELL_HEIGHT+5*SCALE)];
                        [self.contentView setFrame:CGRectMake(0, CGRectGetMaxY(self.storeSalesTableView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_BAR_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT)];
                    }completion:^(BOOL finished) {
                        [self.storeSalesTableView reloadData];
                        
                        [cell.open setBackgroundImage:[UIImage imageNamed:@"sales_down"] forState:UIControlStateNormal];
                    }];
                    
                }else {
                    self.isOpen = YES;
                    cell.open.selected=YES;
                    [cell.salesEtc setHidden:YES];
                    [UIView animateWithDuration:0.3 animations:^{
                        [self.storeSalesTableView setFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT+10*SCALE, SCREEN_WIDTH, [[UserDefaults service] getStoreSales].count*STORE_CELL_HEIGHT+5*SCALE)];
                        [self.contentView setFrame:CGRectMake(0, CGRectGetMaxY(self.storeSalesTableView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_BAR_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT)];
                        [self.storeSalesTableView reloadData];
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:_productView]) {
        return 180*SCALE;
    }else if (tableView == _storeSalesTableView) {
        if (_isOpen == YES) {
            return STORE_CELL_HEIGHT;
        }else {
            return STORE_CELL_HEIGHT+5*SCALE;
        }
    }else {
        return 40*SCALE;//购物车
    }
    
}


// 设置section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if ([tableView isEqual:_ShopCartView.OrderList.tableView])
    {
        return SECTION_HEIGHT+TIPS_HEIGHT;
    }
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if ([tableView isEqual:_ShopCartView.OrderList.tableView])
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
    weakify(self);
    UIAlertAction *NOButton = [UIAlertAction actionWithTitle:@"清空" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        strongify(self);
        CartInfoDAL *dal = [[CartInfoDAL alloc] init];

        [dal cleanCartInfo];
        
        [self.ordersArray removeAllObjects];
        
        self.totalOrders = 0;
        
        self.ShopCartView.badge.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.totalOrders];
        
        [self setTotalMoney];
        
        [self setCartImage];
        
        [self.ShopCartView dismissAnimated:YES];
        
        [self.productView reloadData];
        
    }];
    
    [storeExistAlert addAction:OKButton];
    
    [storeExistAlert addAction:NOButton];
    
    [self presentViewController:storeExistAlert animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    if (tableView == _productView) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        ProductDetailViewController *productDetailViewController = [[ProductDetailViewController alloc] init];
        [productDetailViewController.paramDictionary setObject:_productArray[indexPath.row][@"product_no"] forKey:@"product_no"];
        PUSH(productDetailViewController);
    }
    
}

#pragma mark - 动画
#pragma mark -加入购物车动画
-(void) JoinCartAnimationWithRect:(CGRect)rect
{
    
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
-(void)groupAnimation
{
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
    
    [self.view bringSubviewToFront:_ShopCartView];
    
    [self performSelector:@selector(removeFromLayer:) withObject:dotLayer afterDelay:0.4f];
    
}

- (void)removeFromLayer:(CALayer *)layerAnimation{
    
    [layerAnimation removeFromSuperlayer];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    if ([[anim valueForKey:@"animationName"]isEqualToString:@"groupsAnimation"]) {
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:1.2];
        shakeAnimation.toValue = [NSNumber numberWithFloat:0.9];
        
        [_ShopCartView.shoppingCartBtn.layer addAnimation:shakeAnimation forKey:nil];
    }
    
}

- (void)setCartImage {
    if ([[UserDefaults service] getOperatingState] == YES) {
        [_ShopCartView setHidden:NO];
        [closeView setHidden:YES];

        if (_totalOrders > 0) {
        
        [_ShopCartView setCartImage:@"cart_full"];
        [tipsViewWithoutShopCartView setHidden:NO];
        
    }else {
        [_ShopCartView setCartImage:@"cart_empty"];
        [tipsViewWithoutShopCartView setHidden:YES];
        CartInfoDAL *dal = [[CartInfoDAL alloc] init];
        [dal deleteGift];
        
    }
    }else {
        [_ShopCartView setHidden:YES];
        [closeView setHidden:NO];
    }
    
}

- (void)setTotalMoney {
    
    float nTotal = 0;
    for (NSMutableDictionary *dic in _ordersArray) {
        nTotal += [dic[@"orderCount"] integerValue] * [dic[@"dis_price"] floatValue];
    }
    [_ShopCartView setTotalMoney:nTotal];
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
            [_productView reloadData];
            
            tipsLabelWithoutShopCartView.text = [NSString stringWithFormat:@"再买%.2f元,%@", min_number, [[self test] objectAtIndex:min_index][@"result"]];
            
        }else if (min_number == INFINITY) {
            tipsLabelWithShopCartView.text = [NSString stringWithFormat:@"已满%.2f元,%@", max_number, [[self test] objectAtIndex:max_index][@"result"]];
            [_productView reloadData];
            
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
        for (NSMutableDictionary *dic in _ordersArray) {
            
            if ([dic[@"product_no"] isEqualToString:dictionary[@"product_no"]]){
                //购物车内有选择的商品
                NSInteger nCount = [dic[@"orderCount"] integerValue];
                nCount = nCount+1;
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)nCount] forKey:@"orderCount"];
                
                //更新DB
                [self updateDB:dic];
                
                _ShopCartView.OrderList.objects = _ordersArray;
                [_ShopCartView.OrderList.tableView reloadData];
                return;
            }
        }
        
        //购物车内没有商品
        [dictionary setObject:@"1" forKey:@"orderCount"];
        [_ordersArray addObject:dictionary];
        
        [self updateDB:dictionary];
        
        _ShopCartView.OrderList.objects = _ordersArray;
        [_ShopCartView.OrderList.tableView reloadData];
        return;
        
    }else {
        //减法的时候
        for (NSMutableDictionary *dic in _ordersArray) {
            
            if ([dic[@"product_no"] isEqualToString:dictionary[@"product_no"]]){
                
                NSInteger nCount = [dic[@"orderCount"] integerValue];
                
                nCount = nCount-1;
                
                if (nCount==0) {
                    
                    //更新DB
                    [dic setObject:@"0" forKey:@"orderCount"];
                    [self updateDB:dic];
                    
                    [_ordersArray removeObject:dic];
                    _ShopCartView.OrderList.objects = _ordersArray;
                    [_ShopCartView updateFrame:_ShopCartView.OrderList];
                    [_ShopCartView.OrderList.tableView reloadData];
                    return;
                }else{
                    //更新
                    [dic setObject:[NSString stringWithFormat:@"%ld",(long)nCount] forKey:@"orderCount"];
                    
                    //更新DB
                    [self updateDB:dic];
                    
                    _ShopCartView.OrderList.objects = _ordersArray;
                    [_ShopCartView.OrderList.tableView reloadData];
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


#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}

- (void)rightBtnClick:(id)sender {
    NSLog(@"分享");
}

- (void)searchBtn {
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
    PUSH(searchViewController);
}

@end
