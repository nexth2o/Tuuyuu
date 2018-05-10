//
//  SubmitNoteViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/19.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SubmitNoteViewController.h"
#import "TTextView.h"

@interface SubmitNoteViewController ()<UITextViewDelegate> {
    TTextView *storeTextView;
}

@end

@implementation SubmitNoteViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.titleLabel.text = @"添加备注";
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_gray"] forState:UIControlStateNormal];
        [navigationBar.editButton setTitle:@"完成" forState:UIControlStateNormal];
        [navigationBar.editButton setHidden:NO];
        
        storeTextView = [[TTextView alloc] initWithFrame:CGRectMake(10*SCALE, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT+20*SCALE, SCREEN_WIDTH-20*SCALE, 140*SCALE)];
        storeTextView.backgroundColor = [UIColor whiteColor];
        storeTextView.font = [UIFont systemFontOfSize:15*SCALE];
        storeTextView.placeholder = @"口味，偏好等要求";
        storeTextView.placeholderFont = [UIFont systemFontOfSize:14*SCALE];
        storeTextView.placeholderColor = [UIColor grayColor];
        storeTextView.returnKeyType = UIReturnKeyDefault;
        storeTextView.delegate = self;
        [self.view addSubview:storeTextView];
        
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

    if (textView.text.length > 0) {
        
        if (textView.text.length > 80) {
            [self showMsg:@"备注最多可填写80个字"];
        }else {
            [[UserDefaults service] updateOrderNote:textView.text];
        }
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
    POP;
}


- (void)backGroundClick{
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
}

@end
