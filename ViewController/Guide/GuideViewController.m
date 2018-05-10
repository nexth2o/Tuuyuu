//
//  GuideViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/20.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "GuideViewController.h"
#import "CustomController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.view.backgroundColor = [UIColor purpleColor];
        
        [navigationBar setHidden:YES];
        
        UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        
        scrollView.pagingEnabled = YES;
        
        scrollView.bounces = NO;
        
        for (int i = 0; i < 3; i++) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            
            NSString *imageName = [NSString stringWithFormat:@"guide_image%d",i+1];
            
            imageView.image = [UIImage imageNamed:imageName];
            
            [scrollView addSubview:imageView];
        }
        
        [self.view addSubview:scrollView];
        
        UIButton *skipBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2 + (SCREEN_WIDTH - 120*SCALE)/2, SCREEN_HEIGHT - 90*SCALE, 120*SCALE, 36*SCALE)];
        
        [skipBtn setBackgroundImage:[UIImage imageNamed:@"guide_start"] forState:UIControlStateNormal];
        
        [skipBtn addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [scrollView addSubview:skipBtn];
        
        [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT)];
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

- (void)skipBtnClick {
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[CustomController alloc] initWithNibName:nil bundle:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
