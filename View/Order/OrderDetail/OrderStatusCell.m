//
//  OrderStatusCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/31.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "OrderStatusCell.h"

@implementation OrderStatusCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //图片
        _statusIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20*SCALE, 0*SCALE, 9*SCALE, 50*SCALE)];
        [self addSubview:_statusIcon];
        
        _info = [[UILabel alloc] initWithFrame:CGRectMake(60*SCALE, 0*SCALE, 140*SCALE, 50*SCALE)];
        _info.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_info];
        
        _time = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-160*SCALE, 0*SCALE, 150*SCALE, 50*SCALE)];
        _time.textAlignment = NSTextAlignmentRight;
        _time.textColor = [UIColor darkGrayColor];
        _time.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_time];

    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
