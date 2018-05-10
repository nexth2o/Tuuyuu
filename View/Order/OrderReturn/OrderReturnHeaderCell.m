//
//  OrderReturnHeaderCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/3.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "OrderReturnHeaderCell.h"

@implementation OrderReturnHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //(40*5+6+70)
        self.contentView.backgroundColor = UIColorFromRGB(244, 244, 244);
        
        //分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0*SCALE, SCREEN_WIDTH, 6*SCALE)];
        lineView.backgroundColor = UIColorFromRGB(244, 244, 244);
        [self addSubview:lineView];
        
        UIView *storeBg = [[UIView alloc] initWithFrame:CGRectMake(0, 6*SCALE, SCREEN_WIDTH, 70*SCALE)];
        storeBg.backgroundColor =[UIColor whiteColor];
        [self addSubview:storeBg];
        
        //图片
        UIImageView *_image = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, 15*SCALE, 40*SCALE, 40*SCALE)];
        _image.image = [UIImage imageNamed:@"order_logo"];
        [storeBg addSubview:_image];
        
        //店名
        _title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_image.frame) + 10*SCALE, 15*SCALE, 200*SCALE, 20*SCALE)];
        _title.font = [UIFont systemFontOfSize:16*SCALE];
        [storeBg addSubview:_title];
        
        //消费信息
        _subTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_image.frame)+10*SCALE, CGRectGetMaxY(_title.frame)+5*SCALE, 200*SCALE, 20*SCALE)];
        _subTitle.textColor = [UIColor darkGrayColor];
        _subTitle.font = [UIFont systemFontOfSize:12*SCALE];
        [storeBg addSubview:_subTitle];
        
        //退款方式
        UILabel *returnPay = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, 76*SCALE, SCREEN_WIDTH-20*SCALE, 40*SCALE)];
        returnPay.text = @"退款方式";
        returnPay.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:returnPay];
        
        UIView *returnPayBg = [[UIView alloc] initWithFrame:CGRectMake(0*SCALE, 116*SCALE, SCREEN_WIDTH, 40*SCALE)];
        returnPayBg.backgroundColor = [UIColor whiteColor];
        [self addSubview:returnPayBg];
        
        _pay = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, 0*SCALE, SCREEN_WIDTH-20*SCALE, 40*SCALE)];
        _pay.font = [UIFont systemFontOfSize:15*SCALE];
        [returnPayBg addSubview:_pay];
        
        //选择退货类型
        UILabel *returnType = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, 156*SCALE, SCREEN_WIDTH-20*SCALE, 40*SCALE)];
        returnType.text = @"选择退款类型";
        returnType.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:returnType];
        
        UIView *returnTypeBg = [[UIView alloc] initWithFrame:CGRectMake(0*SCALE, 196*SCALE, SCREEN_WIDTH, 80*SCALE)];
        returnTypeBg.backgroundColor = [UIColor whiteColor];
        [self addSubview:returnTypeBg];
        
        UILabel *all = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, 0*SCALE, SCREEN_WIDTH-20*SCALE, 40*SCALE)];
        all.text = @"申请全单退款";
        all.font = [UIFont systemFontOfSize:15*SCALE];
        [returnTypeBg addSubview:all];
        
        UILabel *other = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, 40*SCALE, SCREEN_WIDTH-20*SCALE, 40*SCALE)];
        other.text = @"申请部分退款(适用少送漏送)";
        other.font = [UIFont systemFontOfSize:13*SCALE];
        [returnTypeBg addSubview:other];
        
        _allIcon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30*SCALE, 10*SCALE, 20*SCALE, 20*SCALE)];
        _allIcon.image = [UIImage imageNamed:@"order_unselected"];
        [returnTypeBg addSubview:_allIcon];
        
        _otherIcon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30*SCALE, 50*SCALE, 20*SCALE, 20*SCALE)];
        _otherIcon.image = [UIImage imageNamed:@"order_selected"];
        [returnTypeBg addSubview:_otherIcon];
        
        //全单
        UIButton *_allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allBtn setFrame:CGRectMake(0*SCALE, 0*SCALE, SCREEN_WIDTH, 40*SCALE)];
        [_allBtn addTarget:self action:@selector(allBtn:) forControlEvents:UIControlEventTouchUpInside];
        [returnTypeBg addSubview:_allBtn];
        
        //部分
        UIButton *_otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_otherBtn setFrame:CGRectMake(0*SCALE, 40*SCALE, SCREEN_WIDTH, 40*SCALE)];
        [_otherBtn addTarget:self action:@selector(otherBtn:) forControlEvents:UIControlEventTouchUpInside];
        [returnTypeBg addSubview:_otherBtn];
        
    }
    return self;
}

- (void)allBtn:(id)sender {
    self.allBtnBlock();
}

- (void)otherBtn:(id)sender {
    self.otherBtnBlock();
}


- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
