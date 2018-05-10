//
//  MineCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/5/14.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "MineCell.h"
#import "Common.h"

@implementation MineCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //83.75 * 108.75
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-2)/9, 30*SCALE, (SCREEN_WIDTH-2)/9, (SCREEN_WIDTH-2)/9)];
        [self addSubview:_imageView];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, CGRectGetMaxY(_imageView.frame)+3*SCALE, (SCREEN_WIDTH-2)/3-20*SCALE, 20*SCALE)];
        _label.textColor = [UIColor darkGrayColor];
        _label.font = [UIFont systemFontOfSize:12*SCALE];
        _label.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:_label];
    }
    return self;
    
}

@end
