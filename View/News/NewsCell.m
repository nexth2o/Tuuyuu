//
//  NewsCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/6.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 110*SCALE - 15*SCALE, 20*SCALE, 110*SCALE, 80*SCALE)];
        [self addSubview:_icon];
        
        //标题
        _title = [[UILabel alloc] initWithFrame:CGRectMake(15*SCALE, 20*SCALE, 220*SCALE, 40*SCALE)];
        _title.numberOfLines = 2;
        _title.font = [UIFont systemFontOfSize:16*SCALE];
        [self addSubview:_title];
        
        _time = [[UILabel alloc] initWithFrame:CGRectMake(15*SCALE, CGRectGetMaxY(_title.frame)+20*SCALE, 220*SCALE, 20*SCALE)];
        _time.textColor = [UIColor darkGrayColor];
        _time.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_time];
        
    }
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
}

@end
