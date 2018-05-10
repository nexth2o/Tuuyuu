//
//  UILabel+AlertActionFont.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/5.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "UILabel+AlertActionFont.h"

@implementation UILabel (AlertActionFont)

- (void)setAppearanceFont:(UIFont *)appearanceFont
{
    if(appearanceFont)
    {
        [self setFont:appearanceFont];
    }
}

- (UIFont *)appearanceFont
{
    return self.font;
    
}

@end
