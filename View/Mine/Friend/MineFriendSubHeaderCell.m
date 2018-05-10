//
//  MineFriendSubHeaderCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/27.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "MineFriendSubHeaderCell.h"

@implementation MineFriendSubHeaderCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = UIColorFromRGB(255,247,226);
        
        //好友数
        _number = [[UILabel alloc] initWithFrame:CGRectMake(50*SCALE, 5*SCALE, 80*SCALE, 20*SCALE)];
        _number.textAlignment = NSTextAlignmentCenter;
        _number.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_number];
        
        _numberTitle = [[UILabel alloc] initWithFrame:CGRectMake(50*SCALE, CGRectGetMaxY(_number.frame)+0*SCALE, 80*SCALE, 20*SCALE)];
        _numberTitle.textAlignment = NSTextAlignmentCenter;
        _numberTitle.font = [UIFont systemFontOfSize:15*SCALE];
        _numberTitle.text = @"直接好友数";
        [self addSubview:_numberTitle];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_number.frame)+40*SCALE, 0*SCALE, 50*SCALE, 50*SCALE)];
        icon.image = [UIImage imageNamed:@"mine_friend_icon"];
        [self addSubview:icon];
        
        _count = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-(80+50)*SCALE, 5*SCALE, 80*SCALE, 20*SCALE)];
        _count.textAlignment = NSTextAlignmentCenter;
        _count.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_count];
        
        UILabel *countTitle = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-(80+50)*SCALE, CGRectGetMaxY(_number.frame)+0*SCALE, 80*SCALE, 20*SCALE)];
        countTitle.textAlignment = NSTextAlignmentCenter;
        countTitle.font = [UIFont systemFontOfSize:15*SCALE];
        countTitle.text = @"我的奖励";
        [self addSubview:countTitle];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

@end
