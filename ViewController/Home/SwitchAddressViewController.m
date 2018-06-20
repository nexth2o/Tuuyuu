//
//  SwitchAddressViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/8/4.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SwitchAddressViewController.h"
#import "MineAddressCell.h"
#import "EditAddressViewController.h"
#import "LoginViewController.h"
#import <MapKit/MapKit.h>


//@interface SwitchAddressViewController ()<UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate> {
@interface SwitchAddressViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *contentView;
@property(nonatomic, strong) NSMutableArray *addressArray;

@end

@implementation SwitchAddressViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.backgroundColor = [UIColor whiteColor];
        
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_gray"] forState:UIControlStateNormal];
        [navigationBar.editButton setTitle:@"新增地址" forState:UIControlStateNormal];
        [navigationBar.editButton setHidden:NO];
        navigationBar.titleLabel.text = @"收货地址";
        
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
    [self new];
}

- (void)new {
    NSDictionary *paramDic = [[NSDictionary alloc] init];
    weakify(self);
    [HttpClientService requestAddress:paramDic success:^(id responseObject) {
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            self.addressArray = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"address"]];
            
            if ([self.addressArray count] > 0) {
                
                [self.contentView setHidden:NO];

                [self hideEmptyView];

                [self.contentView reloadData];
                
            }else {
                [self.contentView setHidden:YES];
                
                [self showEmptyViewWithStyle:EmptyViewStyleNoAddress];
                [self setEmptyViewTitle:@"暂时没有您的送货地址信息"];
            }
            
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
    return [_addressArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60*SCALE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellIdentifier1 = @"MyCellIdentifier1";
    
    MineAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier1];
    if (cell == nil) {
        cell = [[MineAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier1];
    }
    //                cell.store.text = addressArray[indexPath.row][@"cvs_name"];
    
    cell.name.text = _addressArray[indexPath.row][@"name"];
    
    NSString *str = @"";
    if ([_addressArray[indexPath.row][@"flag"] isEqualToString:@"0"]) {
        str = @" 女士";
    }else {
        str = @" 先生";
    }
    
    cell.gender.text = str;
    
    cell.phone.text = _addressArray[indexPath.row][@"tel_no"];
    cell.address.text = [NSString stringWithFormat:@"%@%@", _addressArray[indexPath.row][@"address"], _addressArray[indexPath.row][@"building"]];
    
    CLLocation *orig = [[CLLocation alloc] initWithLatitude:[[[UserDefaults service] getStoreLatitude] doubleValue] longitude:[[[UserDefaults service] getStoreLongitude] doubleValue]];
    CLLocation *dist = [[CLLocation alloc] initWithLatitude:[_addressArray[indexPath.row][@"latitude"] doubleValue] longitude:[_addressArray[indexPath.row][@"longitude"] doubleValue]];
    CLLocationDistance meters = [orig distanceFromLocation:dist];
//    NSLog(@"distance is %f.", meters);
    
    if (meters > 2000) {
        [cell.outImage setHidden:NO];
    }else {
        [cell.outImage setHidden:YES];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CLLocation *orig = [[CLLocation alloc] initWithLatitude:[[[UserDefaults service] getStoreLatitude] doubleValue] longitude:[[[UserDefaults service] getStoreLongitude] doubleValue]];
    CLLocation *dist = [[CLLocation alloc] initWithLatitude:[_addressArray[indexPath.row][@"latitude"] doubleValue] longitude:[_addressArray[indexPath.row][@"longitude"] doubleValue]];
    CLLocationDistance meters = [orig distanceFromLocation:dist];
//    NSLog(@"distance is %f.", meters);
    
    if (meters > 2000) {
        [self showMsg:@"抱歉，该地址不在配送范围内。"];
        
        return;
    }

    [[UserDefaults service] updateName:_addressArray[indexPath.row][@"name"]];
    [[UserDefaults service] updateAddressGender:_addressArray[indexPath.row][@"flag"]];
    [[UserDefaults service] updateAddressPhone:_addressArray[indexPath.row][@"tel_no"]];
    [[UserDefaults service] updateAddress:_addressArray[indexPath.row][@"address"]];
    [[UserDefaults service] updateBuilding:_addressArray[indexPath.row][@"building"]];
    [[UserDefaults service] updateAddressLatitude:_addressArray[indexPath.row][@"latitude"]];
    [[UserDefaults service] updateAddressLongitude:_addressArray[indexPath.row][@"longitude"]];

    
    POP;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_addressArray[indexPath.row][@"address_id"], @"address_id", nil];
    // 删除模型
    [_addressArray removeObjectAtIndex:indexPath.row];
    // 刷新
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [HttpClientService requestAddressdelete:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            [self showMsg:@"删除成功"];
            [self new];
        }
        
    } failure:^(NSError *error) {
        [self showMsg:@"删除失败"];
    }];
}

//修改Delete按钮文字为删除
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}
- (void)editBtnClick:(id)sender {
   
    EditAddressViewController *editAddressViewController = [[EditAddressViewController alloc] init];
    PUSH(editAddressViewController);
    
}


@end
