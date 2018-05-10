//
//  ServiceCenterViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/10/11.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "ServiceCenterViewController.h"
#import "ServiceCenterCell.h"
#import "LoginViewController.h"
#import "CustomerServiceViewController.h"
#import "FAQViewController.h"
#import "FeedbackViewController.h"

@interface ServiceCenterViewController ()<UITableViewDelegate, UITableViewDataSource> {
    UITableView *contentView;
    NSMutableArray *titleArray;
}

@end

@implementation ServiceCenterViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.titleLabel.text = @"客服中心";
        [navigationBar.leftButton setHidden:NO];
        
        contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT) style:UITableViewStyleGrouped];
        
        contentView.delegate = self;
        
        contentView.dataSource = self;
        
        [self.view addSubview:contentView];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        titleArray = [[NSMutableArray alloc] initWithObjects:@"联系客服", @"常见问题", @"意见反馈", nil];
        
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
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
    
    ServiceCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
    
    if (!cell) {
        cell = [[ServiceCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row];

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        CustomerServiceViewController *customerServiceViewController = [[CustomerServiceViewController alloc] init];
        PUSH(customerServiceViewController);
    }else if (indexPath.row == 1) {
        
        FAQViewController *faqViewController = [[FAQViewController alloc] init];
        PUSH(faqViewController);
    }else if (indexPath.row == 2) {
        
        if ([[UserDefaults service] getLoginStatus] == YES) {
            FeedbackViewController *feedbackViewController = [[FeedbackViewController alloc] init];
            PUSH(feedbackViewController);
        }else {
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
        }
        
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
