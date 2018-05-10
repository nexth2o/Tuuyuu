//
//  FAQViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/10/16.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "FAQViewController.h"

@interface FAQViewController ()<UIWebViewDelegate> {
    UIWebView *serviceGuideWebView;
}

@end

@implementation FAQViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.backgroundColor = [UIColor whiteColor];
        
        navigationBar.titleLabel.text = @"常见问题";
        
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_gray"] forState:UIControlStateNormal];
        
        //iOS7新增属性 TODO
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        serviceGuideWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT)];
        serviceGuideWebView.delegate = self;
        serviceGuideWebView.scalesPageToFit = YES;
        
        [self.view addSubview:serviceGuideWebView];
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
    
    [self showLoadHUDMsg:@"努力加载中..."];
    NSURL *url = [NSURL URLWithString:@"http://tuuyuu.seqill.com/app/help.png"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [serviceGuideWebView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideLoadHUD:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideLoadHUD:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark TitleViewDelegate Methods
- (void)leftBtnClick:(id)sender {
    POP;
}

@end
