//
//  BaseViewController.h
//  Tuuyuu
//
//  Created by WishU on 2017/5/8.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationBar.h"
#import "Common.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import "HttpClientService.h"
#import "UserDefaults.h"
#import "CustomEmptyView.h"



@interface BaseViewController : UIViewController<TitleViewDelegate> {
    
    CustomNavigationBar *navigationBar;
    
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) CustomEmptyView *emptyView;

- (void)setEmptyViewTitle:(NSString *)title;

- (void)showEmptyViewWithStyle:(EmptyViewStyle)style;

- (void)hideEmptyView;

- (void)showLoadHUDMsg:(NSString *)msg;

- (void)showMsg:(NSString *)msg;

- (void)showDetailMsg:(NSString *)msg;

- (void)showMsgWithPop:(NSString *)msg;

- (void)showCustomDialog:(NSString *)msg;

- (void)hideLoadHUD:(BOOL)animate ;

//- (void)hideTabBar:(UITabBarController *)tabbarcontroller;
//
//- (void)showTabBar:(UITabBarController *)tabbarcontroller;

- (void)doSomeWork;

- (BOOL)networkStatus;


@end
