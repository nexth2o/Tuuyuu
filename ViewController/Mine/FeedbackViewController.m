//
//  FeedbackViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/10/16.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "FeedbackViewController.h"
#import "TTextView.h"
#import "LoginViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate> {
    TTextView *storeTextView;
    TTextView *phoneTextView;
    NSString *feedbackStr;
    NSString *phoneStr;
}

@end

@implementation FeedbackViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.titleLabel.text = @"意见反馈";
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_gray"] forState:UIControlStateNormal];
        [navigationBar.editButton setTitle:@"提交" forState:UIControlStateNormal];
        [navigationBar.editButton setHidden:NO];
        
        storeTextView = [[TTextView alloc] initWithFrame:CGRectMake(10*SCALE, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT+20*SCALE, SCREEN_WIDTH-20*SCALE, 140*SCALE)];
        storeTextView.backgroundColor = [UIColor whiteColor];
        storeTextView.font = [UIFont systemFontOfSize:15*SCALE];
        storeTextView.placeholder = @"请留下您的宝贵意见和建议，我们将努力改进。\n（80字以内）";
        storeTextView.placeholderFont = [UIFont systemFontOfSize:14*SCALE];
        storeTextView.placeholderColor = [UIColor grayColor];
        storeTextView.returnKeyType = UIReturnKeyDefault;
        storeTextView.delegate = self;
        [self.view addSubview:storeTextView];
        
        phoneTextView = [[TTextView alloc] initWithFrame:CGRectMake(10*SCALE, CGRectGetMaxY(storeTextView.frame)+20*SCALE, SCREEN_WIDTH-20*SCALE, 36*SCALE)];
        phoneTextView.backgroundColor = [UIColor whiteColor];
        phoneTextView.font = [UIFont systemFontOfSize:15*SCALE];
        phoneTextView.placeholder = @"请留下手机号，以便我们回复您";
        phoneTextView.placeholderFont = [UIFont systemFontOfSize:14*SCALE];
        phoneTextView.placeholderColor = [UIColor grayColor];
        phoneTextView.returnKeyType = UIReturnKeyDefault;
        phoneTextView.keyboardType = UIKeyboardTypeNumberPad;
        phoneTextView.delegate = self;
        [self.view addSubview:phoneTextView];
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [[UserDefaults service] updateOrderNote:@""];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - UITextViewDelegate Methods
//编辑结束
-(void)textViewDidEndEditing:(UITextView *)textView {
    
    if (textView == storeTextView) {
        if (storeTextView.text.length > 0) {
            
            if (storeTextView.text.length > 80) {
                [self showMsg:@"最多可填写80个字"];
            }else {
                feedbackStr = storeTextView.text;
            }
        }
    }else if (textView == phoneTextView) {
        phoneStr = phoneTextView.text;
    }
}

//关键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [storeTextView resignFirstResponder];
    [phoneTextView resignFirstResponder];
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
    
    [storeTextView resignFirstResponder];
    [phoneTextView resignFirstResponder];
    
    if (feedbackStr.length > 0) {
    }else {
        [self showMsg:@"请留下您的宝贵意见和建议"];
        return;
    }
    
    
    if (phoneStr.length > 0 && phoneStr.length < 12) {
    }else {
        [self showMsg:@"请输入正确的手机号码"];
        return;
    }
    
    [self showLoadHUDMsg:@"提交中..."];
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:feedbackStr, @"suggestion", phoneStr, @"tel_no", nil];
    
    [HttpClientService requestSuggestion:paramDic success:^(id responseObject) {
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        int status = [[jsonDic objectForKey:@"status"] intValue];
        
        if (status == 0) {
            [self hideLoadHUD:YES];
            [self showCustomDialog:@"提交成功"];
        }else if (status == 202) {
            [self hideLoadHUD:YES];
            [self showMsg:@"您的登录状态失效，请重新登录"];
            
            sleep(1.0);
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            PUSH(loginViewController);
            
        }else {
            
            [self hideLoadHUD:YES];
            [self showMsg:@"服务器异常"];
            
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoadHUD:YES];
        
        NSLog(@"提交失败");
    }];
}


- (void)backGroundClick{
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
}

@end
