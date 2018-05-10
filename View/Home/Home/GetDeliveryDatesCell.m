//
//  GetDeliveryDatesCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/11/11.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "GetDeliveryDatesCell.h"

@implementation GetDeliveryDatesCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _time = [[UILabel alloc] initWithFrame:CGRectMake(20*SCALE, 0*SCALE, SCREEN_WIDTH - 40*SCALE, 44*SCALE)];
        _time.textColor = [UIColor darkGrayColor];
        _time.font = [UIFont systemFontOfSize:15*SCALE];
        _time.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_time];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

@end
