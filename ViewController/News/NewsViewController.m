//
//  NewsViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/6.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsCell.h"
#import "WebViewController.h"
#import "PlayerViewController.h"
#import "LoginViewController.h"

@interface NewsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *contentView;
@property (nonatomic, strong) NSMutableArray *newsArray;

@end

@implementation NewsViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.backgroundColor = [UIColor whiteColor];
        
        navigationBar.titleLabel.text = @"悠荐";
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT+1, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT-BOTTOM_BAR_HEIGHT-1) style:UITableViewStylePlain];
        
        _contentView.delegate = self;
        
        _contentView.dataSource = self;
        
        //        contentView.separatorStyle = NO;
        
        _contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        //去除底部多余分割线
        _contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self.view addSubview:_contentView];
        
//        __weak __typeof(&*self)weakSelf = self;
        weakify(self);
        self.emptyView.reloadBlock = ^()
        {
            strongify(self);
            [self reloadBtnEvent];
            
        };
        
        [_contentView setHidden:YES];
        
        if (@available(iOS 11.0, *)) {
            _contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnect) name:@"ssy" object:nil];

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
    
    if ([self networkStatus] == YES) {
        [self reloadBtnEvent];
    }else {
        [self disconnect];
    }
}

- (void)disconnect {
    [_contentView setHidden:YES];
    [self showEmptyViewWithStyle:EmptyViewStyleNetworkUnreachable];
}

- (void)reloadBtnEvent {
    [_contentView setHidden:YES];
    [self showLoadHUDMsg:@"努力加载中..."];
    
    weakify(self);
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:[[UserDefaults service] getStoreId], @"cvs_no", nil];
    
    [HttpClientService requestNewsmsg:paramDic success:^(id responseObject) {
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            [self.contentView setHidden:NO];
            
            [self hideEmptyView];
            
            self.newsArray = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"news"]];
            
            [self.contentView reloadData];
            
            
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
        strongify(self);
        [self hideLoadHUD:YES];
        [self.contentView setHidden:YES];
        [self showEmptyViewWithStyle:EmptyViewStyleNetworkUnreachable];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_newsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120*SCALE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellIdentifier1 = @"MyCellIdentifier1";
    
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier1];
    if (cell == nil) {
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier1];
    }
    
    
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:_newsArray[indexPath.row][@"pic"]]
                 placeholderImage:[UIImage imageNamed:@"loading_Image"]
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            //TODO
                        }];
    
    cell.title.text = _newsArray[indexPath.row][@"title"];
    cell.time.text = _newsArray[indexPath.row][@"time"];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([_newsArray[indexPath.row][@"type"] isEqualToString:@"1"]) {
        WebViewController *webViewController = [[WebViewController alloc] initWithNibName:nil bundle:nil];
        [webViewController.dictionary setObject:_newsArray[indexPath.row][@"url"] forKey:@"url"];
        [webViewController.dictionary setObject:_newsArray[indexPath.row][@"title"] forKey:@"title"];
        PUSH(webViewController);
    }else if ([_newsArray[indexPath.row][@"type"] isEqualToString:@"0"]) {
        PlayerViewController *playerViewController = [[PlayerViewController alloc] initWithNibName:nil bundle:nil];
        [self presentViewController:playerViewController animated:true completion:nil];
    }
}

#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self hideLoadHUD:YES];
}

@end
