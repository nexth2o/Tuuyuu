//
//  TPayDetailCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/26.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "TPayDetailCell.h"

@implementation TPayDetailCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //cell 70
        self.backgroundColor = UIColorFromRGB(255,247,226);
        
        //类型
        _title = [[UILabel alloc] initWithFrame:CGRectMake(20*SCALE, 15*SCALE, 200*SCALE, 20*SCALE)];
        _title.text = @"兔币退款";
        _title.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_title];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - (90+26)*SCALE, 22*SCALE, 26*SCALE, 26*SCALE)];
        icon.image = [UIImage imageNamed:@"mine_pay_coin"];
        [self addSubview:icon];
        
        _subTitle = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90*SCALE, 0*SCALE, 70*SCALE, 70*SCALE)];
        _subTitle.textAlignment = NSTextAlignmentRight;
        _subTitle.textColor = MAIN_COLOR;
        _subTitle.font = [UIFont boldSystemFontOfSize:17*SCALE];
        [self addSubview:_subTitle];
        
        _time = [[UILabel alloc] initWithFrame:CGRectMake(20*SCALE, CGRectGetMaxY(_title.frame)+0*SCALE, 200*SCALE, 20*SCALE)];
        _time.textColor = [UIColor darkGrayColor];
        _time.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_time];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

@end
