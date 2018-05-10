//
//  MineDetailCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/16.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "MineDetailCell.h"

@implementation MineDetailCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:17.0f*SCALE]];
        [self addSubview:_titleLabel];
        
        _detailTitleLabel = [[UILabel alloc] init];
        [_detailTitleLabel setFont:[UIFont systemFontOfSize:15.0f*SCALE]];
        _detailTitleLabel.textAlignment = NSTextAlignmentRight;
        _detailTitleLabel.textColor = [UIColor grayColor];
        [self addSubview:_detailTitleLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel setFrame:CGRectMake(20*SCALE, ((50-20)/2)*SCALE, 80*SCALE, 20*SCALE)];
    
    [_detailTitleLabel setFrame:CGRectMake(SCREEN_WIDTH-200*SCALE-30*SCALE, ((50-20)/2)*SCALE, 200*SCALE, 20*SCALE)];
    
}

@end
