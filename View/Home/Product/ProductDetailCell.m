//
//  ProductDetailCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/22.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "ProductDetailCell.h"

@implementation ProductDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //图片
        _rightImageView = [[UIImageView alloc] init];
        [self addSubview:_rightImageView];
        
        _rightImageView2 = [[UIImageView alloc] init];
        _rightImageView2.image = [UIImage imageNamed:@"stock_qty"];
        [_rightImageView2 setHidden:YES];
        [self addSubview:_rightImageView2];
        
        //标题
        _rightTitle = [[UILabel alloc] init];
        _rightTitle.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_rightTitle];
        
        //好评率
        _rightSubTitle = [[UILabel alloc] init];
        _rightSubTitle.textColor = [UIColor darkGrayColor];
        _rightSubTitle.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_rightSubTitle];
        
        //好评
        _rate = [[UILabel alloc] init];
        _rate.textColor = [UIColor darkGrayColor];
        _rate.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_rate];
        
        
        //价格
        _price = [[UILabel alloc] init];
        _price.text = @"39.90";
        _price.textColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
        [self addSubview:_price];
        
        
        _oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_price.frame)+0*SCALE, CGRectGetMaxY(_rate.frame)+22*SCALE, 80*SCALE, 20*SCALE)];
        _oldPriceLabel.text = @"99.90";
        [self addSubview:_oldPriceLabel];
        
        //商品简介
        _infoTitle = [[UILabel alloc] init];
        _infoTitle.text = @"商品简介";
        _infoTitle.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_infoTitle];
        
        _info = [[UILabel alloc] init];
        _info.text = @"商品简介内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容";
        _info.textColor = [UIColor darkGrayColor];
        _info.numberOfLines = 2;
        _info.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_info];
        
        
        
        //加号
        _plus = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plus setFrame:CGRectMake(SCREEN_WIDTH -44*SCALE, _price.frame.origin.y-10*SCALE, 44*SCALE, 44*SCALE)];
        [_plus setBackgroundImage:[UIImage imageNamed:@"cart_plus"] forState:UIControlStateNormal];
        [_plus addTarget:self action:@selector(plus:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_plus];
        
        //减号
        _minus = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minus setFrame:CGRectMake(SCREEN_WIDTH -50*SCALE- 44*SCALE, _price.frame.origin.y-10*SCALE, 44*SCALE, 44*SCALE)];
        [_minus setBackgroundImage:[UIImage imageNamed:@"cart_minus"] forState:UIControlStateNormal];
        [_minus addTarget:self action:@selector(minus:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_minus];
        
        //数量
        _orderCount = [[UILabel alloc] init];
        _orderCount.textColor = [UIColor darkGrayColor];
        _orderCount.textAlignment = NSTextAlignmentCenter;
        _orderCount.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_orderCount];
        
        
        self.amount = 0;
        
        [self.minus setHidden:YES];
        [self.orderCount setHidden:YES];
        
        self.amount2 = 0;
    }
    return self;
}

- (void)plus:(id)sender {
    
    if (_plus.selected == YES) {
        self.amount += 1;
        self.plusBlock(self.amount,YES);
        [self showOrderNumbers:self.amount];
    }else {
        self.plusBlock(self.amount,YES);
    }
    
}

- (void)minus:(id)sender {
    
    self.amount -= 1;
    
    self.plusBlock(self.amount,NO);
    
    [self showOrderNumbers:self.amount];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self showOrderNumbers:self.amount];
    
    //原价
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    
    NSString *oldPriceStr = [formatter stringFromNumber:[NSNumber numberWithFloat:_oldPrice]];
    NSAttributedString *oldPriceString =[[NSAttributedString alloc]initWithString:oldPriceStr
                                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f*SCALE],NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                                                                    NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:[UIColor lightGrayColor],NSBaselineOffsetAttributeName:@(0)}];
    
    
    [_oldPriceLabel setAttributedText:oldPriceString];
    
    [_rightSubTitle setFrame:CGRectMake(10*SCALE, CGRectGetMaxY(_rightTitle.frame)+10*SCALE, SCREEN_WIDTH, 20*SCALE)];
    [_rate setFrame:CGRectMake(10*SCALE, CGRectGetMaxY(_rightSubTitle.frame)+10*SCALE, SCREEN_WIDTH, 20*SCALE)];
    [_price setFrame:CGRectMake(10*SCALE, CGRectGetMaxY(_rate.frame)+20*SCALE, 80*SCALE, 20*SCALE)];
    [_oldPriceLabel setFrame:CGRectMake(CGRectGetMaxX(_price.frame)+0*SCALE, CGRectGetMaxY(_rate.frame)+22*SCALE, 80*SCALE, 20*SCALE)];
    [_infoTitle setFrame:CGRectMake(10*SCALE, CGRectGetMaxY(_price.frame)+20*SCALE, 80*SCALE, 20*SCALE)];
    [_info setFrame:CGRectMake(10*SCALE, CGRectGetMaxY(_infoTitle.frame)+10*SCALE, 350*SCALE, 40*SCALE)];
    [_plus setFrame:CGRectMake(SCREEN_WIDTH -44*SCALE, _price.frame.origin.y-10*SCALE, 44*SCALE, 44*SCALE)];
    [_minus setFrame:CGRectMake(SCREEN_WIDTH -50*SCALE- 44*SCALE, _price.frame.origin.y-10*SCALE, 44*SCALE, 44*SCALE)];
    [_orderCount setFrame:CGRectMake(SCREEN_WIDTH -12*SCALE- 44*SCALE, _price.frame.origin.y+2*SCALE, 20*SCALE, 20*SCALE)];
}


- (void)showOrderNumbers:(NSUInteger)count {
    self.orderCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.amount];
    if (self.amount > 0)
    {
        [self.minus setHidden:NO];
        [self.orderCount setHidden:NO];
    }
    else
    {
        [self.minus setHidden:YES];
        [self.orderCount setHidden:YES];
    }
}

@end
