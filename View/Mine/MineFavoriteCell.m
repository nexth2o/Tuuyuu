//
//  MineFavoriteCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/5.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "MineFavoriteCell.h"

//@interface MineFavoriteCell ()
//{
//    UIView *selectedBackView;
//    UIView *lineView;
//}
//
//@end

@implementation MineFavoriteCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        //图片
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, 10*SCALE, 100*SCALE, 100*SCALE)];
//        _icon.image = [UIImage imageNamed:@"test_food2"];
        [self addSubview:_icon];
        
        //标题
        _title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame)+10*SCALE, 10*SCALE, SCREEN_WIDTH-140*SCALE, 40*SCALE)];
        _title.numberOfLines = 2;
        _title.textColor = [UIColor darkGrayColor];
        _title.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_title];
        
        //好评
        _subTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame)+10*SCALE, CGRectGetMaxY(_title.frame)+10*SCALE, 100*SCALE, 20*SCALE)];
        _subTitle.textColor = [UIColor darkGrayColor];
        _subTitle.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_subTitle];
        
        //价格
        _price = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame)+10*SCALE, CGRectGetMaxY(_title.frame)+40*SCALE, 80*SCALE, 20*SCALE)];
        _price.textColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
        _price.font = [UIFont boldSystemFontOfSize:15*SCALE];
        [self addSubview:_price];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
