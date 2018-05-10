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
    UITableView *contentView;
    SecSegmentView *secSegmentView;
    
    MMDatePicker *theDatePicker1;
    MMDatePicker *theDatePicker2;
    
    UILabel *dateLabel1;
    UILabel *dateLabel2;
    
    NSString *tabType;

    NSMutableArray *detailsArray1;
    NSMutableArray *detailsArray2;
    
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    
    UILabel *piont1;
    UILabel *piont2;
    UILabel *piont3;
    
    UIImageView *gradeImage;
    UILabel *gradeLabel;
    UILabel *radixLabel;
    
    NSInteger pageNumber1;
    NSInteger pageNumber2;
    
}

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
        
        gradeImage = [[UIImageView alloc] initWithFrame:CGRectMake(230*SCALE, 57*SCALE, 30*SCALE, 30*SCALE)];
        [self.view addSubview:gradeImage];
        
        gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(gradeImage.frame), 65*SCALE, 60*SCALE, 20*SCALE)];
//        gradeLabel.text = @"注册会员";
        gradeLabel.font = [UIFont systemFontOfSize:14*SCALE];
        [self.view addSubview:gradeLabel];
        
        UIImageView *radixImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(gradeLabel.frame), 64*SCALE, 18*SCALE, 18*SCALE)];
//        radixImage.backgroundColor = [UIColor purpleColor];
        radixImage.image = [UIImage imageNamed:@"mine_radix"];
        [self.view addSubview:radixImage];
        
        radixLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(radixImage.frame), 65*SCALE, 30*SCALE, 20*SCALE)];
        radixLabel.text = @"1.0";
        radixLabel.textColor = [UIColor orangeColor];
        radixLabel.font = [UIFont systemFontOfSize:14*SCALE];
        [self.view addSubview:radixLabel];
        
        //可用兔币
        UIImageView *icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(30*SCALE, 100*SCALE, 90*SCALE, 90*SCALE)];
        icon1.image = [UIImage imageNamed:@"mine_piont_bg"];
//        icon1.backgroundColor = [UIColor purpleColor];
        [self.view addSubview:icon1];
        
        label1 = [[UILabel alloc] initWithFrame:CGRectMake(30*SCALE, CGRectGetMaxY(icon1.frame)+5*SCALE, 90*SCALE, 20*SCALE)];
        label1.text = @"可用兔币";
        label1.font = [UIFont systemFontOfSize:12*SCALE];
        label1.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label1];
        
        piont1 = [[UILabel alloc] initWithFrame:CGRectMake(30*SCALE, 100*SCALE, 90*SCALE, 90*SCALE)];
        piont1.font = [UIFont boldSystemFontOfSize:18*SCALE];
        piont1.textColor = MAIN_COLOR;
        piont1.textAlignment = NSTextAlignmentCenter;
        piont1.text = @"99999";
        [self.view addSubview:piont1];
        
        //已用兔币
        UIImageView *icon2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon1.frame)+22.5*SCALE, 100*SCALE, 90*SCALE, 90*SCALE)];
//        icon2.backgroundColor = [UIColor purpleColor];
        icon2.image = [UIImage imageNamed:@"mine_piont_bg"];
        [self.view addSubview:icon2];
        
        label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon1.frame)+22.5*SCALE, CGRectGetMaxY(icon2.frame)+5*SCALE, 90*SCALE, 20*SCALE)];
        label2.text = @"已用兔币";
        label2.font = [UIFont systemFontOfSize:12*SCALE];
        label2.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label2];
        
        piont2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon1.frame)+26*SCALE, 100*SCALE, 80*SCALE, 90*SCALE)];
        piont2.font = [UIFont boldSystemFontOfSize:18*SCALE];
        piont2.textColor = MAIN_COLOR;
        piont2.textAlignment = NSTextAlignmentCenter;
        piont2.text = @"99999";
        [self.view addSubview:piont2];
        
        //剩余兔币
        UIImageView *icon3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon2.frame)+22.5*SCALE, 100*SCALE, 90*SCALE, 90*SCALE)];
//        icon3.backgroundColor = [UIColor purpleColor];
        icon3.image = [UIImage imageNamed:@"mine_piont_bg"];
        [self.view addSubview:icon3];
        
        label3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon2.frame)+22.5*SCALE, CGRectGetMaxY(icon3.frame)+5*SCALE, 90*SCALE, 20*SCALE)];
        label3.text = @"累计兔币";
        label3.font = [UIFont systemFontOfSize:12*SCALE];
        label3.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label3];
        
        piont3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon2.frame)+26*SCALE, 100*SCALE, 90*SCALE, 90*SCALE)];
        piont3.font = [UIFont boldSystemFontOfSize:18*SCALE];
        piont3.textColor = MAIN_COLOR;
        piont3.textAlignment = NSTextAlignmentCenter;
        piont3.text = @"99999";
        [self.view addSubview:piont3];
        
        
        
        //积分兔币列表
        contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 340*SCALE, SCREEN_WIDTH, SCREEN_HEIGHT-340*SCALE) style:UITableViewStylePlain];
        contentView.delegate = self;
        contentView.dataSource = self;
        //        contentView.separatorStyle = NO;
        contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        //去除底部多余分割线
        contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        contentView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

        [self.view addSubview:contentView];
        
        //tab画面
        NSMutableArray *titleArray = [[NSMutableArray alloc] initWithObjects:@"积分记录",@"我的兔币", nil];
        tabType = @"我的兔币";
        secSegmentView = [[SecSegmentView alloc] initWithFrame:CGRectMake(0 , 240*SCALE, SCREEN_WIDTH, 50*SCALE) titles:titleArray clickBlick:^void(NSInteger index) {
            
            [contentView.mj_footer resetNoMoreData];
            
            tabType = [titleArray objectAtIndex:index];
            
            if ([tabType isEqualToString:@"积分记录"]) {
                [self requestIntegralWithStartDate:[NSString stringWithFormat:@"%@ 00:00:00", dateLabel1.text] endDate:[NSString stringWithFormat:@"%@ 23:59:59", dateLabel2.text]];
                label1.text = @"待转换兔币积分";
                label2.text = @"已转换兔币积分";
                label3.text = @"累计积分";
                navigationBar.titleLabel.text = @"我的积分";
            }else {
                [self requestTuucoinWithStartDate:[NSString stringWithFormat:@"%@ 00:00:00", dateLabel1.text] endDate:[NSString stringWithFormat:@"%@ 23:59:59", dateLabel2.text]];
                label1.text = @"可用兔币";
                label2.text = @"已用兔币";
                label3.text = @"累计兔币";
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
        
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
        //    [lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
        [lastMonthComps setMonth:-1];
        NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:date options:0];
        NSString *dateStr = [formatter stringFromDate:newdate];
        
        
        
        dateLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(30*SCALE, 0*SCALE, 70*SCALE, 50*SCALE)];
        dateLabel1.font = [UIFont systemFontOfSize:12*SCALE];
        dateLabel1.textColor = [UIColor darkGrayColor];
        dateLabel1.text = dateStr;
        [toolView addSubview:dateLabel1];
        
        UIImageView *dateIcon1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(dateLabel1.frame), 15*SCALE, 20*SCALE, 20*SCALE)];
//        dateIcon1.backgroundColor = [UIColor yellowColor];
        dateIcon1.image = [UIImage imageNamed:@"mine_piont_date"];
        [toolView addSubview:dateIcon1];
        
        UIButton *_dateBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dateBtn2 setFrame:CGRectMake(CGRectGetMaxX(_dateBtn1.frame)+20*SCALE, 0*SCALE, 110*SCALE, 50*SCALE)];
        [_dateBtn2 addTarget:self action:@selector(dateBtn2Btn:) forControlEvents:UIControlEventTouchUpInside];
//        _dateBtn2.backgroundColor = [UIColor blueColor];
        [toolView addSubview:_dateBtn2];
        
        dateLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_dateBtn1.frame)+30*SCALE, 0*SCALE, 70*SCALE, 50*SCALE)];
        dateLabel2.font = [UIFont systemFontOfSize:12*SCALE];
        dateLabel2.textColor = [UIColor darkGrayColor];
        dateLabel2.text = dateString;
        [toolView addSubview:dateLabel2];
        
        UIImageView *dateIcon2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(dateLabel2.frame), 15*SCALE, 20*SCALE, 20*SCALE)];
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
        
        theDatePicker1 = [[MMDatePicker alloc] initWithFrame:CGRectMake(0,
                                                                            [[UIScreen mainScreen] applicationFrame].size.height,
                                                                            [[UIScreen mainScreen] applicationFrame].size.width,
                                                                            400)]; //height is not important, it will be overwritten
        [theDatePicker1 setDelegate:self];
        [theDatePicker1.datePicker setDatePickerMode:UIDatePickerModeDate];
        [theDatePicker1 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:theDatePicker1];
        
        theDatePicker2 = [[MMDatePicker alloc] initWithFrame:CGRectMake(0,
                                                                       [[UIScreen mainScreen] applicationFrame].size.height,
                                                                       [[UIScreen mainScreen] applicationFrame].size.width,
                                                                       400)]; //height is not important, it will be overwritten
        [theDatePicker2 setDelegate:self];
        [theDatePicker2.datePicker setDatePickerMode:UIDatePickerModeDate];
        [theDatePicker2 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:theDatePicker2];
        
        
        [self.view bringSubviewToFront:navigationBar];
        
    }
    
    return self;
}

- (void)dateBtn1Btn:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [theDatePicker1 setTransform:CGAffineTransformMakeTranslation(0, -theDatePicker1.frame.size.height)];
    }completion:^(BOOL finished) {
    }];
}
- (void)dateBtn2Btn:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [theDatePicker2 setTransform:CGAffineTransformMakeTranslation(0, -theDatePicker2.frame.size.height)];
    }completion:^(BOOL finished) {
    }];
}
- (void)searchBtn:(id)sender {
    if ([tabType isEqualToString:@"积分记录"]) {
        [self requestIntegralWithStartDate:[NSString stringWithFormat:@"%@ 00:00:00", dateLabel1.text] endDate:[NSString stringWithFormat:@"%@ 23:59:59", dateLabel2.text]];
    }else {
        [self requestTuucoinWithStartDate:[NSString stringWithFormat:@"%@ 00:00:00", dateLabel1.text] endDate:[NSString stringWithFormat:@"%@ 23:59:59", dateLabel2.text]];
        
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
    
    if (datePicker == theDatePicker1) {
        dateLabel1.text = dateString;
    }else {
        dateLabel2.text = dateString;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    if ([tabType isEqualToString:@"积分记录"]) {
        [self requestIntegralWithStartDate:[NSString stringWithFormat:@"%@ 00:00:00", dateLabel1.text] endDate:[NSString stringWithFormat:@"%@ 23:59:59", dateLabel2.text]];
    }else {
        [self requestTuucoinWithStartDate:[NSString stringWithFormat:@"%@ 00:00:00", dateLabel1.text] endDate:[NSString stringWithFormat:@"%@ 23:59:59", dateLabel2.text]];

    }
}

- (void)requestIntegralWithStartDate:(NSString *)startDate endDate:(NSString *)endDate {
    
    pageNumber1 = 0;
    
    [self showLoadHUDMsg:@"努力加载中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:startDate, @"beg_time", endDate, @"end_time", [NSString stringWithFormat:@"%ld", (long)pageNumber1], @"page", nil];
    
    [HttpClientService requestIntegraldetails:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            detailsArray1 = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"details"]];

                if ([[jsonDic objectForKey:@"member_type"] isEqualToString:@"0"]) {
                    gradeImage.image = [UIImage imageNamed:@"mine_grade_0"];
                    gradeLabel.text = @"普通会员";
                }else if ([[jsonDic objectForKey:@"member_type"] isEqualToString:@"1"]) {
                    gradeImage.image = [UIImage imageNamed:@"mine_grade_1"];
                    gradeLabel.text = @"铜牌会员";
                }else if ([[jsonDic objectForKey:@"member_type"] isEqualToString:@"2"]) {
                    gradeImage.image = [UIImage imageNamed:@"mine_grade_2"];
                    gradeLabel.text = @"银牌会员";
                }else if ([[jsonDic objectForKey:@"member_type"] isEqualToString:@"3"]) {
                    gradeImage.image = [UIImage imageNamed:@"mine_grade_3"];
                    gradeLabel.text = @"金牌会员";
                }else if ([[jsonDic objectForKey:@"member_type"] isEqualToString:@"4"]) {
                    gradeImage.image = [UIImage imageNamed:@"mine_grade_4"];
                    gradeLabel.text = @"钻石会员";
                }
                
                radixLabel.text = [jsonDic objectForKey:@"radix"];
                
                pageNumber1++;
            
            piont1.text = [jsonDic objectForKey:@"unconverted"];
            piont2.text = [jsonDic objectForKey:@"converted"];
            piont3.text = [jsonDic objectForKey:@"addup"];
            
            [contentView reloadData];
            [contentView setContentOffset:CGPointMake(0,0) animated:YES];
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
    
    pageNumber2 = 0;
    
    [self showLoadHUDMsg:@"努力加载中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:startDate, @"beg_time", endDate, @"end_time", [NSString stringWithFormat:@"%ld", (long)pageNumber2], @"page", nil];
    
    [HttpClientService requestTuucoindetails:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            detailsArray2 = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"details"]];
            
                if ([[jsonDic objectForKey:@"member_type"] isEqualToString:@"0"]) {
                    gradeImage.image = [UIImage imageNamed:@"mine_grade_0"];
                    gradeLabel.text = @"普通会员";
                }else if ([[jsonDic objectForKey:@"member_type"] isEqualToString:@"1"]) {
                    gradeImage.image = [UIImage imageNamed:@"mine_grade_1"];
                    gradeLabel.text = @"铜牌会员";
                }else if ([[jsonDic objectForKey:@"member_type"] isEqualToString:@"2"]) {
                    gradeImage.image = [UIImage imageNamed:@"mine_grade_2"];
                    gradeLabel.text = @"银牌会员";
                }else if ([[jsonDic objectForKey:@"member_type"] isEqualToString:@"3"]) {
                    gradeImage.image = [UIImage imageNamed:@"mine_grade_3"];
                    gradeLabel.text = @"金牌会员";
                }else if ([[jsonDic objectForKey:@"member_type"] isEqualToString:@"4"]) {
                    gradeImage.image = [UIImage imageNamed:@"mine_grade_4"];
                    gradeLabel.text = @"钻石会员";
                }
                
            
                radixLabel.text = [jsonDic objectForKey:@"radix"];
                
                pageNumber2++;
   
            
            piont1.text = [jsonDic objectForKey:@"useable"];
            piont2.text = [jsonDic objectForKey:@"used"];
            piont3.text = [jsonDic objectForKey:@"addup"];
            
            [contentView reloadData];
            [contentView setContentOffset:CGPointMake(0,0) animated:YES];
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
    if ([tabType isEqualToString:@"积分记录"]) {
        return [detailsArray1 count];
    }else {
        return [detailsArray2 count];
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
    if ([tabType isEqualToString:@"积分记录"]) {
        
        MinePointCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier1];
        if (cell == nil) {
            cell = [[MinePointCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier1];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if ([detailsArray1[indexPath.row][@"money"] floatValue] > 0) {
            cell.title.text = [NSString stringWithFormat:@"%@:%@", detailsArray1[indexPath.row][@"engender_type"], detailsArray1[indexPath.row][@"money"]];
        }else {
            cell.title.text = [NSString stringWithFormat:@"%@", detailsArray1[indexPath.row][@"engender_type"]];
        }
        
        cell.detail.text = [NSString stringWithFormat:@"增加积分:%@", detailsArray1[indexPath.row][@"integral"]];
        cell.info.text = [NSString stringWithFormat:@"%@ %@", detailsArray1[indexPath.row][@"friend_type"], detailsArray1[indexPath.row][@"nick_name"]];
        
        
        if ([detailsArray1[indexPath.row][@"integral"] floatValue] > 0) {
            cell.subTitle.text = [NSString stringWithFormat:@"+ %@", detailsArray1[indexPath.row][@"integral"]];
        }else {
            cell.subTitle.text = [NSString stringWithFormat:@"  %@", detailsArray1[indexPath.row][@"integral"]];
        }
        
        
        cell.time.text = detailsArray1[indexPath.row][@"engender_time"];
        
        if ([detailsArray1[indexPath.row][@"friend_member_type"] isEqualToString:@"0"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_0"];
            cell.grageLabel.text = @"普通会员";
        }else if ([detailsArray1[indexPath.row][@"friend_member_type"] isEqualToString:@"1"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_1"];
            cell.grageLabel.text = @"铜牌会员";
        }else if ([detailsArray1[indexPath.row][@"friend_member_type"] isEqualToString:@"2"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_2"];
            cell.grageLabel.text = @"银牌会员";
        }else if ([detailsArray1[indexPath.row][@"friend_member_type"] isEqualToString:@"3"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_3"];
            cell.grageLabel.text = @"金牌会员";
        }else if ([detailsArray1[indexPath.row][@"friend_member_type"] isEqualToString:@"4"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_4"];
            cell.grageLabel.text = @"钻石会员";
        }
        
        cell.radix.text = detailsArray1[indexPath.row][@"radix"];
        
        
        
        return cell;
    }else {
        
        MinePointCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier2];
        if (cell == nil) {
            cell = [[MinePointCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier2];
        }
        
        if ([detailsArray2[indexPath.row][@"money"] floatValue] > 0) {
            cell.title.text = [NSString stringWithFormat:@"%@:%@", detailsArray2[indexPath.row][@"engender_type"], detailsArray2[indexPath.row][@"money"]];
        }else {
            cell.title.text = [NSString stringWithFormat:@"%@", detailsArray2[indexPath.row][@"engender_type"]];
        }
        
        
        cell.detail.text = [NSString stringWithFormat:@"转换兔币:%@", detailsArray2[indexPath.row][@"tuu_coin"]];
        cell.info.text = [NSString stringWithFormat:@"%@ %@", detailsArray2[indexPath.row][@"friend_type"], detailsArray2[indexPath.row][@"nick_name"]];
        
        if ([detailsArray2[indexPath.row][@"tuu_coin"] floatValue] > 0) {
            cell.subTitle.text = [NSString stringWithFormat:@"+ %@", detailsArray2[indexPath.row][@"tuu_coin"]];
        }else {
            cell.subTitle.text = [NSString stringWithFormat:@"  %@", detailsArray2[indexPath.row][@"tuu_coin"]];
        }

        cell.time.text = detailsArray2[indexPath.row][@"engender_time"];
        
        if ([detailsArray2[indexPath.row][@"friend_member_type"] isEqualToString:@"0"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_0"];
                        cell.grageLabel.text = @"普通会员";
        }else if ([detailsArray2[indexPath.row][@"friend_member_type"] isEqualToString:@"1"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_1"];
                        cell.grageLabel.text = @"铜牌会员";
        }else if ([detailsArray2[indexPath.row][@"friend_member_type"] isEqualToString:@"2"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_2"];
                        cell.grageLabel.text = @"银牌会员";
        }else if ([detailsArray2[indexPath.row][@"friend_member_type"] isEqualToString:@"3"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_3"];
                        cell.grageLabel.text = @"金牌会员";
        }else if ([detailsArray2[indexPath.row][@"friend_member_type"] isEqualToString:@"4"]) {
            cell.gradeImage.image = [UIImage imageNamed:@"mine_grade_4"];
                        cell.grageLabel.text = @"钻石会员";
        }
        
        cell.radix.text = detailsArray2[indexPath.row][@"radix"];
        
        
        return cell;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
 
}

- (void)loadNewData {
    
    if ([tabType isEqualToString:@"积分记录"]) {
        
        [self showLoadHUDMsg:@"努力加载中..."];
        
        pageNumber1 = 0;
        
        
        NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@ 00:00:00", dateLabel1.text], @"beg_time", [NSString stringWithFormat:@"%@ 23:59:59", dateLabel2.text], @"end_time",[NSString stringWithFormat:@"%ld", (long)pageNumber1], @"page", nil];
        
        [HttpClientService requestIntegraldetails:paramDic success:^(id responseObject) {
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            int status = [[jsonDic objectForKey:@"status"] intValue];
            
            if (status == 0) {
                
                detailsArray1 = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"details"]];
                
                
                if ([detailsArray1 count] > 0) {
                    
                    [contentView setHidden:NO];
                    
                    [contentView.mj_header endRefreshing];
                    [contentView.mj_footer endRefreshing];
                    [contentView reloadData];
                    pageNumber1++;
                    
                }
                
                [self hideLoadHUD:YES];
            }
            
        } failure:^(NSError *error) {
            
            [contentView.mj_header endRefreshing];
            
            [self hideLoadHUD:YES];
            
            NSLog(@"请求炸鸡美食失败");
        }];

    }else {
        
        [self showLoadHUDMsg:@"努力加载中..."];
        
        pageNumber2 = 0;
        
        NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@ 00:00:00", dateLabel1.text], @"beg_time", [NSString stringWithFormat:@"%@ 23:59:59", dateLabel2.text], @"end_time",[NSString stringWithFormat:@"%ld", (long)pageNumber2], @"page", nil];
        
        [HttpClientService requestTuucoindetails:paramDic success:^(id responseObject) {
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            int status = [[jsonDic objectForKey:@"status"] intValue];
            
            if (status == 0) {
                
                detailsArray2 = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"details"]];
                
                
                if ([detailsArray2 count] > 0) {
                    
                    [contentView setHidden:NO];
                    
                    [contentView.mj_header endRefreshing];
                    [contentView.mj_footer endRefreshing];
                    [contentView reloadData];
                    pageNumber2++;
                    
                }
                
                [self hideLoadHUD:YES];
            }
            
        } failure:^(NSError *error) {
            
            [contentView.mj_header endRefreshing];
            
            [self hideLoadHUD:YES];
            
            NSLog(@"请求炸鸡美食失败");
        }];

        
    }
    
    
}


- (void)loadMoreData {
    
    if ([tabType isEqualToString:@"积分记录"]) {
        
        [self showLoadHUDMsg:@"努力加载中..."];
        
        NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@ 00:00:00", dateLabel1.text], @"beg_time", [NSString stringWithFormat:@"%@ 23:59:59", dateLabel2.text], @"end_time",[NSString stringWithFormat:@"%ld", (long)pageNumber1], @"page", nil];
        
        [HttpClientService requestIntegraldetails:paramDic success:^(id responseObject) {
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            int status = [[jsonDic objectForKey:@"status"] intValue];
            
            if (status == 0) {
                
                NSMutableArray *array = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"details"]];
                
                if (array.count == 0) {
                    
                    [self hideLoadHUD:YES];
                    
                    [self showMsg:@"没有更多信息了"];
                    
                    [contentView.mj_footer endRefreshingWithNoMoreData];
                    
                }else if (array.count > 0 && array.count < 20) {
                    
                    for (int i = 0; i<array.count; i++) {
                        
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        
                        dic = [array objectAtIndex:i];
                        
                        [detailsArray1 addObject:dic];
                    }
                    
                    [contentView reloadData];
                    
                    [self hideLoadHUD:YES];
                    
                    [contentView.mj_footer endRefreshingWithNoMoreData];
                    
                }else {
                    
                    for (int i = 0; i<array.count; i++) {
                        
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        
                        dic = [array objectAtIndex:i];
                        
                        [detailsArray1 addObject:dic];
                    }
                    pageNumber1++;
                    
                    [contentView reloadData];
                    
                    [self hideLoadHUD:YES];
                    
                    [contentView.mj_footer endRefreshing];
                    
                }
                
            }
            
        } failure:^(NSError *error) {
            
            [self hideLoadHUD:YES];
            
            [self showMsg:@"加载失败"];
            
            [contentView.mj_footer endRefreshing];
            
        }];

        
    }else {
        
        [self showLoadHUDMsg:@"努力加载中..."];
        
        NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@ 00:00:00", dateLabel1.text], @"beg_time", [NSString stringWithFormat:@"%@ 23:59:59", dateLabel2.text], @"end_time",[NSString stringWithFormat:@"%ld", (long)pageNumber2], @"page", nil];
        
        [HttpClientService requestTuucoindetails:paramDic success:^(id responseObject) {
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            int status = [[jsonDic objectForKey:@"status"] intValue];
            
            if (status == 0) {
                
                NSMutableArray *array = [NSMutableArray arrayWithArray:[jsonDic objectForKey:@"details"]];
                
                if (array.count == 0) {
                    
                    [self hideLoadHUD:YES];
                    
                    [self showMsg:@"没有更多信息了"];
                    
                    [contentView.mj_footer endRefreshingWithNoMoreData];
                    
                }else if (array.count > 0 && array.count < 20) {
                    
                    for (int i = 0; i<array.count; i++) {
                        
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        
                        dic = [array objectAtIndex:i];
                        
                        [detailsArray2 addObject:dic];
                    }
                    
                    [contentView reloadData];
                    
                    [self hideLoadHUD:YES];
                    
                    [contentView.mj_footer endRefreshingWithNoMoreData];
                    
                }else {
                    
                    for (int i = 0; i<array.count; i++) {
                        
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        
                        dic = [array objectAtIndex:i];
                        
                        [detailsArray2 addObject:dic];
                    }
                    pageNumber2++;
                    
                    [contentView reloadData];
                    
                    [self hideLoadHUD:YES];
                    
                    [contentView.mj_footer endRefreshing];
                    
                }
                
            }
            
        } failure:^(NSError *error) {
            
            [self hideLoadHUD:YES];
            
            [self showMsg:@"加载失败"];
            
            [contentView.mj_footer endRefreshing];
            
        }];
    }
}


#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}
@end
