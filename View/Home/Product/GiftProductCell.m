//
//  GiftProductCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/20.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "GiftProductCell.h"

@interface GiftProductCell () {
    UIView *selectedBackView;
    UIView *lineView;
}

@end

@implementation GiftProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        //图片
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, 12*SCALE, 70*SCALE, 70*SCALE)];
        [self addSubview:_rightImageView];
        
        _rightImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, 12*SCALE, 70*SCALE, 70*SCALE)];
        _rightImageView2.image = [UIImage imageNamed:@"stock_qty"];
        [_rightImageView2 setHidden:YES];
        [self addSubview:_rightImageView2];
        
        //标题
        _rightTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rightImageView.frame)+10*SCALE, 12*SCALE, SCREEN_WIDTH-20*SCALE-CGRectGetMaxX(_rightImageView.frame), 18*SCALE)];
        _rightTitle.textColor = [UIColor darkGrayColor];
        _rightTitle.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_rightTitle];
        
        //副标题
        _rightSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rightImageView.frame)+10*SCALE, CGRectGetMaxY(_rightTitle.frame)+0*SCALE, SCREEN_WIDTH-20*SCALE-CGRectGetMaxX(_rightImageView.frame), 18*SCALE)];
        _rightSubTitle.textColor = [UIColor grayColor];
        _rightSubTitle.font = [UIFont systemFontOfSize:12*SCALE];
        [self addSubview:_rightSubTitle];
        
               //价格
        _price = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rightImageView.frame)+10*SCALE, CGRectGetMaxY(_rightSubTitle.frame)+14*SCALE, 60*SCALE, 20*SCALE)];
        _price.textColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
        _price.font = [UIFont boldSystemFontOfSize:15*SCALE];
        [self addSubview:_price];
        
        //原价
        _oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_price.frame)+0*SCALE, CGRectGetMaxY(_rightSubTitle.frame)+15*SCALE, 60*SCALE, 20*SCALE)];
        [self addSubview:_oldPriceLabel];
        
        //限制
        _tipsTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rightImageView.frame)+10*SCALE, CGRectGetMaxY(_rightSubTitle.frame)+0*SCALE, 220*SCALE, 12*SCALE)];
        _tipsTitle.textColor = [UIColor orangeColor];
        _tipsTitle.font = [UIFont systemFontOfSize:10*SCALE];
        [self addSubview:_tipsTitle];
 
        //加号
        _plus = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plus setFrame:CGRectMake(SCREEN_WIDTH -44*SCALE, _rightSubTitle.frame.origin.y+20*SCALE, 44*SCALE, 44*SCALE)];
        [_plus setBackgroundImage:[UIImage imageNamed:@"cart_plus"] forState:UIControlStateNormal];
        [_plus addTarget:self action:@selector(plus:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_plus];
        
        //减号
        _minus = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minus setFrame:CGRectMake(SCREEN_WIDTH -50*SCALE- 44*SCALE, _rightSubTitle.frame.origin.y+20*SCALE, 44*SCALE, 44*SCALE)];
        [_minus setBackgroundImage:[UIImage imageNamed:@"cart_minus"] forState:UIControlStateNormal];
        [_minus addTarget:self action:@selector(minus:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_minus];
        
        //数量
        _orderCount = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -12*SCALE- 44*SCALE, _rightSubTitle.frame.origin.y+32*SCALE, 20*SCALE, 20*SCALE)];
        _orderCount.textColor = [UIColor darkGrayColor];
        _orderCount.textAlignment = NSTextAlignmentCenter;
        _orderCount.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_orderCount];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 124*SCALE, SCREEN_WIDTH, 6*SCALE)];
        
        [self addSubview:lineView];
        
        self.amount = 0;
        
        [self.minus setHidden:YES];
        [self.orderCount setHidden:YES];
        
        
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 94*SCALE, SCREEN_WIDTH, 6*SCALE)];
        
        [self addSubview:lineView];
        
        selectedBackView = [[UIView alloc] init];
        
        
        
    }
    return self;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self showOrderNumbers:self.amount];
    
    [selectedBackView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 124*SCALE)];
    self.selectedBackgroundView = selectedBackView;
    
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIColor *myColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    self.selectedBackgroundView.backgroundColor = myColor;
    
    
    //原价
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    
    NSString *oldPriceStr = [formatter stringFromNumber:[NSNumber numberWithFloat:_oldPrice]];
    NSAttributedString *oldPriceString =[[NSAttributedString alloc]initWithString:oldPriceStr
                                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f*SCALE],NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                                                                    NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:[UIColor lightGrayColor],NSBaselineOffsetAttributeName:@(0)}];
    [_oldPriceLabel setAttributedText:oldPriceString];
    
}

- (void)plus:(id)sender {
    
    self.amount += 1;
    
    self.plusBlock(self.amount,YES);
    
    [self showOrderNumbers:self.amount];
    
}
- (void)minus:(id)sender {
    
    self.amount -= 1;
    
    self.plusBlock(self.amount,NO);
    
    [self showOrderNumbers:self.amount];
}

-(void)showOrderNumbers:(NSUInteger)count
{
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
