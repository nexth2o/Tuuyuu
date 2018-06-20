//
//  MinePointViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/27.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "MinePointViewController.h"
#import "MMDatePicker.h"
#import "SecSegmentView.h"
#import "MinePointCell.h"
#import "LoginViewController.h"
#import "MJChiBaoZiHeader.h"
#import "MJChiBaoZiFooter.h"
#import "MJChiBaoZiFooter2.h"
#import "MJDIYHeader.h"
#import "MJDIYAutoFooter.h"
#import "MJDIYBackFooter.h"



@interface MinePointViewController ()<UITableViewDelegate, UITableViewDataSource, MMDatePickerDelegate> {
    SecSegmentView *secSegmentView;
}

@property(nonatomic, strong) UITableView *contentView;
@property(nonatomic, strong) UILabel *label1;
@property(nonatomic, strong) UILabel *label2;
@property(nonatomic, strong) UILabel *label3;
@property(nonatomic, strong) UIImageView *gradeImage;
@property(nonatomic, strong) UILabel *gradeLabel;
@property(nonatomic, strong) UILabel *piont1;
@property(nonatomic, strong) UILabel *piont2;
@property(nonatomic, strong) UILabel *piont3;
@property(nonatomic, copy) NSString *tabType;
@property(nonatomic, strong) NSMutableArray *detailsArray1;
@property(nonatomic, strong) NSMutableArray *detailsArray2;
@property(nonatomic, strong) UILabel *dateLabel1;
@property(nonatomic, strong) UILabel *dateLabel2;
@property(nonatomic, strong) UILabel *radixLabel;
@property(nonatomic, assign) NSInteger pageNumber1;
@property(nonatomic, assign) NSInteger pageNumber2;
@property(nonatomic, strong) MMDatePicker *theDatePicker1;
@property(nonatomic, strong) MMDatePicker *theDatePicker2;

@end

@implementation MinePointViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.backgroundColor = [UIColor clearColor];
        
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_bg"] forState:UIControlStateNormal];
        navigationBar.titleLabel.text = @"我的兔币";
        
        
        //iOS7新增属性 TODO
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.frame];
        bg.image = [UIImage imageNamed:@"mine_content_bg"];
        [self.view addSubview:bg];
        
        _gradeImage = [[UIImageView alloc] initWithFrame:CGRectMake(230*SCALE, 57*SCALE, 30*SCALE, 30*SCALE)];
        [self.view addSubview:_gradeImage];
        
        _gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_gradeImage.frame), 65*SCALE, 60*SCALE, 20*SCALE)];
//        gradeLabel.text = @"注册会员";
        _gradeLabel.font = [UIFont systemFontOfSize:14*SCALE];
        [self.view addSubview:_gradeLabel];
        
        UIImageView *radixImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_gradeLabel.frame), 64*SCALE, 18*SCALE, 18*SCALE)];
//        radixImage.backgroundColor = [UIColor purpleColor];
        radixImage.image = [UIImage imageNamed:@"mine_radix"];
        [self.view addSubview:radixImage];
        
        _radixLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(radixImage.frame), 65*SCALE, 30*SCALE, 20*SCALE)];
        _radixLabel.text = @"1.0";
        _radixLabel.textColor = [UIColor orangeColor];
        _radixLabel.font = [UIFont systemFontOfSize:14*SCALE];
        [self.view addSubview:_radixLabel];
        
        //可用兔币
        UIImageView *icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(30*SCALE, 100*SCALE, 90*SCALE, 90*SCALE)];
        icon1.image = [UIImage imageNamed:@"mine_piont_bg"];
//        icon1.backgroundColor = [UIColor purpleColor];
        [self.view addSubview:icon1];
        
        _label1 = [[UILabel alloc] initWithFrame:CGRectMake(30*SCALE, CGRectGetMaxY(icon1.frame)+5*SCALE, 90*SCALE, 20*SCALE)];
        _label1.text = @"可用兔币";
        _label1.font = [UIFont systemFontOfSize:12*SCALE];
        _label1.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_label1];
        
        _piont1 = [[UILabel alloc] initWithFrame:CGRectMake(30*SCALE, 100*SCALE, 90*SCALE, 90*SCALE)];
        _piont1.font = [UIFont boldSystemFontOfSize:18*SCALE];
        _piont1.textColor = MAIN_COLOR;
        _piont1.textAlignment = NSTextAlignmentCenter;
        _piont1.text = @"99999";
        [self.view addSubview:_piont1];
        
        //已用兔币
        UIImageView *icon2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon1.frame)+22.5*SCALE, 100*SCALE, 90*SCALE, 90*SCALE)];
//        icon2.backgroundColor = [UIColor purpleColor];
        icon2.image = [UIImage imageNamed:@"mine_piont_bg"];
        [self.view addSubview:icon2];
        
        _label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon1.frame)+22.5*SCALE, CGRectGetMaxY(icon2.frame)+5*SCALE, 90*SCALE, 20*SCALE)];
        _label2.text = @"已用兔币";
        _label2.font = [UIFont systemFontOfSize:12*SCALE];
        _label2.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_label2];
        
        _piont2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon1.frame)+26*SCALE, 100*SCALE, 80*SCALE, 90*SCALE)];
        _piont2.font = [UIFont boldSystemFontOfSize:18*SCALE];
        _piont2.textColor = MAIN_COLOR;
        _piont2.textAlignment = NSTextAlignmentCenter;
        _piont2.text = @"99999";
        [self.view addSubview:_piont2];
        
        //剩余兔币
        UIImageView *icon3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon2.frame)+22.5*SCALE, 100*SCALE, 90*SCALE, 90*SCALE)];
//        icon3.backgroundColor = [UIColor purpleColor];
        icon3.image = [UIImage imageNamed:@"mine_piont_bg"];
        [self.view addSubview:icon3];
        
        _label3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon2.frame)+22.5*SCALE, CGRectGetMaxY(icon3.frame)+5*SCALE, 90*SCALE, 20*SCALE)];
        _label3.text = @"累计兔币";
        _label3.font = [UIFont systemFontOfSize:12*SCALE];
        _label3.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_label3];
        
        _piont3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon2.frame)+26*SCALE, 100*SCALE, 90*SCALE, 90*SCALE)];
        _piont3.font = [UIFont boldSystemFontOfSize:18*SCALE];
        _piont3.textColor = MAIN_COLOR;
        _piont3.textAlignment = NSTextAlignmentCenter;
        _piont3.text = @"99999";
        [self.view addSubview:_piont3];
        
        
        
        //积分兔币列表
        _contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 340*SCALE, SCREEN_WIDTH, SCREEN_HEIGHT-340*SCALE) style:UITableViewStylePlain];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        //        contentView.separatorStyle = NO;
        _contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        //去除底部多余分割线
        _contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

        [self.view addSubview:_contentView];
        
        //tab画面
        NSMutableArray *titleArray = [[NSMutableArray alloc] initWithObjects:@"积分记录",@"我的兔币", nil];
        _tabType = @"我的兔币";
        weakify(self);
        secSegmentView = [[SecSegmentView alloc] initWithFrame:CGRectMake(0 , 240*SCALE, SCREEN_WIDTH, 50*SCALE) titles:titleArray clickBlick:^void(NSInteger index) {
            strongify(self);
            [self.contentView.mj_footer resetNoMoreData];
            
            self.tabType = [titleArray objectAtIndex:index];
            
            if ([self.tabType isEqualToString:@"积分记录"]) {
                [self requestIntegralWithStartDate:[NSString stringWithFormat:@"%@ 00:00:00", self.dateLabel1.text] endDate:[NSString stringWithFormat:@"%@ 23:59:59", self.dateLabel2.text]];
                self.label1.text = @"待转换兔币积分";
                self.label2.text = @"已转换兔币积分";
                self.label3.text = @"累计积分";
                navigationBar.titleLabel.text = @"我的积分";
            }else {
                [self requestTuucoinWithStartDate:[NSString stringWithFormat:@"%@ 00:00:00", self.dateLabel1.text] endDate:[NSString stringWithFormat:@"%@ 23:59:59", self.dateLabel2.text]];
                self.label1.text = @"可用兔币";
                self.label2.text = @"已用兔币";
                self.label3.text = @"累计兔币";
                navigationBar.titleLabel.text = @"我的兔币";
            }
    
//            [contentView reloadData];
        }];
        [self.view addSubview:secSegmentView];
        
        //日期选择
        UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(secSegmentView.frame), SCREEN_WIDTH, 50*SCALE)];
        toolView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:toolView];
        
        //
        UIButton *_dateBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dateBtn1 setFrame:CGRectMake(20*SCALE, 0*SCALE, 110*SCALE, 50*SCALE)];
        [_dateBtn1 addTarget:self action:@selector(dateBtn1Btn:) forControlEvents:UIControlEventTouchUpInside];
//        _dateBtn1.backgroundColor = [UIColor blueColor];
        [toolView addSubview:_dateBtn1];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [formatter stringFromDate:date];
        
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
        //    [lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
        [lastMonthComps setMonth:-1];
        NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:date options:0];
        NSString *dateStr = [formatter stringFromDate:newdate];
        
        
        
        _dateLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(30*SCALE, 0*SCALE, 70*SCALE, 50*SCALE)];
        _dateLabel1.font = [UIFont systemFontOfSize:12*SCALE];
        _dateLabel1.textColor = [UIColor darkGrayColor];
        _dateLabel1.text = dateStr;
        [toolView addSubview:_dateLabel1];
        
        UIImageView *dateIcon1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_dateLabel1.frame), 15*SCALE, 20*SCALE, 20*SCALE)];
//        dateIcon1.backgroundColor = [UIColor yellowColor];
        dateIcon1.image = [UIImage imageNamed:@"mine_piont_date"];
        [toolView addSubview:dateIcon1];
        
        UIButton *_dateBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dateBtn2 setFrame:CGRectMake(CGRectGetMaxX(_dateBtn1.frame)+20*SCALE, 0*SCALE, 110*SCALE, 50*SCALE)];
        [_dateBtn2 addTarget:self action:@selector(dateBtn2Btn:) forControlEvents:UIControlEventTouchUpInside];
//        _dateBtn2.backgroundColor = [UIColor blueColor];
        [toolView addSubview:_dateBtn2];
        
        _dateLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_dateBtn1.frame)+30*SCALE, 0*SCALE, 70*SCALE, 50*SCALE)];
        _dateLabel2.font = [UIFont systemFontOfSize:12*SCALE];
        _dateLabel2.textColor = [UIColor darkGrayColor];
        _dateLabel2.text = dateString;
        [toolView addSubview:_dateLabel2];
        
        UIImageView *dateIcon2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_dateLabel2.frame), 15*SCALE, 20*SCALE, 20*SCALE)];
//        dateIcon2.backgroundColor = [UIColor yellowColor];
        dateIcon2.image = [UIImage imageNamed:@"mine_piont_date"];
        [toolView addSubview:dateIcon2];
        
        
        
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchBtn setFrame:CGRectMake(CGRectGetMaxX(_dateBtn2.frame)+20*SCALE, 0*SCALE, 75*SCALE, 50*SCALE)];
        [searchBtn addTarget:self action:@selector(searchBtn:) forControlEvents:UIControlEventTouchUpInside];
        [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:15*SCALE]];
        [searchBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
//        searchBtn.backgroundColor = [UIColor blueColor];
        [toolView addSubview:searchBtn];
        
        _theDatePicker1 = [[MMDatePicker alloc] initWithFrame:CGRectMake(0,
                                                                            [[UIScreen mainScreen] applicationFrame].size.height,
                                                                            [[UIScreen mainScreen] applicationFrame].size.width,
                                                                            400)]; //height is not important, it will be overwritten
        [_theDatePicker1 setDelegate:self];
        [_theDatePicker1.datePicker setDatePickerMode:UIDatePickerModeDate];
        [_theDatePicker1 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_theDatePicker1];
        
        _theDatePicker2 = [[MMDatePicker alloc] initWithFrame:CGRectMake(0,
                                                                       [[UIScreen mainScreen] applicationFrame].size.height,
                                                                       [[UIScreen mainScreen] applicationFrame].size.width,
                                                                       400)]; //height is not important, it will be overwritten
        [_theDatePicker2 setDelegate:self];
        [_theDatePicker2.datePicker setDatePickerMode:UIDatePickerModeDate];
        [_theDatePicker2 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_theDatePicker2];
        
        
        [self.view bringSubviewToFront:navigationBar];
        
    }
    
    return self;
}

- (void)dateBtn1Btn:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [self.theDatePicker1 setTransform:CGAffineTransformMakeTranslation(0, -self.theDatePicker1.frame.size.height)];
    }completion:^(BOOL finished) {
    }];
}
- (void)dateBtn2Btn:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [self.theDatePicker2 setTransform:CGAffineTransformMakeTranslation(0, -self.theDatePicker2.frame.size.height)];
    }completion:^(BOOL finished) {
    }];
}
- (void)searchBtn:(id)sender {
    if ([_tabType isEqualToString:@"积分记录"]) {
        [self requestIntegralWithStartDate:[NSString stringWithFormat:@"%@ 00:00:00", _dateLabel1.text] endDate:[NSString stringWithFormat:@"%@ 23:59:59", _dateLabel2.text]];
    }else {
        [self requestTuucoinWithStartDate:[NSString stringWithFormat:@"%@ 00:00:00", _dateLabel1.text] endDate:[NSString stringWithFormat:@"%@ 23:59:59", _dateLabel2.text]];
        
    }
}

#pragma mark - MMDatePickerDelegate Methods

-(void)didPressDismissButtonOfDatePicker:(MMDatePicker *)datePicker{
    NSLog(@">> Did press cancel Button...");
    
    [UIView animateWithDuration:0.3 animations:^{
        [datePicker setTransform:CGAffineTransformIdentity];
    }completion:^(BOOL finished) {
    }];
}

-(void)datePicker:(MMDatePicker *)datePicker didSelectDate:(NSDate *)date{
//    NSLog(@">> Did press select Button... with date %@",date);
    
    //日期格式化
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    
    if (datePicker == _theDatePicker1) {
        _dateLabel1.text = dateString;
    }else {
        _dateLabel2.text = dateString;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    if ([_tabType isEqualToString:@"积分记录"]) {
        [self requestIntegralWithStartDate:[NSString stringWithFormat:@"%@ 00:00:00", _dateLabel1.text] endDate:[NSString stringWithFormat:@"%@ 23:59:59", _dateLabel2.text]];
    }else {
        [self requestTuucoinWithStartDate:[NSString stringWithFormat:@"%@ 00:00:00", _dateLabel1.text] endDate:[NSString stringWithFormat:@"%@ 23:59:59", _dateLabel2.text]];

    }
}

- (void)requestIntegralWithStartDate:(NSString *)startDate endDate:(NSString *)endDate {
    
    _pageNumber1 = 0;
    
    [self showLoadHUDMsg:@"努力加载中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:startDate, @"beg_time", endDate, @"end_time", [NSString stringWithFormat:@"%ld", (long)_pageNumber1], @"page", nil];
    weakify(self);
    [HttpClientService requestIntegraldetails:paramDic success:^(id responseObject) {
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            self.detailsArray1 = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"details"]];

                if ([[jsonDic objectForKey:@"member_type"] isEqualToString:@"0"]) {
                    self.gradeImage.image = [UIImage imageNamed:@"mine_grade_0"];
                    self.gradeLabel.text = @"普通会员";
                }else if ([[jsonDic objectForKey:@"member_type"] isEqualToString:@"1"]) {
                    self.gradeImage.image = [UIImage imageNamed:@"mine_grade_1"];
                    self.gradeLabel.text = @"铜牌会员";
                }else if ([[jsonDic objectForKey:@"member_type"] isEqualToString:@"2"]) {
                    self.gradeImage.image = [UIImage imageNamed:@"mine_grade_2"];
                    self.gradeLabel.text = @"银牌会员";
                }else if ([[jsonDic objectForKey:@"member_type"] isEqualToString:@"3"]) {
                    self.gradeImage.image = [UIImage imageNamed:@"mine_grade_3"];
                    self.gradeLabel.text = @"金牌会员";
                }else if ([[jsonDic objectForKey:@"member_type"] isEqualToString:@"4"]) {
                    self.gradeImage.image = [UIImage imageNamed:@"mine_grade_4"];
                    self.gradeLabel.text = @"钻石会员";
                }
                
                self.radixLabel.text = [jsonDic objectForKey:@"radix"];
                
                self.pageNumber1++;
            
            self.piont1.text = [jsonDic objectForKey:@"unconverted"];
            self.piont2.text = [jsonDic objectForKey:@"converted"];
            self.piont3.text = [jsonDic objectForKey:@"addup"];
            
            [self.contentView reloadData];
            [self.contentView setContentOffset:CGPointMake(0,0) animated:YES];
            [self hideLoadHUD:YES];
            
        }else if (status == 202) {
            [self showMsg:@"您的登录状态失效，请重新登录"];
            [self hideLoadHUD:YES];
            sleep(1.0);
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
            
        }else if (status == 102) {
            [self showMsg:@"数据库错误"];
            [self hideLoadHUD:YES];
            
        }else {
//            [self showMsg:@"服务器异常"];
            [self hideLoadHUD:YES];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
    }];

}

- (void)requestTuucoinWithStartDate:(NSString *)startDate endDate:(NSString *)endDate {
    
    _pageNumber2 = 0;
    
    [self showLoadHUDMsg:@"努力加载中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:startDate, @"beg_time", endDate, @"end_time", [NSString stringWithFormat:@"%ld", (long)_pageNumber2], @"page", nil];
    weakify(self);
    [HttpClientService requestTuucoindetails:paramDic success:^(id responseObject) {
        strongify(self);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            self.detailsArray2 = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"details"]];
            
                if ([[jsonDic objectForKey:@"member_type"] isEqualToString:@"0"]) {
                    self.gradeImage.image = [UIImage imageNamed:@"mine_grade_0"];
                    self.gradeLabel.text = @"普通会员";
                }else if ([[jsonDic objectForKey:@"member_type"] isEqualToString:@"1"]) {
                    self.gradeImage.image = [UIImage imageNamed:@"mine_grade_1"];
                    self.gradeLabel.text = @"铜牌会员";
                }else if ([[jsonDic objectForKey:@"member_type"] isEqualToString:@"2"]) {
                    self.gradeImage.image = [UIImage imageNamed:@"mine_grade_2"];
                    self.gradeLabel.text = @"银牌会员";
                }else if ([[jsonDic objectForKey:@"member_type"] isEqualToString:@"3"]) {
                    self.gradeImage.image = [UIImage imageNamed:@"mine_grade_3"];
                    self.gradeLabel.text = @"金牌会员";
                }else if ([[jsonDic objectForKey:@"member_type"] isEqualToString:@"4"]) {
                    self.gradeImage.image = [UIImage imageNamed:@"mine_grade_4"];
                    self.gradeLabel.text = @"钻石会员";
                }
                
            
                self.radixLabel.text = [jsonDic objectForKey:@"radix"];
                
                self.pageNumber2++;
   
            
            self.piont1.text = [jsonDic objectForKey:@"useable"];
            self.piont2.text = [jsonDic objectForKey:@"used"];
            self.piont3.text = [jsonDic objectForKey:@"addup"];
            
            [self.contentView reloadData];
            [self.contentView setContentOffset:CGPointMake(0,0) animated:YES];
            [self hideLoadHUD:YES];
            
        }else if (status == 202) {
            [self showMsg:@"您的登录状态失效，请重新登录"];
            [self hideLoadHUD:YES];
            sleep(1.0);
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
         
        }else if (status == 102) {
            [self showMsg:@"数据库错误"];
            [self hideLoadHUD:YES];

        }else {
            [self showMsg:@"服务器异常"];
            [self hideLoadHUD:YES];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
        NSLog(@"请求我的兔币失败");
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_tabType isEqualToString:@"积分记录"]) {
        return [_detailsArray1 count];
    }else {
        return [_detailsArray2 count];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 80*SCALE;
   
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellIdentifier1 = @"MyCellIdentifier1";
    static NSString *myCellIdentifier2 = @"MyCellIdentifier2";
    
    UITableViewCell *cell = nil;
    if ([_tabType isEqualToString:@"积分记录"]) {
        
        MinePointCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier1];
        if (cell == nil) {
            cell = [[MinePointCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier1];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if ([_detailsArray1[indexPath.row][@"money"] floatValue] > 0) {
            cell.title.text = [NSString stringWithFormat:@"%@:%@", _detailsArray1[indexPath.row][@"engender_type"], _detailsArray1[indexPath.row][@"money"]];
        }else {
            cell.title.text = [NSString stringWithFormat:@"%@", _detailsArray1[indexPath.row][@"engender_type"]];
        }
        
        cell.detail.text = [NSString stringWithFormat:@"增加积分:%@", _detailsArray1[indexPath.row][@"integral"]];
        cell.info.text = [NSString stringWithFormat:@"%@ %@", _detailsArray1[indexPath.row][@"friend_type"], _detailsArray1[indexPath.row][@"nick_name"]];
        
        
        if ([_detailsArray1[indexPath.row][@"integral"] floatValue] > 0) {
            cell.subTitle.text = [NSString stringWithFormat:@"+ %@", _detailsArray1[indexPath.row][@"integral"]];
        }else {
            cell.subTitle.text = [NSString stringWithFormat:@"  %@", _detailsArray1[indexPath.row][@"integral"]];
        }
        
        
        cell.time.text = _detailsArray1[indexPath.row][@"engender_time"];
        
        if ([_detailsArray1[indexPath.row][@"friend_member_type"] isEqualToString:@"0"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_0"];
            cell.grageLabel.text = @"普通会员";
        }else if ([_detailsArray1[indexPath.row][@"friend_member_type"] isEqualToString:@"1"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_1"];
            cell.grageLabel.text = @"铜牌会员";
        }else if ([_detailsArray1[indexPath.row][@"friend_member_type"] isEqualToString:@"2"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_2"];
            cell.grageLabel.text = @"银牌会员";
        }else if ([_detailsArray1[indexPath.row][@"friend_member_type"] isEqualToString:@"3"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_3"];
            cell.grageLabel.text = @"金牌会员";
        }else if ([_detailsArray1[indexPath.row][@"friend_member_type"] isEqualToString:@"4"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_4"];
            cell.grageLabel.text = @"钻石会员";
        }
        
        cell.radix.text = _detailsArray1[indexPath.row][@"radix"];
        
        
        
        return cell;
    }else {
        
        MinePointCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier2];
        if (cell == nil) {
            cell = [[MinePointCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier2];
        }
        
        if ([_detailsArray2[indexPath.row][@"money"] floatValue] > 0) {
            cell.title.text = [NSString stringWithFormat:@"%@:%@", _detailsArray2[indexPath.row][@"engender_type"], _detailsArray2[indexPath.row][@"money"]];
        }else {
            cell.title.text = [NSString stringWithFormat:@"%@", _detailsArray2[indexPath.row][@"engender_type"]];
        }
        
        
        cell.detail.text = [NSString stringWithFormat:@"转换兔币:%@", _detailsArray2[indexPath.row][@"tuu_coin"]];
        cell.info.text = [NSString stringWithFormat:@"%@ %@", _detailsArray2[indexPath.row][@"friend_type"], _detailsArray2[indexPath.row][@"nick_name"]];
        
        if ([_detailsArray2[indexPath.row][@"tuu_coin"] floatValue] > 0) {
            cell.subTitle.text = [NSString stringWithFormat:@"+ %@", _detailsArray2[indexPath.row][@"tuu_coin"]];
        }else {
            cell.subTitle.text = [NSString stringWithFormat:@"  %@", _detailsArray2[indexPath.row][@"tuu_coin"]];
        }

        cell.time.text = _detailsArray2[indexPath.row][@"engender_time"];
        
        if ([_detailsArray2[indexPath.row][@"friend_member_type"] isEqualToString:@"0"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_0"];
                        cell.grageLabel.text = @"普通会员";
        }else if ([_detailsArray2[indexPath.row][@"friend_member_type"] isEqualToString:@"1"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_1"];
                        cell.grageLabel.text = @"铜牌会员";
        }else if ([_detailsArray2[indexPath.row][@"friend_member_type"] isEqualToString:@"2"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_2"];
                        cell.grageLabel.text = @"银牌会员";
        }else if ([_detailsArray2[indexPath.row][@"friend_member_type"] isEqualToString:@"3"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_3"];
                        cell.grageLabel.text = @"金牌会员";
        }else if ([_detailsArray2[indexPath.row][@"friend_member_type"] isEqualToString:@"4"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_4"];
                        cell.grageLabel.text = @"钻石会员";
        }
        
        cell.radix.text = _detailsArray2[indexPath.row][@"radix"];
        
        
        return cell;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
 
}

- (void)loadNewData {
    
    if ([_tabType isEqualToString:@"积分记录"]) {
        
        [self showLoadHUDMsg:@"努力加载中..."];
        
        _pageNumber1 = 0;
        
        
        NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@ 00:00:00", _dateLabel1.text], @"beg_time", [NSString stringWithFormat:@"%@ 23:59:59", _dateLabel2.text], @"end_time",[NSString stringWithFormat:@"%ld", (long)_pageNumber1], @"page", nil];
        weakify(self);
        [HttpClientService requestIntegraldetails:paramDic success:^(id responseObject) {
            strongify(self);
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            int status = [[jsonDic objectForKey:@"status"] intValue];
            
            if (status == 0) {
                
                self.detailsArray1 = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"details"]];
                
                
                if ([self.detailsArray1 count] > 0) {
                    
                    [self.contentView setHidden:NO];
                    
                    [self.contentView.mj_header endRefreshing];
                    [self.contentView.mj_footer endRefreshing];
                    [self.contentView reloadData];
                    self.pageNumber1++;
                    
                }
                
                [self hideLoadHUD:YES];
            }
            
        } failure:^(NSError *error) {
            strongify(self);
            [self.contentView.mj_header endRefreshing];
            
            [self hideLoadHUD:YES];
            
            NSLog(@"请求炸鸡美食失败");
        }];

    }else {
        
        [self showLoadHUDMsg:@"努力加载中..."];
        
        _pageNumber2 = 0;
        
        NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@ 00:00:00", _dateLabel1.text], @"beg_time", [NSString stringWithFormat:@"%@ 23:59:59", _dateLabel2.text], @"end_time",[NSString stringWithFormat:@"%ld", (long)_pageNumber2], @"page", nil];
        weakify(self);
        [HttpClientService requestTuucoindetails:paramDic success:^(id responseObject) {
            strongify(self);
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            int status = [[jsonDic objectForKey:@"status"] intValue];
            
            if (status == 0) {
                
                self.detailsArray2 = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"details"]];
                
                
                if ([self.detailsArray2 count] > 0) {
                    
                    [self.contentView setHidden:NO];
                    
                    [self.contentView.mj_header endRefreshing];
                    [self.contentView.mj_footer endRefreshing];
                    [self.contentView reloadData];
                    self.pageNumber2++;
                    
                }
                
                [self hideLoadHUD:YES];
            }
            
        } failure:^(NSError *error) {
            strongify(self);
            [self.contentView.mj_header endRefreshing];
            
            [self hideLoadHUD:YES];
        }];

        
    }
    
    
}


- (void)loadMoreData {
    
    if ([_tabType isEqualToString:@"积分记录"]) {
        
        [self showLoadHUDMsg:@"努力加载中..."];
        
        NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@ 00:00:00", _dateLabel1.text], @"beg_time", [NSString stringWithFormat:@"%@ 23:59:59", _dateLabel2.text], @"end_time",[NSString stringWithFormat:@"%ld", (long)_pageNumber1], @"page", nil];
        weakify(self);
        [HttpClientService requestIntegraldetails:paramDic success:^(id responseObject) {
            strongify(self);
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            int status = [[jsonDic objectForKey:@"status"] intValue];
            
            if (status == 0) {
                
                NSMutableArray *array = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"details"]];
                
                if (array.count == 0) {
                    
                    [self hideLoadHUD:YES];
                    
                    [self showMsg:@"没有更多信息了"];
                    
                    [self.contentView.mj_footer endRefreshingWithNoMoreData];
                    
                }else if (array.count > 0 && array.count < 20) {
                    
                    for (int i = 0; i<array.count; i++) {
                        
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        
                        dic = [array objectAtIndex:i];
                        
                        [self.detailsArray1 addObject:dic];
                    }
                    
                    [self.contentView reloadData];
                    
                    [self hideLoadHUD:YES];
                    
                    [self.contentView.mj_footer endRefreshingWithNoMoreData];
                    
                }else {
                    
                    for (int i = 0; i<array.count; i++) {
                        
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        
                        dic = [array objectAtIndex:i];
                        
                        [self.detailsArray1 addObject:dic];
                    }
                    self.pageNumber1++;
                    
                    [self.contentView reloadData];
                    
                    [self hideLoadHUD:YES];
                    
                    [self.contentView.mj_footer endRefreshing];
                    
                }
                
            }
            
        } failure:^(NSError *error) {
            
            strongify(self);
            [self hideLoadHUD:YES];
            
            [self showMsg:@"加载失败"];
            
            [self.contentView.mj_footer endRefreshing];
            
        }];

        
    }else {
        
        [self showLoadHUDMsg:@"努力加载中..."];
        
        NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@ 00:00:00", _dateLabel1.text], @"beg_time", [NSString stringWithFormat:@"%@ 23:59:59", _dateLabel2.text], @"end_time",[NSString stringWithFormat:@"%ld", (long)_pageNumber2], @"page", nil];
        weakify(self);
        [HttpClientService requestTuucoindetails:paramDic success:^(id responseObject) {
            strongify(self);
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            int status = [[jsonDic objectForKey:@"status"] intValue];
            
            if (status == 0) {
                
                NSMutableArray *array = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"details"]];
                
                if (array.count == 0) {
                    
                    [self hideLoadHUD:YES];
                    
                    [self showMsg:@"没有更多信息了"];
                    
                    [self.contentView.mj_footer endRefreshingWithNoMoreData];
                    
                }else if (array.count > 0 && array.count < 20) {
                    
                    for (int i = 0; i<array.count; i++) {
                        
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        
                        dic = [array objectAtIndex:i];
                        
                        [self.detailsArray2 addObject:dic];
                    }
                    
                    [self.contentView reloadData];
                    
                    [self hideLoadHUD:YES];
                    
                    [self.contentView.mj_footer endRefreshingWithNoMoreData];
                    
                }else {
                    
                    for (int i = 0; i<array.count; i++) {
                        
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        
                        dic = [array objectAtIndex:i];
                        
                        [self.detailsArray2 addObject:dic];
                    }
                    self.pageNumber2++;
                    
                    [self.contentView reloadData];
                    
                    [self hideLoadHUD:YES];
                    
                    [self.contentView.mj_footer endRefreshing];
                    
                }
                
            }
            
        } failure:^(NSError *error) {
            strongify(self);
            [self hideLoadHUD:YES];
            
            [self showMsg:@"加载失败"];
            
            [self.contentView.mj_footer endRefreshing];
            
        }];
    }
}


#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}
@end
