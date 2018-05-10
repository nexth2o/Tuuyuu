//
//  ShareMenuView.h
//  Tuuyuu
//
//  Created by WishU on 2017/10/20.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareMenuView : UIView
{
    UIButton *_backView;
}

- (void)show;
- (void)hide;

@property(nonatomic,copy)void (^ shareButtonClickBlock)(NSInteger index);  

@end
