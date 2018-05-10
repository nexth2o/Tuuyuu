//
//  SearchAddressCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/3.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SearchAddressCell.h"

@implementation SearchAddressCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //店铺
        _address = [[UILabel alloc] initWithFrame:CGRectMake(15*SCALE, 5*SCALE, SCREEN_WIDTH - 30*SCALE, 20*SCALE)];
        _address.textColor = MAIN_COLOR;
        _address.font = [UIFont systemFontOfSize:14*SCALE];
        //        _store.backgroundColor = [UIColor greenColor];
        [self addSubview:_address];
        
        _detailAddress = [[UILabel alloc] initWithFrame:CGRectMake(15*SCALE, CGRectGetMaxY(_address.frame)+0*SCALE, SCREEN_WIDTH - 30*SCALE, 20*SCALE)];
        _detailAddress.font = [UIFont systemFontOfSize:12*SCALE];
        _detailAddress.textColor = [UIColor darkGrayColor];
        //        _store.backgroundColor = [UIColor greenColor];
        [self addSubview:_detailAddress];
        
        
        
        
    }
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
}

@end
