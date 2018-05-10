//
//  CouponCenterViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/8/30.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "CouponCenterViewController.h"
#import "CouponCenterCell.h"
#import "OrderSegmentView.h"
#import "LoginViewController.h"

// 自定义的header
#import "MJChiBaoZiHeader.h"
#import "MJChiBaoZiFooter.h"
#import "MJChiBaoZiFooter2.h"
#import "MJDIYHeader.h"
#import "MJDIYAutoFooter.h"
#import "MJDIYBackFooter.h"



@interface CouponCenterViewController ()<UITableViewDelegate, UITableViewDataSource> {
    OrderSegmentView *tabView;
    UITableView *contentView;
    
    NSMutableArray *couponArray;
    
    NSInteger pageNumber;
    
    NSString *type;
    
    UIImageView *noNetImage;
    UIButton *noNetBtn;
    
    UIImageView *noDataImage;
    UILabel *noDataLabel;
}

@end

@implementation CouponCenterViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        navigationBar.titleLabel.text = @"领券中心";
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        NSArray *tabArray = [NSArray arrayWithObjects:@"全部", @"会员专享劵", @"通用劵", nil];
        
        tabView = [[OrderSegmentView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT, SCREEN_WIDTH, 35*SCALE) titles:tabArray clickBlick:^void(NSInteger index) {
            
            [contentView.mj_footer resetNoMoreData];
            [contentView setHidden:NO];
            
            if (index==1) {
                type = @"0";//全部
            }else if (index==2) {
                type = @"1";//会员专享劵
            }else if (index==3) {
                type = @"2";//通用劵
            }
        }];
        [self.view addSubview:tabView];
        
        contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tabView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT-BOTTOM_BAR_HEIGHT-35*SCALE) style:UITableViewStyleGrouped];
        contentView.delegate = self;
        contentView.dataSource = self;
        contentView.separatorStyle = NO;
        contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        // 纯动画 无状态和时间
        MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        header.lastUpdatedTimeLabel.hidden = YES;
        contentView.mj_header = header;
        contentView.mj_header.automaticallyChangeAlpha = YES;
        contentView.mj_footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        [self.view addSubview:contentView];
        
        [self.view bringSubviewToFront:navigationBar];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        //初始化全部
        type = @"0";
        
        noDataImage = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200*SCALE)/2, 200*SCALE, 200*SCALE, 200*SCALE)];
        noDataImage.image = [UIImage imageNamed:@"no_data"];
        [noDataImage setHidden:YES];
        [self.view addSubview:noDataImage];
        
        noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(noDataImage.frame)+10*SCALE, SCREEN_WIDTH, 20*SCALE)];
        noDataLabel.text = @"没有相关优惠劵";
        [noDataLabel setHidden:YES];
        noDataLabel.textColor = [UIColor darkGrayColor];
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:noDataLabel];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=NO;
    
    if ([[UserDefaults service] getLoginStatus] == YES) {
        [noNetImage setHidden:YES];
        [noNetBtn setHidden:YES];
        [contentView setHidden:YES];
        [self newData];
        
    }else {
        [contentView setHidden:YES];
        [noNetImage setHidden:NO];
        [noNetBtn setHidden:NO];
    }
    
    
}

- (void)newData {
    [self showLoadHUDMsg:@"努力加载中..."];
    
    pageNumber = 0;
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys: type, @"type", [NSString stringWithFormat:@"%ld", (long)pageNumber], @"page", nil];
    
    //查询取餐列表
    [HttpClientService requestOrderlist:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            couponArray = [[NSMutableArray alloc] initWithArray:[jsonDic objectForKey:@"orderlist"]];
            
            if ([couponArray count] > 0) {
                
                [contentView setHidden:NO];
                
                [noDataImage setHidden:YES];
                [self.view sendSubviewToBack:noDataImage];
                
                [noDataLabel setHidden:YES];
                [self.view sendSubviewToBack:noDataLabel];
                
                [contentView reloadData];
                [contentView setContentOffset:CGPointMake(0,0) animated:YES];
                
                
                pageNumber++;
                
            }else {
                [contentView setHidden:YES];
                
                [noDataImage setHidden:NO];
                [self.view bringSubviewToFront:noDataImage];
                
                [noDataLabel setHidden:NO];
                [self.view bringSubviewToFront:noDataLabel];
            }
            
            [self hideLoadHUD:YES];
        }else if (status == 202) {
            [self hideLoadHUD:YES];
            [self showMsg:@"您的登录状态失效，请重新登录"];
            
            sleep(1.0);
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
            
        }else {
            [self hideLoadHUD:YES];
            [self showMsg:[NSString stringWithFormat:@"错误码%d",status]];
            
        }
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
    }];
}



#pragma mark 下拉刷新数据
- (void)loadNewData
{
    pageNumber = 0;
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys: type, @"type", [NSString stringWithFormat:@"%ld", (long)pageNumber], @"page", nil];
    
    //查询取餐列表
    [HttpClientService requestOrderlist:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            
            couponArray = [[NSMutableArray alloc] initWithArray:[jsonDic objectForKey:@"orderlist"]];
            
            
            if ([couponArray count] > 0) {
                
                [contentView setHidden:NO];
                
                [noDataImage setHidden:YES];
                [self.view sendSubviewToBack:noDataImage];
                
                [noDataLabel setHidden:YES];
                [self.view sendSubviewToBack:noDataLabel];
                
                [contentView reloadData];
                [contentView setContentOffset:CGPointMake(0,0) animated:YES];
                
                
                pageNumber++;
                
            }else {
                [contentView setHidden:YES];
                
                [noDataImage setHidden:NO];
                [self.view bringSubviewToFront:noDataImage];
                
                [noDataLabel setHidden:NO];
                [self.view bringSubviewToFront:noDataLabel];
            }
            
            
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
        [contentView.mj_header endRefreshing];
        
    }];
}

- (void)loadMoreData {
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys: type, @"type", [NSString stringWithFormat:@"%ld", (long)pageNumber], @"page", nil];
    
    //查询取餐列表
    [HttpClientService requestOrderlist:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"orderlist"]];
            
            if (array.count == 0) {
                
                [self hideLoadHUD:YES];
                
                [self showMsg:@"没有更多订单了"];
                
                [contentView.mj_footer endRefreshingWithNoMoreData];
                
            }else if (array.count > 0 && array.count < 20) {
                
                for (int i = 0; i<array.count; i++) {
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    
                    dic = [array objectAtIndex:i];
                    
                    [couponArray addObject:dic];
                }
                
                [contentView reloadData];
                
                [self hideLoadHUD:YES];
                
                [contentView.mj_footer endRefreshingWithNoMoreData];
                
                
            }else {
                
                for (int i = 0; i<array.count; i++) {
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    
                    dic = [array objectAtIndex:i];
                    
                    [couponArray addObject:dic];
                }
                pageNumber++;
                
                [contentView reloadData];
                
                [self hideLoadHUD:YES];
                
                [contentView.mj_footer endRefreshing];
                
            }
            
            
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
        [contentView.mj_header endRefreshing];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80*SCALE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *orderCellIdentifier = @"OrderCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了%ld", (long)indexPath.row);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
