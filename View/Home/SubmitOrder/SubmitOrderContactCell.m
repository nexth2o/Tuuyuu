//
//  SubmitOrderContactCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/23.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SubmitOrderContactCell.h"

@implementation SubmitOrderContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //60
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, 13*SCALE, 18*SCALE, 18*SCALE)];
        _icon.image = [UIImage imageNamed:@"order_logo"];
        [self addSubview:_icon];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame)+10*SCALE, 10*SCALE, SCREEN_WIDTH - 50*SCALE, 20*SCALE)];
        _title.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_title];
        
        _subtitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame)+10*SCALE, 35*SCALE, 80*SCALE, 20*SCALE)];
        _subtitle.textColor = [UIColor darkGrayColor];
        _subtitle.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_subtitle];
        
        _phone = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_subtitle.frame)+0*SCALE, 35*SCALE, 100*SCALE, 20*SCALE)];
        _phone.textColor = [UIColor darkGrayColor];
        _phone.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_phone];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
