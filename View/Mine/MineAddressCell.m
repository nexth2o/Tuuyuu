//
//  MineAddressCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/29.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "MineAddressCell.h"

@implementation MineAddressCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        //姓名
        _name = [[UILabel alloc] initWithFrame:CGRectMake(15*SCALE, 10*SCALE, 60*SCALE, 20*SCALE)];
        _name.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_name];
        
        //性别
        _gender = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_name.frame)+ 0*SCALE, 10*SCALE, 40*SCALE, 20*SCALE)];
        _gender.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_gender];
        
        //电话
        _phone = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_gender.frame)+ 10*SCALE, 10*SCALE, 100*SCALE, 20*SCALE)];
        _phone.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_phone];
        
        //地址
        _address = [[UILabel alloc] initWithFrame:CGRectMake(15*SCALE, CGRectGetMaxY(_name.frame)+5*SCALE, SCREEN_WIDTH-20*SCALE, 20*SCALE)];
        _address.textColor = [UIColor darkGrayColor];
        _address.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_address];
        
        _outImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-55*SCALE, 10*SCALE, 40*SCALE, 40*SCALE)];
        _outImage.image = [UIImage imageNamed:@"mine_out_address"];
        [_outImage setHidden:YES];
        [self addSubview:_outImage];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

@end
