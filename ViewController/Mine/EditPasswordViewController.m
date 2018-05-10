//
//  EditPasswordViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/8/23.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "EditPasswordViewController.h"
#import "LoginViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface EditPasswordViewController ()<UITextFieldDelegate> {
    
    UIScrollView *contentView;
    
    UITextField *psd0TextField;
    
    UITextField *psd1TextField;
    UITextField *psd2TextField;
    
}

@end

@implementation EditPasswordViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        navigationBar.titleLabel.text = @"修改密码";
        [navigationBar.leftButton setHidden:NO];
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroundClick)];
        [contentView addGestureRecognizer:tap];
        [self.view addSubview:contentView];
        
        
        //旧密码
        UIImageView *phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30*SCALE, (20+90-64)*SCALE, 29*SCALE, 29*SCALE)];
        phoneImageView.image = [UIImage imageNamed:@"mine_psd"];
        [contentView addSubview:phoneImageView];
        
        //密码
        UIImageView *psdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30*SCALE, (20+140-64)*SCALE, 29*SCALE, 29*SCALE)];
        psdImageView.image = [UIImage imageNamed:@"mine_psd"];
        [contentView addSubview:psdImageView];
        
        //再次密码
        UIImageView *psd2ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30*SCALE, (20+190-64)*SCALE, 29*SCALE, 29*SCALE)];
        psd2ImageView.image = [UIImage imageNamed:@"mine_psd"];
        [contentView addSubview:psd2ImageView];
        
        
        //手机号
        psd0TextField = [[UITextField alloc] initWithFrame:CGRectMake(phoneImageView.frame.origin.x+phoneImageView.frame.size.width+10*SCALE, (20+90-64)*SCALE, 260*SCALE, 30*SCALE)];
        //        phoneTextField.backgroundColor = [UIColor redColor];
        psd0TextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请输入旧密码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        psd0TextField.textColor = [UIColor blackColor];
        psd0TextField.font = [UIFont systemFontOfSize:16.0*SCALE];
        psd0TextField.delegate = self;
        psd0TextField.secureTextEntry = YES;
        psd0TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [contentView addSubview:psd0TextField];
        
        UIView *phoneLine = [[UIView alloc] initWithFrame:CGRectMake(20*SCALE, psd0TextField.frame.origin.y+psd0TextField.frame.size.height+5*SCALE, SCREEN_WIDTH-20*2*SCALE, 0.5)];
        phoneLine.backgroundColor = [UIColor lightGrayColor];
        [contentView addSubview:phoneLine];
        
        
        //密码
        psd1TextField = [[UITextField alloc] initWithFrame:CGRectMake(psdImageView.frame.origin.x+psdImageView.frame.size.width+10*SCALE, (20+140-64)*SCALE, 260*SCALE, 30*SCALE)];
        //        psdTextField.backgroundColor = [UIColor redColor];
        psd1TextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请输入6位以上密码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        psd1TextField.textColor = [UIColor blackColor];
        psd1TextField.font = [UIFont systemFontOfSize:16.0*SCALE];
        psd1TextField.delegate = self;
        psd1TextField.secureTextEntry = YES;
        psd1TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [contentView addSubview:psd1TextField];
        
        UIView *psdLine = [[UIView alloc] initWithFrame:CGRectMake(20*SCALE, psd1TextField.frame.origin.y+psd1TextField.frame.size.height+5*SCALE, SCREEN_WIDTH-20*2*SCALE, 0.5)];
        psdLine.backgroundColor = [UIColor lightGrayColor];
        [contentView addSubview:psdLine];
        
        //再次密码
        psd2TextField = [[UITextField alloc] initWithFrame:CGRectMake(phoneImageView.frame.origin.x+phoneImageView.frame.size.width+10*SCALE, (20+190-64)*SCALE, 260*SCALE, 30*SCALE)];
        //        phoneTextField.backgroundColor = [UIColor redColor];
        psd2TextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 确认密码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        psd2TextField.textColor = [UIColor blackColor];
        psd2TextField.font = [UIFont systemFontOfSize:16.0*SCALE];
        psd2TextField.delegate = self;
        psd2TextField.secureTextEntry = YES;
        psd2TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [contentView addSubview:psd2TextField];
        
        UIView *psd2Line = [[UIView alloc] initWithFrame:CGRectMake(20*SCALE, psd2TextField.frame.origin.y+psd2TextField.frame.size.height+5*SCALE, SCREEN_WIDTH-20*2*SCALE, 0.5)];
        psd2Line.backgroundColor = [UIColor lightGrayColor];
        [contentView addSubview:psd2Line];
        
        //重置密码
        UIButton *resetPsdBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [resetPsdBtn setFrame:CGRectMake(20, (40+330-64)*SCALE, SCREEN_WIDTH -20*2, 44*SCALE)];
        [resetPsdBtn.layer setMasksToBounds:YES];
        [resetPsdBtn.layer setCornerRadius:6.0];
        //        loginBtn.backgroundColor = MAIN_COLOR;
        [resetPsdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        resetPsdBtn.titleLabel.font = [UIFont systemFontOfSize:18.0*SCALE];
        [resetPsdBtn setTitle:@"修 改" forState:UIControlStateNormal];
        [resetPsdBtn setBackgroundImage:[UIImage imageNamed:@"order_appraise"] forState:UIControlStateNormal];
//        [resetPsdBtn setBackgroundImage:[UIImage imageNamed:@"order_appraise"] forState:UIControlStateHighlighted];
        [resetPsdBtn addTarget:self action:@selector(resetPsdEvent) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:resetPsdBtn];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self hideTabBar:self.tabBarController];
    self.tabBarController.tabBar.hidden=YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetPsdEvent {
    
    [psd0TextField resignFirstResponder];
    
    [psd1TextField resignFirstResponder];
    
    [psd2TextField resignFirstResponder];
    
    if([psd0TextField.text isEqualToString:@""] || [psd1TextField.text isEqualToString:@""] || [psd2TextField.text isEqualToString:@""]){
        
        [self showMsg:@"请输入完整信息"];
        return;
    }
    
    if (psd1TextField.text.length != 6) {
        
        [self showMsg:@"新密码格式不正确"];
        return;
    }
    
    
    if (![psd1TextField.text isEqualToString:psd2TextField.text]) {
        [self showMsg:@"新密码不一致"];
        return;
    }
    
    [self showLoadHUDMsg:@"正在修改密码..."];
    
    NSString *stamp = @"62727378627273786272737862727378";

    
    NSString *temp = [NSString stringWithFormat:@"%@%@", [[self md5:psd0TextField.text] uppercaseString], [[self md5:stamp] uppercaseString]];
    
    
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:[[self md5:stamp] uppercaseString], @"stamp", [[self md5:temp] uppercaseString] , @"user_password", [[self md5:psd1TextField.text] uppercaseString], @"new_password", nil];
    
    
    //TODO
    
    [HttpClientService requestPasswordmodify:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            
            
            [self hideLoadHUD:YES];
            [self showCustomDialog:@"密码修改成功"];
            
        }else if (status == 202) {
            [self showMsg:@"您的登录状态失效，请重新登录"];
            [self hideLoadHUD:YES];
            sleep(1.0);
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
            
        }else if (status == 115) {
            
            [self hideLoadHUD:YES];
            [self showMsg:@"密码不正确"];
            
        }else {
            [self hideLoadHUD:YES];
            [self showMsg:[NSString stringWithFormat:@"错误码%d", status]];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
        NSLog(@"修改密码失败");
    }];

    
}

- (void)backGroundClick{
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    if (textField == psd0TextField) {
        
        [psd1TextField becomeFirstResponder];
        
    }if (textField == psd1TextField) {
        
        [psd2TextField becomeFirstResponder];
        
    }else {
        
        [self resetPsdEvent];
        
    }
    
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    int offset = contentView.frame.size.height - 216 - CGRectGetMaxY(textField.frame) - 50;
    
    if (offset < 0) {
        
        [contentView setContentOffset:CGPointMake(0, -offset) animated:YES];
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [contentView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender
{
    POP;
}

- (NSString *)md5:(NSString *)input {
    
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

@end
