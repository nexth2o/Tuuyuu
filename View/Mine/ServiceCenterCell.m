//
//  ServiceCenterCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/10/11.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "ServiceCenterCell.h"

@implementation ServiceCenterCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFrame:CGRectMake(20*SCALE, ((50-20)/2)*SCALE, 80*SCALE, 20*SCALE)];
        [_titleLabel setFont:[UIFont systemFontOfSize:15.0f*SCALE]];
        [self addSubview:_titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
