//
//  CustomController.m
//  Tuuyuu
//
//  Created by WishU on 2017/5/8.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "CustomController.h"

#import "HomeViewController.h"
#import "NewsViewController.h"
#import "OrderViewController.h"
#import "MineViewController.h"
#import "Common.h"

// 字体未选中颜色设置
#define Tab_TITLE_NORMAL_COLOR   [UIColor colorWithRed:70/255.0 green:0/255.0 blue:1/255.0 alpha:1]
// 字体已选中颜色设置
#define Tab_TITLE_SELECTED_COLOR [UIColor colorWithRed:255/255.0 green:218/255.0 blue:37/255.0 alpha:1]
//字体的大小样式设置
#define Tab_TITLE_FONT           [UIFont fontWithName:@"AmericanTypewriter" size:14.0f]


@interface CustomController () {
    NSArray *controllerArray;
}

@end

@implementation CustomController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBar.backgroundColor = [UIColor whiteColor];
//    self.tabBar.translucent = NO;
    
    controllerArray = [NSArray arrayWithObjects:@"HomeViewController", @"NewsViewController", @"OrderViewController", @"MineViewController", nil];
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"首页", @"悠荐", @"订单", @"我的", nil];
    
    NSArray *normalImageArray = [NSArray arrayWithObjects:@"bottom_home_normal", @"bottom_news_normal", @"bottom_order_normal", @"bottom_mine_normal", nil];
    
    NSArray *selectImageArray = [NSArray arrayWithObjects:@"bottom_home_highlight", @"bottom_news_highlight", @"bottom_order_highlight", @"bottom_mine_highlight", nil];
    
    NSMutableArray *navigationControllerArray = [NSMutableArray array];
    
    for (int i = 0; i < controllerArray.count; i++) {
        
        UIViewController *viewController =(UIViewController *)[[NSClassFromString(controllerArray[i]) alloc] init];
        
        viewController.title = titleArray[i];
        
        UIImage *normalImage = [UIImage imageNamed:normalImageArray[i]];
        
        UIImage *selectImage = [UIImage imageNamed:selectImageArray[i]];
        
        viewController.tabBarItem.image = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //等新图片来了 再重新适配
//        viewController.tabBarItem.imageInsets = UIEdgeInsetsMake(1, 0, -1, 0);
        
        viewController.tabBarItem.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [navigationController.navigationBar setHidden:YES];
        
        [navigationControllerArray addObject:navigationController];
    }
    
    self.viewControllers = navigationControllerArray;
    
    UITabBarItem *item = [UITabBarItem appearance];
    
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor], NSFontAttributeName:[UIFont systemFontOfSize:10*SCALE]} forState:UIControlStateNormal];
    
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:248/255.0 green:191/255.0 blue:109/255.0 alpha:1], NSFontAttributeName:[UIFont systemFontOfSize:10*SCALE]} forState:UIControlStateSelected];
    
    
    //改变tabbar 线条颜色
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 0.3);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[UIColor lightGrayColor].CGColor);//颜色
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setShadowImage:img];
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
