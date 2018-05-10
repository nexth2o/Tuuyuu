//
//  MineDetailImageCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/16.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "MineDetailImageCell.h"

@implementation MineDetailImageCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headLabel = [[UILabel alloc] init];
        [_headLabel setFont:[UIFont systemFontOfSize:17.0f*SCALE]];
        [self addSubview:_headLabel];
        
        _headImage = [[UIImageView alloc] init];
        [self addSubview:_headImage];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_headLabel setFrame:CGRectMake(20*SCALE, ((100-20)/2)*SCALE, 60*SCALE, 20*SCALE)];
    
    [_headImage setFrame:CGRectMake(SCREEN_WIDTH-70*SCALE-30*SCALE, 15*SCALE, 70*SCALE, 70*SCALE)];
    
    _headImage.layer.masksToBounds = YES;
    
    _headImage.layer.cornerRadius = 70*SCALE / 2;
    
}
@end
