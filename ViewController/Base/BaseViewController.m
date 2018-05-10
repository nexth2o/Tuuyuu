//
//  BaseViewController.m
//  Tuuyuu
//
//  Created by WishU on 2017/5/8.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatus) name:NETWORK_STATUS_NOTIFICATION object:nil];
        
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        _emptyView = [[CustomEmptyView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        [_emptyView setHidden:YES];
        
        [self.view addSubview:_emptyView];
        
        navigationBar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, NAV_BAR_HEIGHT + STATUS_BAR_HEIGHT)];
        
        navigationBar.delegate = self;
        
        [self.view addSubview:navigationBar];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEmptyViewTitle:(NSString *)title {
    [_emptyView setEmptyViewTitle:title];
}

- (void)showEmptyViewWithStyle:(EmptyViewStyle)style {
    [_emptyView setEmptyViewStyle:style];
    [_emptyView setHidden:NO];
}

- (void)hideEmptyView {
    [_emptyView setHidden:YES];
}

- (void)doSomeWork {
    // Simulate by just waiting.
    sleep(2.);
}

- (void)showLoadHUDMsg:(NSString *)msg {

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //使用SDWebImage 放入gif 图片
    UIImage *image = [UIImage sd_animatedGIFNamed:@"timg"];
    
    //自定义imageView
    UIImageView *cusImageV = [[UIImageView alloc] initWithImage:image];
    
    //设置hud模式
    hud.mode = MBProgressHUDModeCustomView;
    
    //设置在hud影藏时将其从SuperView上移除,自定义情况下默认为NO
    hud.removeFromSuperViewOnHide = YES;
    
    //设置方框view为该模式后修改颜色才有效果
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    //设置方框view背景色
    hud.bezelView.backgroundColor = [UIColor clearColor];
    
    //设置总背景view的背景色，并带有透明效果
//    hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    hud.customView = cusImageV;
    
    hud.label.font = [UIFont systemFontOfSize:13*SCALE];
    hud.label.textColor = [UIColor darkGrayColor];
    hud.label.text = msg;
}



- (void)hideLoadHUD:(BOOL)animate {
    
    //    [HUD hideAnimated:animate];
    [MBProgressHUD hideHUDForView:self.view animated:animate];
    
}

- (void)showMsg:(NSString *)msg {
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    HUD.label.text = msg;
    HUD.mode = MBProgressHUDModeText;
    
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    
    //    HUD.yOffset = 150.0f;
    
    //    HUD.xOffset = 100.0f;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        sleep(1.);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });
    });
    
}

- (void)showDetailMsg:(NSString *)msg {
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    HUD.detailsLabel.text = msg;
    HUD.mode = MBProgressHUDModeText;
    
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    
    //    HUD.yOffset = 150.0f;
    
    //    HUD.xOffset = 100.0f;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        sleep(2.);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });
    });
    
}

- (void)showMsgWithPop:(NSString *)msg {
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    HUD.label.text = msg;
    
    HUD.mode = MBProgressHUDModeCustomView;
    
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    
    //    HUD.yOffset = 150.0f;
    
    //    HUD.xOffset = 100.0f;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        sleep(1.);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            POP;
            
        });
    });
    
}

- (void)showCustomDialog:(NSString *)msg {
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    HUD.label.text = msg;
    
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        sleep(1.);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            POP;
            
        });
    });
    
}

+ (void)showGifToView:(UIView *)view{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    //使用SDWebImage 放入gif 图片
    UIImage *image = [UIImage sd_animatedGIFNamed:@"timg"];
    
    //自定义imageView
    UIImageView *cusImageV = [[UIImageView alloc] initWithImage:image];
    
    //设置hud模式
    hud.mode = MBProgressHUDModeCustomView;
    
    //设置在hud影藏时将其从SuperView上移除,自定义情况下默认为NO
    hud.removeFromSuperViewOnHide = YES;
    
    //设置方框view为该模式后修改颜色才有效果
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    //设置方框view背景色
    hud.bezelView.backgroundColor = [UIColor clearColor];
    
    //设置总背景view的背景色，并带有透明效果
    hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3]; hud.customView = cusImageV;
}


- (BOOL)networkStatus {
    if ([[[UserDefaults service] getNetworkStatus] isEqualToString:NOTREACHABLE]) {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"ssy" object:nil];
        
        return NO;
    }else {
        return YES;
    }
}

#pragma mark TitleViewDelegate
- (void)leftBtnClick:(id)sender {
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NETWORK_STATUS_NOTIFICATION object:nil];
}


@end
