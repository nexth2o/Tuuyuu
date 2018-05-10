//
//  CustomerServiceViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/25.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "CustomerServiceViewController.h"

#import "LoginViewController.h"

@interface CustomerServiceViewController () {
    UILabel *storeNum;
    UILabel *serviceNum;
    UIImageView *contentView;
}

@end

@implementation CustomerServiceViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.backgroundColor = [UIColor whiteColor];
        
        navigationBar.titleLabel.text = @"联系客服";
        
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_gray"] forState:UIControlStateNormal];
        
        //iOS7新增属性 TODO
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        //背景
        contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        contentView.image = [UIImage imageNamed:@"mine_Customer_bg"];
        contentView.userInteractionEnabled = YES;
        [self.view addSubview:contentView];
        
        //白色背景
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(40*SCALE, 40*SCALE, SCREEN_WIDTH-80*SCALE, SCREEN_WIDTH-80*SCALE)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:whiteView];
        
        //标题
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-80*SCALE, 40*SCALE)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [whiteView addSubview:line];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, 10*SCALE, 20*SCALE, 20*SCALE)];
        icon.image = [UIImage imageNamed:@"mine_Customer_tel"];
        [whiteView addSubview:icon];
        
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(40*SCALE, 0, SCREEN_WIDTH-120*SCALE, 40*SCALE)];
        title.text = @"联系客服";
        title.textColor = [UIColor darkGrayColor];
        title.font = [UIFont systemFontOfSize:13*SCALE];
        [whiteView addSubview:title];
        
        UILabel *storeTel = [[UILabel alloc] initWithFrame:CGRectMake(40*SCALE, 80*SCALE, SCREEN_WIDTH-120*SCALE, 40*SCALE)];
        storeTel.text = @"相关店铺电话";
        storeTel.textColor = [UIColor darkGrayColor];
        storeTel.font = [UIFont systemFontOfSize:13*SCALE];
        [whiteView addSubview:storeTel];
        
        UILabel *serviceTel = [[UILabel alloc] initWithFrame:CGRectMake(40*SCALE, 160*SCALE, SCREEN_WIDTH-120*SCALE, 40*SCALE)];
        serviceTel.text = @"官方客服服务电话";
        serviceTel.textColor = [UIColor darkGrayColor];
        serviceTel.font = [UIFont systemFontOfSize:13*SCALE];
        [whiteView addSubview:serviceTel];
        
        storeNum = [[UILabel alloc] initWithFrame:CGRectMake(60*SCALE, 120*SCALE, SCREEN_WIDTH-200*SCALE, 40*SCALE)];
        storeNum.textColor = MAIN_COLOR;
        storeNum.font = [UIFont boldSystemFontOfSize:22*SCALE];
        storeNum.textAlignment = NSTextAlignmentCenter;
        [whiteView addSubview:storeNum];
        
        serviceNum = [[UILabel alloc] initWithFrame:CGRectMake(60*SCALE, 200*SCALE, SCREEN_WIDTH-200*SCALE, 40*SCALE)];
        serviceNum.textColor = MAIN_COLOR;
        serviceNum.font = [UIFont boldSystemFontOfSize:22*SCALE];
        serviceNum.textAlignment = NSTextAlignmentCenter;
        [whiteView addSubview:serviceNum];
        
        UIImageView *storeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(40*SCALE, 130*SCALE, 20*SCALE, 20*SCALE)];
        storeIcon.image = [UIImage imageNamed:@"mine_Customer_tel"];
        [whiteView addSubview:storeIcon];
        
        UIImageView *serviceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(40*SCALE, 210*SCALE, 20*SCALE, 20*SCALE)];
        serviceIcon.image = [UIImage imageNamed:@"mine_Customer_tel"];
        [whiteView addSubview:serviceIcon];
        
        UIButton *storeButton = [[UIButton alloc] initWithFrame:CGRectMake(40*SCALE, 120*SCALE, SCREEN_WIDTH-180*SCALE, 40*SCALE)];
//        [storeButton setBackgroundColor:[UIColor lightGrayColor]];
        [storeButton addTarget:self action:@selector(sroreBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:storeButton];
        
        UIButton *serviceButton = [[UIButton alloc] initWithFrame:CGRectMake(40*SCALE, 200*SCALE, SCREEN_WIDTH-180*SCALE, 40*SCALE)];
//        [serviceButton setBackgroundColor:[UIColor lightGrayColor]];
        [serviceButton addTarget:self action:@selector(serviceBtnEvent) forControlEvents:UIControlEventTouchUpInside];
     
        [whiteView addSubview:serviceButton];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)sroreBtnEvent {
    NSString *telUrl = [NSString stringWithFormat:@"tel://%@", storeNum.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
}

- (void)serviceBtnEvent {
    NSString *telUrl = [NSString stringWithFormat:@"tel://%@", serviceNum.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [contentView setHidden:YES];
    [self showLoadHUDMsg:@"努力加载中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:[[UserDefaults service] getStoreId], @"cvs_no", nil];
    
    [HttpClientService requestStoresummary:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            [contentView setHidden:NO];
            storeNum.text = [NSString stringWithFormat:@"%@-%@", [[jsonDic objectForKey:@"store_tel"] substringWithRange:NSMakeRange(0,3)], [[jsonDic objectForKey:@"store_tel"] substringWithRange:NSMakeRange(3,8)]];
            
            if (![[jsonDic objectForKey:@"service_tel"] isKindOfClass:[NSNull class]] && [jsonDic objectForKey:@"service_tel"]) {
                serviceNum.text = [NSString stringWithFormat:@"%@-%@-%@", [[jsonDic objectForKey:@"service_tel"] substringWithRange:NSMakeRange(0,3)], [[jsonDic objectForKey:@"service_tel"] substringWithRange:NSMakeRange(3,3)], [[jsonDic objectForKey:@"service_tel"] substringWithRange:NSMakeRange(6,4)]];
            }else {
                serviceNum.text = @"400-166-0020";
            }
            
            [self hideLoadHUD:YES];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}


@end
