//
//  OrderDetailViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/15.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailHeaderCell.h"
#import "OrderDetailCell.h"
#import "OrderCigaretteDetailCell.h"
#import "SubmitOrderSalesCell.h"//促销优惠
#import "SubmitOrderSumCell.h"//合计行
#import "OrderDetailFooterCell.h"
#import "OrderReturnViewController.h"
#import "OrderReturnDetailViewController.h"
#import "OrderScoreViewController.h"
#import "PaymentViewController.h"
#import "LoginViewController.h"
#import "OrderStatusViewController.h"
#import "HomeViewController.h"
#import "CategoryViewController.h"
#import "CartInfoDAL.h"
#import "CartInfoEntity.h"


static NSString *SectionViewID = @"XOSectionView";
static NSString *SectionViewID2 = @"XOSectionView2";

@interface OrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *contentView;
@property (nonatomic, strong) NSMutableDictionary *orderDetailDictionary;
@property (nonatomic, strong) UIView *OverlayView;
@property (nonatomic, strong) dispatch_source_t payTimer;

@end

@implementation OrderDetailViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [navigationBar.leftButton setHidden:NO];
        navigationBar.titleLabel.text = @"订单详情";
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _OverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:_OverlayView];
        
        _contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT) style:UITableViewStylePlain];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.separatorStyle = NO;
        _contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self.view addSubview:_contentView];
        
        [self.view bringSubviewToFront:navigationBar];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        _orderDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(close) name:@"closeOrderStatus" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newData) name:@"reloadOrderNotification" object:nil];

    [self newData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)newData {
    
    [_contentView setHidden:YES];
    [self showLoadHUDMsg:@"努力加载中..."];
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_orderDictionary[@"order_id"], @"order_id", nil];
    
    weakify(self);
    [HttpClientService requestOrderdetail:paramDic success:^(id responseObject) {
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            self.orderDetailDictionary = [[NSMutableDictionary alloc] initWithDictionary:jsonDic];
            [self.contentView setHidden:NO];
            [self.contentView reloadData];
            
            [self hideLoadHUD:YES];
        }else if (status == 202) {
            [self hideLoadHUD:YES];
            [self showMsg:@"您的登录状态失效，请重新登录"];
            
            sleep(1.0);
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
            
        }else {
            [self hideLoadHUD:YES];
            [self showMsg:@"服务器异常"];
            
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        NSLog(@"刷新失败");
        
    }];
}

- (void)newData2 {
    
    [_contentView setHidden:YES];
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_orderDictionary[@"order_id"], @"order_id", nil];
    
    weakify(self);
    [HttpClientService requestOrderdetail:paramDic success:^(id responseObject) {
        
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            [self hideLoadHUD:YES];
            
            self.orderDetailDictionary = [[NSMutableDictionary alloc] initWithDictionary:jsonDic];
            
            [self.contentView setHidden:NO];
            [self.contentView reloadData];
            
            
            
            [self cancelSuccess];
            
        }else if (status == 202) {
            [self hideLoadHUD:YES];
            [self showMsg:@"您的登录状态失效，请重新登录"];
            
            sleep(1.0);
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
            
        }else {
            [self hideLoadHUD:YES];
            [self showMsg:@"服务器异常"];
            
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        NSLog(@"刷新失败");
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {//商品区
        return [_orderDetailDictionary[@"product"] count];
    }else if (section == 2) {//优惠区
        return [_orderDetailDictionary[@"promo_list"] count]+1;
    }else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if ([_orderDetailDictionary[@"staff_name"] length] > 0 ) {
            return 220*SCALE;
        }else {
            return 140*SCALE;
        }
        
        
    }else if (indexPath.section == 1) {
        return 90*SCALE;
    }else if (indexPath.section == 2) {
        return 40*SCALE;
    }else {
        return (251+46)*SCALE;
    }
}

- (void)close {
    [self.view sendSubviewToBack:_OverlayView];
    _OverlayView.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *orderCellIdentifier1 = @"OrderCellIdentifier1";
    static NSString *orderCellIdentifier2 = @"OrderCellIdentifier2";
    static NSString *orderCellIdentifier3 = @"OrderCellIdentifier3";
    static NSString *orderCellIdentifier4 = @"OrderCellIdentifier4";
    static NSString *orderCellIdentifier5 = @"OrderCellIdentifier5";
    static NSString *orderCellIdentifier6 = @"OrderCellIdentifier6";
    
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        OrderDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier1];
        if (!cell) {
            cell = [[OrderDetailHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier1];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //计算时间差
        NSDate *validDate = [NSDate dateWithTimeIntervalSince1970:[_orderDetailDictionary[@"ltime"] integerValue]];
        NSTimeInterval secondInterval = [[NSDate date] timeIntervalSinceDate:validDate];
        NSTimeInterval minuteInterval = secondInterval/60;
        NSTimeInterval hourInterval = minuteInterval/60;
        NSTimeInterval dayInterval = hourInterval/24;
        
        
        if ([_orderDetailDictionary[@"state"] isEqualToString:@"0"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"0"]) {
            [cell.statusBtn setTitle:@"请在15分钟内完成支付 >" forState:UIControlStateNormal];
            
            [cell.aBtn setHidden:YES];
            [cell.bBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:NO];
            [cell.eBtn setHidden:NO];
            
            [cell.dBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [cell.eBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            
            if (_payTimer==nil) {
                __block int timeout = [_orderDetailDictionary[@"count_down"] intValue]; //倒计时时间
                
                if (timeout!=0) {
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    _payTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                    dispatch_source_set_timer(_payTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                    weakify(self);
                    dispatch_source_set_event_handler(_payTimer, ^{
                        strongify(self);
                        if(timeout<=0){ //倒计时结束，关闭
                            dispatch_source_cancel(self.payTimer);
                            self.payTimer = nil;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [self newData];
                            });
                        }else {
                            
                            int minute = (int)(timeout/60);
                            int second = timeout-minute*60;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (minute<10) {
                                    if (second<10) {
                                        cell.tips.text = [NSString stringWithFormat:@"超时将自动取消，等待支付0%d:0%d", minute, second];
                                    }else{
                                        cell.tips.text = [NSString stringWithFormat:@"超时将自动取消，等待支付0%d:%d", minute, second];
                                    }
                                }else {
                                    if (second<10) {
                                        cell.tips.text = [NSString stringWithFormat:@"超时将自动取消，等待支付%d:0%d", minute, second];
                                    }else{
                                        cell.tips.text = [NSString stringWithFormat:@"超时将自动取消，等待支付%d:%d", minute, second];
                                    }
                                }
                            });
                            timeout--;
                        }
                    });
                    dispatch_resume(_payTimer);
                }
            }

        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"0"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"1"]) {
            [cell.statusBtn setTitle:@"请在15分钟内完成支付 >" forState:UIControlStateNormal];
            
            [cell.aBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            [cell.bBtn setHidden:NO];
            [cell.bBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            
            if (_payTimer==nil) {
                __block int timeout = [_orderDetailDictionary[@"count_down"] intValue]; //倒计时时间
                
                if (timeout!=0) {
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    _payTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                    dispatch_source_set_timer(_payTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                    weakify(self);
                    dispatch_source_set_event_handler(_payTimer, ^{
                        strongify(self);
                        if(timeout<=0){ //倒计时结束，关闭
                            dispatch_source_cancel(self.payTimer);
                            self.payTimer = nil;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self newData];
                            });
                        }else {
                            
                            int minute = (int)(timeout/60);
                            int second = timeout-minute*60;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (minute<10) {
                                    if (second<10) {
                                        cell.tips.text = [NSString stringWithFormat:@"超时将自动取消，等待支付0%d:0%d", minute, second];
                                    }else{
                                        cell.tips.text = [NSString stringWithFormat:@"超时将自动取消，等待支付0%d:%d", minute, second];
                                    }
                                }else {
                                    if (second<10) {
                                        cell.tips.text = [NSString stringWithFormat:@"超时将自动取消，等待支付%d:0%d", minute, second];
                                    }else{
                                        cell.tips.text = [NSString stringWithFormat:@"超时将自动取消，等待支付%d:%d", minute, second];
                                    }
                                }
                            });
                            timeout--;
                        }
                    });
                    dispatch_resume(_payTimer);
                }
            }
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"2"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"0"] && [_orderDetailDictionary[@"pay_type"] isEqualToString:@"1"]) {
            [cell.statusBtn setTitle:@"等待商家接单 >" forState:UIControlStateNormal];
            cell.tips.text = @"10分钟内商家未接单，将自动取消。";
            
            [cell.aBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            
            [cell.bBtn setHidden:NO];
            [cell.bBtn setTitle:@"取消订单" forState:UIControlStateNormal];

        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"2"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"0"] && ([_orderDetailDictionary[@"pay_type"] isEqualToString:@"2"] || [_orderDetailDictionary[@"pay_type"] isEqualToString:@"3"] || [_orderDetailDictionary[@"pay_type"] isEqualToString:@"4"])) {
            [cell.statusBtn setTitle:@"支付成功 >" forState:UIControlStateNormal];
            cell.tips.text = @"10分钟内商家未接单，将自动取消。";
            [cell.aBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            
            [cell.bBtn setHidden:NO];
            [cell.bBtn setTitle:@"取消订单" forState:UIControlStateNormal];

        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"2"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"1"] && ([_orderDetailDictionary[@"pay_type"] isEqualToString:@"2"] || [_orderDetailDictionary[@"pay_type"] isEqualToString:@"3"] || [_orderDetailDictionary[@"pay_type"] isEqualToString:@"4"])) {
            [cell.statusBtn setTitle:@"支付成功 >" forState:UIControlStateNormal];
            cell.tips.text = @"10分钟内商家未接单，将自动取消。";
            
            [cell.aBtn setHidden:YES];
            [cell.bBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"2"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"1"] && [_orderDetailDictionary[@"pay_type"] isEqualToString:@"1"]) {
            [cell.statusBtn setTitle:@"等待商家接单 >" forState:UIControlStateNormal];
            cell.tips.text = @"10分钟内商家未接单，将自动取消。";
            
            [cell.aBtn setHidden:YES];
            [cell.bBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"3"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"0"] && minuteInterval < 1) {
            [cell.statusBtn setTitle:@"商家已接单 >" forState:UIControlStateNormal];
            cell.tips.text = [NSString stringWithFormat:@"预计送达%@", [_orderDetailDictionary[@"deliverd_time"] substringWithRange:NSMakeRange(11,5)]];
            
            [cell.aBtn setHidden:YES];
            [cell.bBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            
            [cell.dBtn setHidden:NO];
            [cell.eBtn setHidden:NO];
            [cell.dBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [cell.eBtn setTitle:@"催单" forState:UIControlStateNormal];
            [cell.eBtn setEnabled:NO];
            [cell.eBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];

        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"3"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"0"] && minuteInterval >= 1 && minuteInterval < 30) {
            [cell.statusBtn setTitle:@"商家备货中 >" forState:UIControlStateNormal];
            cell.tips.text = [NSString stringWithFormat:@"预计送达%@", [_orderDetailDictionary[@"deliverd_time"] substringWithRange:NSMakeRange(11,5)]];
        
            [cell.aBtn setHidden:YES];
            [cell.bBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:NO];
            [cell.eBtn setHidden:NO];
            
            [cell.dBtn setTitle:@"申请退单" forState:UIControlStateNormal];
            [cell.eBtn setTitle:@"催单" forState:UIControlStateNormal];
            [cell.eBtn setEnabled:NO];
            
            [cell.eBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];

        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"3"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"0"] && minuteInterval >= 30) {
            [cell.statusBtn setTitle:@"商家备货中 >" forState:UIControlStateNormal];
            cell.tips.text = [NSString stringWithFormat:@"预计送达%@", [_orderDetailDictionary[@"deliverd_time"] substringWithRange:NSMakeRange(11,5)]];
            
            [cell.aBtn setHidden:YES];
            [cell.bBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:NO];
            [cell.eBtn setHidden:NO];
            
            [cell.dBtn setTitle:@"申请退单" forState:UIControlStateNormal];
            [cell.eBtn setTitle:@"催单" forState:UIControlStateNormal];
            [cell.eBtn setEnabled:YES];
            
            [cell.eBtn setTitleColor:[UIColor darkGrayColor]forState:UIControlStateNormal];
            
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"3"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"1"] && minuteInterval < 1) {
            [cell.statusBtn setTitle:@"您已申请取消订单，请等待商家处理 >" forState:UIControlStateNormal];
            cell.tips.text = @"商家已出品，出品后商家有权拒绝您的退单申请，建议您先电话联系兔悠协商处理。";
            
            [cell.aBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            
            [cell.bBtn setHidden:NO];
            [cell.bBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [cell.bBtn setEnabled:NO];
            [cell.bBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"3"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"1"] && minuteInterval >= 1 && minuteInterval < 30) {
            [cell.statusBtn setTitle:@"您已申请取消订单，请等待商家处理 >" forState:UIControlStateNormal];
            cell.tips.text = @"商家已出品，出品后商家有权拒绝您的退单申请，建议您先电话联系兔悠协商处理。";
            
            [cell.aBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            

            [cell.bBtn setHidden:NO];
            [cell.bBtn setTitle:@"申请退单" forState:UIControlStateNormal];
            [cell.bBtn setEnabled:NO];
            [cell.bBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"3"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"1"] && minuteInterval >= 30) {
            [cell.statusBtn setTitle:@"您已申请取消订单，请等待商家处理 >" forState:UIControlStateNormal];
            cell.tips.text = @"商家已出品，出品后商家有权拒绝您的退单申请，建议您先电话联系兔悠协商处理。";
            
            [cell.aBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            
            [cell.dBtn setHidden:NO];
            [cell.bBtn setTitle:@"申请退单" forState:UIControlStateNormal];
            [cell.bBtn setEnabled:NO];
            [cell.bBtn setTitleColor:[UIColor darkGrayColor]forState:UIControlStateNormal];
            
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"3"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"2"] && minuteInterval < 1) {
            [cell.statusBtn setTitle:@"商家拒绝退单，商家备货中 >" forState:UIControlStateNormal];
            cell.tips.text = [NSString stringWithFormat:@"预计送达%@", [_orderDetailDictionary[@"deliverd_time"] substringWithRange:NSMakeRange(11,5)]];
            
            [cell.aBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            
            [cell.bBtn setHidden:NO];
            [cell.bBtn setTitle:@"催单" forState:UIControlStateNormal];
            [cell.bBtn setEnabled:NO];
            
            [cell.bBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"3"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"2"] && minuteInterval >= 1 && minuteInterval < 30) {
            [cell.statusBtn setTitle:@"商家拒绝退单，商家备货中 >" forState:UIControlStateNormal];
            cell.tips.text = [NSString stringWithFormat:@"预计送达%@", [_orderDetailDictionary[@"deliverd_time"] substringWithRange:NSMakeRange(11,5)]];
            
            [cell.aBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            
            [cell.bBtn setHidden:NO];
            [cell.bBtn setTitle:@"催单" forState:UIControlStateNormal];
            [cell.bBtn setEnabled:NO];
            [cell.bBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"3"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"2"] && minuteInterval >= 30) {
            [cell.statusBtn setTitle:@"商家拒绝退单，商家备货中 >" forState:UIControlStateNormal];
            cell.tips.text = [NSString stringWithFormat:@"预计送达%@", [_orderDetailDictionary[@"deliverd_time"] substringWithRange:NSMakeRange(11,5)]];

            [cell.aBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            
            [cell.bBtn setHidden:NO];
            [cell.bBtn setTitle:@"催单" forState:UIControlStateNormal];
            [cell.bBtn setEnabled:YES];
            
            [cell.bBtn setTitleColor:[UIColor darkGrayColor]forState:UIControlStateNormal];
            
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"4"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"0"] && minuteInterval < 30) {
            [cell.statusBtn setTitle:@"骑手正在配送中 >" forState:UIControlStateNormal];
            cell.tips.text = [NSString stringWithFormat:@"预计送达%@", [_orderDetailDictionary[@"deliverd_time"] substringWithRange:NSMakeRange(11,5)]];
            
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            
            [cell.aBtn setHidden:NO];
            [cell.bBtn setHidden:NO];
            [cell.cBtn setHidden:NO];
            [cell.aBtn setTitle:@"申请退单" forState:UIControlStateNormal];
            [cell.bBtn setTitle:@"催单" forState:UIControlStateNormal];
            [cell.bBtn setEnabled:NO];
            [cell.cBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            
            [cell.bBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"4"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"0"] && minuteInterval >= 30) {
            [cell.statusBtn setTitle:@"骑手正在配送中 >" forState:UIControlStateNormal];
            cell.tips.text = [NSString stringWithFormat:@"预计送达%@", [_orderDetailDictionary[@"deliverd_time"] substringWithRange:NSMakeRange(11,5)]];
            
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            
            [cell.aBtn setHidden:NO];
            [cell.bBtn setHidden:NO];
            [cell.cBtn setHidden:NO];
            [cell.aBtn setTitle:@"申请退单" forState:UIControlStateNormal];
            [cell.bBtn setTitle:@"催单" forState:UIControlStateNormal];
            [cell.cBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"4"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"1"] && minuteInterval < 30) {
            [cell.statusBtn setTitle:@"您已申请取消订单，请等待商家处理 >" forState:UIControlStateNormal];
            cell.tips.text = @"骑手配送中，配送中商家有权拒绝您的退单申请，建议您先电话联系骑手协商处理。";
            
            [cell.aBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            
            [cell.bBtn setHidden:NO];
            [cell.bBtn setTitle:@"申请退单" forState:UIControlStateNormal];
            [cell.bBtn setEnabled:NO];
            
            [cell.bBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"4"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"1"] && minuteInterval >= 30) {
            [cell.statusBtn setTitle:@"您已申请取消订单，请等待商家处理 >" forState:UIControlStateNormal];
            cell.tips.text = @"骑手配送中，配送中商家有权拒绝您的退单申请，建议您先电话联系骑手协商处理。";
            
            [cell.aBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            
            [cell.bBtn setHidden:NO];
            [cell.bBtn setEnabled:NO];
            [cell.bBtn setTitle:@"申请退单" forState:UIControlStateNormal];
            [cell.bBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"4"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"2"] && minuteInterval < 30) {
            [cell.statusBtn setTitle:@"商家拒绝退单，骑手正在配送中 >" forState:UIControlStateNormal];
            cell.tips.text = [NSString stringWithFormat:@"预计送达%@", [_orderDetailDictionary[@"deliverd_time"] substringWithRange:NSMakeRange(11,5)]];
            
            [cell.aBtn setHidden:YES];
            [cell.bBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:NO];
            [cell.eBtn setHidden:NO];

            [cell.dBtn setTitle:@"催单" forState:UIControlStateNormal];
            [cell.dBtn setEnabled:NO];
            [cell.eBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            
            [cell.dBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"4"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"2"] && minuteInterval >= 30) {
            [cell.statusBtn setTitle:@"商家拒绝退单，骑手正在配送中 >" forState:UIControlStateNormal];
            cell.tips.text = [NSString stringWithFormat:@"预计送达%@", [_orderDetailDictionary[@"deliverd_time"] substringWithRange:NSMakeRange(11,5)]];
            
            [cell.aBtn setHidden:YES];
            [cell.bBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:NO];
            [cell.eBtn setHidden:NO];

            [cell.dBtn setTitle:@"催单" forState:UIControlStateNormal];
            [cell.dBtn setEnabled:YES];
            [cell.eBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            
        }
        
        
        else if ([_orderDetailDictionary[@"state"] isEqualToString:@"5"] && [_orderDetailDictionary[@"has_return"] isEqualToString:@"0"] && [_orderDetailDictionary[@"has_rate"] isEqualToString:@"0"] && dayInterval <= 7) {
            [cell.statusBtn setTitle:@"订单已完成 >" forState:UIControlStateNormal];
            cell.tips.text = @"感谢您对兔悠的支持，欢迎再次光临";
        
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            
            
            [cell.aBtn setHidden:NO];
            [cell.bBtn setHidden:NO];
            [cell.cBtn setHidden:NO];
            [cell.aBtn setTitle:@"申请退货" forState:UIControlStateNormal];
            [cell.bBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [cell.cBtn setTitle:@"去评价" forState:UIControlStateNormal];
            [cell.bBtn setEnabled:YES];
            [cell.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"5"] && [_orderDetailDictionary[@"has_return"] isEqualToString:@"0"] && [_orderDetailDictionary[@"has_rate"] isEqualToString:@"0"] && dayInterval > 7 && dayInterval < 30) {
            [cell.statusBtn setTitle:@"订单已完成 >" forState:UIControlStateNormal];
            cell.tips.text = @"感谢您对兔悠的支持，欢迎再次光临";
            
            
            [cell.aBtn setHidden:YES];
            [cell.bBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            
            [cell.dBtn setHidden:NO];
            [cell.eBtn setHidden:NO];
            [cell.dBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [cell.eBtn setTitle:@"去评价" forState:UIControlStateNormal];
            
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"5"] && [_orderDetailDictionary[@"has_return"] isEqualToString:@"0"] && [_orderDetailDictionary[@"has_rate"] isEqualToString:@"0"] && dayInterval >= 30) {
            [cell.statusBtn setTitle:@"订单已完成 >" forState:UIControlStateNormal];
            cell.tips.text = @"感谢您对兔悠的支持，欢迎再次光临";
            
            [cell.aBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            
            [cell.bBtn setHidden:NO];
            [cell.bBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [cell.bBtn setEnabled:YES];
            [cell.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"5"] && [_orderDetailDictionary[@"has_return"] isEqualToString:@"0"] && [_orderDetailDictionary[@"has_rate"] isEqualToString:@"1"] && dayInterval <= 7) {
            [cell.statusBtn setTitle:@"订单已完成 >" forState:UIControlStateNormal];
            cell.tips.text = @"感谢您对兔悠的支持，欢迎再次光临";
            
            [cell.aBtn setHidden:YES];
            [cell.bBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            
            [cell.dBtn setHidden:NO];
            [cell.eBtn setHidden:NO];

            [cell.dBtn setTitle:@"申请退货" forState:UIControlStateNormal];
            [cell.eBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"5"] && [_orderDetailDictionary[@"has_return"] isEqualToString:@"0"] && [_orderDetailDictionary[@"has_rate"] isEqualToString:@"1"] && dayInterval > 7) {
            [cell.statusBtn setTitle:@"订单已完成 >" forState:UIControlStateNormal];
            cell.tips.text = @"感谢您对兔悠的支持，欢迎再次光临";
            
            [cell.aBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            
            [cell.bBtn setHidden:NO];
            [cell.bBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [cell.bBtn setEnabled:YES];
            [cell.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"5"] && [_orderDetailDictionary[@"has_return"] isEqualToString:@"1"] && [_orderDetailDictionary[@"return_state"] isEqualToString:@"0"]) {
            NSLog(@"退货申请中");
            [cell.aBtn setHidden:YES];
            [cell.bBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"5"] && [_orderDetailDictionary[@"has_return"] isEqualToString:@"1"] && [_orderDetailDictionary[@"return_state"] isEqualToString:@"1"]) {
            NSLog(@"退货申请接单");
            [cell.aBtn setHidden:YES];
            [cell.bBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"5"] && [_orderDetailDictionary[@"has_return"] isEqualToString:@"1"] && [_orderDetailDictionary[@"return_state"] isEqualToString:@"2"]) {
            NSLog(@"退货申请取货");
            [cell.statusBtn setTitle:@"退货已完成 >" forState:UIControlStateNormal];
            cell.tips.text = @"建议您下次订购商家顺便直接取货或自行到周边店铺办理退货手续";
            
            [cell.aBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            
            [cell.bBtn setHidden:NO];
            [cell.bBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [cell.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"5"] && [_orderDetailDictionary[@"has_return"] isEqualToString:@"0"] && [_orderDetailDictionary[@"return_state"] isEqualToString:@"4"]) {
            NSLog(@"退单成功");
            [cell.statusBtn setTitle:@"退款中 >" forState:UIControlStateNormal];
            cell.tips.text = @"线上支付的将退款至您的支付账户，货到付款的将退现金。";
            
            [cell.aBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            
            [cell.bBtn setHidden:NO];
            [cell.bBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [cell.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"5"] && [_orderDetailDictionary[@"has_return"] isEqualToString:@"0"] && [_orderDetailDictionary[@"return_state"] isEqualToString:@"5"] && dayInterval <= 7) {
            NSLog(@"退单失败");
            [cell.statusBtn setTitle:@"订单已完成 >" forState:UIControlStateNormal];
            cell.tips.text = @"商家拒绝了您的退货申请，请联系兔悠协商解决";
            
            [cell.aBtn setHidden:YES];
            [cell.bBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            
            [cell.dBtn setHidden:NO];
            [cell.eBtn setHidden:NO];
            
            [cell.dBtn setTitle:@"申请退货" forState:UIControlStateNormal];
            [cell.eBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"5"] && [_orderDetailDictionary[@"has_return"] isEqualToString:@"0"] && [_orderDetailDictionary[@"return_state"] isEqualToString:@"5"] && dayInterval > 7) {
            NSLog(@"退单失败");
            [cell.statusBtn setTitle:@"订单已完成 >" forState:UIControlStateNormal];
            cell.tips.text = @"商家拒绝了您的退货申请，请联系兔悠协商解决";
            
            [cell.aBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            
            [cell.bBtn setHidden:NO];
            [cell.bBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [cell.bBtn setEnabled:YES];
            [cell.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"6"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"1"] ) {
  
            [cell.statusBtn setTitle:@"订单已取消 >" forState:UIControlStateNormal];
            cell.tips.text = @"您的订单已取消";
            
            [cell.aBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            
            [cell.bBtn setHidden:NO];
            [cell.bBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [cell.bBtn setEnabled:YES];
            [cell.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        }else if ([_orderDetailDictionary[@"state"] isEqualToString:@"6"] && [_orderDetailDictionary[@"user_cancel"] isEqualToString:@"0"] ) {
            
            [cell.statusBtn setTitle:@"订单已取消 >" forState:UIControlStateNormal];
            cell.tips.text = @"由于您订购的商品已售完，您的外卖订单已被取消，欢迎您调换其他商品下单";
            
            [cell.aBtn setHidden:YES];
            [cell.cBtn setHidden:YES];
            [cell.dBtn setHidden:YES];
            [cell.eBtn setHidden:YES];
            
            [cell.bBtn setHidden:NO];
            [cell.bBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [cell.bBtn setEnabled:YES];
            [cell.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        }else {
//            [self showMsg:@"未知错误信息"];
        }
        
        weakify(self);
        cell.statusBlock = ^() {
            strongify(self);
            OrderStatusViewController *orderStatusViewController = [[OrderStatusViewController alloc] init];
            [orderStatusViewController.orderDictionary setObject:self.orderDetailDictionary[@"order_id"] forKey:@"order_id"];
            [self addChildViewController:orderStatusViewController];

            
            [self.view bringSubviewToFront:self.OverlayView];
            [self.view addSubview:orderStatusViewController.view];
            
            // ------View出现动画
            orderStatusViewController.view.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT);
            [UIView animateWithDuration:0.5 animations:^{
                strongify(self);
                self.OverlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
                orderStatusViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                
                
            }];
        };
        
        //        __weak __typeof(&*cell)weakCell =cell;
        weakify(cell);
        
        cell.aBlock = ^() {
            strongify(cell);
            strongify(self);
            if ([cell.aBtn.titleLabel.text isEqualToString:@"申请退单"]) {
                
                UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:@"申请退单" message:@"商家已出品，出品后商家有权拒绝您的退单申请，建议您先电话联系兔悠协商处理。" preferredStyle:(UIAlertControllerStyleAlert)];
                
                UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"申请退单" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                    [self ordercancel:self.orderDetailDictionary[@"order_id"]];
                }];
                
                UIAlertAction *NOButton = [UIAlertAction actionWithTitle:@"联系商家" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                    
                    NSString *telUrl = @"";
                    if ([[UserDefaults service] getStoreTel].length > 0 ) {
                        telUrl = @"tel://02431365487";
                    }else {
                        telUrl = [NSString stringWithFormat:@"tel://%@", [[UserDefaults service] getStoreTel]];
                    }
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
                }];
                
                [storeExistAlert addAction:OKButton];
                
                [storeExistAlert addAction:NOButton];
                
                [self presentViewController:storeExistAlert animated:YES completion:nil];
                
                
                
            }else if ([cell.aBtn.titleLabel.text isEqualToString:@"申请退货"]) {
                //申请退货
                OrderReturnViewController *orderReturnViewController = [[OrderReturnViewController alloc] init];
                [orderReturnViewController.orderDictionary setObject:self.orderDetailDictionary[@"order_id"] forKey:@"order_id"];
                PUSH(orderReturnViewController);
                
            }
            
        };
        
        cell.bBlock = ^() {
            strongify(cell);
            strongify(self);
            if ([cell.bBtn.titleLabel.text isEqualToString:@"取消订单"]) {
                
                UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:@"取消订单并退款" message:@"退款将原路退回到您的支付账户；详情请查看退款进度。" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"先等等" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                }];
                UIAlertAction *NOButton = [UIAlertAction actionWithTitle:@"取消订单" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                    [self ordercancel:self.orderDetailDictionary[@"order_id"]];
                }];
                [storeExistAlert addAction:OKButton];
                [storeExistAlert addAction:NOButton];
                [self presentViewController:storeExistAlert animated:YES completion:nil];
                
                
            }else if ([cell.bBtn.titleLabel.text isEqualToString:@"催单"]) {
                [self orderurge:self.orderDetailDictionary[@"order_id"]];
            }else if ([cell.bBtn.titleLabel.text isEqualToString:@"再来一单"]) {
                
                CartInfoDAL *dal = [[CartInfoDAL alloc] init];
                
                [dal cleanCartInfo];
                
                NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.orderDetailDictionary[@"product"]];
                for ( int i =0; i<tempArray.count; i++) {
                    
                    [self updateDB:tempArray[i]];
                }
                CategoryViewController *categoryViewController = [[CategoryViewController alloc] init];
                [categoryViewController.orderDictionary setObject:@"1" forKey:@"isUp"];
                PUSH(categoryViewController);
            }
            
        };
        
        cell.cBlock = ^() {
            strongify(cell);
            strongify(self);
            if ([cell.cBtn.titleLabel.text isEqualToString:@"申请退单"]) {
                UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:@"申请退单" message:@"商家已出品，出品后商家有权拒绝您的退单申请，建议您先电话联系兔悠协商处理。" preferredStyle:(UIAlertControllerStyleAlert)];
                
                UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"申请退单" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                    [self ordercancel:self.orderDetailDictionary[@"order_id"]];
                }];
                
                UIAlertAction *NOButton = [UIAlertAction actionWithTitle:@"联系商家" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                    
                    NSString *telUrl = @"";
                    if ([[UserDefaults service] getStoreTel].length > 0 ) {
                        telUrl = @"tel://02431365487";
                    }else {
                        telUrl = [NSString stringWithFormat:@"tel://%@", [[UserDefaults service] getStoreTel]];
                    }
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
                }];
                
                [storeExistAlert addAction:OKButton];
                
                [storeExistAlert addAction:NOButton];
                
                [self presentViewController:storeExistAlert animated:YES completion:nil];
            }else if ([cell.cBtn.titleLabel.text isEqualToString:@"确认收货"]) {
                [self confirmreceipt:self.orderDetailDictionary[@"order_id"]];
            }else if ([cell.cBtn.titleLabel.text isEqualToString:@"去评价"]) {
                //去评价
                OrderScoreViewController *orderScoreViewController = [[OrderScoreViewController alloc] init];
                [orderScoreViewController.orderDictionary setObject:self.orderDetailDictionary[@"order_id"] forKey:@"order_id"];
                PUSH(orderScoreViewController);
            }
            
        };
        
        cell.dBlock = ^() {
            strongify(cell);
            strongify(self);
            if ([cell.dBtn.titleLabel.text isEqualToString:@"取消订单"]) {
                UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:@"取消订单并退款" message:@"退款将原路退回到您的支付账户；详情请查看退款进度。" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"先等等" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                }];
                UIAlertAction *NOButton = [UIAlertAction actionWithTitle:@"取消订单" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                    [self ordercancel:self.orderDetailDictionary[@"order_id"]];
                }];
                [storeExistAlert addAction:OKButton];
                [storeExistAlert addAction:NOButton];
                [self presentViewController:storeExistAlert animated:YES completion:nil];
            }else if ([cell.dBtn.titleLabel.text isEqualToString:@"催单"]) {
                [self orderurge:self.orderDetailDictionary[@"order_id"]];
            }else if ([cell.dBtn.titleLabel.text isEqualToString:@"申请退单"]) {
                UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:@"申请退单" message:@"商家已出品，出品后商家有权拒绝您的退单申请，建议您先电话联系兔悠协商处理。" preferredStyle:(UIAlertControllerStyleAlert)];
                
                UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"申请退单" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                    strongify(self);
                    [self ordercancel:self.orderDetailDictionary[@"order_id"]];
                }];
                
                UIAlertAction *NOButton = [UIAlertAction actionWithTitle:@"联系商家" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                    
                    NSString *telUrl = @"";
                    if ([[UserDefaults service] getStoreTel].length > 0 ) {
                        telUrl = @"tel://02431365487";
                    }else {
                        telUrl = [NSString stringWithFormat:@"tel://%@", [[UserDefaults service] getStoreTel]];
                    }
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
                }];
                
                [storeExistAlert addAction:OKButton];
                
                [storeExistAlert addAction:NOButton];
                
                [self presentViewController:storeExistAlert animated:YES completion:nil];
            }else if ([cell.dBtn.titleLabel.text isEqualToString:@"再来一单"]) {
                
                CartInfoDAL *dal = [[CartInfoDAL alloc] init];
                
                [dal cleanCartInfo];
                
                NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.orderDetailDictionary[@"product"]];
                for ( int i =0; i<tempArray.count; i++) {
                    
                    [self updateDB:tempArray[i]];
                }
                CategoryViewController *categoryViewController = [[CategoryViewController alloc] init];
                [categoryViewController.orderDictionary setObject:@"1" forKey:@"isUp"];
                PUSH(categoryViewController);
            }else if ([cell.dBtn.titleLabel.text isEqualToString:@"申请退货"]) {
                //申请退货
                OrderReturnViewController *orderReturnViewController = [[OrderReturnViewController alloc] init];
                [orderReturnViewController.orderDictionary setObject:self.orderDetailDictionary[@"order_id"] forKey:@"order_id"];
                PUSH(orderReturnViewController);
                
            }
            
        };
        
        cell.eBlock = ^() {
            strongify(cell);
            strongify(self);
            if ([cell.eBtn.titleLabel.text isEqualToString:@"立即支付"]) {
                PaymentViewController *paymentViewController = [[PaymentViewController alloc] init];
                [paymentViewController.orderDictionary setObject:self.orderDetailDictionary[@"order_id"] forKey:@"order_id"];
                PUSH(paymentViewController);
            }else if ([cell.eBtn.titleLabel.text isEqualToString:@"催单"]) {
                [self orderurge:self.orderDetailDictionary[@"order_id"]];
            }else if ([cell.eBtn.titleLabel.text isEqualToString:@"去评价"]) {
                //去评价
                OrderScoreViewController *orderScoreViewController = [[OrderScoreViewController alloc] init];
                [orderScoreViewController.orderDictionary setObject:self.orderDetailDictionary[@"order_id"] forKey:@"order_id"];
                PUSH(orderScoreViewController);
            }else if ([cell.eBtn.titleLabel.text isEqualToString:@"再来一单"]) {
                
                CartInfoDAL *dal = [[CartInfoDAL alloc] init];
                
                [dal cleanCartInfo];
                
                NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.orderDetailDictionary[@"product"]];
                for ( int i =0; i<tempArray.count; i++) {
                    
                    [self updateDB:tempArray[i]];
                }
                CategoryViewController *categoryViewController = [[CategoryViewController alloc] init];
                [categoryViewController.orderDictionary setObject:@"1" forKey:@"isUp"];
                PUSH(categoryViewController);
            }
            
        };
        
        
        if ([_orderDetailDictionary[@"staff_name"] length] > 0 ) {
            
            [cell.star1 setHidden:NO];
            [cell.star2 setHidden:NO];
            [cell.star3 setHidden:NO];
            [cell.star4 setHidden:NO];
            [cell.star5 setHidden:NO];
            
            [cell.staffName setHidden:NO];
            [cell.score setHidden:NO];
            [cell.staffIcon setHidden:NO];
            [cell.telBtn setHidden:NO];
            
            [cell.staffMark setHidden:NO];
            
        }else {
            
            [cell.star1 setHidden:YES];
            [cell.star2 setHidden:YES];
            [cell.star3 setHidden:YES];
            [cell.star4 setHidden:YES];
            [cell.star5 setHidden:YES];
            
            [cell.staffName setHidden:YES];
            [cell.score setHidden:YES];
            [cell.staffIcon setHidden:YES];
            [cell.telBtn setHidden:YES];
            
            [cell.staffMark setHidden:YES];
        }
        
        
        if ([[[UserDefaults service] getGender] isEqualToString:@"1"]) {
            //TODO 没有返回骑士头像
            [cell.staffIcon sd_setImageWithURL:[NSURL URLWithString:_orderDetailDictionary[@"product"][indexPath.row][@"staff_portrait"]]
                              placeholderImage:[UIImage imageNamed:@"test_head"]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         //TODO
                                     }];
        }else {
            //TODO 没有返回骑士头像
            [cell.staffIcon sd_setImageWithURL:[NSURL URLWithString:_orderDetailDictionary[@"product"][indexPath.row][@"staff_portrait"]]
                              placeholderImage:[UIImage imageNamed:@"test_head2"]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         //TODO
                                     }];
        }
        
        
        
        cell.staffName.text = _orderDetailDictionary[@"staff_name"];
        
        cell.score.text = _orderDetailDictionary[@"staff_rate"];
        
        
        
        //评论星
        UIImage *halfStar = [UIImage imageNamed:@"score_star_half"];
        UIImage *grayStar = [UIImage imageNamed:@"score_star_gray"];
        UIImage *yellowStar = [UIImage imageNamed:@"score_star_yellow"];
        
        double count = [_orderDetailDictionary[@"staff_rate"] doubleValue];
        
        for (int i = 0; i < 5; i++) {
            
            if ((count-i) >= 0.25 && (count-i) < 0.75) {//半星
                if (i==0) {
                    cell.star1.image = halfStar;
                }else if (i==1) {
                    cell.star2.image = halfStar;
                }else if (i==2) {
                    cell.star3.image = halfStar;
                }else if (i==3) {
                    cell.star4.image = halfStar;
                }else if (i==4) {
                    cell.star5.image = halfStar;
                }
            }else if ((count-i) < 0.25) {//空星
                if (i==0) {
                    cell.star1.image = grayStar;
                }else if (i==1) {
                    cell.star2.image = grayStar;
                }else if (i==2) {
                    cell.star3.image = grayStar;
                }else if (i==3) {
                    cell.star4.image = grayStar;
                }else if (i==4) {
                    cell.star5.image = grayStar;
                }
            }else {//满星
                if (i==0) {
                    cell.star1.image = yellowStar;
                }else if (i==1) {
                    cell.star2.image = yellowStar;
                }else if (i==2) {
                    cell.star3.image = yellowStar;
                }else if (i==3) {
                    cell.star4.image = yellowStar;
                }else if (i==4) {
                    cell.star5.image = yellowStar;
                }
            }
        }
        
        if (count > 0) {
            [cell.star1 setHidden:NO];
            [cell.star2 setHidden:NO];
            [cell.star3 setHidden:NO];
            [cell.star4 setHidden:NO];
            [cell.star5 setHidden:NO];
        }else {
            cell.star1.image = grayStar;
            cell.star2.image = grayStar;
            cell.star3.image = grayStar;
            cell.star4.image = grayStar;
            cell.star5.image = grayStar;
        }
        
        
        
        
        //        __weak __typeof(&*cell)weakCell =cell;
        cell.phoneBlock = ^()
        {
            strongify(self);
            NSString *telUrl = [NSString stringWithFormat:@"tel://%@", self.orderDetailDictionary[@"staff_tel"]];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
        
        };
        
        
        
        return cell;
    }else if (indexPath.section == 1) {

        if ([@"11" isEqualToString:_orderDetailDictionary[@"product"][indexPath.row][@"l_kind_code"]]) {
            OrderCigaretteDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier6];
            if (!cell) {
                cell = [[OrderCigaretteDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier6];
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.productName.text = _orderDetailDictionary[@"product"][indexPath.row][@"description"];
            cell.subTitle.text = _orderDetailDictionary[@"product"][indexPath.row][@"capacity_description"];
            cell.productCount.text = [NSString stringWithFormat:@"x%@", _orderDetailDictionary[@"product"][indexPath.row][@"count"]];
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterCurrencyStyle;
            float nTotal = [_orderDetailDictionary[@"product"][indexPath.row][@"dis_price"] floatValue];
            NSString *priceStr = [formatter stringFromNumber:[NSNumber numberWithFloat:nTotal]];
            cell.price.text = priceStr;
            
            return cell;
        }else {
            OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier2];
            if (!cell) {
                cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier2];
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            [cell.productIcon sd_setImageWithURL:[NSURL URLWithString:_orderDetailDictionary[@"product"][indexPath.row][@"product_url"]]
                                placeholderImage:[UIImage imageNamed:@"loading_Image"]
                                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                           //TODO
                                       }];
            
            cell.productName.text = _orderDetailDictionary[@"product"][indexPath.row][@"description"];
            cell.subTitle.text = _orderDetailDictionary[@"product"][indexPath.row][@"capacity_description"];
            cell.productCount.text = [NSString stringWithFormat:@"x%@", _orderDetailDictionary[@"product"][indexPath.row][@"count"]];
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterCurrencyStyle;
            float nTotal = [_orderDetailDictionary[@"product"][indexPath.row][@"dis_price"] floatValue];
            NSString *priceStr = [formatter stringFromNumber:[NSNumber numberWithFloat:nTotal]];
            cell.price.text = priceStr;
            
            return cell;
        }
        
        
        
    }else if (indexPath.section == 2) {//优惠区
        if ([_orderDetailDictionary[@"promo_list"] count] == indexPath.row) {//合计行 促销行数加1
            
            SubmitOrderSumCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier3];
            if (!cell) {
                cell = [[SubmitOrderSumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier3];
            }
            //
            //            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.totalTitle.text = [NSString stringWithFormat:@"合计 %@", _orderDetailDictionary[@"total"]];
            cell.title.text = [NSString stringWithFormat:@"已优惠 %@", _orderDetailDictionary[@"discount"]];
            cell.subTitle.text = [NSString stringWithFormat:@"实付 %@", _orderDetailDictionary[@"money"]];
            
            return cell;
        }else {
            
            //            if (indexPath.row == 0) {
            SubmitOrderSalesCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier4];
            if (!cell) {
                cell = [[SubmitOrderSalesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier4];
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.icon.image = [UIImage imageNamed:_orderDetailDictionary[@"promo_list"][indexPath.row][@"ptag"]];
            cell.title.text = _orderDetailDictionary[@"promo_list"][indexPath.row][@"info"];
            cell.subTitle.text = [NSString stringWithFormat:@"-%@", _orderDetailDictionary[@"promo_list"][indexPath.row][@"discount"]];
            
            return cell;
        }
    }else if (indexPath.section == 3) {
        OrderDetailFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier5];
        if (!cell) {
            cell = [[OrderDetailFooterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier5];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.time.text = @"立即送达";
        cell.name.text = [NSString stringWithFormat:@"%@ %@", _orderDetailDictionary[@"name"], _orderDetailDictionary[@"tel_no"]];
        cell.address.text = [NSString stringWithFormat:@"%@%@", _orderDetailDictionary[@"address"], _orderDetailDictionary[@"building"]];
        cell.number.text = [NSString stringWithFormat:@"%@", _orderDetailDictionary[@"order_id"]];
        cell.orderTime.text = [NSString stringWithFormat:@"%@", _orderDetailDictionary[@"time"]];
        
        if ([_orderDetailDictionary[@"pay_type"] isEqualToString:@"1"]) {//现金
            cell.pay.text = @"货到付款";
        }else if ([_orderDetailDictionary[@"pay_type"] isEqualToString:@"2"]) {//微信
            cell.pay.text = @"在线支付";
        }else if ([_orderDetailDictionary[@"pay_type"] isEqualToString:@"3"]) {//支付宝
            cell.pay.text = @"在线支付";
        }else {
            cell.pay.text = @"兔币支付";
        }
        
        //        __weak __typeof(&*cell)weakCell =cell;
        weakify(self);
        cell.phoneBlock = ^()
        {
            strongify(self);
            //联系商家
            NSString *telUrl = [NSString stringWithFormat:@"tel://%@", self.orderDetailDictionary[@"store_tel"]];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
           
        };
        
        return cell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 1*SCALE;
    }else if (section == 1) {
        return 6*SCALE;
    }else if (section == 2) {
        return 0*SCALE;
    }else {
        return 0*SCALE;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//取消订单
- (void)ordercancel:(NSString *)orderId {
    _payTimer=nil;
        [self showLoadHUDMsg:@"处理中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:orderId, @"order_id", nil];//"order_id" = 3000583624642535424;
    
    //查询取餐列表
    [HttpClientService requestOrdercancel:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        NSLog(@"取消订单返回信息%@", [jsonDic objectForKey:@"msg"]);
        
        if (status == 0) {
            
            [self performSelector:@selector(newData2) withObject:nil afterDelay:2.0f];
        }else if (status == 117) {

            [self performSelector:@selector(newData2) withObject:nil afterDelay:2.0f];
        }else {

            [self performSelector:@selector(newData2) withObject:nil afterDelay:2.0f];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
        [self showMsg:@"处理失败"];
        
    }];
}

- (void)cancelSuccess{
    
    UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"取消订单成功" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
    }];
    
    [storeExistAlert addAction:OKButton];
    
    [self presentViewController:storeExistAlert animated:YES completion:nil];
}

//催单
- (void)orderurge:(NSString *)orderId {
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:orderId, @"order_id", nil];
    
    //查询取餐列表
    [HttpClientService requestOrderurge:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        NSLog(@"取消订单返回信息%@", [jsonDic objectForKey:@"msg"]);
        
        if (status == 0) {
            
            [self showCustomDialog:@"处理成功"];
        }
        
    } failure:^(NSError *error) {
        
//        [self hideLoadHUD:YES];
        
        [self showMsg:@"处理失败"];
        
    }];
}

//确认收货
- (void)confirmreceipt:(NSString *)orderId {
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:orderId, @"order_id", nil];
    
    //查询取餐列表
    [HttpClientService requestConfirmreceipt:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        NSLog(@"取消订单返回信息%@", [jsonDic objectForKey:@"msg"]);
        
        if (status == 0) {
            
            [self showCustomDialog:@"处理成功"];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
        [self showMsg:@"处理失败"];
        
    }];
}

#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    
    if (self.tabBarController.selectedIndex == 2) {
        POP;
    }else if (self.tabBarController.selectedIndex == 0) {
        
        NSMutableArray *viewControllers =[[NSMutableArray alloc] initWithArray:self.tabBarController.viewControllers];
        UINavigationController *navigationController = [viewControllers objectAtIndex:0];
        
        NSMutableArray *viewControllers2 =[[NSMutableArray alloc] initWithArray:navigationController.viewControllers];
        
        for (UIViewController *viewController in viewControllers2) {
            
            if (![viewController isKindOfClass:[HomeViewController class]]) {
                [viewControllers2 removeObject:viewController];
            }
        }
        navigationController.viewControllers = viewControllers2;
        
        [viewControllers replaceObjectAtIndex:0 withObject:navigationController];
        
        [self.tabBarController setViewControllers:viewControllers animated:YES];
        
        [[UserDefaults service] updatesSelectedViewController:YES];
    }
    
    
}

//更新DB
- (void)updateDB:(NSMutableDictionary *)dic {
    CartInfoDAL *dal = [[CartInfoDAL alloc] init];
    CartInfoEntity *entity = [[CartInfoEntity alloc] init];
    entity.product_no = [dic objectForKey:@"product_no"];
    entity.cvs_no = [[UserDefaults service] getStoreId];
    entity.orderCount = [dic objectForKey:@"count"];
    entity.descriptionn = [dic objectForKey:@"description"];
    entity.dis_price = [dic objectForKey:@"sa_price"];
    entity.gift_flag = @"0";
    [dal insertIntoTable:entity];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeOrderStatus" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadOrderNotification" object:self];
    
}

@end
