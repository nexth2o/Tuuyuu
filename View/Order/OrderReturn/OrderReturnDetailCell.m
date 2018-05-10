//
//  OrderReturnDetailCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/6.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "OrderReturnDetailCell.h"

@implementation OrderReturnDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _line = [[UIImageView alloc] initWithFrame:CGRectMake(20*SCALE, 0, 10*SCALE, 100*SCALE)];
        [self addSubview:_line];
        
        
        _returnTitle = [[UILabel alloc] initWithFrame:CGRectMake(60*SCALE, 20*SCALE, 200*SCALE, 20*SCALE)];
        _returnTitle.text = @"您已取消退款申请";
        _returnTitle.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_returnTitle];
        
        _returnTime = [[UILabel alloc] initWithFrame:CGRectMake(60*SCALE, CGRectGetMaxY(_returnTitle.frame), 200*SCALE, 20*SCALE)];
        _returnTime.text = @"2017-06-01 18:80";
        _returnTime.textColor = [UIColor darkGrayColor];
        _returnTime.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_returnTime];
        
        _returnReason = [[UILabel alloc] initWithFrame:CGRectMake(60*SCALE, CGRectGetMaxY(_returnTime.frame), 200*SCALE, 20*SCALE)];
        _returnReason.text = @"退款原因:买错了，买多了";
        _returnReason.textColor = [UIColor darkGrayColor];
        _returnReason.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_returnReason];
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end
