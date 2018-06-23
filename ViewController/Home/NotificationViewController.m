//
//  NotificationViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/3.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationCell.h"

#import "LoginViewController.h"

@interface NotificationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *contentView;
@property(nonatomic, strong) NSMutableArray *noticeArray;

@end

@implementation NotificationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.backgroundColor = [UIColor whiteColor];
        
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_gray"] forState:UIControlStateNormal];
        navigationBar.titleLabel.text = @"消息中心";
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT+1, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT-1) style:UITableViewStylePlain];
        
        _contentView.delegate = self;
        
        _contentView.dataSource = self;
        
        //        contentView.separatorStyle = NO;
        
        _contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        //去除底部多余分割线
        _contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self.view addSubview:_contentView];
        
        if (@available(iOS 11.0, *)) {
            _contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
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
    
    [self showLoadHUDMsg:@"努力加载中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:[[UserDefaults service] getStoreId], @"cvs_no", nil];
    weakify(self);
    [HttpClientService requestNoticemsg:paramDic success:^(id responseObject) {
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            self.noticeArray = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"notice"]];
            
            [self.contentView reloadData];
            
            
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

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_noticeArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80*SCALE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellIdentifier1 = @"MyCellIdentifier1";
    
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier1];
    if (cell == nil) {
        cell = [[NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier1];
    }
    
    
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:_noticeArray[indexPath.row][@"icon"]]
                           placeholderImage:[UIImage imageNamed:@"loading_Image"]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      //TODO
                                  }];
    
    cell.title.text = _noticeArray[indexPath.row][@"title"];
    cell.subTitle.text = _noticeArray[indexPath.row][@"content"];
    cell.time.text = _noticeArray[indexPath.row][@"time"];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}

@end
