//
//  SearchBuildingViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/2.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SearchBuildingViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SearchAddressCell.h"
#import <MapKit/MapKit.h>
// 自定义的header
#import "MJChiBaoZiHeader.h"
#import "MJChiBaoZiFooter.h"
#import "MJChiBaoZiFooter2.h"
#import "MJDIYHeader.h"
#import "MJDIYAutoFooter.h"
#import "MJDIYBackFooter.h"

@interface SearchBuildingViewController ()<MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    
    MKMapView *searchMapView;
    MKPointAnnotation *anno;

    UITextField *searchTextField;

    double contentLongitude;
    double contentLatitude;
}

@property(nonatomic, strong) UITableView *placemarksView;
@property(nonatomic, strong) NSMutableArray *placemarksArray;
@property(nonatomic, strong) UITableView *contentView;
@property(nonatomic, strong) NSMutableArray *contentArray;

@end

@implementation SearchBuildingViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.backgroundColor = [UIColor whiteColor];
        
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_gray"] forState:UIControlStateNormal];
        
        
        UIImageView *searchBg = [[UIImageView alloc] initWithFrame:CGRectMake(NAV_BAR_HEIGHT+10*SCALE, STATUS_BAR_HEIGHT, 240*SCALE, NAV_BAR_HEIGHT)];
        searchBg.image = [UIImage imageNamed:@"location_search_gray"];
        [navigationBar addSubview:searchBg];
        
        searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(NAV_BAR_HEIGHT+40*SCALE, STATUS_BAR_HEIGHT, 224*SCALE, NAV_BAR_HEIGHT)];
        searchTextField.delegate = self;
        searchTextField.returnKeyType = UIReturnKeySearch;
        [navigationBar addSubview:searchTextField];
        
        //地图
        searchMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT, SCREEN_WIDTH, 300*SCALE)];
        [searchMapView setDelegate:self];
        
        CLLocationCoordinate2D coordinate;
        
        coordinate.longitude = [[[UserDefaults service] getLongitude] doubleValue];
        coordinate.latitude = [[[UserDefaults service] getLatitude] doubleValue];
        
        contentLongitude = coordinate.longitude;
        contentLatitude = coordinate.latitude;
        
        // 表示範囲を設定する
        MKCoordinateRegion region;
        region.span.latitudeDelta = 0.008f;
        region.span.longitudeDelta = 0.008f;
        region.center = coordinate;
        
        searchMapView.scrollEnabled = YES;
        searchMapView.zoomEnabled = YES;
//        searchMapView.showsUserLocation=YES;
        
        // 表示位置を設定する（動画）
        [searchMapView setRegion:region animated:YES];
        // 表示タイプと範囲で地図を表示する
        [searchMapView regionThatFits:region];
        
        anno = [[MKPointAnnotation alloc] init];
        anno.coordinate=coordinate;
        anno.title=@"收货位置";
//        anno.subtitle=@"附近";
        [searchMapView addAnnotation:anno];
        
        [self.view addSubview:searchMapView];
        
        UIButton *_locateButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0f, 249.0f-33-20, 33.0f, 33.0f)];
        [_locateButton setBackgroundImage:[UIImage imageNamed:@"btn_map_locate_hl"] forState:UIControlStateNormal];
        [_locateButton setBackgroundImage:[UIImage imageNamed:@"btn_map_locate_hl"] forState:UIControlStateHighlighted];
        [_locateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_locateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_locateButton addTarget:self action:@selector(locateEvent) forControlEvents:UIControlEventTouchUpInside];
        
        [searchMapView addSubview:_locateButton];
        
        //地址列表
        _contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchMapView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT-300*SCALE) style:UITableViewStylePlain];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        //        placemarksView.separatorStyle = NO;
        _contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        //去除底部多余分割线
        _contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self.view addSubview:_contentView];
        
        _placemarksView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT) style:UITableViewStylePlain];
        _placemarksView.delegate = self;
        _placemarksView.dataSource = self;
        //        placemarksView.separatorStyle = NO;
        _placemarksView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        //去除底部多余分割线
        _placemarksView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_placemarksView setHidden:YES];
        [self.view addSubview:_placemarksView];
        
        if (@available(iOS 11.0, *)) {
            _contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _placemarksView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:searchTextField];
        
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
    
}

- (void)reloadContentView {
    NSString *locationStr = [NSString stringWithFormat:@"%f,%f", contentLongitude, contentLatitude];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"c04fd37f34ea2b75ac010823e26a732e", @"key", locationStr, @"location", @"2000", @"radius", @"all", @"extensions", nil];
    weakify(self);
    [HttpClientService requestGeoAddressWithPoint:paramDic success:^(id responseObject) {
        strongify(self);
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 1) {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[responseObject objectForKey:@"regeocode"]];
            
            self.contentArray = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"pois"]];
            
            [self.contentView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self hideLoadHUD:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locateEvent {
    
    //设置地图的中心点，（以用户所在的位置为中心点）
    [searchMapView setCenterCoordinate:searchMapView.userLocation.coordinate animated:YES];
    //设置地图的显示范围
    //    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_mapView.userLocation.coordinate, 600, 600);
    //    [_mapView setRegion:region animated:YES];
    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"%f,%f",mapView.region.span.latitudeDelta,mapView.region.span.longitudeDelta);
    
    contentLongitude = mapView.region.center.longitude;
    contentLatitude = mapView.region.center.latitude;
    
    [searchMapView removeAnnotation:anno];
    
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    
    anno.coordinate=centerCoordinate;
    anno.title=@"收货位置";
//    anno.subtitle=@"附近";
    [searchMapView addAnnotation:anno];
    
    [self reloadContentView];
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _contentView) {
        return [_contentArray count];
    }else {
        return _placemarksArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50*SCALE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellIdentifier1 = @"MyCellIdentifier1";
    static NSString *myCellIdentifier2 = @"MyCellIdentifier2";
    
    if (tableView == _contentView) {
        SearchAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier1];
        if (cell == nil) {
            cell = [[SearchAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier1];
        }
        
        cell.address.text = [NSString stringWithFormat:@"%@", [_contentArray objectAtIndex:indexPath.row][@"name"]];
        
        cell.detailAddress.text = [NSString stringWithFormat:@"%@", [_contentArray objectAtIndex:indexPath.row][@"address"]];
        
        
        return cell;
    }else {
        SearchAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier2];
        if (cell == nil) {
            cell = [[SearchAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier2];
        }
        
        cell.address.text = [NSString stringWithFormat:@"%@", [_placemarksArray objectAtIndex:indexPath.row][@"name"]];
        
        cell.detailAddress.text = [NSString stringWithFormat:@"%@", [_placemarksArray objectAtIndex:indexPath.row][@"address"]];
        
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (tableView == _contentView) {
        NSString *placemark = [_contentArray objectAtIndex:indexPath.row][@"location"];
        NSArray *aArray = [placemark componentsSeparatedByString:@","];
        
        [[UserDefaults service] updateEditAddress:[NSString stringWithFormat:@"%@%@", [_contentArray objectAtIndex:indexPath.row][@"address"], [_contentArray objectAtIndex:indexPath.row][@"name"]]];
        
        [[UserDefaults service] updateEditLatitude:aArray[1]];
        [[UserDefaults service] updateEditLongitude:aArray[0]];
        POP;
    }else {
        NSString *placemark = [_placemarksArray objectAtIndex:indexPath.row][@"location"];
        NSArray *aArray = [placemark componentsSeparatedByString:@","];
        
        [[UserDefaults service] updateEditAddress:[NSString stringWithFormat:@"%@%@", [_placemarksArray objectAtIndex:indexPath.row][@"address"], [_placemarksArray objectAtIndex:indexPath.row][@"name"]]];
        
        [[UserDefaults service] updateEditLatitude:aArray[1]];
        [[UserDefaults service] updateEditLongitude:aArray[0]];
        POP;
    }
}


#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [searchTextField resignFirstResponder];
}

- (void)textFieldTextDidChange {
    NSLog(@"监听输入变化输入的是:%@", searchTextField.text);
    
    UITextRange *selectedRange = [searchTextField markedTextRange];
    NSString * newText = [searchTextField textInRange:selectedRange];
    //获取高亮部分
    if(newText.length>0) {
        return;
    }
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:searchTextField.text, @"keywords", @"c04fd37f34ea2b75ac010823e26a732e", @"key", @"沈阳", @"city", @"1", @"page", nil];
    weakify(self);
    [HttpClientService requestGeoAddress:paramDic success:^(id responseObject) {
        strongify(self);
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 1) {
            
            self.placemarksArray = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"pois"]];
            [self.placemarksView reloadData];
            [self.placemarksView setHidden:NO];
        }
        
    } failure:^(NSError *error) {
        strongify(self);
        [self.placemarksView setHidden:YES];
        [self hideLoadHUD:YES];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"点击搜索按钮输入的是:%@", textField.text);
    [textField resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
}

@end

