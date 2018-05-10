//
//  EditMineDetailViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/29.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "EditMineDetailViewController.h"

@interface EditMineDetailViewController ()<UITextFieldDelegate>

@end

@implementation EditMineDetailViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [navigationBar.leftButton setHidden:NO];
        
        [navigationBar.editButton setTitle:@"完成" forState:UIControlStateNormal];
        [navigationBar.editButton setHidden:NO];
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _titleLabel = [[UILabel alloc] init];
        
        UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(0, 100*SCALE, SCREEN_WIDTH, 50*SCALE)];
        
        textView.backgroundColor = [UIColor whiteColor];
        
        _detailTextField = [[UITextField alloc] initWithFrame:CGRectMake(20*SCALE, 0, SCREEN_WIDTH, 50*SCALE)];
        
        _detailTextField.delegate = self;
        
        [textView addSubview:_detailTextField];
        
        [self.view addSubview:textView];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [navigationBar.titleLabel setText:[NSString stringWithFormat:@"修改%@",_titleLabel.text]];
    
    if ([_titleLabel.text isEqualToString:@"昵称"]) {
        _detailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请输入您的新昵称" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        
        _detailTextField.text = [[UserDefaults service] getNickName];
    }
    
    [_detailTextField becomeFirstResponder];
    
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
    [_detailTextField resignFirstResponder];
    
    [self showLoadHUDMsg:@"修改中..."];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    if ([_titleLabel.text isEqualToString:@"昵称"]) {
        
        [paramDic setObject:_detailTextField.text forKey:@"nick_name"];
        [paramDic setObject:[[UserDefaults service] getGender] forKey:@"is_male"];
        
    }
    
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
