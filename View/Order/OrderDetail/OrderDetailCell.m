//
//  OrderDetailCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/15.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "OrderDetailCell.h"

@implementation OrderDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //图片
        _productIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, 10*SCALE, 70*SCALE, 70*SCALE)];
//        _productIcon.image = [UIImage imageNamed:@"test_food2"];
        [self addSubview:_productIcon];
        
        //商品名称
        _productName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_productIcon.frame)+10*SCALE, 10*SCALE, 200*SCALE, 20*SCALE)];
        _productName.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_productName];
        
        //规格
        _subTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_productIcon.frame)+10*SCALE, CGRectGetMaxY(_productName.frame)+3*SCALE, 200*SCALE, 20*SCALE)];
        _subTitle.textColor = [UIColor darkGrayColor];
        _subTitle.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_subTitle];
        
        //数量
        _productCount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_productIcon.frame)+10*SCALE, CGRectGetMaxY(_subTitle.frame)+8*SCALE, 200*SCALE, 20*SCALE)];
        _productCount.textColor = [UIColor darkGrayColor];
        _productCount.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_productCount];
        
        //价格
        _price = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10*SCALE-80*SCALE, 0, 80*SCALE, 40*SCALE)];
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
