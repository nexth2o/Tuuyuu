//
//  BadgeView.h
//  Tuuyuu
//
//  Created by WishU on 2017/6/1.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeView : UIView

-(instancetype)initWithFrame:(CGRect)frame withString:(NSString *)string;

-(instancetype)initWithFrame:(CGRect)frame withString:(NSString *)string withTextColor:(UIColor *)textColor;

@property (nonatomic,strong) NSString *badgeValue;

@end
