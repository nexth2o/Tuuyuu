//
//  MineFriendViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/10.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "MineFriendViewController.h"
#import "MineFriendHeaderCell.h"
#import "MineFriendSubHeaderCell.h"
#import "MineFriendCell.h"
#import "MineFriendSubViewController.h"
#import "LoginViewController.h"

// 自定义的header
#import "MJChiBaoZiHeader.h"
#import "MJChiBaoZiFooter.h"
#import "MJChiBaoZiFooter2.h"
#import "MJDIYHeader.h"
#import "MJDIYAutoFooter.h"
#import "MJDIYBackFooter.h"

@interface MineFriendViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *contentView;
@property(nonatomic, strong) NSDictionary *jsonDic;
@property(nonatomic, strong) NSMutableArray *friendArray;
@property(nonatomic, strong) UIImageView *bg;
@property(nonatomic, assign) NSInteger pageNumber;
@property(nonatomic, assign) NSInteger pageLen;

@end

@implementation MineFriendViewController

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
        
        _contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        
        _contentView.delegate = self;
        
        _contentView.dataSource = self;
        
        //        contentView.separatorStyle = NO;
        
        _contentView.backgroundColor = [UIColor clearColor];
        
        // 上拉刷新
        _contentView.mj_footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        //去除底部多余分割线
        _contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self.view addSubview:_contentView];
        
        [self.view bringSubviewToFront:navigationBar];
        
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
        [self requestFriendslist];
    });
    
    
}

- (void)requestFriendslist {
    [_contentView setHidden:YES];
    [_bg setHidden:YES];
    
    [self showLoadHUDMsg:@"努力加载中..."];
    
    _pageNumber = 0;
    _pageLen = 20;
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"0", @"user_id", [NSString stringWithFormat:@"%ld", (long)_pageNumber], @"page", nil];
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
        
        NSLog(@"请求好友列表失败");
    }];
}

- (void)loadMoreData {
    [self showLoadHUDMsg:@"努力加载中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"0", @"user_id", [NSString stringWithFormat:@"%ld", (long)_pageNumber], @"page", nil];

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
        [self hideLoadHUD:YES];//TODO 需要回到主线程
        
        [self showMsg:@"加载好友失败"];
        
        [self.contentView.mj_footer endRefreshing];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_friendArray count]+2;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 250*SCALE;
    }else if (indexPath.section == 1) {
        return 50*SCALE;
    }else {
        return 50*SCALE;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellIdentifier1 = @"MyCellIdentifier1";
    static NSString *myCellIdentifier2 = @"MyCellIdentifier2";
    static NSString *myCellIdentifier3 = @"MyCellIdentifier3";
    
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        
        MineFriendHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier1];
        if (cell == nil) {
            cell = [[MineFriendHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier1];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //例如
        cell.name.text = [_jsonDic objectForKey:@"nick_name"];
        
        if ([[_jsonDic objectForKey:@"member_type"] isEqualToString:@"0"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_0"];
            cell.grade.text = @"注册会员";
        }else if ([[_jsonDic objectForKey:@"member_type"] isEqualToString:@"1"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_1"];
            cell.grade.text = @"铜牌会员";
        }else if ([[_jsonDic objectForKey:@"member_type"] isEqualToString:@"2"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_2"];
            cell.grade.text = @"银牌会员";
        }else if ([[_jsonDic objectForKey:@"member_type"] isEqualToString:@"3"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_3"];
            cell.grade.text = @"金牌会员";
        }else if ([[_jsonDic objectForKey:@"member_type"] isEqualToString:@"4"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_4"];
            cell.grade.text = @"钻石会员";
        }
        
        
        
        return cell;
    }else if (indexPath.section == 1) {
        
        MineFriendSubHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier2];
        if (cell == nil) {
            cell = [[MineFriendSubHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier2];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.number.text = [_jsonDic objectForKey:@"total"];
        cell.numberTitle.text = @"直接好友数";
        cell.count.text = [_jsonDic objectForKey:@"integral"];
        
        
        return cell;
    }else {
        
        MineFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier3];
        if (cell == nil) {
            cell = [[MineFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier3];
        }

    cell.name.text = _friendArray[indexPath.section-2][@"nick_name"];
        
        cell.time.text = [NSString stringWithFormat:@"加入时间：%@", _friendArray[indexPath.section-2][@"register_time"]];
        
        cell.type.text = @"直接好友贡献";
        
        cell.coinCount.text = _friendArray[indexPath.section-2][@"integral"];
        
        return cell;
    }
return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section > 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        MineFriendSubViewController *mineFriendSubViewController = [[MineFriendSubViewController alloc] init];
        [mineFriendSubViewController.orderDictionary setObject:_friendArray[indexPath.section-2][@"user_id"] forKey:@"user_id"];
       
        PUSH(mineFriendSubViewController);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 20*SCALE;
    }else if (section == 1) {
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
