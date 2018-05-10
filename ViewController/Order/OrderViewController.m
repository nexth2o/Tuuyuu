//
//  OrderViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/5/8.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderSegmentView.h"
#import "OrderCell.h"
#import "OrderDetailViewController.h"
#import "OrderReturnViewController.h"
#import "OrderReturnDetailViewController.h"
#import "OrderScoreViewController.h"
#import "PaymentViewController.h"
#import "CategoryViewController.h"
#import "OrderHeaderView.h"
#import "OrderFooterView.h"
#import "LoginViewController.h"

// 自定义的header
#import "MJChiBaoZiHeader.h"
#import "MJChiBaoZiFooter.h"
#import "MJChiBaoZiFooter2.h"
#import "MJDIYHeader.h"
#import "MJDIYAutoFooter.h"
#import "MJDIYBackFooter.h"

#import "CartInfoDAL.h"
#import "CartInfoEntity.h"

static NSString *SectionViewID = @"XOSectionView";
static NSString *SectionViewID2 = @"XOSectionView2";

@interface OrderViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    OrderSegmentView *tabView;

}
@property (nonatomic, strong) UITableView *contentView;
@property (nonatomic, strong) NSMutableArray *orderArray;
@property (nonatomic, strong) NSString *type;
@property (nonatomic) NSUInteger pageNumber;

@end

@implementation OrderViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        navigationBar.titleLabel.text = @"订单";
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        NSArray *tabArray = [NSArray arrayWithObjects:@"全部订单", @"待评价", @"退款", nil];
        
        weakify(self);
        tabView = [[OrderSegmentView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT, SCREEN_WIDTH, 35*SCALE) titles:tabArray clickBlick:^void(NSInteger index) {
            
            strongify(self);
            [self.contentView.mj_footer resetNoMoreData];
            [self.contentView setHidden:NO];
            
            if (index==1) {
                self.type = @"0";//全部订单
                [self setEmptyViewTitle:@"您还没有订单"];
            }else if (index==2) {
                self.type = @"1";//待评价
                [self setEmptyViewTitle:@"没有待评价的订单"];
            }else if (index==3) {
                self.type = @"2";//退款
                [self setEmptyViewTitle:@"没有待退款的订单"];
            }
            
            [self reloadBtnEvent];
            
            
        }];
        [self.view addSubview:tabView];
        
        _contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tabView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT-BOTTOM_BAR_HEIGHT-35*SCALE) style:UITableViewStyleGrouped];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.separatorStyle = NO;
        _contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [_contentView registerClass:[OrderHeaderView class] forHeaderFooterViewReuseIdentifier:SectionViewID];
        [_contentView registerClass:[OrderFooterView class] forHeaderFooterViewReuseIdentifier:SectionViewID2];
        
        // 纯动画 无状态和时间
        MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        header.lastUpdatedTimeLabel.hidden = YES;
        _contentView.mj_header = header;
        _contentView.mj_header.automaticallyChangeAlpha = YES;
        _contentView.mj_footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        [self.view addSubview:_contentView];
        
        [self.view bringSubviewToFront:navigationBar];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        //初始化全部订单
        _type = @"0";
        [self setEmptyViewTitle:@"您还没有订单"];
        
        self.emptyView.reloadBlock = ^()
        {
            strongify(self);
            if ([[UserDefaults service] getLoginStatus] == YES) {
                
                [self reloadData];
            }else {
                [self loginEvent];
            }
            
        };
        
        [_contentView setHidden:YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnect) name:@"ssy" object:nil];

    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"reloadOrderListNotification" object:nil];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self reloadBtnEvent];
    });
}

- (void)reloadBtnEvent {
    
    if ([self networkStatus] == YES) {
        if ([[UserDefaults service] getLoginStatus] == YES) {
            
            [self reloadData];
        }else {
            [_contentView setHidden:YES];
            
            [self showEmptyViewWithStyle:EmptyViewStyleLogout];
        }
    }else {
        [self disconnect];
    }
}

- (void)disconnect {
    [_contentView setHidden:YES];
    [self showEmptyViewWithStyle:EmptyViewStyleNetworkUnreachable];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)loginEvent {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    PUSH(loginViewController);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_orderArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_orderArray[section][@"product"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40*SCALE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *orderCellIdentifier = @"OrderCellIdentifier";
    
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier];
    if (!cell) {
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.title.text = _orderArray[indexPath.section][@"product"][indexPath.row][@"description"];
    cell.subTitle.text = [NSString stringWithFormat:@"x%@件", _orderArray[indexPath.section][@"product"][indexPath.row][@"count"]];
    
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    float nTotal = [_orderArray[indexPath.section][@"product"][indexPath.row][@"sa_price"] floatValue]*[_orderArray[indexPath.section][@"product"][indexPath.row][@"count"] intValue];
    NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:nTotal]];
    cell.price.text = price;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 46*SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80*SCALE;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    OrderHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionViewID];
    
    if (headerView) {
        
        headerView.title.text = _orderArray[section][@"cvs_name"];
        
        headerView.section = section;
        
        //计算时间差
        NSDate *validDate = [NSDate dateWithTimeIntervalSince1970:[_orderArray[section][@"ltime"] integerValue]];
        NSTimeInterval secondInterval = [[NSDate date] timeIntervalSinceDate:validDate];
        NSTimeInterval minuteInterval = secondInterval/60;
        NSTimeInterval hourInterval = minuteInterval/60;
        NSTimeInterval dayInterval = hourInterval/24;
        
        if ([_orderArray[section][@"state"] isEqualToString:@"0"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"0"]) {
            headerView.status.text = @"等待支付";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"0"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"1"]) {
            headerView.status.text = @"订单已取消";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"2"] && [_orderArray[section][@"pay_type"] isEqualToString:@"1"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"0"]) {
            headerView.status.text = @"订单提交成功";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"2"] && ([_orderArray[section][@"pay_type"] isEqualToString:@"2"] || [_orderArray[section][@"pay_type"] isEqualToString:@"3"] || [_orderArray[section][@"pay_type"] isEqualToString:@"4"]) && [_orderArray[section][@"user_cancel"] isEqualToString:@"0"]) {
            headerView.status.text = @"线上支付成功";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"2"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"1"] && [_orderArray[section][@"pay_type"] isEqualToString:@"1"]) {
            headerView.status.text = @"订单已取消";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"2"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"1"] && ([_orderArray[section][@"pay_type"] isEqualToString:@"2"] || [_orderArray[section][@"pay_type"] isEqualToString:@"3"] || [_orderArray[section][@"pay_type"] isEqualToString:@"4"])) {
            headerView.status.text = @"订单已取消";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"3"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"0"] && minuteInterval < 1) {
            headerView.status.text = @"骑手已接单";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"3"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"0"] && minuteInterval >= 1 && minuteInterval < 30) {
            headerView.status.text = @"骑手已接单";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"3"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"0"] && minuteInterval >= 30) {
            headerView.status.text = @"骑手已接单";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"3"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"1"] && minuteInterval < 1) {
            headerView.status.text = @"等待受理";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"3"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"1"] && minuteInterval >= 1 && minuteInterval < 30) {
            headerView.status.text = @"等待受理";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"3"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"1"] && minuteInterval >= 30) {
            headerView.status.text = @"等待受理";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"3"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"2"] && minuteInterval < 1) {
            headerView.status.text = @"骑手已接单";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"3"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"2"] && minuteInterval >= 1 && minuteInterval < 30) {
            headerView.status.text = @"骑手已接单";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"3"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"2"] && minuteInterval >= 30) {
            headerView.status.text = @"骑手已接单";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"4"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"0"] && minuteInterval < 30) {
            headerView.status.text = @"配送中";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"4"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"0"] && minuteInterval >= 30) {
            headerView.status.text = @"配送中";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"4"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"1"] && minuteInterval < 30) {
            headerView.status.text = @"等待受理";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"4"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"1"] && minuteInterval >= 30) {
            headerView.status.text = @"等待受理";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"4"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"2"] && minuteInterval < 30) {
            headerView.status.text = @"配送中";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"4"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"2"] && minuteInterval >= 30) {
            headerView.status.text = @"配送中";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"0"] && [_orderArray[section][@"has_rate"] isEqualToString:@"0"] && dayInterval <= 7) {
            headerView.status.text = @"订单已完成";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"0"] && [_orderArray[section][@"has_rate"] isEqualToString:@"0"] && dayInterval > 7 && dayInterval <= 30) {
            headerView.status.text = @"订单已完成";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"0"] && [_orderArray[section][@"has_rate"] isEqualToString:@"0"] && dayInterval > 30) {
            headerView.status.text = @"订单已完成";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"0"] && [_orderArray[section][@"has_rate"] isEqualToString:@"1"] && dayInterval <= 7) {
            headerView.status.text = @"订单已完成";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"0"] && [_orderArray[section][@"has_rate"] isEqualToString:@"1"] && dayInterval > 7) {
            headerView.status.text = @"订单已完成";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"1"] && [_orderArray[section][@"return_state"] isEqualToString:@"0"]) {
            headerView.status.text = @"等待受理";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"1"] && [_orderArray[section][@"return_state"] isEqualToString:@"1"]) {
            headerView.status.text = @"商家审核中";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"1"] && [_orderArray[section][@"return_state"] isEqualToString:@"2"]) {
            headerView.status.text = @"退货待验收中";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"1"] && [_orderArray[section][@"return_state"] isEqualToString:@"3"]) {
            headerView.status.text = @"骑手已完成取货";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"1"] && [_orderArray[section][@"return_state"] isEqualToString:@"4"]) {
            headerView.status.text = @"退货成功";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"1"] && [_orderArray[section][@"return_state"] isEqualToString:@"5"]) {
            headerView.status.text = @"拒绝退货";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"6"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"1"] ) {
            headerView.status.text = @"订单已取消";
        }else if ([_orderArray[section][@"state"] isEqualToString:@"6"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"0"] ) {
            headerView.status.text = @"订单已取消";
        }else {
            headerView.status.text = @"";
        }
        
    }
    
    return headerView;
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    OrderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionViewID2];
    
    if (footerView) {
        
        footerView.title.text = [NSString stringWithFormat:@"共%@件商品", _orderArray[section][@"count"]];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        
        float nTotal = [_orderArray[section][@"price"] floatValue];
        NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:nTotal]];
        footerView.price.text = price;
        
        //计算时间差
        NSDate *validDate = [NSDate dateWithTimeIntervalSince1970:[_orderArray[section][@"ltime"] integerValue]];
        NSTimeInterval secondInterval = [[NSDate date] timeIntervalSinceDate:validDate];
        NSTimeInterval minuteInterval = secondInterval/60;
        NSTimeInterval hourInterval = minuteInterval/60;
        NSTimeInterval dayInterval = hourInterval/24;
        
        if ([_orderArray[section][@"state"] isEqualToString:@"0"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"0"]) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:NO];
            [footerView.cBtn setHidden:NO];
            [footerView.bBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"0"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"1"]) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:YES];
            [footerView.cBtn setHidden:NO];
            [footerView.cBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"2"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"0"] && [_orderArray[section][@"pay_type"] isEqualToString:@"1"]) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:YES];
            [footerView.cBtn setHidden:NO];
            [footerView.cBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"2"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"0"] && ([_orderArray[section][@"pay_type"] isEqualToString:@"2"] || [_orderArray[section][@"pay_type"] isEqualToString:@"3"] || [_orderArray[section][@"pay_type"] isEqualToString:@"4"])) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:YES];
            [footerView.cBtn setHidden:NO];
            [footerView.cBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"2"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"1"] && [_orderArray[section][@"pay_type"] isEqualToString:@"1"]) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:YES];
            [footerView.cBtn setHidden:NO];
            [footerView.cBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:NO];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"2"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"1"] && ([_orderArray[section][@"pay_type"] isEqualToString:@"2"] || [_orderArray[section][@"pay_type"] isEqualToString:@"3"] || [_orderArray[section][@"pay_type"] isEqualToString:@"4"])) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:YES];
            [footerView.cBtn setHidden:NO];
            [footerView.cBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:NO];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"3"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"0"] && minuteInterval < 1) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:NO];
            [footerView.cBtn setHidden:NO];
            [footerView.bBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"催单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:NO];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"3"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"0"] && minuteInterval >= 1 && minuteInterval < 30) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:NO];
            [footerView.cBtn setHidden:NO];
            [footerView.bBtn setTitle:@"申请退单" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"催单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:NO];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"3"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"0"] && minuteInterval >= 30) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:NO];
            [footerView.cBtn setHidden:NO];
            [footerView.bBtn setTitle:@"申请退单" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"催单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"3"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"1"] && minuteInterval < 1) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:NO];
            [footerView.cBtn setHidden:NO];
            [footerView.bBtn setTitle:@"申请退单" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"催单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:NO];
            [footerView.cBtn setEnabled:NO];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"3"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"1"] && minuteInterval >= 1 && minuteInterval < 30) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:NO];
            [footerView.cBtn setHidden:NO];
            [footerView.bBtn setTitle:@"申请退单" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"催单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:NO];
            [footerView.cBtn setEnabled:NO];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"3"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"1"] && minuteInterval >= 30) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:NO];
            [footerView.cBtn setHidden:NO];
            [footerView.bBtn setTitle:@"申请退单" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"催单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:NO];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"3"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"2"] && minuteInterval < 1) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:YES];
            [footerView.cBtn setHidden:NO];
            //            [footerView.bBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"催单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:NO];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"3"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"2"] && minuteInterval >= 1 && minuteInterval < 30) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:YES];
            [footerView.cBtn setHidden:NO];
            //            [footerView.bBtn setTitle:@"申请退单" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"催单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:NO];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"3"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"2"] && minuteInterval >= 30) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:YES];
            [footerView.cBtn setHidden:NO];
            //            [footerView.bBtn setTitle:@"申请退单" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"催单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"4"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"0"] && minuteInterval < 30) {
            [footerView.aBtn setHidden:NO];
            [footerView.bBtn setHidden:NO];
            [footerView.cBtn setHidden:NO];
            [footerView.aBtn setTitle:@"申请退单" forState:UIControlStateNormal];
            [footerView.bBtn setTitle:@"催单" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:NO];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"4"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"0"] && minuteInterval >= 30) {
            [footerView.aBtn setHidden:NO];
            [footerView.bBtn setHidden:NO];
            [footerView.cBtn setHidden:NO];
            [footerView.aBtn setTitle:@"申请退单" forState:UIControlStateNormal];
            [footerView.bBtn setTitle:@"催单" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"4"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"1"] && minuteInterval < 30) {
            [footerView.aBtn setHidden:NO];
            [footerView.bBtn setHidden:NO];
            [footerView.cBtn setHidden:NO];
            [footerView.aBtn setTitle:@"申请退单" forState:UIControlStateNormal];
            [footerView.bBtn setTitle:@"催单" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:NO];
            [footerView.bBtn setEnabled:NO];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"4"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"1"] && minuteInterval >= 30) {
            [footerView.aBtn setHidden:NO];
            [footerView.bBtn setHidden:NO];
            [footerView.cBtn setHidden:NO];
            [footerView.aBtn setTitle:@"申请退单" forState:UIControlStateNormal];
            [footerView.bBtn setTitle:@"催单" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:NO];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"4"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"2"] && minuteInterval < 30) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:NO];
            [footerView.cBtn setHidden:NO];
            [footerView.aBtn setTitle:@"申请退单" forState:UIControlStateNormal];
            [footerView.bBtn setTitle:@"催单" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:NO];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"4"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"2"] && minuteInterval >= 30) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:NO];
            [footerView.cBtn setHidden:NO];
            [footerView.aBtn setTitle:@"申请退单" forState:UIControlStateNormal];
            [footerView.bBtn setTitle:@"催单" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"0"] && [_orderArray[section][@"has_rate"] isEqualToString:@"0"] && dayInterval <= 7) {
            [footerView.aBtn setHidden:NO];
            [footerView.bBtn setHidden:NO];
            [footerView.cBtn setHidden:NO];
            [footerView.aBtn setTitle:@"申请退货" forState:UIControlStateNormal];
            [footerView.bBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"去评价" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"0"] && [_orderArray[section][@"has_rate"] isEqualToString:@"0"] && dayInterval > 7 && dayInterval <= 30) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:NO];
            [footerView.cBtn setHidden:NO];
            [footerView.bBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"去评价" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"0"] && [_orderArray[section][@"has_rate"] isEqualToString:@"0"] && dayInterval > 30) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:YES];
            [footerView.cBtn setHidden:NO];
            [footerView.cBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"0"] && [_orderArray[section][@"has_rate"] isEqualToString:@"1"] && dayInterval <= 7) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:NO];
            [footerView.cBtn setHidden:NO];
            [footerView.bBtn setTitle:@"申请退货" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"0"] && [_orderArray[section][@"has_rate"] isEqualToString:@"1"] && dayInterval > 7) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:YES];
            [footerView.cBtn setHidden:NO];
            [footerView.cBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"1"] && [_orderArray[section][@"return_state"] isEqualToString:@"0"]) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:NO];
            [footerView.cBtn setHidden:NO];
            [footerView.bBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"退款详情" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"1"] && [_orderArray[section][@"return_state"] isEqualToString:@"1"]) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:NO];
            [footerView.cBtn setHidden:NO];
            [footerView.bBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"退款详情" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"1"] && [_orderArray[section][@"return_state"] isEqualToString:@"2"]) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:NO];
            [footerView.cBtn setHidden:NO];
            [footerView.bBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"退款详情" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"1"] && [_orderArray[section][@"return_state"] isEqualToString:@"4"]) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:YES];
            [footerView.cBtn setHidden:NO];
            //            [footerView.bBtn setTitle:@"退款详情" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"1"] && [_orderArray[section][@"return_state"] isEqualToString:@"5"] && dayInterval <= 7) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:NO];
            [footerView.cBtn setHidden:NO];
            [footerView.bBtn setTitle:@"申请退货" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }else if ([_orderArray[section][@"state"] isEqualToString:@"5"] && [_orderArray[section][@"has_return"] isEqualToString:@"1"] && [_orderArray[section][@"return_state"] isEqualToString:@"5"] && dayInterval > 7) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:YES];
            [footerView.cBtn setHidden:NO];
            //            [footerView.bBtn setTitle:@"申请退货" forState:UIControlStateNormal];
            [footerView.cBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }
        else if ([_orderArray[section][@"state"] isEqualToString:@"6"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"0"] ) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:YES];
            [footerView.cBtn setHidden:NO];
            [footerView.cBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }
        
        
        else if ([_orderArray[section][@"state"] isEqualToString:@"6"] && [_orderArray[section][@"user_cancel"] isEqualToString:@"1"] ) {
            [footerView.aBtn setHidden:YES];
            [footerView.bBtn setHidden:YES];
            [footerView.cBtn setHidden:NO];
            [footerView.cBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [footerView.aBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.bBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.cBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [footerView.aBtn setEnabled:YES];
            [footerView.bBtn setEnabled:YES];
            [footerView.cBtn setEnabled:YES];
        }else {
            
        }
        
        weakify(self);
        weakify(footerView);
//        __weak __typeof(&*footerView)view =footerView;
        footerView.aBlock = ^() {
            strongify(self);
            strongify(footerView);
            if ([footerView.aBtn.titleLabel.text isEqualToString:@"申请退单"]) {
                
                UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:@"申请退单" message:@"商家已出品，出品后商家有权拒绝您的退单申请，建议您先电话联系兔悠协商处理。" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"申请退单" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                    [self ordercancel:self.orderArray[section][@"order_id"]];
                }];
                UIAlertAction *NOButton = [UIAlertAction actionWithTitle:@"联系商家" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                    NSString *telUrl = @"";
                    if ([[UserDefaults service] getStoreTel].length > 0 ) {
                        telUrl = @"tel://02431365487";
                    }else {
                        telUrl = [NSString stringWithFormat:@"tel://%@", [[UserDefaults service] getStoreTel]];
                    }
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
                }];
                [storeExistAlert addAction:OKButton];
                [storeExistAlert addAction:NOButton];
                [self presentViewController:storeExistAlert animated:YES completion:nil];
                
            }else if ([footerView.aBtn.titleLabel.text isEqualToString:@"申请退货"]) {
                //申请退货
                OrderReturnViewController *orderReturnViewController = [[OrderReturnViewController alloc] init];
                [orderReturnViewController.orderDictionary setObject:self.orderArray[section][@"order_id"] forKey:@"order_id"];
                PUSH(orderReturnViewController);
            }else {
                
            }
        };
        
        footerView.bBlock = ^() {
            strongify(self);
            strongify(footerView);
            if ([footerView.bBtn.titleLabel.text isEqualToString:@"取消订单"]) {
                
                UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:@"取消订单并退款" message:@"退款将原路退回到您的支付账户；详情请查看退款进度。" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"先等等" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                }];
                UIAlertAction *NOButton = [UIAlertAction actionWithTitle:@"取消订单" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                    [self ordercancel:self.orderArray[section][@"order_id"]];
                }];
                [storeExistAlert addAction:OKButton];
                [storeExistAlert addAction:NOButton];
                [self presentViewController:storeExistAlert animated:YES completion:nil];
                
            }else if ([footerView.bBtn.titleLabel.text isEqualToString:@"申请退单"]) {
                UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:@"申请退单" message:@"商家已出品，出品后商家有权拒绝您的退单申请，建议您先电话联系兔悠协商处理。" preferredStyle:(UIAlertControllerStyleAlert)];
                
                UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"申请退单" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                    [self ordercancel:self.orderArray[section][@"order_id"]];
                }];
                
                UIAlertAction *NOButton = [UIAlertAction actionWithTitle:@"联系商家" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                    
                    NSString *telUrl = @"";
                    if ([[UserDefaults service] getStoreTel].length > 0 ) {
                        telUrl = @"tel://02431365487";
                    }else {
                        telUrl = [NSString stringWithFormat:@"tel://%@", [[UserDefaults service] getStoreTel]];
                    }
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
                }];
                
                [storeExistAlert addAction:OKButton];
                
                [storeExistAlert addAction:NOButton];
                
                [self presentViewController:storeExistAlert animated:YES completion:nil];
            }else if ([footerView.bBtn.titleLabel.text isEqualToString:@"催单"]) {
                [self orderurge:self.orderArray[section][@"order_id"]];
            }else if ([footerView.bBtn.titleLabel.text isEqualToString:@"再来一单"]) {
                
                CartInfoDAL *dal = [[CartInfoDAL alloc] init];
                
                [dal cleanCartInfo];
                
                NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.orderArray[section][@"product"]];
                for ( int i =0; i<tempArray.count; i++) {
                    
                    [self updateDB:tempArray[i]];
                }
                CategoryViewController *categoryViewController = [[CategoryViewController alloc] init];
                [categoryViewController.orderDictionary setObject:@"1" forKey:@"isUp"];
                PUSH(categoryViewController);
                
            }else if ([footerView.bBtn.titleLabel.text isEqualToString:@"申请退货"]) {
                //申请退货
                OrderReturnViewController *orderReturnViewController = [[OrderReturnViewController alloc] init];
                [orderReturnViewController.orderDictionary setObject:self.orderArray[section][@"order_id"] forKey:@"order_id"];
                PUSH(orderReturnViewController);
            }else {
                
            }
        };
        
        
        footerView.cBlock = ^() {
            strongify(self);
            strongify(footerView);
            if ([footerView.cBtn.titleLabel.text isEqualToString:@"取消订单"]) {
                UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:@"取消订单并退款" message:@"退款将原路退回到您的支付账户；详情请查看退款进度。" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"先等等" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                }];
                UIAlertAction *NOButton = [UIAlertAction actionWithTitle:@"取消订单" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                    [self ordercancel:self.orderArray[section][@"order_id"]];
                }];
                [storeExistAlert addAction:OKButton];
                [storeExistAlert addAction:NOButton];
                [self presentViewController:storeExistAlert animated:YES completion:nil];
            }else if ([footerView.cBtn.titleLabel.text isEqualToString:@"立即支付"]) {
                PaymentViewController *paymentViewController = [[PaymentViewController alloc] init];
                [paymentViewController.orderDictionary setObject:self.orderArray[section][@"order_id"] forKey:@"order_id"];
                PUSH(paymentViewController);
            }else if ([footerView.cBtn.titleLabel.text isEqualToString:@"催单"]) {
                [self orderurge:self.orderArray[section][@"order_id"]];
            }else if ([footerView.cBtn.titleLabel.text isEqualToString:@"确认收货"]) {
                [self confirmreceipt:self.orderArray[section][@"order_id"]];
            }else if ([footerView.cBtn.titleLabel.text isEqualToString:@"去评价"]) {
                //去评价
                OrderScoreViewController *orderScoreViewController = [[OrderScoreViewController alloc] init];
                [orderScoreViewController.orderDictionary setObject:self.orderArray[section][@"order_id"] forKey:@"order_id"];
                PUSH(orderScoreViewController);
            }else if ([footerView.cBtn.titleLabel.text isEqualToString:@"再来一单"]) {
                
                CartInfoDAL *dal = [[CartInfoDAL alloc] init];
                
                [dal cleanCartInfo];
                
                NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.orderArray[section][@"product"]];
                for ( int i =0; i<tempArray.count; i++) {
                    
                    [self updateDB:tempArray[i]];
                }
                CategoryViewController *categoryViewController = [[CategoryViewController alloc] init];
                [categoryViewController.orderDictionary setObject:@"1" forKey:@"isUp"];
                PUSH(categoryViewController);
            }else if ([footerView.cBtn.titleLabel.text isEqualToString:@"退款详情"]) {
                //退款详情
                OrderReturnDetailViewController *orderReturnDetailViewController = [[OrderReturnDetailViewController alloc] init];
                [orderReturnDetailViewController.orderDictionary setObject:self.orderArray[section][@"order_id"] forKey:@"order_id"];
                PUSH(orderReturnDetailViewController);
            }else {
                
            }
        };
    }
    
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //计算时间差
    NSDate *validDate = [NSDate dateWithTimeIntervalSince1970:[_orderArray[indexPath.section][@"ltime"] integerValue]];
    NSTimeInterval secondInterval = [[NSDate date] timeIntervalSinceDate:validDate];
    NSTimeInterval minuteInterval = secondInterval/60;
    NSTimeInterval hourInterval = minuteInterval/60;
    NSTimeInterval dayInterval = hourInterval/24;
    
    
    if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"2"] && ([_orderArray[indexPath.section][@"pay_type"] isEqualToString:@"2"] || [_orderArray[indexPath.section][@"pay_type"] isEqualToString:@"3"] || [_orderArray[indexPath.section][@"pay_type"] isEqualToString:@"4"])) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"2"] && [_orderArray[indexPath.section][@"pay_type"] isEqualToString:@"1"]) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"0"]) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"3"] && [_orderArray[indexPath.section][@"user_cancel"] isEqualToString:@"0"] && minuteInterval < 1) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"3"] && [_orderArray[indexPath.section][@"user_cancel"] isEqualToString:@"0"] && minuteInterval >= 1 && minuteInterval < 30) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"3"] && [_orderArray[indexPath.section][@"user_cancel"] isEqualToString:@"0"] && minuteInterval >= 30) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"3"] && [_orderArray[indexPath.section][@"user_cancel"] isEqualToString:@"1"] && minuteInterval < 1) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"3"] && [_orderArray[indexPath.section][@"user_cancel"] isEqualToString:@"1"] && minuteInterval >= 1 && minuteInterval < 30) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"3"] && [_orderArray[indexPath.section][@"user_cancel"] isEqualToString:@"1"] && minuteInterval >= 30) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"3"] && [_orderArray[indexPath.section][@"user_cancel"] isEqualToString:@"2"] && minuteInterval < 1) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"3"] && [_orderArray[indexPath.section][@"user_cancel"] isEqualToString:@"2"] && minuteInterval >= 1 && minuteInterval < 30) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"3"] && [_orderArray[indexPath.section][@"user_cancel"] isEqualToString:@"2"] && minuteInterval >= 30) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"4"] && [_orderArray[indexPath.section][@"user_cancel"] isEqualToString:@"0"] && minuteInterval < 30) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"4"] && [_orderArray[indexPath.section][@"user_cancel"] isEqualToString:@"0"] && minuteInterval >= 30) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"4"] && [_orderArray[indexPath.section][@"user_cancel"] isEqualToString:@"1"] && minuteInterval < 30) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"4"]  && [_orderArray[indexPath.section][@"user_cancel"] isEqualToString:@"1"] && minuteInterval >= 30) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"4"] && [_orderArray[indexPath.section][@"user_cancel"] isEqualToString:@"2"] && minuteInterval < 30) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"4"]  && [_orderArray[indexPath.section][@"user_cancel"] isEqualToString:@"2"] && minuteInterval >= 30) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"5"] && [_orderArray[indexPath.section][@"has_return"] isEqualToString:@"0"] && [_orderArray[indexPath.section][@"has_rate"] isEqualToString:@"0"] && [_orderArray[indexPath.section][@"has_return"] isEqualToString:@"0"]) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"5"] && [_orderArray[indexPath.section][@"has_return"] isEqualToString:@"0"] && [_orderArray[indexPath.section][@"has_rate"] isEqualToString:@"0"] && dayInterval > 7 && dayInterval < 30) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"5"] && [_orderArray[indexPath.section][@"has_return"] isEqualToString:@"0"] && [_orderArray[indexPath.section][@"has_rate"] isEqualToString:@"0"] && dayInterval >= 30) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"5"] && [_orderArray[indexPath.section][@"has_return"] isEqualToString:@"0"] && [_orderArray[indexPath.section][@"has_rate"] isEqualToString:@"1"] && [_orderArray[indexPath.section][@"has_return"] isEqualToString:@"0"]) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"5"] && [_orderArray[indexPath.section][@"has_return"] isEqualToString:@"0"] && [_orderArray[indexPath.section][@"has_rate"] isEqualToString:@"1"] && dayInterval > 7 && dayInterval < 30) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"5"] && [_orderArray[indexPath.section][@"has_return"] isEqualToString:@"0"] && [_orderArray[indexPath.section][@"has_rate"] isEqualToString:@"1"] && dayInterval >= 30) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"6"] && [_orderArray[indexPath.section][@"user_cancel"] isEqualToString:@"1"] ) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"6"] && [_orderArray[indexPath.section][@"user_cancel"] isEqualToString:@"0"] ) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //订单详情
        OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
        [orderDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderDetailViewController);
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"5"] && [_orderArray[indexPath.section][@"has_return"] isEqualToString:@"1"] && [_orderArray[indexPath.section][@"return_state"] isEqualToString:@"0"]) {
        
        OrderReturnDetailViewController *orderReturnDetailViewController = [[OrderReturnDetailViewController alloc] init];
        [orderReturnDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderReturnDetailViewController);
        
        //        [footerView.bBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        //        [footerView.cBtn setTitle:@"退款详情" forState:UIControlStateNormal];
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"5"] && [_orderArray[indexPath.section][@"has_return"] isEqualToString:@"1"] && [_orderArray[indexPath.section][@"return_state"] isEqualToString:@"1"]) {
        
        OrderReturnDetailViewController *orderReturnDetailViewController = [[OrderReturnDetailViewController alloc] init];
        [orderReturnDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderReturnDetailViewController);
        
        //        [footerView.bBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        //        [footerView.cBtn setTitle:@"退款详情" forState:UIControlStateNormal];
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"5"] && [_orderArray[indexPath.section][@"has_return"] isEqualToString:@"1"] && [_orderArray[indexPath.section][@"return_state"] isEqualToString:@"2"]) {
        
        OrderReturnDetailViewController *orderReturnDetailViewController = [[OrderReturnDetailViewController alloc] init];
        [orderReturnDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderReturnDetailViewController);
        
        //        [footerView.bBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        //        [footerView.cBtn setTitle:@"退款详情" forState:UIControlStateNormal];
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"5"] && [_orderArray[indexPath.section][@"has_return"] isEqualToString:@"1"] && [_orderArray[indexPath.section][@"return_state"] isEqualToString:@"4"]) {
        
        OrderReturnDetailViewController *orderReturnDetailViewController = [[OrderReturnDetailViewController alloc] init];
        [orderReturnDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderReturnDetailViewController);
        
        //        [footerView.bBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        //        [footerView.cBtn setTitle:@"退款详情" forState:UIControlStateNormal];
        
    }else if ([_orderArray[indexPath.section][@"state"] isEqualToString:@"5"] && [_orderArray[indexPath.section][@"has_return"] isEqualToString:@"1"] && [_orderArray[indexPath.section][@"return_state"] isEqualToString:@"5"]) {
        
        OrderReturnDetailViewController *orderReturnDetailViewController = [[OrderReturnDetailViewController alloc] init];
        [orderReturnDetailViewController.orderDictionary setObject:_orderArray[indexPath.section][@"order_id"] forKey:@"order_id"];
        PUSH(orderReturnDetailViewController);
        
        //        [footerView.bBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        //        [footerView.cBtn setTitle:@"退款详情" forState:UIControlStateNormal];
        
    }else {
        
    }
    
}

- (void)reloadData {
    [self showLoadHUDMsg:@"努力加载中..."];
    [_contentView setHidden:YES];
    [self hideEmptyView];
    
    _pageNumber = 0;
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys: _type, @"type", [NSString stringWithFormat:@"%lu", (unsigned long)_pageNumber], @"page", nil];
    
    weakify(self);
    [HttpClientService requestOrderlist:paramDic success:^(id responseObject) {
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            self.orderArray = [[NSMutableArray alloc] initWithArray:[jsonDic objectForKey:@"orderlist"]];
            
            if (self.orderArray.count == 0) {
                [self hideLoadHUD:YES];
                [self.contentView setHidden:YES];
                [self showEmptyViewWithStyle:EmptyViewStyleNoResults];
            }else if (self.orderArray.count > 0 && self.orderArray.count < 20) {
                
                [self hideLoadHUD:YES];
                [self.contentView setHidden:NO];
                [self hideEmptyView];
                
                [self.contentView reloadData];
                [self.contentView setContentOffset:CGPointMake(0,0) animated:NO];
                [self.contentView.mj_footer endRefreshingWithNoMoreData];
                
            }else {
                
                [self hideLoadHUD:YES];
                [self.contentView setHidden:NO];
                [self hideEmptyView];
                
                [self.contentView reloadData];
                [self.contentView setContentOffset:CGPointMake(0,0) animated:NO];
                
                self.pageNumber++;
            }
            
        }else if (status == 202) {
            [self hideLoadHUD:YES];
            [self showMsg:@"您的登录状态失效，请重新登录"];
            
            sleep(1.0);
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
            
        }else {
            [self hideLoadHUD:YES];
            [self showMsg:[NSString stringWithFormat:@"错误码%i",status]];
            
        }
    } failure:^(NSError *error) {
        strongify(self);
        [self hideLoadHUD:YES];
        [self.contentView setHidden:YES];
        [self showEmptyViewWithStyle:EmptyViewStyleNetworkUnreachable];
        
    }];
}



#pragma mark 下拉刷新数据
- (void)loadNewData
{
    
    _pageNumber = 0;
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys: _type, @"type", [NSString stringWithFormat:@"%lu", (unsigned long)_pageNumber], @"page", nil];
    
    weakify(self);
    
    [HttpClientService requestOrderlist:paramDic success:^(id responseObject) {
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            self.orderArray = [[NSMutableArray alloc] initWithArray:[jsonDic objectForKey:@"orderlist"]];
            
            [self tableView:self.contentView endRefreshHeaderViewWithData:self.orderArray];
            
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
        [self.contentView.mj_header endRefreshing];
        
    }];
}

- (void)loadMoreData {
    weakify(self);
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys: _type, @"type", [NSString stringWithFormat:@"%lu", (unsigned long)_pageNumber], @"page", nil];
    
    //查询取餐列表
    [HttpClientService requestOrderlist:paramDic success:^(id responseObject) {
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"orderlist"]];
            
            [self tableView:self.contentView endRefreshFooterViewWithData:array];
            
            
            
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
        [self.contentView.mj_header endRefreshing];
        
    }];
}

- (void)tableView:(UITableView *)tableView endRefreshHeaderViewWithData:(NSArray *)array {
    
    if (array.count == 0) {
        [self hideLoadHUD:YES];
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshingWithNoMoreData];
    }else if (array.count > 0 && array.count < 20) {
        [tableView reloadData];
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshingWithNoMoreData];
        [self hideLoadHUD:YES];
        
    }else {
        [tableView reloadData];
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
        [self hideLoadHUD:YES];
        _pageNumber++;
    }
    
}

- (void)tableView:(UITableView *)tableView endRefreshFooterViewWithData:(NSArray *)array {
    
    if (array.count == 0) {
        
        [self hideLoadHUD:YES];
        
        [self showMsg:@"没有更多订单了"];
        
        [tableView.mj_footer endRefreshingWithNoMoreData];
        
    }else if (array.count > 0 && array.count < 20) {
        
        [_orderArray addObjectsFromArray:array];
        
        [tableView reloadData];
        
        [self hideLoadHUD:YES];
        
        [tableView.mj_footer endRefreshingWithNoMoreData];
        
    }else {
        
        [_orderArray addObjectsFromArray:array];
        
        _pageNumber++;
        
        [tableView reloadData];
        
        [self hideLoadHUD:YES];
        
        [tableView.mj_footer endRefreshing];
        
    }
}


//取消订单
- (void)ordercancel:(NSString *)orderId {
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:orderId, @"order_id", nil];
    
    //查询取餐列表
    [HttpClientService requestOrdercancel:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        NSLog(@"取消订单返回信息%@", [jsonDic objectForKey:@"msg"]);
        
        if (status == 0) {
            
            
            [self reloadBtnEvent];
            
            [self cancelSuccess];
            
        }else {
            [self showMsg:[NSString stringWithFormat:@"错误码%i", status]];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
        [self showMsg:@"处理失败"];
        
    }];
}
- (void)cancelSuccess{
    
    UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"取消订单成功" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
    }];
    
    [storeExistAlert addAction:OKButton];
    
    [self presentViewController:storeExistAlert animated:YES completion:nil];
}

//催单
- (void)orderurge:(NSString *)orderId {
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:orderId, @"order_id", nil];
    
    
    [HttpClientService requestOrderurge:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        NSLog(@"催单返回信息%@", [jsonDic objectForKey:@"msg"]);
        
        if (status == 0) {
            
            UIAlertController *hurryAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已催单成功，骑手将尽快为您送达商品。如有问题请联系骑手。" preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                
            }];
            
            [hurryAlert addAction:OKButton];
            
            [self presentViewController:hurryAlert animated:YES completion:nil];
            
            
            [self reloadBtnEvent];
        }else {
            [self showMsg:[NSString stringWithFormat:@"错误码%i", status]];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
        [self showMsg:@"处理失败"];
        
    }];
}

//确认收货
- (void)confirmreceipt:(NSString *)orderId {
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:orderId, @"order_id", nil];
    
    //查询取餐列表
    [HttpClientService requestConfirmreceipt:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        NSLog(@"取消订单返回信息%@", [jsonDic objectForKey:@"msg"]);
        
        if (status == 0) {
            
            [self showMsg:@"处理成功"];
            
            [self reloadBtnEvent];
        }else {
            [self showMsg:[NSString stringWithFormat:@"错误码%i", status]];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
        [self showMsg:@"处理失败"];
        
    }];
}

//更新DB
- (void)updateDB:(NSMutableDictionary *)dic {
    CartInfoDAL *dal = [[CartInfoDAL alloc] init];
    CartInfoEntity *entity = [[CartInfoEntity alloc] init];
    entity.product_no = [dic objectForKey:@"product_no"];
    entity.cvs_no = [[UserDefaults service] getStoreId];
    entity.orderCount = [dic objectForKey:@"count"];
    entity.descriptionn = [dic objectForKey:@"description"];
    entity.dis_price = [dic objectForKey:@"sa_price"];
    entity.gift_flag = @"0";
    [dal insertIntoTable:entity];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self hideLoadHUD:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadOrderListNotification" object:self];
}

@end
