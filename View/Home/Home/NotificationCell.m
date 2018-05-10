//
//  NotificationCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/3.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(15*SCALE, 15*SCALE, 50*SCALE, 50*SCALE)];
        [self addSubview:_icon];
        
        //标题
        _title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame)+ 15*SCALE, 15*SCALE, 190*SCALE, 20*SCALE)];
        _title.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_title];
        
        //内容
        _subTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame)+ 15*SCALE, CGRectGetMaxY(_title.frame) + 10*SCALE, SCREEN_WIDTH - 30*SCALE - CGRectGetMaxX(_icon.frame), 20*SCALE)];
        _subTitle.textColor = [UIColor darkGrayColor];
        _subTitle.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_subTitle];
        
        _time = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 95*SCALE, 15*SCALE, 80*SCALE, 20*SCALE)];
        _time.textColor = [UIColor darkGrayColor];
        _time.textAlignment = NSTextAlignmentRight;
        _time.font = [UIFont systemFontOfSize:12*SCALE];
        [self addSubview:_time];
        
    }
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
}

@end
