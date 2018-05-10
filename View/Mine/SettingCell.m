//
//  SettingCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/16.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFrame:CGRectMake(20*SCALE, ((50-20)/2)*SCALE, 80*SCALE, 20*SCALE)];
        [_titleLabel setFont:[UIFont systemFontOfSize:15.0f*SCALE]];
        [self addSubview:_titleLabel];
        
        _subTitleLabel = [[UILabel alloc] init];
        [_subTitleLabel setFrame:CGRectMake(SCREEN_WIDTH - 100*SCALE, ((50-20)/2)*SCALE, 80*SCALE, 20*SCALE)];
        [_subTitleLabel setFont:[UIFont systemFontOfSize:14.0f*SCALE]];
        _subTitleLabel.textColor = [UIColor darkGrayColor];
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_subTitleLabel];
        
        _switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 61*SCALE, 10*SCALE, 51*SCALE, 31*SCALE)];
        [_switchBtn setOnTintColor:ICON_COLOR];
        [_switchBtn addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_switchBtn];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)switchAction {
    self.switchActionBlock();
}

@end
