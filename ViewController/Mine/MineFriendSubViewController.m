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



@interface MineFriendSubViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *contentView;
@property(nonatomic, strong) NSDictionary *jsonDic;
@property(nonatomic, strong) NSMutableArray *friendArray;
@property(nonatomic, strong) UIImageView *bg;
@property(nonatomic, assign) NSInteger pageNumber;
@property(nonatomic, assign) NSInteger pageLen;

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
        
        _bg = [[UIImageView alloc] initWithFrame:self.view.frame];
        _bg.image = [UIImage imageNamed:@"mine_content_bg"];
        [self.view addSubview:_bg];
        
        _contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70*SCALE, SCREEN_WIDTH, SCREEN_HEIGHT-70*SCALE) style:UITableViewStylePlain];
        
        _contentView.delegate = self;
        
        _contentView.dataSource = self;
        
        //        contentView.separatorStyle = NO;
        
        _contentView.backgroundColor = [UIColor clearColor];
        
        _contentView.mj_footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        //去除底部多余分割线
        _contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self.view addSubview:_contentView];
        
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
    [_contentView setHidden:YES];
    [_bg setHidden:YES];
    [self showLoadHUDMsg:@"努力加载中..."];
    
    _pageNumber = 0;
    _pageLen = 20;
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_orderDictionary[@"user_id"], @"user_id", [NSString stringWithFormat:@"%ld", (long)_pageNumber], @"page", nil];
    weakify(self);
    [HttpClientService requestFriendslist:paramDic success:^(id responseObject) {
        strongify(self);
        self.jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[self.jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            [self.contentView setHidden:NO];
            [self.bg setHidden:NO];
            self.friendArray = [NSMutableArray arrayWithArray:[self.jsonDic objectForKey:@"friends"]];
            
            [self.contentView reloadData];
            
            
            [self hideLoadHUD:YES];
            if ([self.friendArray count] < 20) {
                [self.contentView.mj_footer endRefreshingWithNoMoreData];
            }
            self.pageNumber++;
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
        NSLog(@"请求好友列表失败");
    }];
}

- (void)loadMoreData {
    [self showLoadHUDMsg:@"努力加载中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_orderDictionary[@"user_id"], @"user_id", [NSString stringWithFormat:@"%ld", (long)_pageNumber], @"page", nil];
    
    weakify(self);
    [HttpClientService requestFriendslist:paramDic success:^(id responseObject) {
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"friends"]];
            
            if (array.count == 0) {
                
                [self hideLoadHUD:YES];
                
                [self showMsg:@"没有更多好友了"];
                
                [self.contentView.mj_footer endRefreshingWithNoMoreData];
                
            }else if (array.count > 0 && array.count < self.pageLen) {
                
                for (int i = 0; i<array.count; i++) {
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    
                    dic = [array objectAtIndex:i];
                    
                    [self.friendArray addObject:dic];
                }
                
                [self.contentView reloadData];
                
                [self hideLoadHUD:YES];
                
                [self.contentView.mj_footer endRefreshingWithNoMoreData];
                
                
            }else {
                
                for (int i = 0; i<array.count; i++) {
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    
                    dic = [array objectAtIndex:i];
                    
                    [self.friendArray addObject:dic];
                }
                self.pageNumber++;
                
                [self.contentView reloadData];
                
                [self hideLoadHUD:YES];
                
                [self.contentView.mj_footer endRefreshing];
                
            }
            
        }
        
    } failure:^(NSError *error) {
        strongify(self);
        [self hideLoadHUD:YES];
        
        [self showMsg:@"加载好友失败"];
        
        [self.contentView.mj_footer endRefreshing];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_friendArray count]+1;
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
        
        cell.number.text = [_jsonDic objectForKey:@"total"];
        cell.numberTitle.text = @"间接好友数";
        cell.count.text = [_jsonDic objectForKey:@"integral"];
        
        
        return cell;
    }else {
        
        MineFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier3];
        if (cell == nil) {
            cell = [[MineFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier3];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.name.text = _friendArray[indexPath.section-1][@"nick_name"];
        cell.time.text = [NSString stringWithFormat:@"加入时间：%@", _friendArray[indexPath.section-1][@"register_time"]];
        
        cell.type.text = @"间接好友贡献";
        
        cell.coinCount.text = _friendArray[indexPath.section-1][@"integral"];
        
        
        
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
