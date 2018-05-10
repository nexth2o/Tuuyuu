//
//  CategoryDiscountProductCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/30.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "CategoryDiscountProductCell.h"

@interface CategoryDiscountProductCell () {
    UIView *selectedBackView;
    UIView *lineView;
}

@end

@implementation CategoryDiscountProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //图片
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8*SCALE, 8*SCALE, 60*SCALE, 60*SCALE)];
        [self addSubview:_rightImageView];
        
        _rightImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(8*SCALE, 8*SCALE, 60*SCALE, 60*SCALE)];
        _rightImageView2.image = [UIImage imageNamed:@"stock_qty"];
        [_rightImageView2 setHidden:YES];
        [self addSubview:_rightImageView2];
        
        //标题
        _rightTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rightImageView.frame)+8*SCALE, 8*SCALE, SCREEN_WIDTH-20*SCALE-CGRectGetMaxX(_rightImageView.frame), 13*SCALE)];
        _rightTitle.textColor = [UIColor darkGrayColor];
        _rightTitle.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_rightTitle];
        
        //副标题
        _rightSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rightImageView.frame)+8*SCALE, CGRectGetMaxY(_rightTitle.frame)+5*SCALE, SCREEN_WIDTH-20*SCALE-CGRectGetMaxX(_rightImageView.frame), 10*SCALE)];
        _rightSubTitle.textColor = [UIColor grayColor];
        _rightSubTitle.font = [UIFont systemFontOfSize:10*SCALE];
        [self addSubview:_rightSubTitle];
        
        //标签
        _label1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rightImageView.frame)+8*SCALE, CGRectGetMaxY(_rightSubTitle.frame)+10*SCALE, 20.87*SCALE, 11*SCALE)];
        [self addSubview:_label1];
        
        _label2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label1.frame)+5*SCALE, CGRectGetMaxY(_rightSubTitle.frame)+10*SCALE, 20.87*SCALE, 11*SCALE)];
        [self addSubview:_label2];
        
        _label3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label2.frame)+5*SCALE, CGRectGetMaxY(_rightSubTitle.frame)+10*SCALE, 20.87*SCALE, 11*SCALE)];
        [self addSubview:_label3];
        
        _label4 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label3.frame)+5*SCALE, CGRectGetMaxY(_rightSubTitle.frame)+10*SCALE, 20.87*SCALE, 11*SCALE)];
        [self addSubview:_label4];
        
        _label5 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label4.frame)+5*SCALE, CGRectGetMaxY(_rightSubTitle.frame)+10*SCALE, 20.87*SCALE, 11*SCALE)];
        [self addSubview:_label5];
        
        _label6 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label5.frame)+5*SCALE, CGRectGetMaxY(_rightSubTitle.frame)+10*SCALE, 20.87*SCALE, 11*SCALE)];
        [self addSubview:_label6];
        
        _label7 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_label6.frame)+5*SCALE, CGRectGetMaxY(_rightSubTitle.frame)+10*SCALE, 20.87*SCALE, 11*SCALE)];
        [self addSubview:_label7];
        
        //价格
        _priceLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rightImageView.frame)+8*SCALE, CGRectGetMaxY(_label1.frame)+5*SCALE, 80*SCALE, 12*SCALE)];
        _priceLabel1.textColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
        _priceLabel1.font = [UIFont boldSystemFontOfSize:12*SCALE];
        [self addSubview:_priceLabel1];
        
        //加号
        _plus = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plus setFrame:CGRectMake(SCREEN_WIDTH -44*SCALE-80*SCALE, _label1.frame.origin.y-5*SCALE, 44*SCALE, 44*SCALE)];
        [_plus setBackgroundImage:[UIImage imageNamed:@"cart_plus"] forState:UIControlStateNormal];
        [_plus addTarget:self action:@selector(plus:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_plus];
        
        //减号
        _minus = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minus setFrame:CGRectMake(SCREEN_WIDTH -50*SCALE- 44*SCALE-80*SCALE, _label1.frame.origin.y-5*SCALE, 44*SCALE, 44*SCALE)];
        [_minus setBackgroundImage:[UIImage imageNamed:@"cart_minus"] forState:UIControlStateNormal];
        [_minus addTarget:self action:@selector(minus:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_minus];
        
        //数量
        _orderCount = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -12*SCALE- 44*SCALE-80*SCALE, _label1.frame.origin.y+7*SCALE, 20*SCALE, 20*SCALE)];
        _orderCount.textColor = [UIColor darkGrayColor];
        _orderCount.textAlignment = NSTextAlignmentCenter;
        _orderCount.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_orderCount];
        
        
        //买赠区
        //分割线
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rightImageView.frame)+8*SCALE, CGRectGetMaxY(_rightImageView.frame)+10*SCALE, 250*SCALE, 0.5)];
        line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:line2];
        
        _giftLabel = [[UILabel alloc] initWithFrame:CGRectMake((110-50-40)*SCALE, CGRectGetMaxY(_rightImageView.frame)+15*SCALE, 50*SCALE, 15*SCALE)];
        _giftLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
        _giftLabel.layer.cornerRadius = 2;
        _giftLabel.layer.borderWidth = 0.6;
        _giftLabel.textColor = [UIColor redColor];
        _giftLabel.textAlignment = NSTextAlignmentCenter;
        _giftLabel.text = @"第二件7.5折";
        _giftLabel.font = [UIFont systemFontOfSize:8*SCALE];
        _giftLabel.layer.borderColor = [UIColor redColor].CGColor;
        [self addSubview:_giftLabel];
        
        //图片
        _giftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_giftLabel.frame)+8*SCALE, CGRectGetMaxY(_rightImageView.frame)+15*SCALE, 30*SCALE, 30*SCALE)];
//        _giftImageView.image = [UIImage imageNamed:@"test_food2"];
        [self addSubview:_giftImageView];
        
        _giftImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_giftLabel.frame)+8*SCALE, CGRectGetMaxY(_rightImageView.frame)+15*SCALE, 30*SCALE, 30*SCALE)];
        [_giftImageView2 setHidden:YES];
        [self addSubview:_giftImageView2];
        
        _giftTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_giftImageView.frame)+8*SCALE, CGRectGetMaxY(_rightImageView.frame)+15*SCALE, 170*SCALE, 16*SCALE)];
        _giftTitle.font = [UIFont systemFontOfSize:12*SCALE];
        _giftTitle.textColor = [UIColor darkGrayColor];
        [self addSubview:_giftTitle];
        
        _giftSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_giftImageView.frame)+8*SCALE, CGRectGetMaxY(_giftTitle.frame)+0*SCALE, 170*SCALE, 16*SCALE)];
        _giftSubTitle.font = [UIFont systemFontOfSize:10*SCALE];
        _giftSubTitle.textColor = [UIColor grayColor];
        [self addSubview:_giftSubTitle];
        
        _giftPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_giftImageView.frame)+8*SCALE, CGRectGetMaxY(_giftSubTitle.frame)+2*SCALE, 50*SCALE, 16*SCALE)];
        _giftPrice.font = [UIFont systemFontOfSize:12*SCALE];
        [self addSubview:_giftPrice];
        
        _giftOldPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_giftPrice.frame)+0*SCALE, CGRectGetMaxY(_giftSubTitle.frame)+4*SCALE, 50*SCALE, 16*SCALE)];
        [self addSubview:_giftOldPrice];
        
        
        //加号
        _plus2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plus2 setFrame:CGRectMake(SCREEN_WIDTH -44*SCALE-80*SCALE, _giftSubTitle.frame.origin.y-2*SCALE, 44*SCALE, 44*SCALE)];
        [_plus2 setBackgroundImage:[UIImage imageNamed:@"cart_plus"] forState:UIControlStateNormal];
        [_plus2 addTarget:self action:@selector(plus2:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_plus2];
        
        //减号
        _minus2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minus2 setFrame:CGRectMake(SCREEN_WIDTH -50*SCALE- 44*SCALE-80*SCALE, _giftSubTitle.frame.origin.y-2*SCALE, 44*SCALE, 44*SCALE)];
        [_minus2 setBackgroundImage:[UIImage imageNamed:@"cart_minus"] forState:UIControlStateNormal];
        [_minus2 addTarget:self action:@selector(minus2:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_minus2];
        
        //数量
        _orderCount2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -12*SCALE- 44*SCALE-80*SCALE, _giftSubTitle.frame.origin.y+10*SCALE, 20*SCALE, 20*SCALE)];
        _orderCount2.textColor = [UIColor darkGrayColor];
        _orderCount2.textAlignment = NSTextAlignmentCenter;
        _orderCount2.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_orderCount2];
        
        
        //成箱
        _packageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_packageBtn setFrame:CGRectMake(SCREEN_WIDTH - 55*SCALE-90*SCALE, CGRectGetMaxY(_rightTitle.frame)+10*SCALE, 55*SCALE, 25*SCALE)];
        [_packageBtn setTitle:@"成箱优惠" forState:UIControlStateNormal];
        [_packageBtn setBackgroundColor:ICON_COLOR];
        _packageBtn.layer.cornerRadius = 12.5;
        [_packageBtn setTitleColor:MAIN_TEXT_COLOR forState:UIControlStateNormal];
        [_packageBtn.titleLabel setFont:[UIFont systemFontOfSize:11*SCALE]];
        [_packageBtn addTarget:self action:@selector(package:) forControlEvents:UIControlEventTouchUpInside];
        [_packageBtn setHidden:YES];
        [self addSubview:_packageBtn];
        
        
        //130+50
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 138*SCALE, SCREEN_WIDTH, 2*SCALE)];

        [self addSubview:lineView];
        
        self.amount = 0;
        
        [self.minus setHidden:YES];
        [self.orderCount setHidden:YES];
        
        //第二件折扣
        self.amount2 = 0;
        
        [self.minus2 setHidden:YES];
        [self.orderCount2 setHidden:YES];
        
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
    
    if (self.amount == self.amount2) {
        self.amount2 -= 1;
    }
    
    self.amount -= 1;
    
    self.plusBlock(self.amount,NO);
    
    [self showOrderNumbers:self.amount];
}

- (void)package:(id)sender {
    
    //    self.amount += 12;
    
    self.packageBlock(self.amount,YES);
    
    [self showOrderNumbers:self.amount];
}

//第二件折扣
- (void)plus2:(id)sender {
    
    if (self.amount > self.amount2) {
        self.amount2 += 1;
        self.plusBlock2(self.amount2,YES,NO);
    }else {
        self.plusBlock2(self.amount2,YES,YES);
    }
    
    [self showOrderNumbers2:self.amount2];
    
}
- (void)minus2:(id)sender {
    
    self.amount2 -= 1;
    
    self.plusBlock2(self.amount2,NO,NO);
    
    [self showOrderNumbers2:self.amount2];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self showOrderNumbers:self.amount];
    [self showOrderNumbers2:self.amount2];
    
    [selectedBackView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 138*SCALE)];
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
    
    
    [_giftOldPrice setAttributedText:oldPriceString];
    
    //现价
    //    float newPrice = 39; _price.textColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
    NSString *newPriceStr = [formatter stringFromNumber:[NSNumber numberWithFloat:_newPrice]];
    NSMutableAttributedString *newPriceString =[[NSMutableAttributedString alloc]initWithString:newPriceStr
                                                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f*SCALE],NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    [newPriceString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9.0f] range:NSMakeRange(0, 1)];
    [_giftPrice setAttributedText:newPriceString];
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

-(void)showOrderNumbers2:(NSUInteger)count
{
    self.orderCount2.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.amount2];
    if (self.amount2 > 0)
    {
        [self.minus2 setHidden:NO];
        [self.orderCount2 setHidden:NO];
    }
    else
    {
        [self.minus2 setHidden:YES];
        [self.orderCount2 setHidden:YES];
    }
}

@end
