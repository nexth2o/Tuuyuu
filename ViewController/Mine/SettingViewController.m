//
//  SettingViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/16.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "LoginViewController.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *contentView;
    
    NSString *notify;
    NSString *nightNotify;
}

@end

@implementation SettingViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        
        navigationBar.titleLabel.text = @"设置";
        [navigationBar.leftButton setHidden:NO];
        
        contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT) style:UITableViewStyleGrouped];
        
        contentView.delegate = self;
        
        contentView.dataSource = self;
        
        [self.view addSubview:contentView];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        notify = @"0";
        nightNotify = @"0";
        
    }
    
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self requestData];
}

- (void)requestData {
    [self showLoadHUDMsg:@"努力加载中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] init];
    
    [HttpClientService requestIntegralconfig:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            notify = [jsonDic objectForKey:@"code_notify"];
            nightNotify = [jsonDic objectForKey:@"is_night_notify_for_code"];

            [contentView reloadData];
            
            [self hideLoadHUD:YES];
         
        }else if (status == 202) {
            [self showMsg:@"您的登录状态失效，请重新登录"];
            [self hideLoadHUD:YES];
            sleep(1.0);
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
            
        }else {
            [self hideLoadHUD:YES];
            [self showMsg:@"服务器异常"];
            
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
//        NSLog(@"请求积分提醒失败");
    }];
}

- (void)requestSetData {
    [self showLoadHUDMsg:@"设置中..."];
    
        NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:notify, @"code_notify", nightNotify, @"is_night_notify_for_code", nil];
    
    [HttpClientService requestIntegralconfigure:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            [contentView reloadData];
            
            [self hideLoadHUD:YES];
            
        }else if (status == 202) {
            [self showMsg:@"您的登录状态失效，请重新登录"];
            [self hideLoadHUD:YES];
            sleep(1.0);
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
            
        }else {
            [self hideLoadHUD:YES];
            [self showMsg:@"服务器异常"];
            
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
        NSLog(@"设置积分提醒失败");
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50*SCALE;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myCellIdentifier = @"MyCellIdentifier";
    
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
    
    if (!cell) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier];
    }
    if (indexPath.row == 1) {
        
        cell.titleLabel.text = @"积分提醒";
        [cell.subTitleLabel setHidden:YES];
        [cell.switchBtn setHidden:NO];
        
        if ([notify isEqualToString:@"1"]) {
            [cell.switchBtn setOn:YES];
        }else {
            [cell.switchBtn setOn:NO];
        }
        
//        __weak __typeof(&*cell)weakCell =cell;
        weakify(cell);
        cell.switchActionBlock = ^()
        {
            strongify(cell);
            if (cell.switchBtn.on == YES) {
                notify = @"1";
            }else {
                notify = @"0";
            }
            
            [self requestSetData];
        };
        
        
    }else if (indexPath.row == 0) {

        cell.titleLabel.text = @"清理缓存";
         [cell.switchBtn setHidden:YES];
        [cell.subTitleLabel setHidden:NO];
        
        float tmpSize = [[SDImageCache sharedImageCache] getSize] / 1024.0 /1024.0;
        NSString *clearCacheSizeStr = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];
        cell.subTitleLabel.text = clearCacheSizeStr;
        
    }else {
        [cell.switchBtn setHidden:YES];
        [cell.subTitleLabel setHidden:NO];
        cell.titleLabel.text = @"版本";
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        cell.subTitleLabel.text = appVersion;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //清除缓存
    if (indexPath.row == 0) {
        UIAlertController *tipsAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否清除缓存？" preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            [self showMsg:@"缓存清理成功"];
            [contentView reloadData];

        }];
        
        UIAlertAction *NOButton = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            
        }];
        
        [tipsAlert addAction:OKButton];
        
        [tipsAlert addAction:NOButton];
        
        [self presentViewController:tipsAlert animated:YES completion:nil];
    
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
