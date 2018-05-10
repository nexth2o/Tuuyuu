//
//  OrderStatusTitleCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/31.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "OrderStatusTitleCell.h"

@implementation OrderStatusTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //标题
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0*SCALE, 0*SCALE, SCREEN_WIDTH, 50*SCALE)];
        _title.font = [UIFont systemFontOfSize:15*SCALE];
        _title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_title];
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end
