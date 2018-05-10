//
//  PopView.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/25.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//关闭按钮的位置
typedef NS_ENUM(NSInteger, ButtonPositionType) {
    //无
    ButtonPositionTypeNone = 0,
    
    //左上角
    ButtonPositionTypeLeft = 1 << 0,
    
    //右上角
    ButtonPositionTypeRight = 2 << 0
};

//蒙板的背景色
typedef NS_ENUM(NSInteger, ShadeBackgroundType) {
    
    //渐变色
    ShadeBackgroundTypeGradient = 0,
    
    //固定色
    ShadeBackgroundTypeSolid = 1 << 0
};

typedef void(^completeBlock)(void);

@interface PopView : NSObject

@property (strong, nonatomic) UIColor *popBackgroudColor;//弹出视图的背景色
@property (assign, nonatomic) BOOL tapOutsideToDismiss;//点击蒙板是否弹出视图消失
@property (assign, nonatomic) ButtonPositionType closeButtonType;//关闭按钮的类型
@property (assign, nonatomic) ShadeBackgroundType shadeBackgroundType;//蒙板的背景色


+ (PopView *)sharedInstance;

//弹出要展示的View
- (void)showWithPresentView:(UIView *)presentView animated:(BOOL)animated;

//关闭弹出视图
- (void)closeWithBlcok:(void(^)())complete;

@end
