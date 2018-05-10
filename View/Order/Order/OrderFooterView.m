//
//  OrderFooterView.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/13.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "OrderFooterView.h"

@implementation OrderFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(180*SCALE, 0, 80*SCALE, 40*SCALE)];
        _title.textColor = [UIColor darkGrayColor];
        _title.font = [UIFont systemFontOfSize:12*SCALE];
        [self addSubview:_title];
        
      
        
        _subTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_title.frame)-5*SCALE, 0, 30*SCALE, 40*SCALE)];
        _subTitle.text = [NSString stringWithFormat:@"合计:"];
        _subTitle.textColor = [UIColor darkGrayColor];
        _subTitle.font = [UIFont systemFontOfSize:12*SCALE];
        [self addSubview:_subTitle];
        
        _price = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-85*SCALE, 0, 75*SCALE, 40*SCALE)];
        _price.textColor = [UIColor darkGrayColor];
        _price.textAlignment = NSTextAlignmentRight;
        _price.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_price];
        
        //按钮区
        _aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_aBtn setFrame:CGRectMake(SCREEN_WIDTH -20*SCALE- 88*SCALE-88*SCALE-88*SCALE, 40*SCALE, 88*SCALE, 40*SCALE)];
        [_aBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_aBtn setBackgroundImage:[UIImage imageNamed:@"order_again"] forState:UIControlStateNormal];
        _aBtn.titleLabel.font = [UIFont systemFontOfSize:13.0*SCALE];
        [_aBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        [_aBtn addTarget:self action:@selector(aBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_aBtn];
        
        
        _bBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bBtn setFrame:CGRectMake(SCREEN_WIDTH -15*SCALE- 88*SCALE-88*SCALE, 40*SCALE, 88*SCALE, 40*SCALE)];
        [_bBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bBtn setBackgroundImage:[UIImage imageNamed:@"order_again"] forState:UIControlStateNormal];
        _bBtn.titleLabel.font = [UIFont systemFontOfSize:13.0*SCALE];
        [_bBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        [_bBtn addTarget:self action:@selector(bBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bBtn];

        
        //去评价
        _cBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cBtn setFrame:CGRectMake(SCREEN_WIDTH -10*SCALE-88*SCALE, 40*SCALE, 88*SCALE, 40*SCALE)];
        [_cBtn setTitleColor:MAIN_TEXT_COLOR forState:UIControlStateNormal];
        [_cBtn setBackgroundImage:[UIImage imageNamed:@"order_appraise"] forState:UIControlStateNormal];
        _cBtn.titleLabel.font = [UIFont systemFontOfSize:13.0*SCALE];
        [_cBtn setTitle:@"评价" forState:UIControlStateNormal];
        [_cBtn addTarget:self action:@selector(cBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cBtn];
        
        
        //线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
        line.backgroundColor = UIColorFromRGB(250, 250, 250);
        [self addSubview:line];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
    }
    return self;
    
}

- (void)aBtn:(id)sender {
    
    self.aBlock();
}

- (void)bBtn:(id)sender {
    
    self.bBlock();
}

- (void)cBtn:(id)sender {
    
    self.cBlock();
}
@end
