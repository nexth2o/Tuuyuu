//
//  OrderDetailHeaderCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/15.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "OrderDetailHeaderCell.h"

@implementation OrderDetailHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //订单状态按钮
        _statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_statusBtn setFrame:CGRectMake(0*SCALE, 5*SCALE, SCREEN_WIDTH, 37*SCALE)];
        [_statusBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        _statusBtn.titleLabel.font = [UIFont systemFontOfSize:18*SCALE];
        [_statusBtn setTitle:@"订单已完成" forState:UIControlStateNormal];
        [_statusBtn addTarget:self action:@selector(status:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_statusBtn];
        
        //提示
        _tips = [[UILabel alloc] initWithFrame:CGRectMake(40*SCALE, CGRectGetMaxY(_statusBtn.frame), SCREEN_WIDTH-80*SCALE, 40*SCALE)];
        _tips.textAlignment = NSTextAlignmentCenter;
        _tips.numberOfLines = 2;
        _tips.textColor = [UIColor darkGrayColor];
        _tips.font = [UIFont systemFontOfSize:13*SCALE];
        _tips.text = @"感谢您对兔悠的支持，欢迎再次光临!";
        [self addSubview:_tips];
        
        //按钮区
        _bBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bBtn setFrame:CGRectMake((SCREEN_WIDTH -88*SCALE)/2, CGRectGetMaxY(_tips.frame)+5*SCALE, 88*SCALE, 40*SCALE)];
        [_bBtn setBackgroundImage:[UIImage imageNamed:@"order_again"] forState:UIControlStateNormal];
        [_bBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _bBtn.titleLabel.font = [UIFont systemFontOfSize:13.0*SCALE];
        [_bBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        [_bBtn addTarget:self action:@selector(bBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_bBtn setHidden:YES];
        [self addSubview:_bBtn];
        
        _aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_aBtn setFrame:CGRectMake((SCREEN_WIDTH -88*SCALE)/2-88*SCALE-5*SCALE, CGRectGetMaxY(_tips.frame)+5*SCALE, 88*SCALE, 40*SCALE)];
        [_aBtn setBackgroundImage:[UIImage imageNamed:@"order_again"] forState:UIControlStateNormal];
        [_aBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _aBtn.titleLabel.font = [UIFont systemFontOfSize:13.0*SCALE];
        [_aBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        [_aBtn addTarget:self action:@selector(aBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_aBtn setHidden:YES];
        [self addSubview:_aBtn];
        
        _cBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cBtn setFrame:CGRectMake((SCREEN_WIDTH -88*SCALE)/2+88*SCALE+5*SCALE, CGRectGetMaxY(_tips.frame)+5*SCALE, 88*SCALE, 40*SCALE)];
        [_cBtn setBackgroundImage:[UIImage imageNamed:@"order_again"] forState:UIControlStateNormal];
        [_cBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cBtn.titleLabel.font = [UIFont systemFontOfSize:13.0*SCALE];
        [_cBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        [_cBtn addTarget:self action:@selector(cBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_cBtn setHidden:YES];
        [self addSubview:_cBtn];
        
        _dBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dBtn setFrame:CGRectMake((SCREEN_WIDTH -88*2*SCALE-5*SCALE)/2, CGRectGetMaxY(_tips.frame)+5*SCALE, 88*SCALE, 40*SCALE)];
        [_dBtn setBackgroundImage:[UIImage imageNamed:@"order_again"] forState:UIControlStateNormal];
        [_dBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _dBtn.titleLabel.font = [UIFont systemFontOfSize:13.0*SCALE];
        [_dBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        [_dBtn addTarget:self action:@selector(dBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_dBtn setHidden:YES];
        [self addSubview:_dBtn];
        
        _eBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_eBtn setFrame:CGRectMake(CGRectGetMaxX(_dBtn.frame)+5*SCALE, CGRectGetMaxY(_tips.frame)+5*SCALE, 88*SCALE, 40*SCALE)];
        [_eBtn setBackgroundImage:[UIImage imageNamed:@"order_again"] forState:UIControlStateNormal];
        [_eBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _eBtn.titleLabel.font = [UIFont systemFontOfSize:13.0*SCALE];
        [_eBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        [_eBtn addTarget:self action:@selector(eBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_eBtn setHidden:YES];
        [self addSubview:_eBtn];
        
        //线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_aBtn.frame)+15*SCALE, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineView];
        
        //骑士
        //图片
        _staffIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, CGRectGetMaxY(lineView.frame)+20*SCALE, 36*SCALE, 36*SCALE)];
        
        //这里应该使用骑士的性别 服务器暂时没给返回
        if ([[[UserDefaults service] getGender] isEqualToString:@"1"]) {
            _staffIcon.image = [UIImage imageNamed:@"test_head"];
        }else {
            _staffIcon.image = [UIImage imageNamed:@"test_head2"];
        }
        
        [self addSubview:_staffIcon];
        
        
        //骑士名
        _staffName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_staffIcon.frame)+20*SCALE, CGRectGetMaxY(lineView.frame)+10*SCALE, 50*SCALE, 20*SCALE)];
        _staffName.textColor = [UIColor darkGrayColor];
        _staffName.font = [UIFont systemFontOfSize:16*SCALE];
        [self addSubview:_staffName];
        
        //骑士标识
        _staffMark = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_staffName.frame)+5*SCALE, _staffName.frame.origin.y+2*SCALE, 50*SCALE, 16*SCALE)];
        _staffMark.text = @"兔悠骑士";
        _staffMark.textColor = MAIN_TEXT_COLOR;
        _staffMark.textAlignment = NSTextAlignmentCenter;
        _staffMark.font = [UIFont systemFontOfSize:10*SCALE];
        _staffMark.layer.backgroundColor = ICON_COLOR.CGColor;
        _staffMark.layer.cornerRadius = 2;
        _staffMark.layer.borderWidth = 0.6;
        _staffMark.layer.borderColor = ICON_COLOR.CGColor;
        [self addSubview:_staffMark];
        
        //评星
        _star1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_staffIcon.frame)+20*SCALE, CGRectGetMaxY(_staffName.frame)+18*SCALE, 12*SCALE, 12*SCALE)];
        _star1.image = [UIImage imageNamed:@"score_star_yellow"];
        [self addSubview:_star1];
        
        _star2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_star1.frame)+2*SCALE, CGRectGetMaxY(_staffName.frame)+18*SCALE, 12*SCALE, 12*SCALE)];
        _star2.image = [UIImage imageNamed:@"score_star_yellow"];
        [self addSubview:_star2];
        
        _star3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_star2.frame)+2*SCALE, CGRectGetMaxY(_staffName.frame)+18*SCALE, 12*SCALE, 12*SCALE)];
        _star3.image = [UIImage imageNamed:@"score_star_yellow"];
        [self addSubview:_star3];
        
        _star4 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_star3.frame)+2*SCALE, CGRectGetMaxY(_staffName.frame)+18*SCALE, 12*SCALE, 12*SCALE)];
        _star4.image = [UIImage imageNamed:@"score_star_yellow"];
        [self addSubview:_star4];
        
        _star5 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_star4.frame)+2*SCALE, CGRectGetMaxY(_staffName.frame)+18*SCALE, 12*SCALE, 12*SCALE)];
        _star5.image = [UIImage imageNamed:@"score_star_yellow"];
        [self addSubview:_star5];
    
        //评分
        _score = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_star5.frame)+10*SCALE, CGRectGetMaxY(_staffName.frame)+18*SCALE, 40*SCALE, 12*SCALE)];
        _score.text = @"4.9分";
        _score.textColor = MAIN_COLOR;
        _score.font = [UIFont systemFontOfSize:11*SCALE];
        [self addSubview:_score];
        
        //电话
        _telBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_telBtn setFrame:CGRectMake(SCREEN_WIDTH -44*SCALE, CGRectGetMaxY(lineView.frame)+20*SCALE, 44*SCALE, 44*SCALE)];
        [_telBtn setBackgroundImage:[UIImage imageNamed:@"order_staff_phone"] forState:UIControlStateNormal];
        [_telBtn addTarget:self action:@selector(tel:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_telBtn];
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
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
- (void)dBtn:(id)sender {
    
    self.dBlock();
}
- (void)eBtn:(id)sender {
    
    self.eBlock();
}

- (void)tel:(id)sender {
    
    self.phoneBlock();
    
}

- (void)status:(id)sender {
    
    self.statusBlock();
    
}


@end
