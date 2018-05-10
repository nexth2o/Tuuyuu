//
//  SearchStoreCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/28.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SearchStoreCell.h"

@implementation SearchStoreCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //店铺
        _store = [[UILabel alloc] initWithFrame:CGRectMake(15*SCALE, 0*SCALE, 210*SCALE, 44*SCALE)];
        _store.font = [UIFont systemFontOfSize:14*SCALE];
//        _store.backgroundColor = [UIColor greenColor];
        [self addSubview:_store];
        
        //距离
        _distance = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-150*SCALE, 0*SCALE, 140*SCALE, 44*SCALE)];
        _distance.textColor = [UIColor darkGrayColor];
        _distance.textAlignment = NSTextAlignmentRight;
        _distance.font = [UIFont systemFontOfSize:13*SCALE];
//        distance.backgroundColor = [UIColor greenColor];
        [self addSubview:_distance];
        
    }
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
}


@end
