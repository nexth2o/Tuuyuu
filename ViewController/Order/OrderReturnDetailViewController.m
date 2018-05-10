//
//  OrderReturnDetailViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/6.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "OrderReturnDetailViewController.h"
#import "OrderReturnDetailHeaderCell.h"
#import "OrderReturnDetailCell.h"
#import "LoginViewController.h"

@interface OrderReturnDetailViewController ()<UITableViewDelegate, UITableViewDataSource> {
    UITableView *contentView;
    NSInteger pageNumber;
    NSMutableDictionary *returnDetailDic;
}

@end

@implementation OrderReturnDetailViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.backgroundColor = [UIColor whiteColor];
        
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_gray"] forState:UIControlStateNormal];
        navigationBar.titleLabel.text = @"退款进度";
        
        
        //iOS7新增属性 TODO
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT) style:UITableViewStylePlain];
        
        contentView.delegate = self;
        
        contentView.dataSource = self;
        
        contentView.separatorStyle = NO;
        
        contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        //去除底部多余分割线
        contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        
        [self.view addSubview:contentView];
        
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
    
    [self showLoadHUDMsg:@"努力加载中..."];
    
    [self loadNewData];
}

- (void)loadNewData {
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_orderDictionary[@"order_id"], @"order_id", nil];
    
    [HttpClientService requestReturnstate:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            returnDetailDic = [[NSMutableDictionary alloc] initWithDictionary:jsonDic];
            
            [contentView reloadData];
            
            [self hideLoadHUD:YES];
        }else if (status == 202) {
            [self showMsg:@"您的登录状态失效，请重新登录"];
            [self hideLoadHUD:YES];
            sleep(1.0);
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
            
        }else if (status == 102) {
            [self hideLoadHUD:YES];
            [self showMsg:@"系统内部错误"];
            
        }else {
//            [self showMsg:@"服务器异常"];
            [self hideLoadHUD:YES];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
    
    }];
}

- (void)loadMoreData {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return [returnDetailDic[@"info"] count];//节点数组
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return (160+12)*SCALE;
    }else {
        return 100*SCALE;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellIdentifier1 = @"MyCellIdentifier1";
    static NSString *myCellIdentifier2 = @"MyCellIdentifier2";
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        OrderReturnDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier1];
        
        if (cell == nil) {
            cell = [[OrderReturnDetailHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //店铺
        cell.store.text = returnDetailDic[@"cvs_name"];
        
        //订单号码
        cell.order.text = returnDetailDic[@"order_id"];
        
        //价格
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        float nTotal = [returnDetailDic[@"money"] floatValue];
        NSString *priceStr = [formatter stringFromNumber:[NSNumber numberWithFloat:nTotal]];
        cell.price.text = priceStr;
        
        return cell;
    }else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            OrderReturnDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier2];
            
            if (cell == nil) {
                cell = [[OrderReturnDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier2];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.line.image = [UIImage imageNamed:@"order_status_header"];
            
            cell.returnTitle.text = returnDetailDic[@"info"][indexPath.row][@"state"];
            cell.returnTime.text = returnDetailDic[@"info"][indexPath.row][@"time"];
            cell.returnReason.text = returnDetailDic[@"info"][indexPath.row][@"description"];
            
            return cell;
        }
        
        if (indexPath.row == [returnDetailDic[@"info"] count] - 1) {
            OrderReturnDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier2];
            
            if (cell == nil) {
                cell = [[OrderReturnDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier2];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.line.image = [UIImage imageNamed:@"order_status_footer_gray"];
            
            cell.returnTitle.text = returnDetailDic[@"info"][indexPath.row][@"state"];
            cell.returnTime.text = returnDetailDic[@"info"][indexPath.row][@"time"];
            cell.returnReason.text = returnDetailDic[@"info"][indexPath.row][@"description"];
            
            return cell;
        }else {
            OrderReturnDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier2];
            
            if (cell == nil) {
                cell = [[OrderReturnDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier2];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.line.image = [UIImage imageNamed:@"order_status_middle_gray"];
            
            cell.returnTitle.text = returnDetailDic[@"info"][indexPath.row][@"state"];
            cell.returnTime.text = returnDetailDic[@"info"][indexPath.row][@"time"];
            cell.returnReason.text = returnDetailDic[@"info"][indexPath.row][@"description"];
            
            return cell;
            
        }
    }
    
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
