//
//  ShoppingCartCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/1.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "ShoppingCartCell.h"

@implementation ShoppingCartCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_nameLabel];
        _nameLabel.text = @"春饼";
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:15*SCALE];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_priceLabel];
        _priceLabel.text = @"18元";
        
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = [UIFont systemFontOfSize:15*SCALE];
        _numberLabel.text = @"10";
        _numberLabel.textColor = [UIColor darkGrayColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_numberLabel];
        
        
        //购物车减
        _minus = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_minus setImage:[UIImage imageNamed:@"cart_minus"] forState:UIControlStateNormal];
        [_minus setImage:[UIImage imageNamed:@"cart_minus"] forState:UIControlStateHighlighted];
        [_minus addTarget:self action:@selector(minus:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_minus];
        
        
        
        //购物车加
        _plus = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_plus setImage:[UIImage imageNamed:@"cart_plus"] forState:UIControlStateNormal];
        [_plus setImage:[UIImage imageNamed:@"cart_plus"] forState:UIControlStateHighlighted];
        [_plus addTarget:self action:@selector(plus:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_plus];
        

//        _cartDic = [[NSMutableDictionary alloc] init];
        
        
    }
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self showNumber:self.number];
    
    [_nameLabel setFrame:CGRectMake(20*SCALE, 10*SCALE, 180*SCALE, 20*SCALE)];
    
    [_priceLabel setFrame:CGRectMake(SCREEN_WIDTH - 165*SCALE, 10*SCALE, 65*SCALE, 20*SCALE)];
    
    [_numberLabel setFrame:CGRectMake(SCREEN_WIDTH - 65*SCALE, 10*SCALE, 25*SCALE, 20*SCALE)];
    
    [_minus setFrame:CGRectMake(SCREEN_WIDTH - 100*SCALE, 0*SCALE, 40*SCALE, 40*SCALE)];
    
    [_plus setFrame:CGRectMake(SCREEN_WIDTH - 50*SCALE, 0*SCALE, 40*SCALE, 40*SCALE)];
    
}

- (void)minus:(id)sender {
    
    self.number -= 1;
    
    [self showNumber:self.number];
    self.operationBlock(self.number,NO);
}

- (void)plus:(id)sender {

    self.number += 1;
    [self showNumber:self.number];
    self.operationBlock(self.number,YES);
}

-(void)showNumber:(NSUInteger)count
{
    self.numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.number];
    if (self.number > 0)
    {
        [self.minus setHidden:NO];
        [self.numberLabel setHidden:NO];
    }
    else
    {
        [self.minus setHidden:YES];
        [self.numberLabel setHidden:YES];
    }
}


@end
