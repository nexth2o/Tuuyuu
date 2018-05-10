//
//  MineFriendCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/10.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "MineFriendCell.h"

@implementation MineFriendCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = UIColorFromRGB(255,247,226);
        
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(20*SCALE, 5*SCALE, 40*SCALE, 40*SCALE)];
        
        if ([[[UserDefaults service] getGender] isEqualToString:@"1"]) {
            _icon.image = [UIImage imageNamed:@"test_head"];
        }else {
            _icon.image = [UIImage imageNamed:@"test_head2"];
        }
        
        
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = _icon.frame.size.width / 2;
        [self addSubview:_icon];
        
        //姓名
        _name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame)+10*SCALE, 5*SCALE, 120*SCALE, 20*SCALE)];
        _name.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_name];
        
        //加入时间
        _time = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame)+10*SCALE, CGRectGetMaxY(_name.frame)+0*SCALE, 120*SCALE, 20*SCALE)];
        _time.font = [UIFont systemFontOfSize:10*SCALE];
        _time.textColor = [UIColor darkGrayColor];
        [self addSubview:_time];
        
        //类型
        _type = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_name.frame)+0*SCALE, 0*SCALE, 80*SCALE, 50*SCALE)];
        _type.font = [UIFont systemFontOfSize:12*SCALE];
        _type.text = @"直接好友贡献";
        [self addSubview:_type];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_type.frame)+0*SCALE, 15*SCALE, 20*SCALE, 20*SCALE)];
        icon.image = [UIImage imageNamed:@"mine_pay_coin"];
        [self addSubview:icon];
        
        _coinCount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+5*SCALE, 0*SCALE, 70*SCALE, 50*SCALE)];
        _coinCount.textAlignment = NSTextAlignmentCenter;
        _coinCount.textColor = MAIN_COLOR;
        _coinCount.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_coinCount];
        
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

@end
