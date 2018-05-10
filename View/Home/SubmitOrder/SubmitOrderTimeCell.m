//
//  SubmitOrderTimeCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/23.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SubmitOrderTimeCell.h"

@implementation SubmitOrderTimeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //44
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, 13*SCALE, 18*SCALE, 18*SCALE)];
        _icon.image = [UIImage imageNamed:@"order_logo"];
        [self addSubview:_icon];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame)+10*SCALE, 0, 200*SCALE, 44*SCALE)];
        _title.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_title];
        
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
