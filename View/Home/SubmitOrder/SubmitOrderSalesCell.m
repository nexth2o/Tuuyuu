//
//  SubmitOrderSalesCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/23.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SubmitOrderSalesCell.h"

@implementation SubmitOrderSalesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //40
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, 12*SCALE, 16*SCALE, 16*SCALE)];
        _icon.image = [UIImage imageNamed:@"order_logo"];
        [self addSubview:_icon];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame)+10*SCALE, 0*SCALE, 280*SCALE, 40*SCALE)];
        _title.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_title];
        
        _subTitle = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70*SCALE, 0*SCALE, 60*SCALE, 40*SCALE)];
        _subTitle.textAlignment = NSTextAlignmentRight;
        _subTitle.textColor = [UIColor redColor];
        _subTitle.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_subTitle];
        
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
