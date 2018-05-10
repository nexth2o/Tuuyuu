//
//  MineFriendSubViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/27.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "MineFriendSubViewController.h"
#import "MineFriendSubHeaderCell.h"
#import "MineFriendCell.h"
#import "LoginViewController.h"

// 自定义的header
#import "MJChiBaoZiHeader.h"
#import "MJChiBaoZiFooter.h"
#import "MJChiBaoZiFooter2.h"
#import "MJDIYHeader.h"
#import "MJDIYAutoFooter.h"
#import "MJDIYBackFooter.h"



@interface MineFriendSubViewController ()<UITableViewDelegate, UITableViewDataSource> {
    UITableView *contentView;
    NSDictionary *jsonDic;
    NSMutableArray *friendArray;
    
    UIImageView *bg;
    
    NSInteger pageNumber;
    
    NSInteger pageLen;
    
}

@end

@implementation MineFriendSubViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.backgroundColor = [UIColor clearColor];
        
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_bg"] forState:UIControlStateNormal];
        
        //iOS7新增属性 TODO
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        bg = [[UIImageView alloc] initWithFrame:self.view.frame];
        bg.image = [UIImage imageNamed:@"mine_content_bg"];
        [self.view addSubview:bg];
        
        contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70*SCALE, SCREEN_WIDTH, SCREEN_HEIGHT-70*SCALE) style:UITableViewStylePlain];
        
        contentView.delegate = self;
        
        contentView.dataSource = self;
        
        //        contentView.separatorStyle = NO;
        
        contentView.backgroundColor = [UIColor clearColor];
        
        contentView.mj_footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        //去除底部多余分割线
        contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self.view addSubview:contentView];
        
        [self.view bringSubviewToFront:navigationBar];
        
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
    
    self.tabBarController.tabBar.hidden = YES;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self requestSubFriendslist];
    });
}

- (void)requestSubFriendslist {
    [contentView setHidden:YES];
    [bg setHidden:YES];
    [self showLoadHUDMsg:@"努力加载中..."];
    
    pageNumber = 0;
    pageLen = 20;
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_orderDictionary[@"user_id"], @"user_id", [NSString stringWithFormat:@"%zd", pageNumber], @"page", nil];
    
    [HttpClientService requestFriendslist:paramDic success:^(id responseObject) {
        
        jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            [contentView setHidden:NO];
            [bg setHidden:NO];
            friendArray = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"friends"]];
            
            [contentView reloadData];
            
            
            [self hideLoadHUD:YES];
            if ([friendArray count] < 20) {
                [contentView.mj_footer endRefreshingWithNoMoreData];
            }
            pageNumber++;
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
        NSLog(@"请求好友列表失败");
    }];
}

- (void)loadMoreData {
    [self showLoadHUDMsg:@"努力加载中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_orderDictionary[@"user_id"], @"user_id", [NSString stringWithFormat:@"%zd", pageNumber], @"page", nil];
    
    //查询取餐列表
    [HttpClientService requestFriendslist:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"friends"]];
            
            if (array.count == 0) {
                
                [self hideLoadHUD:YES];
                
                [self showMsg:@"没有更多好友了"];
                
                [contentView.mj_footer endRefreshingWithNoMoreData];
                
            }else if (array.count > 0 && array.count < pageLen) {
                
                for (int i = 0; i<array.count; i++) {
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    
                    dic = [array objectAtIndex:i];
                    
                    [friendArray addObject:dic];
                }
                
                [contentView reloadData];
                
                [self hideLoadHUD:YES];
                
                [contentView.mj_footer endRefreshingWithNoMoreData];
                
                
            }else {
                
                for (int i = 0; i<array.count; i++) {
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    
                    dic = [array objectAtIndex:i];
                    
                    [friendArray addObject:dic];
                }
                pageNumber++;
                
                [contentView reloadData];
                
                [self hideLoadHUD:YES];
                
                [contentView.mj_footer endRefreshing];
                
            }
            
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
        [self showMsg:@"加载好友失败"];
        
        [contentView.mj_footer endRefreshing];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [friendArray count]+1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 50*SCALE;
    }else {
        return 50*SCALE;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *myCellIdentifier2 = @"MyCellIdentifier2";
    static NSString *myCellIdentifier3 = @"MyCellIdentifier3";
    
    UITableViewCell *cell = nil;
   if (indexPath.section == 0) {
        
        MineFriendSubHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier2];
        if (cell == nil) {
            cell = [[MineFriendSubHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier2];
        }
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.number.text = [jsonDic objectForKey:@"total"];
        cell.numberTitle.text = @"间接好友数";
        cell.count.text = [jsonDic objectForKey:@"integral"];
        
        
        return cell;
    }else {
        
        MineFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier3];
        if (cell == nil) {
            cell = [[MineFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier3];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.name.text = friendArray[indexPath.section-1][@"nick_name"];
        cell.time.text = [NSString stringWithFormat:@"加入时间：%@", friendArray[indexPath.section-1][@"register_time"]];
        
        cell.type.text = @"间接好友贡献";
        
        cell.coinCount.text = friendArray[indexPath.section-1][@"integral"];
        
        
        
        return cell;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 20*SCALE;
    }else {
        return 10*SCALE;
    }
    
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
