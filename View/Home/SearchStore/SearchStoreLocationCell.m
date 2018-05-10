//
//  SearchStoreLocationCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/28.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SearchStoreLocationCell.h"

@implementation SearchStoreLocationCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(30*SCALE, 12*SCALE, 20*SCALE, 20*SCALE)];
        icon.image = [UIImage imageNamed:@"location_icon"];
        [self addSubview:icon];

        //店铺
        _title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+0*SCALE, 12*SCALE, 250*SCALE, 20*SCALE)];
        _title.text = @"点击定位当前位置";
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [UIFont systemFontOfSize:15*SCALE];
//        _title.backgroundColor = [UIColor greenColor];
        [self addSubview:_title];
        
    }
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
}
@end
