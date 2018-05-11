//
//  LoginViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/5/27.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ResetPasswordViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface LoginViewController ()<UITextFieldDelegate> {
    UIScrollView *contentView;
    
    UITextField *phoneTextField;
    UITextField *psdTextField;
}

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        navigationBar.backgroundColor = [UIColor colorWithRed:(255)/255.0 green:(184)/255.0 blue:(63)/255.0 alpha:0.0];
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_bg"] forState:UIControlStateNormal];
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroundClick)];
        [contentView addGestureRecognizer:tap];
        [self.view addSubview:contentView];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bgImageView.image = [UIImage imageNamed:@"mine_content_bg"];
        [contentView addSubview:bgImageView];
        
        UIImageView *whiteBg = [[UIImageView alloc] initWithFrame:CGRectMake(20*SCALE, SCREEN_HEIGHT-40*SCALE-500*SCALE, SCREEN_WIDTH-40*SCALE, 500*SCALE)];
        whiteBg.image = [UIImage imageNamed:@"mine_white_bg"];
        [contentView addSubview:whiteBg];
        
        //请登录
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 250*SCALE, SCREEN_WIDTH, 30*SCALE)];
        titleLabel.text = @"请登录";
        titleLabel.font = [UIFont boldSystemFontOfSize:19.0*SCALE];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:titleLabel];
        
        UIImageView *phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30*SCALE, 355*SCALE, 22*SCALE, 22*SCALE)];
        phoneImageView.image = [UIImage imageNamed:@"mine_phone"];
        [contentView addSubview:phoneImageView];
        
        UIImageView *psdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30*SCALE, 415*SCALE, 22*SCALE, 22*SCALE)];
        psdImageView.image = [UIImage imageNamed:@"mine_psd"];
        [contentView addSubview:psdImageView];
        
        
        //手机号
        phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(phoneImageView.frame.origin.x+phoneImageView.frame.size.width+10*SCALE, 350*SCALE, 180*SCALE, 30*SCALE)];
//        phoneTextField.backgroundColor = [UIColor yellowColor];
        phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请输入手机号码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        phoneTextField.textColor = [UIColor blackColor];
        phoneTextField.font = [UIFont systemFontOfSize:16.0*SCALE];
        phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        phoneTextField.delegate = self;
        //        _phoneTextField.secureTextEntry = YES;
        phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        phoneTextField.inputAccessoryView = [self addToolbar];
        [contentView addSubview:phoneTextField];
        
        UIView *phoneLine = [[UIView alloc] initWithFrame:CGRectMake(60*SCALE, phoneTextField.frame.origin.y+phoneTextField.frame.size.height+10*SCALE, SCREEN_WIDTH-100*SCALE, 1)];
        phoneLine.backgroundColor = [UIColor colorWithRed:(244)/255.0 green:(244)/255.0 blue:(244)/255.0 alpha:1.0];
        [contentView addSubview:phoneLine];
        
        
        //密码
        psdTextField = [[UITextField alloc] initWithFrame:CGRectMake(psdImageView.frame.origin.x+psdImageView.frame.size.width+10*SCALE, 410*SCALE, 180*SCALE, 30*SCALE)];
//        psdTextField.backgroundColor = [UIColor yellowColor];
        psdTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请输入密码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        psdTextField.textColor = [UIColor blackColor];
        psdTextField.font = [UIFont systemFontOfSize:16.0*SCALE];
        psdTextField.delegate = self;
        psdTextField.secureTextEntry = YES;
        psdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [contentView addSubview:psdTextField];
        
        UIView *psdLine = [[UIView alloc] initWithFrame:CGRectMake(60*SCALE, psdTextField.frame.origin.y+psdTextField.frame.size.height+10*SCALE, SCREEN_WIDTH-100*SCALE, 1)];
        psdLine.backgroundColor = [UIColor colorWithRed:(244)/255.0 green:(244)/255.0 blue:(244)/255.0 alpha:1.0];
        [contentView addSubview:psdLine];
        
        //忘记密码
        UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [forgetBtn setFrame:CGRectMake(psdTextField.frame.origin.x+psdTextField.frame.size.width+20*SCALE, 400*SCALE, 70*SCALE, 44*SCALE)];
        [forgetBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:@"忘记密码"
                                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f*SCALE],NSForegroundColorAttributeName:MAIN_COLOR}];
        [forgetBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
        [forgetBtn addTarget:self action:@selector(forgetEvent) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:forgetBtn];
        
        // 登录
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [loginBtn setFrame:CGRectMake(50*SCALE, CGRectGetMaxY(forgetBtn.frame)+45*SCALE, SCREEN_WIDTH-100*SCALE, 44*SCALE)];
        [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:17.0*SCALE];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn setBackgroundImage:[UIImage imageNamed:@"mine_login_btn"] forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(loginEvent) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:loginBtn];
        
        //注册
        UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [registerBtn setFrame:CGRectMake((SCREEN_WIDTH - 70*SCALE)/2, CGRectGetMaxY(loginBtn.frame)+15*SCALE, 70*SCALE, 44*SCALE)];
        [registerBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        
        NSAttributedString *registerStr =[[NSAttributedString alloc]initWithString:@"用户注册"
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f*SCALE],NSForegroundColorAttributeName:MAIN_COLOR, NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:MAIN_COLOR,NSBaselineOffsetAttributeName:@(0)}];
        
        [registerBtn setAttributedTitle:registerStr forState:UIControlStateNormal];
        [registerBtn addTarget:self action:@selector(registerEvent) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:registerBtn];
        
        [self.view bringSubviewToFront:navigationBar];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)backGroundClick{
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    if (textField == phoneTextField) {
        
        [psdTextField becomeFirstResponder];
        
    } else {
        [phoneTextField resignFirstResponder];
        
        [psdTextField resignFirstResponder];
        
        [self loginEvent];
        
    }
    
    return YES;
    
}

- (void)textFieldDone {
    
    [psdTextField becomeFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == phoneTextField) {
        
        int offset = contentView.frame.size.height - 216 - CGRectGetMaxY(textField.frame) - 50 - 35;
        
        if (offset < 0) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                [contentView setContentOffset:CGPointMake(0, -offset) animated:NO];
                
            }completion:^(BOOL finished) {
                
            }];
            
            
        }
    }else{
        int offset = contentView.frame.size.height - 216 - CGRectGetMaxY(textField.frame) - 50;
        
        if (offset < 0) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                [contentView setContentOffset:CGPointMake(0, -offset) animated:NO];
                
            }completion:^(BOOL finished) {
                
            }];
        }
    }
    
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [contentView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

- (void)loginEvent {
    [self showLoadHUDMsg:@"正在登录..."];
    
    NSString *stamp = @"62727378627273786272737862727378";
    
    NSString *temp = [NSString stringWithFormat:@"%@%@", [[self md5:psdTextField.text] uppercaseString], [[self md5:stamp] uppercaseString]];
    
    //真机 TODO OPEN
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:phoneTextField.text, @"tel_no", @"1", @"device_type", [[UserDefaults service] getDeviceToken], @"device_token", [[self md5:temp] uppercaseString], @"user_password", [[self md5:stamp] uppercaseString], @"stamp", nil];
    
    //模拟器 TODO DELETE
//    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:phoneTextField.text, @"tel_no", @"1", @"device_type", @"c00df9049925d6cb7357c17d768b13a1a6248d2b1679f64d717b7ea79a8ee592", @"device_token", [[self md5:temp] uppercaseString], @"user_password", [[self md5:stamp] uppercaseString], @"stamp", nil];
    
    [HttpClientService requestLogin:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            [[UserDefaults service] updateSessionId:[jsonDic objectForKey:@"session_id"]];
            
            //兔币
            [[UserDefaults service] updateIntegral:[jsonDic objectForKey:@"integral"]];
            
            //星级
            [[UserDefaults service] updateValueStar:[jsonDic objectForKey:@"value_star"]];
            
            //会员等级 0 注册会员1铜牌会员2银牌会员,3 金牌会员,4 钻石会员
            [[UserDefaults service] updateGrade:[jsonDic objectForKey:@"grade"]];
           
            //昵称
            [[UserDefaults service] updateNickName:[jsonDic objectForKey:@"nick_name"]];
            
            //性别
            [[UserDefaults service] updateGender:[jsonDic objectForKey:@"gender"]];
            
            [[UserDefaults service] updateName:@""];
            [[UserDefaults service] updateAddressGender:@""];
            [[UserDefaults service] updateAddressPhone:@""];
            [[UserDefaults service] updateAddress:@""];
            [[UserDefaults service] updateBuilding:@""];
            [[UserDefaults service] updateAddressLatitude:@""];
            [[UserDefaults service] updateAddressLongitude:@""];

            [self hideLoadHUD:YES];
            [self showCustomDialog:@"登录成功"];
        }else if (status == 114){
            [self hideLoadHUD:YES];
            [self showMsg:@"用户未找到"];
        }else if (status == 115){
            [self hideLoadHUD:YES];
            [self showMsg:@"密码错误"];
        }else {
            [self hideLoadHUD:YES];
//            [self showMsg:@"未知错误"];
        }
    } failure:^(NSError *error) {
        [self hideLoadHUD:YES];
//        [self showMsg:@"登录失败"];
        
    }];
}

- (void)registerEvent {
    RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];
    
    PUSH(registerViewController);
}

- (void)forgetEvent {
    ResetPasswordViewController *resetPasswordViewController = [[ResetPasswordViewController alloc] initWithNibName:nil bundle:nil];
    
    PUSH(resetPasswordViewController);
}

- (UIToolbar *)addToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 35)];
    toolbar.tintColor = MAIN_COLOR;
    toolbar.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
    toolbar.items = @[space, bar];
    return toolbar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)md5:(NSString *)input {
    
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}


@end
