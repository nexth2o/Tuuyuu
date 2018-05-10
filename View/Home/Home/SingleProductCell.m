//
//  SingleProductCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/5/24.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SingleProductCell.h"

@interface SingleProductCell () {
    UILabel *leftPricelabel;
    NSNumberFormatter *formatter;
    UILabel *rightPricelabel;
}

@end

@implementation SingleProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //分割线
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        lineView1.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineView1];
        
        //左商品
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH/2, 180*SCALE)];
        [self addSubview:_leftImageView];
        
        _leftImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH/2, 180*SCALE)];
        [_leftImageView2 setHidden:YES];
        [self addSubview:_leftImageView2];
        
        _leftBtn = [[UIButton alloc] initWithFrame:_leftImageView.frame];
        [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftBtn];
        
        //左商品名称
        _leftTitle = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, CGRectGetMaxY(_leftImageView.frame), SCREEN_WIDTH/2-20*SCALE, 40*SCALE)];
        _leftTitle.numberOfLines = 2;
        _leftTitle.textColor = [UIColor darkGrayColor];
        [_leftTitle setFont:[UIFont systemFontOfSize:12*SCALE]];
        [self addSubview:_leftTitle];
        
        //左商品价格
        leftPricelabel = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, CGRectGetMaxY(_leftTitle.frame), 100*SCALE, 20*SCALE)];

        formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        [self addSubview:leftPricelabel];
        
        
        //左购物车
        UIButton *leftCartBtn = [[UIButton alloc] initWithFrame:CGRectMake(130*SCALE, CGRectGetMaxY(_leftTitle.frame)-10*SCALE, 40*SCALE, 40*SCALE)];
        [leftCartBtn setImage:[UIImage imageNamed:@"home_single_cart"] forState:UIControlStateNormal];
        [leftCartBtn addTarget:self action:@selector(leftCartBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftCartBtn];
        
        
        //右商品
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 1, SCREEN_WIDTH/2, 180*SCALE)];
        [self addSubview:_rightImageView];
        
        _rightImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 1, SCREEN_WIDTH/2, 180*SCALE)];
        _rightImageView2.image = [UIImage imageNamed:@"stock_qty"];
        [_rightImageView2 setHidden:YES];
        [self addSubview:_rightImageView2];
        
        _rightBtn = [[UIButton alloc] initWithFrame:_rightImageView.frame];
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBtn];
        
        //右商品名称
        _rightTitle = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+10*SCALE, CGRectGetMaxY(_rightImageView.frame), SCREEN_WIDTH/2-20*SCALE, 40*SCALE)];
        _rightTitle.numberOfLines = 2;
        _rightTitle.textColor = [UIColor darkGrayColor];
        [_rightTitle setFont:[UIFont systemFontOfSize:12*SCALE]];
        [self addSubview:_rightTitle];
        
        //右商品价格
        rightPricelabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+10*SCALE, CGRectGetMaxY(_rightTitle.frame), 100*SCALE, 20*SCALE)];
        [self addSubview:rightPricelabel];
        
        //右购物车
        UIButton *rightCartBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+130*SCALE, CGRectGetMaxY(_rightTitle.frame)-10*SCALE, 40*SCALE, 40*SCALE)];
        [rightCartBtn setImage:[UIImage imageNamed:@"home_single_cart"] forState:UIControlStateNormal];
        [rightCartBtn addTarget:self action:@selector(rightCartBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightCartBtn];

        //竖分割线
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, 1, 250*SCALE)];
        lineView2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineView2];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSString *leftPriceStr = [formatter stringFromNumber:[NSNumber numberWithFloat:_leftPrice]];
    NSMutableAttributedString *leftPriceString =[[NSMutableAttributedString alloc]initWithString:leftPriceStr
                                                                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f*SCALE],NSForegroundColorAttributeName:[UIColor redColor]}];
    [leftPriceString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9.0f] range:NSMakeRange(0, 1)];
    [leftPricelabel setAttributedText:leftPriceString];
    
    NSString *rightPriceStr = [formatter stringFromNumber:[NSNumber numberWithFloat:_rightPrice]];
    NSMutableAttributedString *rightPriceString =[[NSMutableAttributedString alloc]initWithString:rightPriceStr
                                                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f*SCALE],NSForegroundColorAttributeName:[UIColor redColor]}];
    [rightPriceString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9.0f] range:NSMakeRange(0, 1)];
    [rightPricelabel setAttributedText:rightPriceString];
}

- (void)leftBtnClick {
    self.leftBtnEvent();
}

- (void)rightBtnClick {
    self.rightBtnEvent();
}

- (void)leftCartBtnClick {
    self.leftCartBtnEvent();
}

- (void)rightCartBtnClick {
    self.rightCartBtnEvent();
}


@end
