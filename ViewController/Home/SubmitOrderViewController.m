//
//  SubmitOrderViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/23.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SubmitOrderViewController.h"
#import "SwitchAddressViewController.h"
#import "SubmitOrderContactCell.h"//收货地址
#import "SubmitOrderTimeCell.h"//送达时间
#import "SubmitOrderCell.h"//商品
#import "SubmitOrderSalesCell.h"//促销优惠
#import "SubmitOrderSumCell.h"//合计行
#import "SubmitOrderFooterCell.h"//备注
#import "PaymentViewController.h"
#import "UILabel+AlertActionFont.h"
#import "SubmitNoteViewController.h"//提交备注
#import "GiftProductViewController.h"//换购商品
#import "GetDeliveryDatesViewController.h"

#import "CartInfoDAL.h"
#import "CartInfoEntity.h"

#import "LoginViewController.h"
#import "OrderDetailViewController.h"
#import "OrderViewController.h"
#import "HomeViewController.h"
#import <MapKit/MapKit.h>



@interface SubmitOrderViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *ordersArray;
    NSMutableArray *settle;
}

@property(nonatomic, strong) UIView *OverlayView;
@property(nonatomic, strong) UITableView *contentView;
@property(nonatomic, strong) NSDictionary *orderDictionary;
@property(nonatomic, strong) NSMutableArray *giftArray;
//底部结算
@property(nonatomic, strong) UILabel *money;
@property(nonatomic, strong) UILabel *sumMoney;
//支付类型
@property(nonatomic, copy) NSString *payType;
//是否使用兔币
@property(nonatomic, copy) NSString *useIntegral;

@property(nonatomic, strong) NSMutableArray *deliveryDatesArray;
@property(nonatomic, copy) NSString *deliveryDatesTime;
@property(nonatomic, assign) NSInteger deliveryDatesIndex;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, assign) BOOL first;

@end

@implementation SubmitOrderViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [navigationBar.leftButton setHidden:NO];
        navigationBar.titleLabel.text = @"提交订单";
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _OverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:_OverlayView];
        
        _contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT+1, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT-BOTTOM_BAR_HEIGHT-1) style:UITableViewStylePlain];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        
        [_contentView setSeparatorColor:UIColorFromRGB(240,240,240)];
        _contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.contentInset = UIEdgeInsetsMake(0, 0, -10*SCALE, 0);

        [self.view addSubview:_contentView];
        
        [self.view bringSubviewToFront:navigationBar];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIView *submitView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - BOTTOM_BAR_HEIGHT2, SCREEN_WIDTH, BOTTOM_BAR_HEIGHT)];
        submitView.backgroundColor = UIColorFromRGB(76,76,76);
        [self.view addSubview:submitView];
        
        //横线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = UIColorFromRGB(240,240,240);
        [submitView addSubview:line];
        
        //购物金额提示框
        _money = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, 10*SCALE, 100*SCALE, 30*SCALE)];
        [_money setTextColor:[UIColor whiteColor]];
        [_money setFont:[UIFont systemFontOfSize:13.0]];
        [submitView addSubview:_money];
        
        _sumMoney = [[UILabel alloc] initWithFrame:CGRectMake(140*SCALE, 10*SCALE, 120*SCALE, 30*SCALE)];
        [_sumMoney setTextColor:[UIColor whiteColor]];
        [_sumMoney setFont:[UIFont systemFontOfSize:17.0]];
        _sumMoney.textAlignment = NSTextAlignmentRight;
        [submitView addSubview:_sumMoney];
        
        //结账按钮
        UIButton *_accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _accountBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _accountBtn.frame = CGRectMake(SCREEN_WIDTH - 100*SCALE, 0.5, 100*SCALE, BOTTOM_BAR_HEIGHT-0.5);
        [_accountBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        [_accountBtn setTitleColor:MAIN_TEXT_COLOR forState:UIControlStateNormal];
        [_accountBtn setBackgroundColor:ICON_COLOR];
        [_accountBtn addTarget:self action:@selector(accountBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [submitView addSubview:_accountBtn];
        
        //初始化 支付默认在线支付
        _payType = @"2";
        //初始化 不使用兔币
        _useIntegral = @"0";
        
        _first = YES;
        
    }
    
    return self;
}

- (void)reload {
    NSMutableArray *array = [[UserDefaults service] getDeliveryDates];
    
    for (int i = 0; i<[array count]; i++) {
        NSMutableDictionary *dic = [array objectAtIndex:i];
        if ([dic[@"selected"] isEqualToString:@"1"]) {
            
            _deliveryDatesTime = dic[@"time"];
          
            _deliveryDatesIndex = [dic[@"index"] integerValue];
        }
    }
    [_contentView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(close) name:@"closeDeliveryDates" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"submitOrderReload" object:nil];
    //购物车数据初始化
    ordersArray = [NSMutableArray array];
    
    //取DB最新
    CartInfoDAL *dal = [[CartInfoDAL alloc] init];
    NSMutableArray *entityArray = [dal queryCartInfo];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < entityArray.count; i++) {
        CartInfoEntity *entity = [[CartInfoEntity alloc] init];
        entity = entityArray[i];
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
        
        NSArray *array = [entity.product_no componentsSeparatedByString:@","];
        
        if ([array count]==2) {
            [tempDic setObject:[array objectAtIndex:1] forKey:@"product_no"];
        }else if ([array count]==1) {
            [tempDic setObject:[array objectAtIndex:0] forKey:@"product_no"];
        }
        
        [tempDic setObject:entity.orderCount forKey:@"orderCount"];
        [tempDic setObject:entity.descriptionn forKey:@"description"];
        [tempDic setObject:entity.dis_price forKey:@"dis_price"];
        
        [tempArray addObject:tempDic];
    }
    
    
    NSMutableArray *entityGiftArray = [dal queryCartInfoGift];
    
    for (int i = 0; i < entityGiftArray.count; i++) {
        CartInfoEntity *entity = [[CartInfoEntity alloc] init];
        entity = entityGiftArray[i];
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
        
        [tempDic setObject:entity.product_no forKey:@"product_no"];
        [tempDic setObject:entity.cvs_no forKey:@"cvs_no"];
        [tempDic setObject:entity.orderCount forKey:@"orderCount"];
        [tempDic setObject:entity.descriptionn forKey:@"description"];
        [tempDic setObject:entity.dis_price forKey:@"dis_price"];
        
        [tempArray addObject:tempDic];
        
    }
    
    

    ordersArray = tempArray;
    [self requestData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)close {
    
    weakify(self);
    [UIView animateWithDuration:0.5 animations:^{
        strongify(self);
        self.OverlayView.backgroundColor = [UIColor clearColor];
        
    }completion:^(BOOL finished) {
        strongify(self);
        [self.view sendSubviewToBack:self.OverlayView];
    }];
    
}

- (void)requestData {
    [_contentView setHidden:YES];
    [self showLoadHUDMsg:@"努力加载中..."];
    
    //构造参数
    settle = [NSMutableArray array];
    for (int i = 0; i < ordersArray.count; i++) {
        NSDictionary *tempDic = [ordersArray objectAtIndex:i];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:tempDic[@"product_no"] forKey:@"product_no"];
        [dic setObject:tempDic[@"orderCount"] forKey:@"count"];
        [dic setObject:@"0" forKey:@"type"];//是否是换购
        [settle addObject:dic];
    }
    
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:settle, @"settle", [[UserDefaults service] getStoreId], @"cvs_no", @"0", @"use_integral", nil];
    weakify(self);
    [HttpClientService requestSettle:paramDic success:^(id responseObject) {
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            [self.contentView setHidden:NO];
            
            self.orderDictionary = [[NSDictionary alloc] initWithDictionary:jsonDic];
            
            //换购商品
            NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:self.orderDictionary[@"exchg"]];
            
            self.giftArray = [NSMutableArray array];
            for (int i=0; i<[tempArr count]; i++) {
                NSMutableDictionary *dic = tempArr[i];
                if ([dic[@"stock_qty"] integerValue] > 0) {
                    [self.giftArray addObject:dic];
                }
            }
            
            
            self.money.text = [NSString stringWithFormat:@"已优惠 %@", self.orderDictionary[@"discount"]];
            
            
            if ([self.useIntegral isEqualToString:@"0"]) {
                self.sumMoney.text = [NSString stringWithFormat:@"实付 %@", self.orderDictionary[@"money"]];
            }else {
                
                if ([self.orderDictionary[@"money"] doubleValue] - [self.orderDictionary[@"integral_usable"] doubleValue] > 0) {
                    self.sumMoney.text = [NSString stringWithFormat:@"实付 %.2f", [self.orderDictionary[@"money"] doubleValue] - [self.orderDictionary[@"integral_usable"] doubleValue]];
                }else {
                    self.sumMoney.text = @"实付 0.00";
                }
            }
            
            if (self.first == YES) {

                self.first = NO;

                NSString *startStr1 = [self.orderDictionary[@"deliver_beg"] stringByReplacingOccurrencesOfString:@":" withString:@""];
                NSString *endStr1 = [self.orderDictionary[@"deliver_end"] stringByReplacingOccurrencesOfString:@":" withString:@""];

                NSString *startStr2 = [startStr1 stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSString *endStr2 = [endStr1 stringByReplacingOccurrencesOfString:@" " withString:@""];

                NSString *startStr3 = [startStr2 stringByReplacingOccurrencesOfString:@"/" withString:@""];
                NSString *endStr3 = [endStr2 stringByReplacingOccurrencesOfString:@"/" withString:@""];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyyMMddHHmmss"];
                NSDate *startDate = [formatter dateFromString:startStr3];
                NSDate *endDate = [formatter dateFromString:endStr3];

                self.deliveryDatesArray = [NSMutableArray array];

                self.index = -1;
                while ([startDate timeIntervalSinceDate:endDate] <= 0.0) {

                    NSString *destDateString = [formatter stringFromDate:startDate];
                    
                    self.index++;
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

                    [dic setObject:destDateString forKey:@"time"];
                    [dic setObject:[NSNumber numberWithInteger:self.index] forKey:@"index"];
                    [dic setObject:@"0" forKey:@"selected"];

                    [self.deliveryDatesArray addObject:dic];

                    startDate = [startDate dateByAddingTimeInterval:[self.orderDictionary[@"deliver_interval"] integerValue]];

                }

                NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] initWithDictionary:self.deliveryDatesArray[0]];
                [dic2 setObject:@"1" forKey:@"selected"];

                NSMutableArray *tarray = [NSMutableArray array];
                for (int i = 0; i<[self.deliveryDatesArray count]; i++) {
                    NSMutableDictionary *dic = [self.deliveryDatesArray[i] mutableCopy];
                    [dic setObject:@"0" forKey:@"selected"];
                    if (i == 0) {

                        [tarray addObject:dic2];
                    }else {

                        [tarray addObject:dic];
                    }

                }

                [[UserDefaults service] updateDeliveryDates:tarray];

                NSMutableArray *array = [[UserDefaults service] getDeliveryDates];


                NSMutableDictionary *dic = [array objectAtIndex:0];

                self.deliveryDatesTime = dic[@"time"];
                self.deliveryDatesIndex = -1;
            }else {
                NSMutableArray *array = [[UserDefaults service] getDeliveryDates];

                for (int i = 0; i<[array count]; i++) {
                    NSMutableDictionary *dic = [array objectAtIndex:i];
                    if ([dic[@"selected"] isEqualToString:@"1"]) {

                        self.deliveryDatesTime = dic[@"time"];
                        self.deliveryDatesIndex = [dic[@"index"] integerValue];
                    }
                }
            }
            
            [self.contentView reloadData];
            [self hideLoadHUD:YES];
            
            
        }else {
            [self hideLoadHUD:YES];
            [self showMsg:[jsonDic objectForKey:@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
    }];
}



- (void)updateMoney {
    
    if ([_useIntegral isEqualToString:@"0"]) {
        _sumMoney.text = [NSString stringWithFormat:@"实付 %@", self.orderDictionary[@"money"]];
    }else {
        
        if ([self.orderDictionary[@"money"] doubleValue] - [self.orderDictionary[@"integral_usable"] doubleValue] > 0) {
            _sumMoney.text = [NSString stringWithFormat:@"实付 %.2f", [self.orderDictionary[@"money"] doubleValue] - [self.orderDictionary[@"integral_usable"] doubleValue]];
        }else {
            _sumMoney.text = @"实付 0.00";
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {//用户信息区
        return 2;
    }else if (section == 1) {//商品区
        return [(NSArray *)_orderDictionary[@"settle_info"] count]+[(NSArray *)_orderDictionary[@"gift"] count];
        
    }else if (section == 2) {//优惠区
        return [(NSArray *)_orderDictionary[@"promo_list"] count]+1;
    }else {
        return 4;//换购+积分+支付方式+备注
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([[UserDefaults service] getAddress].length > 0) { //需要重新选择地址 缩小高度 TODO 替换判断条件
                return 60*SCALE;
            }else {
                return 44*SCALE;//地址
            }
            
        }else {
            return 44*SCALE;//送出时间
        }
        
    }else if (indexPath.section == 1) {
        return 90*SCALE;
    }else if (indexPath.section == 2) {
        if (indexPath.row > 1) {//合计行 促销行数加1
            return 40*SCALE;
        }else {
            return 40*SCALE;
        }
        
    }else {
        return 40*SCALE;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *orderCellIdentifier1 = @"OrderCellIdentifier1";
    static NSString *orderCellIdentifier2 = @"OrderCellIdentifier2";
    static NSString *orderCellIdentifier3 = @"OrderCellIdentifier3";
    static NSString *orderCellIdentifier4 = @"OrderCellIdentifier4";
    static NSString *orderCellIdentifier5 = @"OrderCellIdentifier5";
    static NSString *orderCellIdentifier6 = @"OrderCellIdentifier6";
    static NSString *orderCellIdentifier7 = @"OrderCellIdentifier7";
    static NSString *orderCellIdentifier8 = @"OrderCellIdentifier8";
    static NSString *orderCellIdentifier9 = @"OrderCellIdentifier9";
    
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {//用户信息区
        
        if (indexPath.row == 0) {//用户地址
            
            if ([[UserDefaults service] getName].length > 0 && [[UserDefaults service] getAddressGender].length > 0 && [[UserDefaults service] getAddressPhone].length > 0 && [[UserDefaults service] getAddress].length > 0 && [[UserDefaults service] getBuilding].length > 0 && [[UserDefaults service] getAddressLatitude].length > 0 && [[UserDefaults service] getAddressLongitude].length > 0) {//需要重新选择地址
                //已有地址
                SubmitOrderContactCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier8];
                if (!cell) {
                    cell = [[SubmitOrderContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier8];
                }
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.icon.image = [UIImage imageNamed:@"order_address"];
                
                cell.title.text = [NSString stringWithFormat:@"%@ %@", [[UserDefaults service] getAddress], [[UserDefaults service] getBuilding]];
                
                NSString *str = @"";
                if ([[[UserDefaults service] getAddressGender] isEqualToString:@"0"]) {
                    str = @" 女士";
                }else {
                    str = @" 先生";
                }
                cell.subtitle.text = [NSString stringWithFormat:@"%@%@", [[UserDefaults service] getName], str];
                cell.phone.text = [[UserDefaults service] getAddressPhone];
                
                
                return cell;
                
                
            }else {
                SubmitOrderTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier7];
                if (!cell) {
                    cell = [[SubmitOrderTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier7];
                }
                //未匹配地址
                cell.icon.image = [UIImage imageNamed:@"order_address"];
                cell.title.text = @"选择收货地址";
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                return cell;
            }
            
            
        }else {
            //送达时间
            SubmitOrderTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier1];
            if (!cell) {
                cell = [[SubmitOrderTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier1];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.icon.image = [UIImage imageNamed:@"order_time"];
            
            NSString *hhStr = [_deliveryDatesTime substringWithRange:NSMakeRange(8,2)];
            NSString *mmStr = [_deliveryDatesTime substringWithRange:NSMakeRange(10,2)];
            NSString *hhmmStr = [NSString stringWithFormat:@"%@:%@", hhStr, mmStr];
            
            if (_deliveryDatesIndex == 0 ||_deliveryDatesIndex == -1) {
                
                cell.title.text = [NSString stringWithFormat:@"立即送出（大约%@送达）", hhmmStr];
            }else {
                
                cell.title.text = [NSString stringWithFormat:@"大约%@送达", hhmmStr];
            }
            
            
            
            return cell;
            
            
            
            
            
            ////deliver_time
            
            //            return cell;
        }
        
    }else if (indexPath.section == 1) {//商品区
        SubmitOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier2];
        if (!cell) {
            cell = [[SubmitOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier2];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row+1 > [(NSArray *)_orderDictionary[@"settle_info"] count]) {
            //赠品
            [cell.image sd_setImageWithURL:[NSURL URLWithString:_orderDictionary[@"gift"][indexPath.row-[(NSArray *)_orderDictionary[@"settle_info"] count]][@"product_url"]]
                          placeholderImage:[UIImage imageNamed:@"loading_Image"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     //TODO
                                 }];
            
            cell.title.text = _orderDictionary[@"gift"][indexPath.row-[(NSArray *)_orderDictionary[@"settle_info"] count]][@"description"];//商品名
            cell.subTitle.text = _orderDictionary[@"gift"][indexPath.row-[(NSArray *)_orderDictionary[@"settle_info"] count]][@"cap_description"];//规格
            cell.count.text = [NSString stringWithFormat:@"x%@", _orderDictionary[@"gift"][indexPath.row-[(NSArray *)_orderDictionary[@"settle_info"] count]][@"count"]];//数量
            cell.oldPrice = [_orderDictionary[@"gift"][indexPath.row-[(NSArray *)_orderDictionary[@"settle_info"] count]][@"sa_price"] floatValue];//原价
            cell.newPrice = [_orderDictionary[@"gift"][indexPath.row-[(NSArray *)_orderDictionary[@"settle_info"] count]][@"dis_price"] floatValue];//现价
            
            return cell;
        }else {
            
            //商品
            if ([@"11" isEqualToString:_orderDictionary[@"settle_info"][indexPath.row][@"l_kind_code"]]) {
                [cell.title setFrame:CGRectMake(10*SCALE, 10*SCALE, 200*SCALE, 20*SCALE)];
                [cell.subTitle setFrame:CGRectMake(10*SCALE, CGRectGetMaxY(cell.title.frame)+3*SCALE, 200*SCALE, 20*SCALE)];
                [cell.count setFrame:CGRectMake(10*SCALE, CGRectGetMaxY(cell.subTitle.frame)+8*SCALE, 200*SCALE, 20*SCALE)];
            }else {
                [cell.title setFrame:CGRectMake(90*SCALE, 10*SCALE, 200*SCALE, 20*SCALE)];
                [cell.subTitle setFrame:CGRectMake(90*SCALE, CGRectGetMaxY(cell.title.frame)+3*SCALE, 200*SCALE, 20*SCALE)];
                [cell.count setFrame:CGRectMake(90*SCALE, CGRectGetMaxY(cell.subTitle.frame)+8*SCALE, 200*SCALE, 20*SCALE)];
                [cell.image sd_setImageWithURL:[NSURL URLWithString:_orderDictionary[@"settle_info"][indexPath.row][@"product_url"]]
                              placeholderImage:[UIImage imageNamed:@"loading_Image"]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         //TODO
                                     }];
            }
            
            cell.title.text = _orderDictionary[@"settle_info"][indexPath.row][@"description"];//商品名
            cell.subTitle.text = _orderDictionary[@"settle_info"][indexPath.row][@"cap_description"];//规格
            cell.count.text = [NSString stringWithFormat:@"x%@", _orderDictionary[@"settle_info"][indexPath.row][@"count"]];//数量
            cell.oldPrice = [_orderDictionary[@"settle_info"][indexPath.row][@"sa_total"] floatValue];//原价
            cell.newPrice = [_orderDictionary[@"settle_info"][indexPath.row][@"price"] floatValue];//现价
            
            if ([_orderDictionary[@"settle_info"][indexPath.row][@"sa_total"] isEqualToString:_orderDictionary[@"settle_info"][indexPath.row][@"price"]]) {
                [cell.oldPriceLabel setHidden:YES];
            }else {
                [cell.oldPriceLabel setHidden:NO];
            }
            
            return cell;
        }
        
    }else if (indexPath.section == 2) {//优惠区
        
        if ([(NSArray *)_orderDictionary[@"promo_list"] count] == indexPath.row) {//合计行 促销行数加1
            
            SubmitOrderSumCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier3];
            if (!cell) {
                cell = [[SubmitOrderSumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier3];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.totalTitle.text = [NSString stringWithFormat:@"总计 %@", _orderDictionary[@"total"]];
            cell.title.text = [NSString stringWithFormat:@"已优惠 %@", _orderDictionary[@"discount"]];
            
            if ([_useIntegral isEqualToString:@"0"]) {
                cell.subTitle.text = [NSString stringWithFormat:@"实付 %@", _orderDictionary[@"money"]];
            }else {
                
                if ([_orderDictionary[@"money"] doubleValue] - [_orderDictionary[@"integral_usable"] doubleValue] > 0) {
                    cell.subTitle.text = [NSString stringWithFormat:@"实付 %.2f", [_orderDictionary[@"money"] doubleValue] - [_orderDictionary[@"integral_usable"] doubleValue]];
                }else {
                    cell.subTitle.text = @"实付 0.00";
                }
            }
            
            return cell;
        }else {
            
            SubmitOrderSalesCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier4];
            if (!cell) {
                cell = [[SubmitOrderSalesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier4];
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.icon.image = [UIImage imageNamed:_orderDictionary[@"promo_list"][indexPath.row][@"ptag"]];
            cell.title.text = _orderDictionary[@"promo_list"][indexPath.row][@"info"];
            cell.subTitle.text = [NSString stringWithFormat:@"-%@", _orderDictionary[@"promo_list"][indexPath.row][@"discount"]];
            
            return cell;
        }
        
    }else if (indexPath.section == 3) {//备注区
        if (indexPath.row == 0) {
            
            SubmitOrderFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier6];
            if (!cell) {
                cell = [[SubmitOrderFooterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier6];
            }
            
            cell.title.text = @"换购";
            [cell.subTitle setHidden:NO];
            [cell.switchBtn setHidden:YES];
            
            NSString *str = @"";
            NSString *moneyStr = @"";
            NSArray *tempArr = [NSArray arrayWithArray:[self test]];
            
            for (int i=0; i<tempArr.count; i++) {
                NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:tempArr[i]];
                if ([dic[@"type"] isEqualToString:@"huan"]) {
                    str = [NSString stringWithFormat:@"满%@元%@", dic[@"if"], dic[@"result"]];
                    moneyStr = dic[@"if"];
                }
            }
            
            if ([_orderDictionary[@"money"] doubleValue] > [moneyStr doubleValue]) {
                if (_giftArray.count > 0) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.subTitle.text = @"请选择换购商品";
                }else {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.subTitle.text = @"换购商品已抢光";
                }
                
            }else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.subTitle.text = str;
            }
            
            
            
            return cell;
        }else if (indexPath.row == 1) {
            SubmitOrderFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier9];
            if (!cell) {
                cell = [[SubmitOrderFooterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier9];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.title.text = [NSString stringWithFormat:@"是否使用兔币 (可用兔币%@)", _orderDictionary[@"integral_usable"]];
            [cell.subTitle setHidden:YES];
            [cell.switchBtn setHidden:NO];
            
//            __weak __typeof(&*cell)weakCell =cell;
            weakify(self);
            weakify(cell);
            cell.switchActionBlock = ^()
            {
                strongify(self);
                strongify(cell);
                if (cell.switchBtn.on == YES) {
                    self.useIntegral = @"1";
                    [self updateMoney];
                    [self.contentView reloadData];
                }else {
                    self.useIntegral = @"0";
                    [self updateMoney];
                    [self.contentView reloadData];
                }
            };
            
            
            return cell;
        }else if (indexPath.row == 2) {
            SubmitOrderFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier5];
            if (!cell) {
                cell = [[SubmitOrderFooterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier5];
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.title.text = @"支付方式";
            [cell.subTitle setHidden:NO];
            [cell.switchBtn setHidden:YES];
            if ([_payType isEqualToString:@"2"]) {
                cell.subTitle.text = @"在线支付";
            }else {
                cell.subTitle.text = @"货到付款";
            }
            
            
            return cell;
        }else if (indexPath.row == 3) {
            SubmitOrderFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier6];
            if (!cell) {
                cell = [[SubmitOrderFooterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier6];
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.title.text = @"备注";
            [cell.subTitle setHidden:NO];
            [cell.switchBtn setHidden:YES];
            
            if ([[UserDefaults service] getOrderNote].length > 0) {
                cell.subTitle.text = [[UserDefaults service] getOrderNote];
            }else {
                cell.subTitle.text = @"口味，偏好等要求";
            }
            
            return cell;
        }
        
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 2) {
        return 0*SCALE;
    }else {
        return 6*SCALE;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSLog(@"地址");
            SwitchAddressViewController *switchAddressViewController = [[SwitchAddressViewController alloc] init];
            PUSH(switchAddressViewController);
        }else {
            
            GetDeliveryDatesViewController *getDeliveryDatesViewController = [[GetDeliveryDatesViewController alloc] init];
            getDeliveryDatesViewController.deliveryDatesArray = [[UserDefaults service] getDeliveryDates];
            [self addChildViewController:getDeliveryDatesViewController];
            
            
            [self.view bringSubviewToFront:_OverlayView];
            [self.view addSubview:getDeliveryDatesViewController.view];
            
            //View出现动画
            weakify(self);
            getDeliveryDatesViewController.view.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT);
            [UIView animateWithDuration:0.5 animations:^{
                strongify(self);
                self.OverlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
                getDeliveryDatesViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                
                
            }];
            NSLog(@"送达时间");
        }
    }else if (indexPath.section == 2) {
        
    }else if (indexPath.section == 3) {
        
        
        if (indexPath.row == 0) {
            
            if (_giftArray.count > 0) {//如果有换购商品
                
                GiftProductViewController *giftProductViewController = [[GiftProductViewController alloc] init];
                giftProductViewController.paramArray = _giftArray;
                PUSH(giftProductViewController);
            }
            
        }else if (indexPath.row == 2) {
            
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
                
            }];
            weakify(self);
            UIAlertAction *online = [UIAlertAction actionWithTitle:@"在线支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                strongify(self);
                self.payType = @"2";
                [self.contentView reloadData];
            }];
            
            UIAlertAction *offline = [UIAlertAction actionWithTitle:@"货到付款" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                strongify(self);
                self.payType = @"1";
                [self.contentView reloadData];
            }];
            
            if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
                
                [cancle setValue:[UIColor darkGrayColor] forKey:@"titleTextColor"];
                [online setValue:[UIColor darkGrayColor] forKey:@"titleTextColor"];
                [offline setValue:[UIColor darkGrayColor] forKey:@"titleTextColor"];
                
                UILabel *appearanceLabel = [UILabel appearanceWhenContainedInInstancesOfClasses:@[[UIAlertController class]]];
                UIFont *font = [UIFont systemFontOfSize:15*SCALE];
                [appearanceLabel setAppearanceFont:font];
            }
            
            [alertVc addAction:cancle];
            [alertVc addAction:online];
            [alertVc addAction:offline];
            [self presentViewController:alertVc animated:YES completion:nil];
            
        }else if (indexPath.row == 3) {
            SubmitNoteViewController *submitNoteViewController = [[SubmitNoteViewController alloc] init];
            PUSH(submitNoteViewController);
            
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

- (void)accountBtnClick {
    
    if ([self isBetweenFromHour:7 toHour:24]==YES) {
        //
    }else {
        UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:@"兔悠提示" message:@"很抱歉我们的送货时间是7:00～24:00" preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        }];
        
        [storeExistAlert addAction:OKButton];
        [self presentViewController:storeExistAlert animated:YES completion:nil];
        return;
    }
    
    if ([[UserDefaults service] getAddress].length > 0) {
    }else {
        [self showMsg:@"请选择收货地址"];
        return;
    }
    
    CLLocation *orig = [[CLLocation alloc] initWithLatitude:[[[UserDefaults service] getAddressLatitude] doubleValue] longitude:[[[UserDefaults service] getAddressLongitude] doubleValue]];
    CLLocation *dist = [[CLLocation alloc] initWithLatitude:[[[UserDefaults service] getStoreLatitude] doubleValue] longitude:[[[UserDefaults service] getStoreLongitude] doubleValue]];
    CLLocationDistance meters = [orig distanceFromLocation:dist];
    
    if (meters > 2000) {
        [self showMsg:@"该地址不在配送范围内,请更换地址。"];
        return;
    }
    
    //货到付款
    if ([_payType isEqualToString:@"1"]) {
        UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:@"确认货到付款吗？" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"否" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            
        }];
        
        UIAlertAction *NOButton = [UIAlertAction actionWithTitle:@"是" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            [self submitOrder];
        }];
        
        [storeExistAlert addAction:OKButton];
        
        [storeExistAlert addAction:NOButton];
        
        [self presentViewController:storeExistAlert animated:YES completion:nil];
    }else {
        [self submitOrder];
    }
}

- (void)submitOrder {
    [self showLoadHUDMsg:@"努力加载中..."];
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:settle, @"ordersubmit", @"1", @"cart_delete", _payType, @"pay_type", [[UserDefaults service] getStoreId], @"cvs_no", _useIntegral, @"use_integral", [[UserDefaults service] getAddress], @"address", [[UserDefaults service] getBuilding], @"building", [[UserDefaults service] getAddressLongitude], @"longitude", [[UserDefaults service] getAddressLatitude], @"latitude", [[UserDefaults service] getName], @"name", [[UserDefaults service] getAddressPhone], @"tel_no", [[UserDefaults service] getOrderNote], @"comments", _deliveryDatesTime, @"delay_time", nil];
    weakify(self);
    [HttpClientService requestOrdersubmit:paramDic success:^(id responseObject) {
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            [self hideLoadHUD:YES];
            
            if ([self.useIntegral isEqualToString:@"0"]) {
                //未使用积分
                if ([self.payType isEqualToString:@"2"]) {
                    PaymentViewController *paymentViewController = [[PaymentViewController alloc] init];
                    [paymentViewController.orderDictionary setObject:[jsonDic objectForKey:@"order_id"] forKey:@"order_id"];
                    paymentViewController.startDate = [NSDate date];
                    PUSH(paymentViewController);
                }else {
                    
                    [[UserDefaults service] updateOrderNote:@""];
                    CartInfoDAL *dal = [[CartInfoDAL alloc] init];
                    [dal cleanCartInfo];
                    
                    NSMutableArray *viewControllers =[[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
                    for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
                        if (![[[self.navigationController.viewControllers mutableCopy] objectAtIndex:i] isKindOfClass:[HomeViewController class]] && ![[[self.navigationController.viewControllers mutableCopy] objectAtIndex:i] isKindOfClass:[OrderViewController class]]) {
                            [viewControllers removeObject:[[self.navigationController.viewControllers mutableCopy] objectAtIndex:i]];
                        }
                    }
                    OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
                    [orderDetailViewController.orderDictionary setObject:[jsonDic objectForKey:@"order_id"] forKey:@"order_id"];
                    [viewControllers addObject:orderDetailViewController];
                    [self.navigationController setViewControllers:viewControllers animated:YES];
                }
            }else {
                
                if ([self.orderDictionary[@"money"] doubleValue] - [self.orderDictionary[@"integral_usable"] doubleValue] > 0){
                    if ([self.payType isEqualToString:@"2"]) {
                        PaymentViewController *paymentViewController = [[PaymentViewController alloc] init];
                        [paymentViewController.orderDictionary setObject:[jsonDic objectForKey:@"order_id"] forKey:@"order_id"];
                        paymentViewController.startDate = [NSDate date];
                        PUSH(paymentViewController);
                    }else {
                        
                        [[UserDefaults service] updateOrderNote:@""];
                        CartInfoDAL *dal = [[CartInfoDAL alloc] init];
                        [dal cleanCartInfo];
                        
                        NSMutableArray *viewControllers =[[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
                        for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
                            if (![[[self.navigationController.viewControllers mutableCopy] objectAtIndex:i] isKindOfClass:[HomeViewController class]] && ![[[self.navigationController.viewControllers mutableCopy] objectAtIndex:i] isKindOfClass:[OrderViewController class]]) {
                                [viewControllers removeObject:[[self.navigationController.viewControllers mutableCopy] objectAtIndex:i]];
                            }
                        }
                        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
                        [orderDetailViewController.orderDictionary setObject:[jsonDic objectForKey:@"order_id"] forKey:@"order_id"];
                        [viewControllers addObject:orderDetailViewController];
                        [self.navigationController setViewControllers:viewControllers animated:YES];
                    }
                }else {
        
                    [[UserDefaults service] updateOrderNote:@""];
                    CartInfoDAL *dal = [[CartInfoDAL alloc] init];
                    [dal cleanCartInfo];
                    
                    NSMutableArray *viewControllers =[[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
                    for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
                        if (![[[self.navigationController.viewControllers mutableCopy] objectAtIndex:i] isKindOfClass:[HomeViewController class]] && ![[[self.navigationController.viewControllers mutableCopy] objectAtIndex:i] isKindOfClass:[OrderViewController class]]) {
                            [viewControllers removeObject:[[self.navigationController.viewControllers mutableCopy] objectAtIndex:i]];
                        }
                    }
                    OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
                    [orderDetailViewController.orderDictionary setObject:[jsonDic objectForKey:@"order_id"] forKey:@"order_id"];
                    [viewControllers addObject:orderDetailViewController];
                    [self.navigationController setViewControllers:viewControllers animated:YES];
                }
            }
            
            
        }else if (status == 202) {
            [self hideLoadHUD:YES];
            [self showMsg:@"您的登录状态失效，请重新登录"];
            
            sleep(1.0);
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
            
        }else if (status == 203) {
            [self hideLoadHUD:YES];
            [self showMsg:[jsonDic objectForKey:@"msg"]];
            
            
        }else {
            [self hideLoadHUD:YES];
            [self showMsg:[jsonDic objectForKey:@"msg"]];
            
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
    }];
}

- (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour {
    
    NSDate *dateFrom = [self getCustomDateWithHour:fromHour];
    
    NSDate *dateTo = [self getCustomDateWithHour:toHour];
    
    NSDate *currentDate = [NSDate date];
    
    
    
    if ([currentDate compare:dateFrom]==NSOrderedDescending && [currentDate compare:dateTo]==NSOrderedAscending) {
        
//        NSLog(@"该时间在 %ld:00-%ld:00 之间！", (long)fromHour, (long)toHour);
        
        return YES;
        
    }
    
    return NO;
    
}

- (NSDate *)getCustomDateWithHour:(NSInteger)hour {
    
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];

    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    
    [resultComps setYear:[currentComps year]];
    
    [resultComps setMonth:[currentComps month]];
    
    [resultComps setDay:[currentComps day]];
    
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    return [resultCalendar dateFromComponents:resultComps];
    
}

#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    [[UserDefaults service] updateOrderNote:@"口味，偏好等要求"];
    
    POP;
}

//去粘性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    //去掉UItableview的section的headerview黏性
    if (scrollView == _contentView) {
        CGFloat sectionHeaderHeight = 6*SCALE;
        if (scrollView.contentOffset.y<=sectionHeaderHeight && scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeDeliveryDates" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"submitOrderReload" object:nil];

}

@end

