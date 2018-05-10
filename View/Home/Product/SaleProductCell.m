//
//  SaleProductCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/18.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SaleProductCell.h"

@interface SaleProductCell () {
    UIView *selectedBackView;
    UIView *lineView;
}

@end

@implementation SaleProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //图片
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, 12*SCALE, 100*SCALE, 100*SCALE)];
        [self addSubview:_rightImageView];
        
        _rightImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, 12*SCALE, 100*SCALE, 100*SCALE)];
        _rightImageView2.image = [UIImage imageNamed:@"stock_qty"];
        [_rightImageView2 setHidden:YES];
        [self addSubview:_rightImageView2];
        
        //标题
        _rightTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rightImageView.frame)+10*SCALE, 12*SCALE, SCREEN_WIDTH-20*SCALE-CGRectGetMaxX(_rightImageView.frame), 20*SCALE)];
        _rightTitle.textColor = [UIColor darkGrayColor];
        _rightTitle.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_rightTitle];
        
        //副标题
        _rightSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rightImageView.frame)+10*SCALE, CGRectGetMaxY(_rightTitle.frame)+3*SCALE, SCREEN_WIDTH-20*SCALE-CGRectGetMaxX(_rightImageView.frame), 20*SCALE)];
        _rightSubTitle.textColor = [UIColor grayColor];
        _rightSubTitle.font = [UIFont systemFontOfSize:12*SCALE];
        [self addSubview:_rightSubTitle];
        
        //标签
        _label1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rightImageView.frame)+10*SCALE, CGRectGetMaxY(_rightSubTitle.frame)+10*SCALE, 24.67*SCALE, 13*SCALE)];
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
        
        //现价
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rightImageView.frame)+10*SCALE, CGRectGetMaxY(_label1.frame)+10*SCALE, 80*SCALE, 20*SCALE)];
        _priceLabel.textColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
        _priceLabel.font = [UIFont boldSystemFontOfSize:15*SCALE];
        [self addSubview:_priceLabel];
        
        _oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_priceLabel.frame)+0*SCALE, CGRectGetMaxY(_label1.frame)+11*SCALE, 50*SCALE, 20*SCALE)];
        [self addSubview:_oldPriceLabel];
        
        //加号
        _plus = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plus setFrame:CGRectMake(SCREEN_WIDTH -44*SCALE, _label1.frame.origin.y+5*SCALE, 44*SCALE, 44*SCALE)];
        [_plus setBackgroundImage:[UIImage imageNamed:@"cart_plus"] forState:UIControlStateNormal];
        [_plus addTarget:self action:@selector(plus:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_plus];
        
        //减号
        _minus = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minus setFrame:CGRectMake(SCREEN_WIDTH -50*SCALE- 44*SCALE, _label1.frame.origin.y+5*SCALE, 44*SCALE, 44*SCALE)];
        [_minus setBackgroundImage:[UIImage imageNamed:@"cart_minus"] forState:UIControlStateNormal];
        [_minus addTarget:self action:@selector(minus:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_minus];
        
        //数量
        _orderCount = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -12*SCALE- 44*SCALE, _label1.frame.origin.y+17*SCALE, 20*SCALE, 20*SCALE)];
        _orderCount.textColor = [UIColor darkGrayColor];
        _orderCount.textAlignment = NSTextAlignmentCenter;
        _orderCount.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_orderCount];
        
        
        //买赠区
        //分割线
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rightImageView.frame)+10*SCALE, CGRectGetMaxY(_rightImageView.frame)+0*SCALE, 250*SCALE, 1)];
        line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:line2];
        
        //标签
        _giftLabel = [[UILabel alloc] initWithFrame:CGRectMake((110-26)*SCALE, CGRectGetMaxY(_rightImageView.frame)+5*SCALE, 42*SCALE, 15*SCALE)];
        _giftLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
        _giftLabel.layer.cornerRadius = 2;
        _giftLabel.layer.borderWidth = 0.6;
        _giftLabel.textColor = [UIColor redColor];
        _giftLabel.textAlignment = NSTextAlignmentCenter;
        _giftLabel.text = @"买3赠1";
        _giftLabel.font = [UIFont systemFontOfSize:9*SCALE];
        _giftLabel.layer.borderColor = [UIColor redColor].CGColor;
        [self addSubview:_giftLabel];
        
        //图片
        _giftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_giftLabel.frame)+10*SCALE, CGRectGetMaxY(_rightImageView.frame)+5*SCALE, 50*SCALE, 50*SCALE)];
        [self addSubview:_giftImageView];
        
        _giftImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_giftLabel.frame)+10*SCALE, CGRectGetMaxY(_rightImageView.frame)+5*SCALE, 50*SCALE, 50*SCALE)];
        [_giftImageView2 setHidden:YES];
        [self addSubview:_giftImageView2];
        
        _giftTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_giftImageView.frame)+10*SCALE, CGRectGetMaxY(_rightImageView.frame)+5*SCALE, 170*SCALE, 16*SCALE)];
        _giftTitle.font = [UIFont systemFontOfSize:12*SCALE];
        _giftTitle.textColor = [UIColor darkGrayColor];
        [self addSubview:_giftTitle];
        
        _giftSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_giftImageView.frame)+10*SCALE, CGRectGetMaxY(_giftTitle.frame)+0*SCALE, 170*SCALE, 16*SCALE)];
        _giftSubTitle.font = [UIFont systemFontOfSize:10*SCALE];
        _giftSubTitle.textColor = [UIColor grayColor];
        [self addSubview:_giftSubTitle];
        
        _giftPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_giftImageView.frame)+10*SCALE, CGRectGetMaxY(_giftSubTitle.frame)+2*SCALE, 50*SCALE, 16*SCALE)];
        _giftPrice.font = [UIFont systemFontOfSize:12*SCALE];
        [self addSubview:_giftPrice];
        
        _giftOldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_giftPrice.frame)+0*SCALE, CGRectGetMaxY(_giftSubTitle.frame)+4*SCALE, 50*SCALE, 16*SCALE)];
        [self addSubview:_giftOldPriceLabel];

        //130+50
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 174*SCALE, SCREEN_WIDTH, 6*SCALE)];
        
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


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self showOrderNumbers:self.amount];
    
    [selectedBackView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 174*SCALE)];
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
                                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.f*SCALE],NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                                                                    NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:[UIColor lightGrayColor],NSBaselineOffsetAttributeName:@(0)}];
    
 
    [_oldPriceLabel setAttributedText:oldPriceString];
    
    
    //现价
    NSString *newPriceStr = [formatter stringFromNumber:[NSNumber numberWithFloat:_newPrice]];
    NSMutableAttributedString *newPriceString =[[NSMutableAttributedString alloc]initWithString:newPriceStr
                                                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f*SCALE],NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    [newPriceString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9.0f] range:NSMakeRange(0, 1)];
    [_giftPrice setAttributedText:newPriceString];
    
    NSString *giftOldPriceStr = [formatter stringFromNumber:[NSNumber numberWithFloat:_giftOldPrice]];
    NSAttributedString *giftOldPriceString =[[NSAttributedString alloc]initWithString:giftOldPriceStr
                                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.f*SCALE],NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                                                                    NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:[UIColor lightGrayColor],NSBaselineOffsetAttributeName:@(0)}];
    
    [_giftOldPriceLabel setAttributedText:giftOldPriceString];
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
