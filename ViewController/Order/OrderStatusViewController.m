//
//  OrderStatusViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/31.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "OrderStatusViewController.h"
#import "OrderStatusTitleCell.h"
#import "OrderStatusCell.h"

@interface OrderStatusViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *contentView;
@property(nonatomic, strong) NSMutableArray *statusArray;

@end

#define CELLCOUNT 8

@implementation OrderStatusViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [navigationBar setHidden:YES];
        
        self.view.backgroundColor = [UIColor clearColor];
        
        _contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50*SCALE*CELLCOUNT, SCREEN_WIDTH, 50*SCALE*CELLCOUNT) style:UITableViewStylePlain];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        //        contentView.separatorStyle = NO;s
        _contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_contentView];
        
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
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_orderDictionary[@"order_id"], @"order_id", @"0", @"state", nil];
    
    //查询订单节点
    weakify(self);
    [HttpClientService requestLogisticsinfo:paramDic success:^(id responseObject) {
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            self.statusArray = [[NSMutableArray alloc] initWithArray:[jsonDic objectForKey:@"logistics_state"]];
            [self.contentView reloadData];
            [self hideLoadHUD:YES];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return CELLCOUNT;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50*SCALE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myCellIdentifier = @"MyCellIdentifier";
    static NSString *myCellIdentifier2 = @"MyCellIdentifier2";
    static NSString *myCellIdentifier3 = @"MyCellIdentifier3";
    
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        //订单跟踪
        OrderStatusTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
        
        if (!cell) {
            cell = [[OrderStatusTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier];
        }
        
        cell.title.text = @"订单跟踪";
        
        return cell;
        
    }else if (indexPath.row == 1) {
        OrderStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier3];
        
        if (cell == nil) {
            cell = [[OrderStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier3];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([_statusArray count] >= 1) {
            cell.statusIcon.image = [UIImage imageNamed:@"order_detail_status_header_gray"];
        }else {
            cell.statusIcon.image = [UIImage imageNamed:@""];
        }
        cell.info.text = _statusArray[0][@"description"];
        cell.time.text = _statusArray[0][@"time"];
        
        
        return cell;
    }else if (indexPath.row == 2) {
        OrderStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier3];
        
        if (cell == nil) {
            cell = [[OrderStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier3];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([_statusArray count] == 2) {
            cell.statusIcon.image = [UIImage imageNamed:@"order_detail_status_footer"];
            cell.info.text = _statusArray[1][@"description"];
            cell.time.text = _statusArray[1][@"time"];
        }else if ([_statusArray count] > 2) {
            cell.statusIcon.image = [UIImage imageNamed:@"order_detail_status_middle_gray"];
            cell.info.text = _statusArray[1][@"description"];
            cell.time.text = _statusArray[1][@"time"];
        }else {
            cell.statusIcon.image = [UIImage imageNamed:@""];
        }
        
        return cell;
    }else if (indexPath.row == 3) {
        OrderStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier3];
        
        if (cell == nil) {
            cell = [[OrderStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier3];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([_statusArray count] == 3) {
            cell.statusIcon.image = [UIImage imageNamed:@"order_detail_status_footer"];
            cell.info.text = _statusArray[2][@"description"];
            cell.time.text = _statusArray[2][@"time"];
        }else if ([_statusArray count] > 3) {
            cell.statusIcon.image = [UIImage imageNamed:@"order_detail_status_middle_gray"];
            cell.info.text = _statusArray[2][@"description"];
            cell.time.text = _statusArray[2][@"time"];
        }else {
            cell.statusIcon.image = [UIImage imageNamed:@""];
        }
        
        return cell;
    }else if (indexPath.row == 4) {
        OrderStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier3];
        
        if (cell == nil) {
            cell = [[OrderStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier3];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([_statusArray count] == 4) {
            cell.statusIcon.image = [UIImage imageNamed:@"order_detail_status_footer"];
            cell.info.text = _statusArray[3][@"description"];
            cell.time.text = _statusArray[3][@"time"];
        }else if ([_statusArray count] > 4) {
            cell.statusIcon.image = [UIImage imageNamed:@"order_detail_status_middle_gray"];
            cell.info.text = _statusArray[3][@"description"];
            cell.time.text = _statusArray[3][@"time"];
        }else {
            cell.statusIcon.image = [UIImage imageNamed:@""];
        }
        
        return cell;
    }else if (indexPath.row == 5) {
        OrderStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier3];
        
        if (cell == nil) {
            cell = [[OrderStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier3];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([_statusArray count] == 5) {
            cell.statusIcon.image = [UIImage imageNamed:@"order_detail_status_footer"];
            cell.info.text = _statusArray[4][@"description"];
            cell.time.text = _statusArray[4][@"time"];
        }else if ([_statusArray count] > 5) {
            cell.statusIcon.image = [UIImage imageNamed:@"order_detail_status_middle_gray"];
            cell.info.text = _statusArray[4][@"description"];
            cell.time.text = _statusArray[4][@"time"];
        }else {
            cell.statusIcon.image = [UIImage imageNamed:@""];
        }
        
        return cell;
    }else if (indexPath.row == 6) {
        OrderStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier3];
        
        if (cell == nil) {
            cell = [[OrderStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier3];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([_statusArray count] == 6) {
            cell.statusIcon.image = [UIImage imageNamed:@"order_detail_status_footer"];
            cell.info.text = _statusArray[5][@"description"];
            cell.time.text = _statusArray[5][@"time"];
        }else if ([_statusArray count] > 6) {
            cell.statusIcon.image = [UIImage imageNamed:@"order_detail_status_middle_gray"];
            cell.info.text = _statusArray[5][@"description"];
            cell.time.text = _statusArray[5][@"time"];
        }else {
            cell.statusIcon.image = [UIImage imageNamed:@""];
        }
        
        return cell;
    }else if (indexPath.row == 7) {
        //关闭
        OrderStatusTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier2];
        
        if (!cell) {
            cell = [[OrderStatusTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier2];
        }
        
        cell.title.text = @"关闭";
        cell.title.backgroundColor = ICON_COLOR;
        
        return cell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 7) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"closeOrderStatus" object:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
