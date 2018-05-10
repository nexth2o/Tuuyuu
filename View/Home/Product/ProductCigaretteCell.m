//
//  ProductCigaretteCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/11/2.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "ProductCigaretteCell.h"

@interface ProductCigaretteCell () {
    UIView *selectedBackView;
    UIView *lineView;
}

@end

@implementation ProductCigaretteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //标题
        _rightTitle = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, 12*SCALE, SCREEN_WIDTH-30*SCALE, 20*SCALE)];
        _rightTitle.textColor = [UIColor darkGrayColor];
        _rightTitle.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_rightTitle];
        
        //副标题
        _rightSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, CGRectGetMaxY(_rightTitle.frame)+3*SCALE, SCREEN_WIDTH-30*SCALE, 20*SCALE)];
        _rightSubTitle.textColor = [UIColor grayColor];
        _rightSubTitle.font = [UIFont systemFontOfSize:12*SCALE];
        [self addSubview:_rightSubTitle];
        
        //标签
        _label1 = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, CGRectGetMaxY(_rightSubTitle.frame)+10*SCALE, 24.67*SCALE, 13*SCALE)];
        [self addSubview:_label1];
        
        _label2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label1.frame)+5*SCALE, CGRectGetMaxY(_rightSubTitle.frame)+10*SCALE, 24.67*SCALE, 13*SCALE)];
        [self addSubview:_label2];
        
        _label3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label2.frame)+5*SCALE, CGRectGetMaxY(_rightSubTitle.frame)+10*SCALE, 24.67*SCALE, 13*SCALE)];
        [self addSubview:_label3];
        
        _label4 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label3.frame)+5*SCALE, CGRectGetMaxY(_rightSubTitle.frame)+10*SCALE, 24.67*SCALE, 13*SCALE)];
        [self addSubview:_label4];
        
        _label5 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label4.frame)+5*SCALE, CGRectGetMaxY(_rightSubTitle.frame)+10*SCALE, 24.67*SCALE, 13*SCALE)];
        [self addSubview:_label5];
        
        _label6 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label5.frame)+5*SCALE, CGRectGetMaxY(_rightSubTitle.frame)+10*SCALE, 24.67*SCALE, 13*SCALE)];
        [self addSubview:_label6];
        
        _label7 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label6.frame)+5*SCALE, CGRectGetMaxY(_rightSubTitle.frame)+10*SCALE, 24.67*SCALE, 13*SCALE)];
        [self addSubview:_label7];
        
        //价格
        _price = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, CGRectGetMaxY(_label1.frame)+10*SCALE, 80*SCALE, 20*SCALE)];
        _price.textColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
        _price.font = [UIFont boldSystemFontOfSize:15*SCALE];
        [self addSubview:_price];
        
        _oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_price.frame)+0*SCALE, CGRectGetMaxY(_label1.frame)+11*SCALE, 50*SCALE, 20*SCALE)];
        [self addSubview:_oldPriceLabel];
        
        //加号
        _plus = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plus setFrame:CGRectMake(SCREEN_WIDTH -44*SCALE, _label1.frame.origin.y+10*SCALE, 44*SCALE, 44*SCALE)];
        [_plus setBackgroundImage:[UIImage imageNamed:@"cart_plus"] forState:UIControlStateNormal];
        [_plus addTarget:self action:@selector(plus:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_plus];
        
        //减号
        _minus = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minus setFrame:CGRectMake(SCREEN_WIDTH -50*SCALE- 44*SCALE, _label1.frame.origin.y+10*SCALE, 44*SCALE, 44*SCALE)];
        [_minus setBackgroundImage:[UIImage imageNamed:@"cart_minus"] forState:UIControlStateNormal];
        [_minus addTarget:self action:@selector(minus:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_minus];
        
        //数量
        _orderCount = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -12*SCALE- 44*SCALE, _label1.frame.origin.y+22*SCALE, 20*SCALE, 20*SCALE)];
        _orderCount.textColor = [UIColor darkGrayColor];
        _orderCount.textAlignment = NSTextAlignmentCenter;
        _orderCount.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_orderCount];
        
        
        //成箱
        _packageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_packageBtn setFrame:CGRectMake(SCREEN_WIDTH - 55*SCALE-10*SCALE, CGRectGetMaxY(_rightTitle.frame)+10*SCALE, 55*SCALE, 25*SCALE)];
        [_packageBtn setTitle:@"成箱优惠" forState:UIControlStateNormal];
        [_packageBtn setBackgroundColor:ICON_COLOR];
        _packageBtn.layer.cornerRadius = 12.5;
        [_packageBtn setTitleColor:MAIN_TEXT_COLOR forState:UIControlStateNormal];
        [_packageBtn.titleLabel setFont:[UIFont systemFontOfSize:11*SCALE]];
        [_packageBtn addTarget:self action:@selector(package:) forControlEvents:UIControlEventTouchUpInside];
        [_packageBtn setHidden:YES];
        [self addSubview:_packageBtn];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 124*SCALE, SCREEN_WIDTH, 6*SCALE)];
        
        [self addSubview:lineView];
        
        self.amount = 0;
        
        [self.minus setHidden:YES];
        [self.orderCount setHidden:YES];
        
        selectedBackView = [[UIView alloc] init];
        
        _salesArray = [NSArray array];
        
        
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

- (void)package:(id)sender {
    
    //    self.amount += 12;
    
    self.packageBlock(self.amount,YES);
    
    [self showOrderNumbers:self.amount];
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
    
    [_label1 setImage:[UIImage imageNamed:@""]];
    [_label2 setImage:[UIImage imageNamed:@""]];
    [_label3 setImage:[UIImage imageNamed:@""]];
    [_label4 setImage:[UIImage imageNamed:@""]];
    [_label5 setImage:[UIImage imageNamed:@""]];
    [_label6 setImage:[UIImage imageNamed:@""]];
    [_label7 setImage:[UIImage imageNamed:@""]];
    
    for (int i =0; i < _salesArray.count; i++) {
        
        if (i==0) {
            [_label1 setImage:[UIImage imageNamed:[_salesArray objectAtIndex:i][@"ptag"]]];
        }else if (i==1) {
            [_label2 setImage:[UIImage imageNamed:[_salesArray objectAtIndex:i][@"ptag"]]];
        }else if (i==2) {
            [_label3 setImage:[UIImage imageNamed:[_salesArray objectAtIndex:i][@"ptag"]]];
        }else if (i==3) {
            [_label4 setImage:[UIImage imageNamed:[_salesArray objectAtIndex:i][@"ptag"]]];
        }else if (i==4) {
            [_label5 setImage:[UIImage imageNamed:[_salesArray objectAtIndex:i][@"ptag"]]];
        }else if (i==5) {
            [_label6 setImage:[UIImage imageNamed:[_salesArray objectAtIndex:i][@"ptag"]]];
        }
    }
    
    //原价
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    
    NSString *oldPriceStr = [formatter stringFromNumber:[NSNumber numberWithFloat:_oldPrice]];
    NSAttributedString *oldPriceString =[[NSAttributedString alloc]initWithString:oldPriceStr
                                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f*SCALE],NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                                                                    NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:[UIColor lightGrayColor],NSBaselineOffsetAttributeName:@(0)}];
    
    
    [_oldPriceLabel setAttributedText:oldPriceString];
    
    
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
