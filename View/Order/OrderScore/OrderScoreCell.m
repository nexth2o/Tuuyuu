//
//  OrderScoreCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/8.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "OrderScoreCell.h"

@implementation OrderScoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _product = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, 10*SCALE, 200*SCALE, 20*SCALE)];
        _product.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_product];
        
        _upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_upBtn setFrame:CGRectMake(SCREEN_WIDTH - 135*SCALE, 5*SCALE, 58*SCALE, 30*SCALE)];
        [_upBtn setImage:[UIImage imageNamed:@"score_up"] forState:UIControlStateNormal];
        [_upBtn addTarget:self action:@selector(upBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_upBtn];

        _downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downBtn setFrame:CGRectMake(SCREEN_WIDTH - 68*SCALE, 5*SCALE, 58*SCALE, 30*SCALE)];
        [_downBtn setImage:[UIImage imageNamed:@"score_down"] forState:UIControlStateNormal];
        [_downBtn addTarget:self action:@selector(downBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_downBtn];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 39*SCALE, SCREEN_WIDTH, 1)];
        line1.backgroundColor = UIColorFromRGB(244, 244, 244);
        [self addSubview:line1];
        
    }
    return self;
}

- (void)upBtn:(id)sender {
    self.upBtnBlock();
}

- (void)downBtn:(id)sender {
    self.downBtnBlock();
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

@end
