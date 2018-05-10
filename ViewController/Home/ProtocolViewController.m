//
//  ProtocolViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/11/8.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "ProtocolViewController.h"

@interface ProtocolViewController ()

@end

@implementation ProtocolViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        navigationBar.backgroundColor = [UIColor whiteColor];
        
        navigationBar.titleLabel.text = @"帮买服务协议";
        
        [navigationBar.leftButton setHidden:NO];
        [navigationBar.leftButton setImage:[UIImage imageNamed:@"navigation_back_gray"] forState:UIControlStateNormal];
        
        //iOS7新增属性 TODO
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        

        UIImage *image = [UIImage imageNamed:@"home_protocol"];
    
        CGFloat imageHeight = [self heightForImage:image];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAV_BAR_HEIGHT)];
        [self.view addSubview:scrollView];
        [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, imageHeight)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, imageHeight)];
        imageView.image = [UIImage imageNamed:@"home_protocol"];
        [scrollView addSubview:imageView];
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
}

- (CGFloat)heightForImage:(UIImage *)image {
    
    CGSize size = image.size;
    CGFloat scale = SCREEN_WIDTH / size.width;
    CGFloat imageHeight = size.height * scale;
    
    return imageHeight;
    
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
