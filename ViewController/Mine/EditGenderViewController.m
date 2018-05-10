//
//  EditGenderViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/9/21.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "EditGenderViewController.h"

@interface EditGenderViewController () {
    UIImageView *maleImage;
    UIImageView *femaleImage;
    NSString *is_male;
}

@end

@implementation EditGenderViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        navigationBar.titleLabel.text = @"修改性别";
        [navigationBar.leftButton setHidden:NO];
        
        [navigationBar.editButton setTitle:@"完成" forState:UIControlStateNormal];
        [navigationBar.editButton setHidden:NO];
    
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 120*SCALE, SCREEN_WIDTH, 40*SCALE)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgView];
        
        //性别
        //男
        maleImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, 10*SCALE+1, 20*SCALE, 20*SCALE)];
        maleImage.image = [UIImage imageNamed:@"male_selected"];
        [bgView addSubview:maleImage];
        
        UILabel *maleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maleImage.frame)+5*SCALE, 10*SCALE+1, 40*SCALE, 20*SCALE)];
        maleLabel.text = @"先生";
        maleLabel.textColor = [UIColor lightGrayColor];
        maleLabel.font = [UIFont systemFontOfSize:13*SCALE];
        [bgView addSubview:maleLabel];
        
        UIButton *maleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [maleBtn setFrame:CGRectMake(10*SCALE, 1, 80*SCALE, 40*SCALE)];
        [maleBtn addTarget:self action:@selector(maleBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:maleBtn];
        
        //女
        femaleImage = [[UIImageView alloc] initWithFrame:CGRectMake(100*SCALE, 10*SCALE+1, 20*SCALE, 20*SCALE)];
        femaleImage.image = [UIImage imageNamed:@"female_unselected"];
        [bgView addSubview:femaleImage];
        
        UILabel *femaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(femaleImage.frame)+5*SCALE, 10*SCALE+1, 40*SCALE, 20*SCALE)];
        femaleLabel.text = @"女士";
        femaleLabel.textColor = [UIColor lightGrayColor];
        femaleLabel.font = [UIFont systemFontOfSize:13*SCALE];
        [bgView addSubview:femaleLabel];
        
        UIButton *femaleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [femaleBtn setFrame:CGRectMake(100*SCALE, 1, 80*SCALE, 40*SCALE)];
        [femaleBtn addTarget:self action:@selector(femaleBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:femaleBtn];
        
        
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    if ([[[UserDefaults service] getGender] isEqualToString:@"0"]) {
        maleImage.image = [UIImage imageNamed:@"male_unselected"];
        femaleImage.image = [UIImage imageNamed:@"female_selected"];
        is_male = @"0";
        
    }else if ([[[UserDefaults service] getGender] isEqualToString:@"1"]){
        maleImage.image = [UIImage imageNamed:@"male_selected"];
        femaleImage.image = [UIImage imageNamed:@"female_unselected"];
        is_male = @"1";
    }else {
        [[UserDefaults service] updateGender:@"0"];
        maleImage.image = [UIImage imageNamed:@"male_unselected"];
        femaleImage.image = [UIImage imageNamed:@"female_selected"];
        is_male = @"0";
    }
}

- (void)maleBtnEvent {
    maleImage.image = [UIImage imageNamed:@"male_selected"];
    femaleImage.image = [UIImage imageNamed:@"female_unselected"];
    is_male = @"1";
}

- (void)femaleBtnEvent {
    maleImage.image = [UIImage imageNamed:@"male_unselected"];
    femaleImage.image = [UIImage imageNamed:@"female_selected"];
    is_male = @"0";
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

- (void)editBtnClick:(id)sender {
    
    [self showLoadHUDMsg:@"修改中..."];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
 
            [paramDic setObject:[[UserDefaults service] getName] forKey:@"nick_name"];
            [paramDic setObject:is_male forKey:@"is_male"];
    
    [HttpClientService requestSetpersonalinfo:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            [self hideLoadHUD:YES];
            
            POP;
        }if (status == 202) {
            
            [[UserDefaults service] updateSessionId:@""];
            
            [self hideLoadHUD:YES];
            
            [self showMsgWithPop:@"其他设备登录您的账号，请重新登录"];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
    }];
}


@end
