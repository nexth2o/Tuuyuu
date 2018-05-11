//
//  ResetPasswordViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/5/31.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import<CommonCrypto/CommonDigest.h>

@interface ResetPasswordViewController ()<UITextFieldDelegate> {
    UIScrollView *contentView;
    UITextField *phoneTextField;
    UITextField *psdTextField;
    UITextField *psd2TextField;
    UITextField *codeTextField;
    UIButton *codeBtn;
    UILabel *codeLabel;
    int timeout;
}

@end

@implementation ResetPasswordViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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
        
        //重置密码
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200*SCALE, SCREEN_WIDTH, 30*SCALE)];
        titleLabel.text = @"重置密码";
        titleLabel.font = [UIFont boldSystemFontOfSize:19.0*SCALE];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:titleLabel];
        
        //手机号
        UIImageView *phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30*SCALE, 280*SCALE, 22*SCALE, 22*SCALE)];
        phoneImageView.image = [UIImage imageNamed:@"mine_phone"];
        [contentView addSubview:phoneImageView];
        
        //密码
        UIImageView *psdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30*SCALE, 345*SCALE, 22*SCALE, 22*SCALE)];
        psdImageView.image = [UIImage imageNamed:@"mine_psd"];
        [contentView addSubview:psdImageView];
        
        //再次密码
        UIImageView *psd2ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30*SCALE, 410*SCALE, 22*SCALE, 22*SCALE)];
        psd2ImageView.image = [UIImage imageNamed:@"mine_psd"];
        [contentView addSubview:psd2ImageView];
        
        //验证码
        UIImageView *codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30*SCALE, 475*SCALE, 22*SCALE, 22*SCALE)];
        codeImageView.image = [UIImage imageNamed:@"mine_code"];
        [contentView addSubview:codeImageView];
        
        //手机号
        phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(phoneImageView.frame.origin.x+phoneImageView.frame.size.width+10*SCALE, 275*SCALE, 180*SCALE, 30*SCALE)];
        //        phoneTextField.backgroundColor = [UIColor redColor];
        phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请输入11位手机号码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        phoneTextField.textColor = [UIColor blackColor];
        phoneTextField.font = [UIFont systemFontOfSize:16.0*SCALE];
        phoneTextField.delegate = self;
        phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        phoneTextField.inputAccessoryView = [self addToolbar];
        phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [contentView addSubview:phoneTextField];
        
        UIView *phoneLine = [[UIView alloc] initWithFrame:CGRectMake(60*SCALE, phoneTextField.frame.origin.y+phoneTextField.frame.size.height+10*SCALE, SCREEN_WIDTH-100*SCALE, 1)];
        phoneLine.backgroundColor = [UIColor colorWithRed:(244)/255.0 green:(244)/255.0 blue:(244)/255.0 alpha:1.0];
        [contentView addSubview:phoneLine];
        
        //密码
        psdTextField = [[UITextField alloc] initWithFrame:CGRectMake(psdImageView.frame.origin.x+psdImageView.frame.size.width+10*SCALE, 340*SCALE, 180*SCALE, 30*SCALE)];
        //        psdTextField.backgroundColor = [UIColor redColor];
        psdTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请输入新密码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        psdTextField.textColor = [UIColor blackColor];
        psdTextField.font = [UIFont systemFontOfSize:16.0*SCALE];
        psdTextField.delegate = self;
        psdTextField.secureTextEntry = YES;
        psdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [contentView addSubview:psdTextField];
        
        UIView *psdLine = [[UIView alloc] initWithFrame:CGRectMake(60*SCALE, psdTextField.frame.origin.y+psdTextField.frame.size.height+10*SCALE, SCREEN_WIDTH-100*SCALE, 1)];
        psdLine.backgroundColor = [UIColor colorWithRed:(244)/255.0 green:(244)/255.0 blue:(244)/255.0 alpha:1.0];
        [contentView addSubview:psdLine];
        
        //再次密码
        psd2TextField = [[UITextField alloc] initWithFrame:CGRectMake(phoneImageView.frame.origin.x+phoneImageView.frame.size.width+10*SCALE, 405*SCALE, 180*SCALE, 30*SCALE)];
        //        phoneTextField.backgroundColor = [UIColor redColor];
        psd2TextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 确认密码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        psd2TextField.textColor = [UIColor blackColor];
        psd2TextField.font = [UIFont systemFontOfSize:16.0*SCALE];
        psd2TextField.delegate = self;
        psd2TextField.secureTextEntry = YES;
        psd2TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [contentView addSubview:psd2TextField];
        
        UIView *psd2Line = [[UIView alloc] initWithFrame:CGRectMake(60*SCALE, psd2TextField.frame.origin.y+psd2TextField.frame.size.height+10*SCALE, SCREEN_WIDTH-100*SCALE, 1)];
        psd2Line.backgroundColor = [UIColor colorWithRed:(244)/255.0 green:(244)/255.0 blue:(244)/255.0 alpha:1.0];
        [contentView addSubview:psd2Line];
        
        
        //验证码
        codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(psdImageView.frame.origin.x+psdImageView.frame.size.width+10*SCALE, 470*SCALE, 140*SCALE, 30*SCALE)];
        //        psdTextField.backgroundColor = [UIColor redColor];
        codeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请输入验证码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        codeTextField.textColor = [UIColor blackColor];
        codeTextField.font = [UIFont systemFontOfSize:16.0*SCALE];
        codeTextField.delegate = self;
        codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        codeTextField.inputAccessoryView = [self addToolbar2];
        codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [contentView addSubview:codeTextField];
        
        UIView *codeLine = [[UIView alloc] initWithFrame:CGRectMake(60*SCALE, codeTextField.frame.origin.y+codeTextField.frame.size.height+10*SCALE, SCREEN_WIDTH-100*SCALE, 1)];
        codeLine.backgroundColor = [UIColor colorWithRed:(244)/255.0 green:(244)/255.0 blue:(244)/255.0 alpha:1.0];
        [contentView addSubview:codeLine];
        
        //获取验证码
        codeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [codeBtn setFrame:CGRectMake(codeTextField.frame.origin.x+codeTextField.frame.size.width+40*SCALE, 460*SCALE, 100*SCALE, 44*SCALE)];
        //        [codeBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:@"获取验证码"
                                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f*SCALE],NSForegroundColorAttributeName:MAIN_COLOR}];
        [codeBtn addTarget:self action:@selector(codeEvent) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:codeBtn];
        
        codeLabel = [[UILabel alloc] initWithFrame:codeBtn.frame];
        [codeLabel setAttributedText:attrStr];
        [contentView addSubview:codeLabel];
        
        //重置密码
        UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        
        [registerBtn setFrame:CGRectMake(50*SCALE, CGRectGetMaxY(codeBtn.frame)+30*SCALE, SCREEN_WIDTH-100*SCALE, 44*SCALE)];
        [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        registerBtn.titleLabel.font = [UIFont systemFontOfSize:17.0*SCALE];
        [registerBtn setTitle:@"重置密码" forState:UIControlStateNormal];
        [registerBtn setBackgroundImage:[UIImage imageNamed:@"mine_login_btn"] forState:UIControlStateNormal];
        [registerBtn addTarget:self action:@selector(registerEvent) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view bringSubviewToFront:navigationBar];
        
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
        
    }else if (textField == psdTextField) {
        
        [psd2TextField becomeFirstResponder];
        
    }else if (textField == psd2TextField) {
        
        [codeTextField becomeFirstResponder];
        
    }else {
        [phoneTextField resignFirstResponder];
        
        [psdTextField resignFirstResponder];
        
        [psd2TextField resignFirstResponder];
        
        [codeTextField resignFirstResponder];
        
        [self registerEvent];
        
    }
    
    return YES;
    
}

- (void)textFieldDone {
    
    [psdTextField becomeFirstResponder];
}

- (void)textFieldDone2 {
    
    [phoneTextField resignFirstResponder];
    
    [psdTextField resignFirstResponder];
    
    [psd2TextField resignFirstResponder];
    
    [codeTextField resignFirstResponder];
    
    [self registerEvent];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    int offset = contentView.frame.size.height - 216 - CGRectGetMaxY(textField.frame) - 50;
    
    if (offset < 0) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [contentView setContentOffset:CGPointMake(0, -offset) animated:NO];
            
        }completion:^(BOOL finished) {
            
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [contentView setContentOffset:CGPointMake(0, 0) animated:YES];
    
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

- (UIToolbar *)addToolbar2
{
    UIToolbar *toolbar2 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 35)];
    toolbar2.tintColor = MAIN_COLOR;
    toolbar2.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone2)];
    toolbar2.items = @[space, bar];
    return toolbar2;
}

- (void)codeEvent{
    
    if (phoneTextField.text.length > 0 && phoneTextField.text.length == 11) {
        
        NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:phoneTextField.text, @"tel_no", nil];
        
        [HttpClientService requestVerificationCode:paramDic success:^(id responseObject) {
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            int status = [[jsonDic objectForKey:@"status"] intValue];
            
            if (status == 0) {
                [self showMsg:@"获取验证码成功"];
            }else if (status == 2) {
                [self showMsg:@"注册的用户已存在"];
                timeout = 0;
            }else if (status == 4){
                [self showMsg:@"请求太频烦，每分钟只能请求一次"];
            }else if (status == 5){
                [self showMsg:@"验证码发送出错"];
                timeout = 0;
            }else {
                [self showMsg:@"获取验证码失败"];
                timeout = 0;
            }
        } failure:^(NSError *error) {
            [self showMsg:@"获取验证码失败"];
            timeout = 0;
        }];
        
        timeout = 60;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
        
        dispatch_source_set_event_handler(_timer, ^{
            
            if(timeout <= 0){
                
                dispatch_source_cancel(_timer);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:@"获取验证码"
                                                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f*SCALE],NSForegroundColorAttributeName:MAIN_COLOR}];
                    [codeLabel setAttributedText:attrStr];
                    
                    codeBtn.userInteractionEnabled = YES;
                    
                });
                
            }else {
                
                int seconds = timeout;
                
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *codeStr = [NSString stringWithFormat:@"重新获取(%@)",strTime];
                    NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:codeStr
                                                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f*SCALE],NSForegroundColorAttributeName:[UIColor grayColor]}];
                    [codeLabel setAttributedText:attrStr];
                    
                    codeBtn.userInteractionEnabled = NO;
                    
                });
                
                timeout--;
                
            }
            
        });
        
        dispatch_resume(_timer);
        
    }else {
        
        [self showMsg:@"请输入正确的手机号码"];
    }
    
}

- (void)registerEvent {
    if([phoneTextField.text isEqualToString:@""] || [psdTextField.text isEqualToString:@""] || [psd2TextField.text isEqualToString:@""]) {
        
        [self showMsg:@"用户名或密码不能为空"];
        return;
    }
    
    if([codeTextField.text isEqualToString:@""] || codeTextField.text.length != 6){
        
        [self showMsg:@"请输入验证码"];
        return;
    }
    
    if (![psdTextField.text isEqualToString:psd2TextField.text]) {
        [self showMsg:@"两次密码不一致"];
        return;
    }
    
    if(codeTextField.text.length != 6){
        
        [self showMsg:@"验证码不正确"];
        return;
    }
    
    [self showLoadHUDMsg:@"密码重置中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:phoneTextField.text, @"tel_no", codeTextField.text, @"verfication_code", [[self md5:psdTextField.text] uppercaseString], @"new_password", nil];
    
    [HttpClientService requestForgetpassword:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            [self hideLoadHUD:YES];
            [self showCustomDialog:@"密码重置成功"];
        }else if (status == 110) {
            [self hideLoadHUD:YES];
            [self showMsg:@"验证码错误"];
        }else {
            [self hideLoadHUD:YES];
            [self showMsg:@"未知错误"];
        }
    } failure:^(NSError *error) {
        [self hideLoadHUD:YES];
        [self showMsg:@"注册失败"];
        
    }];
}


#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
