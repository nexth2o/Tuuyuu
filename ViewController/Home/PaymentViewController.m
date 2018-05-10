//
//  PaymentViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/23.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "PaymentViewController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "OrderDetailViewController.h"
#import "HomeViewController.h"
#import "OrderViewController.h"

#import "CartInfoDAL.h"
#import "CartInfoEntity.h"

@interface PaymentViewController () {
    dispatch_source_t payTimer;
    
    UILabel *minuteLabel1;
    UILabel *minuteLabel2;
    UILabel *secondLabel1;
    UILabel *secondLabel2;
    
    UIButton *wxBtn;
    UIButton *aliBtn;
    UIImageView *wxBtnImage;
    UIImageView *aliBtnImage;
    
    UILabel *orderInfo;
    UILabel *price;

}

@end

@implementation PaymentViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.backgroundColor = [UIColor whiteColor];
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_gray"] forState:UIControlStateNormal];
        navigationBar.titleLabel.text = @"支付订单";
        
        //iOS7新增属性 TODO
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT)];
        contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:contentView];
        
        //店铺区 40 100
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT + 6*SCALE, SCREEN_WIDTH, 140*SCALE)];
        titleView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:titleView];
        
        //支付剩余时间
        UILabel *timeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10*SCALE, SCREEN_WIDTH, 20*SCALE)];
        timeTitle.textAlignment = NSTextAlignmentCenter;
        timeTitle.text = @"支付剩余时间";
        timeTitle.textColor = [UIColor darkGrayColor];
        timeTitle.font = [UIFont systemFontOfSize:13*SCALE];
        [titleView addSubview:timeTitle];
        
        //剩余时间背景
        UIImageView *timeBg = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-(280/3)*SCALE)/2, CGRectGetMaxY(timeTitle.frame)+3*SCALE, (280/3)*SCALE, (50/3)*SCALE)];
        timeBg.image = [UIImage imageNamed:@"order_time_bg"];
        [titleView addSubview:timeBg];
        
        if ([[UIApplication sharedApplication] statusBarFrame].size.height > 20) {
            minuteLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(138*SCALE, CGRectGetMaxY(timeTitle.frame)+1*SCALE, 10*SCALE, 20*SCALE)];
        }else {
           minuteLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(145*SCALE, CGRectGetMaxY(timeTitle.frame)+1*SCALE, 10*SCALE, 20*SCALE)];
        }
        
        minuteLabel1.text = @"9";
        minuteLabel1.textColor = [UIColor whiteColor];
        [minuteLabel1 setFont:[UIFont boldSystemFontOfSize:14*SCALE]];
        [titleView addSubview:minuteLabel1];
        
        if ([[UIApplication sharedApplication] statusBarFrame].size.height > 20) {
            minuteLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(158*SCALE, CGRectGetMaxY(timeTitle.frame)+1*SCALE, 10*SCALE, 20*SCALE)];
        }else {
            minuteLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(165*SCALE, CGRectGetMaxY(timeTitle.frame)+1*SCALE, 10*SCALE, 20*SCALE)];
        }
        
        minuteLabel2.text = @"9";
        minuteLabel2.textColor = [UIColor whiteColor];
        [minuteLabel2 setFont:[UIFont boldSystemFontOfSize:14*SCALE]];
        [titleView addSubview:minuteLabel2];
        
        if ([[UIApplication sharedApplication] statusBarFrame].size.height > 20) {
            secondLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(194*SCALE, CGRectGetMaxY(timeTitle.frame)+1*SCALE, 10*SCALE, 20*SCALE)];
        }else {
           secondLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(201*SCALE, CGRectGetMaxY(timeTitle.frame)+1*SCALE, 10*SCALE, 20*SCALE)];
        }
        
        secondLabel1.text = @"9";
        secondLabel1.textColor = [UIColor whiteColor];
        [secondLabel1 setFont:[UIFont boldSystemFontOfSize:14*SCALE]];
        [titleView addSubview:secondLabel1];
        
        if ([[UIApplication sharedApplication] statusBarFrame].size.height > 20) {
            secondLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(214*SCALE, CGRectGetMaxY(timeTitle.frame)+1*SCALE, 10*SCALE, 20*SCALE)];
        }else {
           secondLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(221*SCALE, CGRectGetMaxY(timeTitle.frame)+1*SCALE, 10*SCALE, 20*SCALE)];
        }
        
        secondLabel2.text = @"9";
        secondLabel2.textColor = [UIColor whiteColor];
        [secondLabel2 setFont:[UIFont boldSystemFontOfSize:14*SCALE]];
        [titleView addSubview:secondLabel2];
        
        //店铺图标 (100)
        UIImageView *storeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(40*SCALE, 75*SCALE, 40*SCALE, 40*SCALE)];
        storeIcon.image = [UIImage imageNamed:@"order_logo"];
        [titleView addSubview:storeIcon];
        
        //金额
        price = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(storeIcon.frame)+30*SCALE, 70*SCALE, 240*SCALE, 30*SCALE)];
        price.text = @"40.00";
        price.font = [UIFont systemFontOfSize:25*SCALE];
        [titleView addSubview:price];
        
        //店铺加订单号
        orderInfo = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(storeIcon.frame)+30*SCALE, CGRectGetMaxY(price.frame)+5*SCALE, 240*SCALE, 12*SCALE)];
        orderInfo.text = @"兔悠和平店-3487324873874";
        orderInfo.font = [UIFont systemFontOfSize:13*SCALE];
        [titleView addSubview:orderInfo];
        
        
        //微信区 50
        UIView *wxView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame) +6*SCALE, SCREEN_WIDTH, 50*SCALE)];
        wxView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:wxView];
        
        //图标
        UIImageView *wxIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15*SCALE, 15*SCALE, 20*SCALE, 20*SCALE)];
        wxIcon.image = [UIImage imageNamed:@"order_wx"];
        [wxView addSubview:wxIcon];
        
        UILabel *wxLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(wxIcon.frame)+20*SCALE, 0*SCALE, 200*SCALE, 50*SCALE)];
        wxLabel.text = @"微信支付";
        wxLabel.font = [UIFont systemFontOfSize:15*SCALE];
        [wxView addSubview:wxLabel];
        
        wxBtnImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35*SCALE, 15*SCALE, 20*SCALE, 20*SCALE)];
        wxBtnImage.image = [UIImage imageNamed:@"order_selected"];
        [wxView addSubview:wxBtnImage];
        
        //选择
        wxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [wxBtn setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50*SCALE)];
        [wxBtn addTarget:self action:@selector(wxBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        wxBtn.selected = YES;
        [wxView addSubview:wxBtn];
        
        //支付宝 50
        UIView *aliView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(wxView.frame) +6*SCALE, SCREEN_WIDTH, 50*SCALE)];
        aliView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:aliView];
        
        UIImageView *aliIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15*SCALE, 15*SCALE, 20*SCALE, 20*SCALE)];
        aliIcon.image = [UIImage imageNamed:@"order_ali"];
        [aliView addSubview:aliIcon];
        
        UILabel *aliLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(wxIcon.frame)+20*SCALE, 0*SCALE, 200*SCALE, 50*SCALE)];
        aliLabel.text = @"支付宝";
        aliLabel.font = [UIFont systemFontOfSize:15*SCALE];
        [aliView addSubview:aliLabel];
        
        aliBtnImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35*SCALE, 15*SCALE, 20*SCALE, 20*SCALE)];
        aliBtnImage.image = [UIImage imageNamed:@"order_unselected"];
        [aliView addSubview:aliBtnImage];
        
        //选择
        aliBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [aliBtn setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50*SCALE)];
        [aliBtn addTarget:self action:@selector(aliBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        aliBtn.selected = NO;
        [aliView addSubview:aliBtn];
        
        //确认支付按钮
        UIButton *paymentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [paymentBtn setFrame:CGRectMake(10*SCALE, CGRectGetMaxY(aliView.frame)+50*SCALE, SCREEN_WIDTH-20*SCALE, 44*SCALE)];
        [paymentBtn addTarget:self action:@selector(paymentBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        paymentBtn.backgroundColor = ICON_COLOR;
        [paymentBtn setTitleColor:MAIN_TEXT_COLOR forState:UIControlStateNormal];
        [paymentBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        [self.view addSubview:paymentBtn];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessNotification) name:@"paySuccess" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFailNotification) name:@"payFail" object:nil];
        
        _orderDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showLoadHUDMsg:@"努力加载中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_orderDictionary[@"order_id"], @"order_id", nil];
    
    [HttpClientService requestOrderpay:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            [self runTime:[[jsonDic objectForKey:@"count_down"] intValue]];
            
            price.text = [jsonDic objectForKey:@"money"];
            
            orderInfo.text = [NSString stringWithFormat:@"%@-%@", [jsonDic objectForKey:@"cvs_name"], [jsonDic objectForKey:@"order_id"]];
            
            [self hideLoadHUD:YES];
        }else {
            [self hideLoadHUD:YES];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];

    }];
}

- (void)wxBtnEvent {
    wxBtnImage.image = [UIImage imageNamed:@"order_selected"];
    aliBtnImage.image = [UIImage imageNamed:@"order_unselected"];
    wxBtn.selected = YES;
    aliBtn.selected = NO;
}

- (void)aliBtnEvent {
    wxBtnImage.image = [UIImage imageNamed:@"order_unselected"];
    aliBtnImage.image = [UIImage imageNamed:@"order_selected"];
    wxBtn.selected = NO;
    aliBtn.selected = YES;
}

- (void)paymentBtnEvent {
    if (wxBtn.selected == YES && aliBtn.selected == NO) {
        [self wxPay];
    }else if(wxBtn.selected == NO && aliBtn.selected == YES) {
        [self alipay];
    }
}



- (void)wxPay {
    
    if (![WXApi isWXAppInstalled]) {
        [self showMsg:@"没有安装微信"];
        NSLog(@"没有安装微信");
        return;
    }else if (![WXApi isWXAppSupportApi]) {
        NSLog(@"不支持微信支付");
        return;
    }
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_orderDictionary[@"order_id"], @"order_id", nil];
    
    [HttpClientService requestPrepay:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = [jsonDic objectForKey:@"partnerid"];
            req.prepayId            = [jsonDic objectForKey:@"prepayid"];
            req.nonceStr            = [jsonDic objectForKey:@"noncestr"];
            req.timeStamp           = [[jsonDic objectForKey:@"timestamp"] intValue];
            req.package             = [jsonDic objectForKey:@"package"];
            req.sign                = [jsonDic objectForKey:@"sign"];
            [WXApi sendReq:req];
//            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dic objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
            
        }else if (status == 1) {
            //订单参数为空
            [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
        }else if (status == 2){
            //订单编号不存在
            [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
        }else if (status == 3){
            //统一支付接口获取预支付交易回话出错
            [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
        }else if(status == 9001) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
            [self showMsg:@"您的帐号存在异地登录，请重新登录。"];
        }else {

            [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
        }
    } failure:^(NSError *error) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
        
    }];
    
}

- (void)alipay {

    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_orderDictionary[@"order_id"], @"order_id", nil];
    
    [HttpClientService requestAlitrade:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            NSString *dic = [jsonDic objectForKey:@"trade_msg"];
            
            //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
            NSString *appScheme = @"alituuyuu";
            
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:dic fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                //网页支付成功或者失败 6001
                NSLog(@"31reslut = %@",resultDic);
                
                //【callback处理支付结果】
                if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
                    
                }else if([resultDic[@"resultStatus"] isEqualToString:@"8000"]) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
                    
                }else if([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
                    
                    //已取消支付
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
                    
                }else if([resultDic[@"resultStatus"] isEqualToString:@"6002"]) {
                    
                    //网络连接出错
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
                    
                }else if([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {
                    
                    //支付失败
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
                    
                }else{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
                    
                }
                
            }];
            
        }else if (status == 1) {
            //订单参数为空
            [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
        }else if (status == 2){
            //订单编号不存在
            [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
        }else if(status == 202) {
            
//            [self showMsg:@"您的帐号存在异地登录，请重新登录。"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
        }
        
        
    } failure:^(NSError *error) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
        
    }];
    
}

- (void)payFailNotification {
    
    [self hideLoadHUD:YES];
    
    [self showMsg:@"支付失败"];
}

- (void)paySuccessNotification {
    
    [[UserDefaults service] updateOrderNote:@""];
    
    CartInfoDAL *dal = [[CartInfoDAL alloc] init];
    
    [dal cleanCartInfo];
    
    [self showMsg:@"支付成功"];
    
    [self reloadViewController];
    
}

- (void)reloadViewController {
    
    NSMutableArray *viewControllers =[[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    
    for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
        if (![[[self.navigationController.viewControllers mutableCopy] objectAtIndex:i] isKindOfClass:[HomeViewController class]] && ![[[self.navigationController.viewControllers mutableCopy] objectAtIndex:i] isKindOfClass:[OrderViewController class]]) {
            [viewControllers removeObject:[[self.navigationController.viewControllers mutableCopy] objectAtIndex:i]];
        }
        
    }

    OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
    [orderDetailViewController.orderDictionary setObject:_orderDictionary[@"order_id"] forKey:@"order_id"];
    
    [viewControllers addObject:orderDetailViewController];
    [self.navigationController setViewControllers:viewControllers animated:YES];
}

- (void)runTime:(int)timeInterval {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    if (payTimer==nil) {
        __block int timeout = timeInterval; //倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            payTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(payTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(payTimer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(payTimer);
                    payTimer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        minuteLabel1.text = @"0";
                        minuteLabel2.text = @"0";
                        secondLabel1.text = @"0";
                        secondLabel2.text = @"0";
                    });
                }else {
                    
                    int minute = (int)(timeout/60);
                    int second = timeout-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{

                        if (minute<10) {
                            minuteLabel1.text = @"0";
                            minuteLabel2.text = [NSString stringWithFormat:@"%d",minute];
                        }else {
                            minuteLabel1.text = [[NSString stringWithFormat:@"%d",minute] substringWithRange:NSMakeRange(0,1)];
                            minuteLabel2.text = [[NSString stringWithFormat:@"%d",minute] substringWithRange:NSMakeRange(1,1)];
                        }
                        if (second<10) {
                            secondLabel1.text = @"0";
                            secondLabel2.text = [NSString stringWithFormat:@"%d",second];
                        }else{
                            secondLabel1.text = [[NSString stringWithFormat:@"%d",second] substringWithRange:NSMakeRange(0,1)];
                            secondLabel2.text = [[NSString stringWithFormat:@"%d",second] substringWithRange:NSMakeRange(1,1)];
                        }
                        
                    });
                    timeout--;
                }
            });
            dispatch_resume(payTimer);
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}

@end
