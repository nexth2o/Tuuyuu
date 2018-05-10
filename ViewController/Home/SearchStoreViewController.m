//
//  SearchStoreViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/22.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SearchStoreViewController.h"
#import "EditAddressViewController.h"
#import "HomeViewController.h"
#import "MineAddressCell.h"
#import "SearchStoreLocationCell.h"
#import "SearchStoreCell.h"
#import "SearchAddressCell.h"
#import "LoginViewController.h"
#import "CartInfoDAL.h"
//#import <CoreLocation/CoreLocation.h>
#import <AMapLocationKit/AMapLocationKit.h>


@interface SearchStoreViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, AMapLocationManagerDelegate> {
    
    UITapGestureRecognizer *tap;
    CLGeocoder *geocoder;
}

@property (nonatomic, strong) UITableView *contentView;
@property (nonatomic, strong) UITableView *placemarksView;
@property (nonatomic, strong) NSMutableArray *storeArray;
@property (nonatomic, strong) NSMutableArray *addressArray;
@property (nonatomic, strong) NSMutableArray *placemarksArray;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

@implementation SearchStoreViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.backgroundColor = [UIColor whiteColor];
        
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_gray"] forState:UIControlStateNormal];
        [navigationBar.editButton setTitle:@"新增地址" forState:UIControlStateNormal];
        [navigationBar.editButton setHidden:NO];
        
        UIImageView *searchBg = [[UIImageView alloc] initWithFrame:CGRectMake(NAV_BAR_HEIGHT+10*SCALE, STATUS_BAR_HEIGHT, SCREEN_WIDTH - (44.0f*3+20.0f)*SCALE, NAV_BAR_HEIGHT)];
        searchBg.image = [UIImage imageNamed:@"location_search_gray"];
        [navigationBar addSubview:searchBg];
        
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(NAV_BAR_HEIGHT+40*SCALE, STATUS_BAR_HEIGHT, SCREEN_WIDTH - (44.0f*3+20.0f)*SCALE-30*SCALE, NAV_BAR_HEIGHT)];
        _searchTextField.delegate = self;
        _searchTextField.returnKeyType = UIReturnKeyDone;
        [navigationBar addSubview:_searchTextField];
        
        //iOS7新增属性 TODO
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        _contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT) style:UITableViewStylePlain];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        //去除底部多余分割线
        _contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self.view addSubview:_contentView];
        
        //地址列表
        _placemarksView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT) style:UITableViewStylePlain];
        _placemarksView.delegate = self;
        _placemarksView.dataSource = self;
        //        placemarksView.separatorStyle = NO;
        _placemarksView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        //去除底部多余分割线
        _placemarksView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self.view addSubview:_placemarksView];
        [_placemarksView setHidden:YES];
        
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroundClick)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:_searchTextField];
        geocoder = [[CLGeocoder alloc] init];
        
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        _address = @"点击定位当前位置";
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
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:[[UserDefaults service] getLatitude], @"latitude", [[UserDefaults service] getLongitude], @"longitude", nil];
    
    weakify(self);
    [HttpClientService requestStoreaddress:paramDic success:^(id responseObject) {
        
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            [self hideLoadHUD:YES];
            
            self.addressArray = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"address"]];
            
            self.storeArray = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"storelist"]];
            
            [self.contentView reloadData];
            
            [self.placemarksView setHidden:YES];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _placemarksView) {
        return 1;
    }else {
        return 3;
    }
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _placemarksView) {
        return _placemarksArray.count;
    }else {
        if (section == 0) {
            return 1;
        }else if (section == 1) {
            return [_addressArray count];
        }else {
            return [_storeArray count];
        }
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _contentView) {
        if (indexPath.section == 1) {
            return 60*SCALE;
        }else {
            return 44*SCALE;
        }
    }else {
        return 50*SCALE;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier1 = @"CellIdentifier1";
    static NSString *cellIdentifier2 = @"CellIdentifier2";
    static NSString *cellIdentifier3 = @"CellIdentifier3";
    static NSString *cellIdentifier4 = @"CellIdentifier4";
    
    UITableViewCell *cell = nil;
    
    if (tableView == _contentView) {
        
        if (indexPath.section == 0) {
            
            SearchStoreLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell == nil) {
                cell = [[SearchStoreLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
            }
            cell.title.text = _address;
            
            return cell;
        }else if (indexPath.section == 1) {
            MineAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
            if (cell == nil) {
                cell = [[MineAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
            }
            
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
            //            cell.store.text = storeArray[indexPath.row][@"cvs_name"];
            
            return cell;
        }else if (indexPath.section == 2) {
            SearchStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
            if (cell == nil) {
                cell = [[SearchStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
            }
            cell.store.text = _storeArray[indexPath.row][@"cvs_name"];
            cell.distance.text = [NSString stringWithFormat:@"距您%@km", _storeArray[indexPath.row][@"distance"]];
            
            
            return cell;
        }
    }else if (tableView == _placemarksView) {
        
        SearchAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier4];
        if (cell == nil) {
            cell = [[SearchAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier4];
        }
        
        cell.address.text = [NSString stringWithFormat:@"%@", [_placemarksArray objectAtIndex:indexPath.row][@"name"]];
        
        cell.detailAddress.text = [NSString stringWithFormat:@"%@", [_placemarksArray objectAtIndex:indexPath.row][@"address"]];
        
        
        return cell;
    }else {
        return cell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView == _contentView) {
        if (section == 0) {
            return 20*SCALE;
        }else if (section == 1 && _addressArray.count > 0) {
            return 40*SCALE;
        }else if (section == 2 && _storeArray.count > 0) {
            return 40*SCALE;
        }else {
            return 0;
        }
    }else {
        return 0;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (tableView == _placemarksView) {
        //调用服务器接口 传经纬度 等结果
        NSString *placemark = [_placemarksArray objectAtIndex:indexPath.row][@"location"];
        NSArray *aArray = [placemark componentsSeparatedByString:@","];
        
        NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:aArray[1], @"latitude", aArray[0], @"longitude", nil];
        
        weakify(self);
        [HttpClientService requestStoreaddress:paramDic success:^(id responseObject) {
            strongify(self);
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            int status = [[jsonDic objectForKey:@"status"] intValue];
            
            if (status == 0) {
                //如果有推荐店铺迁移至首页
                int recommended = [[jsonDic objectForKey:@"rec_flag"] intValue];
                if (recommended == 1) {
                    [[UserDefaults service] updateStoreId:[jsonDic objectForKey:@"rec_cvs_no"]];
                    [[UserDefaults service] updateStoreName:[jsonDic objectForKey:@"rec_cvs_name"]];
                    [[UserDefaults service] updateStoreLatitude:[jsonDic objectForKey:@"rec_latitude"]];
                    [[UserDefaults service] updateStoreLongitude:[jsonDic objectForKey:@"rec_longitude"]];
                    
                    POP;
                }else {
                    self.addressArray = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"address"]];
                    self.storeArray = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"storelist"]];
                    [self.contentView reloadData];
                    [self.placemarksView setHidden:YES];
                    [self outSide2:self.storeArray];
                }
            }
            
        } failure:^(NSError *error) {
            strongify(self);
            [self.placemarksView setHidden:YES];
            [self hideLoadHUD:YES];
            
        }];
        
        
        
    }else {
        
        if (indexPath.section == 0) {
            
            [_locationManager startUpdatingLocation];
            
            //点击定位 取得经纬度 调用上面接口
            NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:[[UserDefaults service] getLatitude], @"latitude", [[UserDefaults service] getLongitude], @"longitude", nil];
            weakify(self);
            [HttpClientService requestStoreaddress:paramDic success:^(id responseObject) {
                strongify(self);
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                int status = [[jsonDic objectForKey:@"status"] intValue];
                
                if (status == 0) {
                    
                    //如果有推荐店铺迁移至首页
                    int recommended = [[jsonDic objectForKey:@"rec_flag"] intValue];
                    if (recommended == 1) {
                        
                        [[UserDefaults service] updateStoreId:[jsonDic objectForKey:@"rec_cvs_no"]];
                        [[UserDefaults service] updateStoreName:[jsonDic objectForKey:@"rec_cvs_name"]];
                        [[UserDefaults service] updateStoreLatitude:[jsonDic objectForKey:@"rec_latitude"]];
                        [[UserDefaults service] updateStoreLongitude:[jsonDic objectForKey:@"rec_longitude"]];
                        
                        POP;
                    }else {
                
                        self.addressArray = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"address"]];
                        self.storeArray = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"storelist"]];
                        
                        [self.contentView reloadData];
                        
                        [self.placemarksView setHidden:YES];
                        
                        [self outSide:self.storeArray];
                    }
                }
                
            } failure:^(NSError *error) {
                strongify(self);
                [self.placemarksView setHidden:YES];
                [self hideLoadHUD:YES];
            }];
            
            
            
        }else if (indexPath.section == 1) {
            
            //点击地址 传经纬度
            NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_addressArray[indexPath.row][@"latitude"], @"latitude", _addressArray[indexPath.row][@"longitude"], @"longitude", nil];
            weakify(self);
            [HttpClientService requestStoreaddress:paramDic success:^(id responseObject) {
                strongify(self);
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                int status = [[jsonDic objectForKey:@"status"] intValue];
                
                if (status == 0) {
                    
                    //如果有推荐店铺迁移至首页
                    int recommended = [[jsonDic objectForKey:@"rec_flag"] intValue];
                    if (recommended == 1) {
                        [[UserDefaults service] updateStoreId:[jsonDic objectForKey:@"rec_cvs_no"]];
                        [[UserDefaults service] updateStoreName:[jsonDic objectForKey:@"rec_cvs_name"]];
                        [[UserDefaults service] updateStoreLatitude:[jsonDic objectForKey:@"rec_latitude"]];
                        [[UserDefaults service] updateStoreLongitude:[jsonDic objectForKey:@"rec_longitude"]];
                        POP;
                    }else {
                        self.addressArray = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"address"]];
                        self.storeArray = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"storelist"]];
                        [self.contentView reloadData];
                        
                        [self.placemarksView setHidden:YES];
                        
                        [self outSideAddress:self.storeArray];
                    }
                }
                
            } failure:^(NSError *error) {
                strongify(self);
                [self.placemarksView setHidden:YES];
                [self hideLoadHUD:YES];
            }];
        }else if (indexPath.section == 2) {

            if ( [[_storeArray objectAtIndex:indexPath.row][@"distance"] floatValue] > [[_storeArray objectAtIndex:indexPath.row][@"service_distance"] floatValue]) {
                //点击附近店铺 迁移至首页
                //超过配送公里数提示
                UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您选择的店铺不在配送范围内，是否切换店铺？" preferredStyle:(UIAlertControllerStyleAlert)];
                
                weakify(self);
                UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"是" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                    strongify(self);
                    [[UserDefaults service] updateStoreId:[self.storeArray objectAtIndex:indexPath.row][@"cvs_no"]];
                    [[UserDefaults service] updateStoreName:[self.storeArray objectAtIndex:indexPath.row][@"cvs_name"]];
                    [[UserDefaults service] updateStoreTel:[self.storeArray objectAtIndex:indexPath.row][@"store_tel"]];
                    [[UserDefaults service] updateStoreLatitude:[self.storeArray objectAtIndex:indexPath.row][@"latitude"]];
                    [[UserDefaults service] updateStoreLongitude:[self.storeArray objectAtIndex:indexPath.row][@"longitude"]];
                    
                    POP;
                }];
                
                UIAlertAction *NOButton = [UIAlertAction actionWithTitle:@"否" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                    
                }];
                
                [storeExistAlert addAction:NOButton];
                
                [storeExistAlert addAction:OKButton];
                
                [self presentViewController:storeExistAlert animated:YES completion:nil];
                
            }else {
                
                [[UserDefaults service] updateStoreId:[_storeArray objectAtIndex:indexPath.row][@"cvs_no"]];
                [[UserDefaults service] updateStoreName:[_storeArray objectAtIndex:indexPath.row][@"cvs_name"]];
                [[UserDefaults service] updateStoreTel:[_storeArray objectAtIndex:indexPath.row][@"store_tel"]];
                [[UserDefaults service] updateStoreLatitude:[_storeArray objectAtIndex:indexPath.row][@"latitude"]];
                [[UserDefaults service] updateStoreLongitude:[_storeArray objectAtIndex:indexPath.row][@"longitude"]];
                
                POP;
            }
        }
    }
}

- (void)outSide:(NSArray *)array {
    
    UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:[array objectAtIndex:0][@"cvs_name"] message:@"您定位的地址不在配送范围内，是否浏览该店铺？" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"是" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        [[UserDefaults service] updateStoreId:[array objectAtIndex:0][@"cvs_no"]];
        [[UserDefaults service] updateStoreName:[array objectAtIndex:0][@"cvs_name"]];
        [[UserDefaults service] updateStoreTel:[array objectAtIndex:0][@"store_tel"]];
        [[UserDefaults service] updateStoreLatitude:[array objectAtIndex:0][@"latitude"]];
        [[UserDefaults service] updateStoreLongitude:[array objectAtIndex:0][@"longitude"]];
        
        POP;
        
    }];
    
    UIAlertAction *NOButton = [UIAlertAction actionWithTitle:@"重新定位" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
    }];
    
    [storeExistAlert addAction:OKButton];
    
    [storeExistAlert addAction:NOButton];
    
    [self presentViewController:storeExistAlert animated:YES completion:nil];
}

- (void)outSide2:(NSArray *)array {

    UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:[array objectAtIndex:0][@"cvs_name"] message:@"您搜索的地址不在配送范围内，是否浏览该店铺？" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"是" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        [[UserDefaults service] updateStoreId:[array objectAtIndex:0][@"cvs_no"]];
        [[UserDefaults service] updateStoreName:[array objectAtIndex:0][@"cvs_name"]];
        [[UserDefaults service] updateStoreTel:[array objectAtIndex:0][@"store_tel"]];
        [[UserDefaults service] updateStoreLatitude:[array objectAtIndex:0][@"latitude"]];
        [[UserDefaults service] updateStoreLongitude:[array objectAtIndex:0][@"longitude"]];
        
        POP;
        
    }];
    
    UIAlertAction *NOButton = [UIAlertAction actionWithTitle:@"否" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
    }];
    
    [storeExistAlert addAction:OKButton];
    
    [storeExistAlert addAction:NOButton];
    
    [self presentViewController:storeExistAlert animated:YES completion:nil];
}

- (void)outSideAddress:(NSArray *)array  {
    
    UIAlertController *storeExistAlert = [UIAlertController alertControllerWithTitle:[array objectAtIndex:0][@"cvs_name"] message:@"您的收货地址不在配送范围内，是否浏览该店铺？" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *OKButton = [UIAlertAction actionWithTitle:@"是" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        [[UserDefaults service] updateStoreId:[array objectAtIndex:0][@"cvs_no"]];
        [[UserDefaults service] updateStoreName:[array objectAtIndex:0][@"cvs_name"]];
        [[UserDefaults service] updateStoreTel:[array objectAtIndex:0][@"store_tel"]];
        [[UserDefaults service] updateStoreLatitude:[array objectAtIndex:0][@"latitude"]];
        [[UserDefaults service] updateStoreLongitude:[array objectAtIndex:0][@"longitude"]];
        
        POP;
        
    }];
    
    UIAlertAction *NOButton = [UIAlertAction actionWithTitle:@"换个地址" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
    }];
    
    [storeExistAlert addAction:OKButton];
    
    [storeExistAlert addAction:NOButton];
    
    [self presentViewController:storeExistAlert animated:YES completion:nil];
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = nil;
    if (tableView == _contentView) {
        
        if (section == 0) {
            headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20*SCALE)];
            return headerView;
        }else if (section == 1) {
            
            if (_addressArray.count > 0) {
                headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40*SCALE)];
                UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, 12*SCALE, 16*SCALE, 16*SCALE)];
                icon.image = [UIImage imageNamed:@"location_icon"];
                [headerView addSubview:icon];
                
                UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+10*SCALE, 0*SCALE, 100*SCALE, 40*SCALE)];
                title.font = [UIFont systemFontOfSize:14*SCALE];
                title.text = @"收货地址";
                [headerView addSubview:title];
                return headerView;
            }
        }else if (section == 2) {
            
            if (_storeArray.count > 0) {
                headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40*SCALE)];
                UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, 12*SCALE, 16*SCALE, 16*SCALE)];
                icon.image = [UIImage imageNamed:@"location_icon"];
                [headerView addSubview:icon];
                
                UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+10*SCALE, 0*SCALE, 100*SCALE, 40*SCALE)];
                title.font = [UIFont systemFontOfSize:14*SCALE];
                title.text = @"附近店铺";
                [headerView addSubview:title];
                return headerView;
            }
        }
    }
    
    return headerView;
}

#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:tap];
}

- (void)textFieldTextDidChange {
    //    NSLog(@"监听输入变化输入的是:%@", searchTextField.text);
    UITextRange *selectedRange = [_searchTextField markedTextRange];
    NSString * newText = [_searchTextField textInRange:selectedRange];
    //获取高亮部分
    if(newText.length>0) {
        return;
    }
    
    if (_searchTextField.text.length <= 0) {
        [_placemarksView setHidden:YES];
        
    }
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:_searchTextField.text, @"keywords", @"c04fd37f34ea2b75ac010823e26a732e", @"key", @"沈阳", @"city", @"1", @"page", nil];
    weakify(self);
    [HttpClientService requestGeoAddress:paramDic success:^(id responseObject) {
        strongify(self);
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 1) {
            
            self.placemarksArray = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"pois"]];
            [self.placemarksView reloadData];
            if (self.searchTextField.text.length <= 0) {
                [self.placemarksView setHidden:YES];
                
            }else {
                [self.placemarksView setHidden:NO];
            }
            
        }
        
    } failure:^(NSError *error) {
        strongify(self);
        [self.placemarksView setHidden:YES];
        [self hideLoadHUD:YES];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//    NSLog(@"点击搜索按钮输入的是:%@", textField.text);
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)editBtnClick:(id)sender {
    
    if ([[UserDefaults service] getLoginStatus] == YES) {
        EditAddressViewController *editAddressViewController = [[EditAddressViewController alloc] init];
        PUSH(editAddressViewController);
        
    }else {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        PUSH(loginViewController);
    }
    
}

- (void)backGroundClick {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
    [self.view removeGestureRecognizer:tap];
}


#pragma mark - AMapLocationManager Delegate

//- (void)locationManager:(CLLocationManager *)manager
//     didUpdateLocations:(NSArray *)locations
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {

    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
    
    [_locationManager stopUpdatingLocation];
    
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    
    CLLocation *cl = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    weakify(self);
    [clGeoCoder reverseGeocodeLocation:cl completionHandler: ^(NSArray *placemarks,NSError *error) {
        strongify(self);
        for (CLPlacemark *placeMark in placemarks) {
            
            NSDictionary *addressDic = placeMark.addressDictionary;
            
            NSString *state=[addressDic objectForKey:@"State"];
            
            NSString *city=[addressDic objectForKey:@"City"];
            
            NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
            
            NSString *street=[addressDic objectForKey:@"Street"];
            
            self.address = [NSString stringWithFormat:@"%@%@%@%@", state, city, subLocality, street];
            
            [self.contentView reloadData];
            //            NSLog(@"所在城市====%@ %@ %@ %@", state, city, subLocality, street);
            
            [self.locationManager stopUpdatingLocation];
        }
    }];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_searchTextField resignFirstResponder];
    
    //去掉UItableview的section的headerview黏性
    if (scrollView == _contentView) {
        CGFloat sectionHeaderHeight = 40*SCALE;
        if (scrollView.contentOffset.y<=sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

@end

