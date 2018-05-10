//
//  TPayDetailViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/26.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "TPayDetailViewController.h"
#import "TPayDetailCell.h"
#import "LoginViewController.h"
// 自定义的header
#import "MJChiBaoZiHeader.h"
#import "MJChiBaoZiFooter.h"
#import "MJChiBaoZiFooter2.h"
#import "MJDIYHeader.h"
#import "MJDIYAutoFooter.h"
#import "MJDIYBackFooter.h"



@interface TPayDetailViewController ()<UITableViewDelegate, UITableViewDataSource> {
    UITableView *contentView;
    NSMutableArray *detailArray;
    
    NSInteger pageNumber;
    
    UIImageView *bg;
}

@end

@implementation TPayDetailViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.backgroundColor = [UIColor clearColor];
        
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_bg"] forState:UIControlStateNormal];
        navigationBar.titleLabel.text = @"兔币明细";
        
        
        //iOS7新增属性 TODO
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        
        bg = [[UIImageView alloc] initWithFrame:self.view.frame];
        bg.image = [UIImage imageNamed:@"mine_content_bg"];
        [self.view addSubview:bg];
        
        [self.view bringSubviewToFront:navigationBar];
        
        contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT+6, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT-6) style:UITableViewStylePlain];
        
        contentView.delegate = self;
        
        contentView.dataSource = self;
        
        //        contentView.separatorStyle = NO;
        
        contentView.backgroundColor = [UIColor clearColor];
        
        //去除底部多余分割线
        contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        // 纯动画 无状态和时间
        MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        header.lastUpdatedTimeLabel.hidden = YES;
        contentView.mj_header = header;
        contentView.mj_header.automaticallyChangeAlpha = YES;
        contentView.mj_footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        [self.view addSubview:contentView];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
    
    [self newData];
    
    [contentView setHidden:YES];
    [bg setHidden:YES];
    
}

- (void)newData {
    [self showLoadHUDMsg:@"努力加载中..."];
    
    pageNumber = 0;
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%zd", pageNumber], @"page", nil];
    
    [HttpClientService requestTuucoinconsume:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            [contentView setHidden:NO];
            [bg setHidden:NO];
            
            detailArray = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"details"]];
            [contentView reloadData];
            
            pageNumber++;
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
        
//        NSLog(@"请求兔币明细失败");
    }];
}

#pragma mark 下拉刷新数据
- (void)loadNewData
{
    pageNumber = 0;
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%zd", pageNumber], @"page", nil];
    
    [HttpClientService requestTuucoinconsume:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            [contentView setHidden:NO];
            [bg setHidden:NO];
            
            detailArray = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"details"]];
            [contentView reloadData];
            
            pageNumber++;
            [contentView.mj_header endRefreshing];
            [contentView.mj_footer resetNoMoreData];
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
        [contentView.mj_header endRefreshing];
//        NSLog(@"请求兔币明细失败");
    }];
}

- (void)loadMoreData {
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%zd", pageNumber], @"page", nil];
    
    [HttpClientService requestTuucoinconsume:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"details"]];
            
            if (array.count == 0) {
                [self hideLoadHUD:YES];
                
                [self showMsg:@"没有更多记录了"];
                
                [contentView.mj_footer endRefreshingWithNoMoreData];
            }else if (array.count > 0 && array.count < 20) {
                
                for (int i = 0; i<array.count; i++) {
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    
                    dic = [array objectAtIndex:i];
                    
                    [detailArray addObject:dic];
                }
                
                [contentView reloadData];
                
                [self hideLoadHUD:YES];
                
                [contentView.mj_footer endRefreshingWithNoMoreData];
            }else {
                for (int i = 0; i<array.count; i++) {
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    
                    dic = [array objectAtIndex:i];
                    
                    [detailArray addObject:dic];
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
//            [self showMsg:@"服务器异常"];
            [self hideLoadHUD:YES];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        [contentView.mj_footer endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [detailArray count];
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70*SCALE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellIdentifier1 = @"MyCellIdentifier1";
    
    
    TPayDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier1];
    if (cell == nil) {
        cell = [[TPayDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier1];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.title.text = detailArray[indexPath.section][@"engender_type"];
    cell.subTitle.text = detailArray[indexPath.section][@"tuu_coin"];
    cell.time.text = detailArray[indexPath.section][@"engender_time"];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
   
        return 10*SCALE;
   
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20*SCALE)];
    footerView.backgroundColor = [UIColor clearColor];
    
    return footerView;
}

#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}

@end
