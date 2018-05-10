//
//  OrderScoreHeaderCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/8.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "OrderScoreHeaderCell.h"

@implementation OrderScoreHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //骑士区 60 +50 +6
        _staffIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, 10*SCALE, 40*SCALE, 40*SCALE)];
        if ([[[UserDefaults service] getGender] isEqualToString:@"1"]) {
            _staffIcon.image = [UIImage imageNamed:@"test_head"];
        }else {
            _staffIcon.image = [UIImage imageNamed:@"test_head2"];
        }
        
        [self addSubview:_staffIcon];
        
        _staffLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_staffIcon.frame)+10*SCALE, 10*SCALE, 50*SCALE, 20*SCALE)];
        _staffLabel.font = [UIFont systemFontOfSize:16*SCALE];
        [self addSubview:_staffLabel];
        
        UILabel *staffMark = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_staffIcon.frame)+10*SCALE, CGRectGetMaxY(_staffLabel.frame)+3*SCALE, 40*SCALE, 14*SCALE)];
        staffMark.text = @"兔悠骑士";
        staffMark.textColor = MAIN_TEXT_COLOR;
        staffMark.textAlignment = NSTextAlignmentCenter;
        staffMark.font = [UIFont systemFontOfSize:8*SCALE];
        staffMark.layer.backgroundColor = ICON_COLOR.CGColor;
        staffMark.layer.cornerRadius = 2;
        staffMark.layer.borderWidth = 0.6;
        staffMark.layer.borderColor = ICON_COLOR.CGColor;
        [self addSubview:staffMark];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 59*SCALE, SCREEN_WIDTH, 1)];
        line1.backgroundColor = UIColorFromRGB(244, 244, 244);
        [self addSubview:line1];
        
        
        _staffBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_staffBtn1 setFrame:CGRectMake(110*SCALE, 70*SCALE, 30*SCALE, 30*SCALE)];
        [_staffBtn1 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
        [_staffBtn1 addTarget:self action:@selector(staffBtn1:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_staffBtn1];
        
        _staffBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_staffBtn2 setFrame:CGRectMake(CGRectGetMaxX(_staffBtn1.frame)+1*SCALE, 70*SCALE, 30*SCALE, 30*SCALE)];
        [_staffBtn2 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
        [_staffBtn2 addTarget:self action:@selector(staffBtn2:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_staffBtn2];
        
        _staffBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_staffBtn3 setFrame:CGRectMake(CGRectGetMaxX(_staffBtn2.frame)+1*SCALE, 70*SCALE, 30*SCALE, 30*SCALE)];
        [_staffBtn3 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
        [_staffBtn3 addTarget:self action:@selector(staffBtn3:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_staffBtn3];
        
        _staffBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_staffBtn4 setFrame:CGRectMake(CGRectGetMaxX(_staffBtn3.frame)+1*SCALE, 70*SCALE, 30*SCALE, 30*SCALE)];
        [_staffBtn4 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
        [_staffBtn4 addTarget:self action:@selector(staffBtn4:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_staffBtn4];
        
        _staffBtn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_staffBtn5 setFrame:CGRectMake(CGRectGetMaxX(_staffBtn4.frame)+1*SCALE, 70*SCALE, 30*SCALE, 30*SCALE)];
        [_staffBtn5 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
        [_staffBtn5 addTarget:self action:@selector(staffBtn5:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_staffBtn5];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 110*SCALE, SCREEN_WIDTH, 4*SCALE)];
        line2.backgroundColor = UIColorFromRGB(244, 244, 244);
        [self addSubview:line2];
        
        //店铺区 60+50
        UIImageView *storeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, (114+10)*SCALE, 40*SCALE, 40*SCALE)];
        storeIcon.image = [UIImage imageNamed:@"order_logo"];
        [self addSubview:storeIcon];
        
        _storeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(storeIcon.frame)+10*SCALE, (116+20)*SCALE, 200*SCALE, 20*SCALE)];
        _storeLabel.font = [UIFont systemFontOfSize:16*SCALE];
        [self addSubview:_storeLabel];
        
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, (116+59)*SCALE, SCREEN_WIDTH, 1)];
        line3.backgroundColor = UIColorFromRGB(244, 244, 244);
        [self addSubview:line3];
        
        _storeBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_storeBtn1 setFrame:CGRectMake(110*SCALE, (114+60+10)*SCALE, 30*SCALE, 30*SCALE)];
        [_storeBtn1 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
        [_storeBtn1 addTarget:self action:@selector(storeBtn1:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_storeBtn1];
        
        _storeBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_storeBtn2 setFrame:CGRectMake(CGRectGetMaxX(_storeBtn1.frame)+1*SCALE, (114+60+10)*SCALE, 30*SCALE, 30*SCALE)];
        [_storeBtn2 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
        [_storeBtn2 addTarget:self action:@selector(storeBtn2:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_storeBtn2];
        
        _storeBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_storeBtn3 setFrame:CGRectMake(CGRectGetMaxX(_storeBtn2.frame)+1*SCALE, (114+60+10)*SCALE, 30*SCALE, 30*SCALE)];
        [_storeBtn3 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
        [_storeBtn3 addTarget:self action:@selector(storeBtn3:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_storeBtn3];
        
        _storeBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_storeBtn4 setFrame:CGRectMake(CGRectGetMaxX(_storeBtn3.frame)+1*SCALE, (114+60+10)*SCALE, 30*SCALE, 30*SCALE)];
        [_storeBtn4 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
        [_storeBtn4 addTarget:self action:@selector(storeBtn4:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_storeBtn4];
        
        _storeBtn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_storeBtn5 setFrame:CGRectMake(CGRectGetMaxX(_storeBtn4.frame)+1*SCALE, (114+60+10)*SCALE, 30*SCALE, 30*SCALE)];
        [_storeBtn5 setImage:[UIImage imageNamed:@"score_star_gray"] forState:UIControlStateNormal];
        [_storeBtn5 addTarget:self action:@selector(storeBtn5:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_storeBtn5];
        
        
        
        _storeTextView = [[TTextView alloc] initWithFrame:CGRectMake(10*SCALE, 226*SCALE, SCREEN_WIDTH-20*SCALE, 140*SCALE)];
        _storeTextView.backgroundColor = UIColorFromRGB(244, 244, 244);
        _storeTextView.font = [UIFont systemFontOfSize:15*SCALE];
        _storeTextView.placeholder = @"亲，商品口味如何，对包装服务等还满意吗？";
        _storeTextView.placeholderFont = [UIFont systemFontOfSize:14*SCALE];
        _storeTextView.placeholderColor = [UIColor grayColor];
        _storeTextView.returnKeyType = UIReturnKeyDefault;
        [self addSubview:_storeTextView];
        
        UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, 383*SCALE, SCREEN_WIDTH, 1)];
        line4.backgroundColor = UIColorFromRGB(244, 244, 244);
        [self addSubview:line4];

        
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_storeTextView resignFirstResponder];
}

- (void)staffBtn1:(id)sender {
    self.staffBtn1Block();
}

- (void)staffBtn2:(id)sender {
    self.staffBtn2Block();
}

- (void)staffBtn3:(id)sender {
    self.staffBtn3Block();
}

- (void)staffBtn4:(id)sender {
    self.staffBtn4Block();
}

- (void)staffBtn5:(id)sender {
    self.staffBtn5Block();
}

- (void)storeBtn1:(id)sender {
    self.storeBtn1Block();
}

- (void)storeBtn2:(id)sender {
    self.storeBtn2Block();
}

- (void)storeBtn3:(id)sender {
    self.storeBtn3Block();
}

- (void)storeBtn4:(id)sender {
    self.storeBtn4Block();
}

- (void)storeBtn5:(id)sender {
    self.storeBtn5Block();
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

@end
