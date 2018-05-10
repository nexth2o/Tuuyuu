//
//  SubmitOrderSumCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/24.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SubmitOrderSumCell.h"

@implementation SubmitOrderSumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _totalTitle = [[UILabel alloc] initWithFrame:CGRectMake(50*SCALE, 0*SCALE, 100*SCALE, 40*SCALE)];
        _totalTitle.textAlignment = NSTextAlignmentRight;
        _totalTitle.textColor = [UIColor darkGrayColor];
        _totalTitle.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_totalTitle];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 210*SCALE, 0*SCALE, 100*SCALE, 40*SCALE)];
        _title.textAlignment = NSTextAlignmentRight;
        _title.textColor = [UIColor darkGrayColor];
        _title.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_title];
        
        _subTitle = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 110*SCALE, 0*SCALE, 100*SCALE, 40*SCALE)];
        _subTitle.textAlignment = NSTextAlignmentRight;
        _subTitle.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_subTitle];
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
