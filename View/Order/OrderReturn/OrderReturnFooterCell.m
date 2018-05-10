//
//  OrderReturnFooterCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/3.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "OrderReturnFooterCell.h"

@implementation OrderReturnFooterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = UIColorFromRGB(244, 244, 244);
        
        //退款金额
        UIView *tipsBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100*SCALE)];
        tipsBg.backgroundColor = [UIColor whiteColor];
        [self addSubview:tipsBg];
        
        UILabel *returnPrice = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, 10*SCALE, 65*SCALE, 20*SCALE)];
        returnPrice.text = @"退款金额";
        returnPrice.font = [UIFont systemFontOfSize:15*SCALE];
        [tipsBg addSubview:returnPrice];
        
        UILabel *pricetips = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(returnPrice.frame), 10*SCALE, 200*SCALE, 20*SCALE)];
        pricetips.font = [UIFont systemFontOfSize:11.5*SCALE];
        pricetips.textColor = [UIColor darkGrayColor];
        pricetips.text = @"(已包含促销活动、折扣及礼品)";
        [tipsBg addSubview:pricetips];
        
        _price = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90*SCALE, 10*SCALE, 80, 20*SCALE)];
        _price.textColor = [UIColor redColor];
        _price.font = [UIFont boldSystemFontOfSize:15*SCALE];
        _price.textAlignment = NSTextAlignmentRight;
        [tipsBg addSubview:_price];
        
        UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, 40*SCALE, SCREEN_WIDTH-20*SCALE, 40*SCALE)];
        tips.font = [UIFont systemFontOfSize:11.5*SCALE];
        tips.numberOfLines = 2;
        tips.textColor = [UIColor darkGrayColor];
        tips.text = @"单独商品的退款金额是在刨除优惠活动金额后按照优惠等比计算得出。如您选择全部商品则按照全部退款返还您支付的全部金额。";
        [tipsBg addSubview:tips];
        
        //退款原因
        UIView *reasonBg = [[UIView alloc] initWithFrame:CGRectMake(0, 106*SCALE, SCREEN_WIDTH, 80*SCALE)];
        reasonBg.backgroundColor = [UIColor whiteColor];
        [self addSubview:reasonBg];
        
        UILabel *reasonTitle = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, 10*SCALE, 80*SCALE, 20*SCALE)];
        reasonTitle.text = @"退款原因";
        reasonTitle.font = [UIFont systemFontOfSize:15*SCALE];
        [reasonBg addSubview:reasonTitle];
        
        _reason = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, 40*SCALE, SCREEN_WIDTH-20*SCALE, 40*SCALE)];
        _reason.textColor = [UIColor darkGrayColor];
        _reason.text = @"请描述退款原因";
        _reason.font = [UIFont systemFontOfSize:13*SCALE];
        [reasonBg addSubview:_reason];
        
        UIButton *_reasonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reasonBtn setFrame:CGRectMake(0*SCALE, 40*SCALE, SCREEN_WIDTH, 40*SCALE)];
        [_reasonBtn addTarget:self action:@selector(reasonBtn:) forControlEvents:UIControlEventTouchUpInside];
        [reasonBg addSubview:_reasonBtn];
        
    }
    return self;
}

- (void)reasonBtn:(id)sender {
    self.reasonBtnBlock();
}


- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
