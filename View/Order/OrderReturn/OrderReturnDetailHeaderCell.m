//
//  OrderReturnDetailHeaderCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/6.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "OrderReturnDetailHeaderCell.h"

@implementation OrderReturnDetailHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6*SCALE)];
        line1.backgroundColor = UIColorFromRGB(244, 244, 244);
        [self addSubview:line1];
        
        //商家名称
        UILabel *storeTitle = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, 16*SCALE, 65*SCALE, 20*SCALE)];
        storeTitle.text = @"商家名称";
        storeTitle.font = [UIFont systemFontOfSize:15*SCALE];
        storeTitle.textColor = [UIColor darkGrayColor];
        [self addSubview:storeTitle];
        
        _store = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(storeTitle.frame)+20*SCALE, 16*SCALE, 270*SCALE, 20*SCALE)];
        _store.text = @"兔悠(沈阳北站东门)";
        _store.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_store];
        
        //订单号码
        UILabel *orderTitle = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, 56*SCALE, 65*SCALE, 20*SCALE)];
        orderTitle.text = @"订单号码";
        orderTitle.font = [UIFont systemFontOfSize:15*SCALE];
        orderTitle.textColor = [UIColor darkGrayColor];
        [self addSubview:orderTitle];
        
        _order = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(orderTitle.frame)+20*SCALE, 56*SCALE, 270*SCALE, 20*SCALE)];
        _order.text = @"123143543656";
        _order.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_order];
        
        
        //退款金额
        UILabel *priceTitle = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, 96*SCALE, 65*SCALE, 20*SCALE)];
        priceTitle.text = @"退款金额";
        priceTitle.font = [UIFont systemFontOfSize:15*SCALE];
        priceTitle.textColor = [UIColor darkGrayColor];
        [self addSubview:priceTitle];
        
        _price = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceTitle.frame)+20*SCALE, 96*SCALE, 270*SCALE, 20*SCALE)];
        _price.text = @"39.90";
        _price.font = [UIFont boldSystemFontOfSize:15*SCALE];
        _price.textColor = [UIColor redColor];
        [self addSubview:_price];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 126*SCALE, SCREEN_WIDTH, 6*SCALE)];
        line2.backgroundColor = UIColorFromRGB(244, 244, 244);
        [self addSubview:line2];
        
        //退款流程
        UILabel *returnDetail = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, 142*SCALE, 65*SCALE, 20*SCALE)];
        returnDetail.text = @"退款流程";
        returnDetail.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:returnDetail];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end
