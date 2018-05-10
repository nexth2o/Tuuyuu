//
//  OrderCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/9.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "OrderCell.h"

@interface OrderCell () {
    UIView *selectedBackView;
    UIView *lineView;
}

@end

@implementation OrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //标题
        _title = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, 0, 200*SCALE, 40*SCALE)];
        _title.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_title];
        
        //副标题
        _subTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_title.frame)+10*SCALE, 0, 60*SCALE, 40*SCALE)];
        _subTitle.textColor = [UIColor grayColor];
        _subTitle.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_subTitle];
        
        //价格
        _price = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10*SCALE-80*SCALE, 0, 80*SCALE, 40*SCALE)];
        _price.textColor = [UIColor darkGrayColor];
        _price.textAlignment = NSTextAlignmentRight;
        _price.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_price];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
