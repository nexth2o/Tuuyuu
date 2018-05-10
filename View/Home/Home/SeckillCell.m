//
//  SeckillCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/5/19.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SeckillCell.h"


@interface SeckillCell ()<SeckillScrollViewDelegate> {
    UIButton *saleBtn;
    UIButton *halfBtn;
    UIButton *freeBtn;
    UIButton *newBtn;
    
    UIView *lineView1;
    UIView *lineView2;
    UIView *lineView3;
    UIView *lineView4;
    
}

@end

@implementation SeckillCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //标题区30
        //兔悠秒杀图标
        _seckillImageView = [[UIImageView alloc] init];
        _seckillImageView.image = [UIImage imageNamed:@"home_seckill"];
        [self addSubview:_seckillImageView];
        
        //兔悠秒杀标题
        _seckillLabel = [[UILabel alloc] init];
        _seckillLabel.text = @"兔悠秒杀";
        [_seckillLabel setFont:[UIFont systemFontOfSize:15*SCALE]];
        _seckillLabel.textColor = [UIColor redColor];
        [self addSubview:_seckillLabel];
        
        //秒杀倒计时背景
        _timeImageView = [[UIImageView alloc] init];
        _timeImageView.image = [UIImage imageNamed:@"home_seckill_time"];
        [self addSubview:_timeImageView];
        
        //兔悠秒杀倒计时
        _hourLabel = [[UILabel alloc] init];
        _hourLabel.text = @"00";
        _hourLabel.textColor = [UIColor whiteColor];
        [_hourLabel setFont:[UIFont systemFontOfSize:12*SCALE]];
        [self addSubview:_hourLabel];
        
        _minuteLabel = [[UILabel alloc] init];
        _minuteLabel.text = @"00";
        _minuteLabel.textColor = [UIColor whiteColor];
        [_minuteLabel setFont:[UIFont systemFontOfSize:12*SCALE]];
        [self addSubview:_minuteLabel];
        
        _secondLabel = [[UILabel alloc] init];
        _secondLabel.text = @"00";
        _secondLabel.textColor = [UIColor whiteColor];
        [_secondLabel setFont:[UIFont systemFontOfSize:12*SCALE]];
        [self addSubview:_secondLabel];
        
        //分割线
        lineView1 = [[UIView alloc] init];
        lineView1.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineView1];
        
        //分割线
        lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineView2];
        
        
        _saleImage = [[UIImageView alloc] init];
        [self addSubview:_saleImage];
        
        _halfImage = [[UIImageView alloc] init];
        [self addSubview:_halfImage];
        
        _freeImage = [[UIImageView alloc] init];
        [self addSubview:_freeImage];
        
        _nnewImage = [[UIImageView alloc] init];
        [self addSubview:_nnewImage];
        
        //按钮区
        //特价专区
        saleBtn = [[UIButton alloc] init];
        [saleBtn addTarget:self action:@selector(saleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:saleBtn];
        
        halfBtn = [[UIButton alloc] init];
        [halfBtn addTarget:self action:@selector(halfBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:halfBtn];
        
        //分割线
        lineView3 = [[UIView alloc] init];
        lineView3.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineView3];
        
        //买赠区
        freeBtn = [[UIButton alloc] init];
        [freeBtn addTarget:self action:@selector(freeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:freeBtn];
        
        //新品悠荐
        newBtn = [[UIButton alloc] init];
        [newBtn addTarget:self action:@selector(newBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:newBtn];
        
        //竖分割线
        lineView4 = [[UIView alloc] init];
        lineView4.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineView4];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //秒杀区横向滑动
    
    if (_productArray.count > 0) {
        
        //兔悠秒杀图标
        [_seckillImageView setFrame:CGRectMake(10*SCALE, 7*SCALE, 16*SCALE, 16*SCALE)];
        //兔悠秒杀标题
        [_seckillLabel setFrame:CGRectMake(CGRectGetMaxX(_seckillImageView.frame)+6*SCALE, 5*SCALE, 65*SCALE, 20*SCALE)];
        
        //秒杀倒计时背景
        [_timeImageView setFrame:CGRectMake(CGRectGetMaxX(_seckillLabel.frame)+8*SCALE, 7*SCALE, 68*SCALE, 16*SCALE)];
        
        //兔悠秒杀倒计时
        [_hourLabel setFrame:CGRectMake(CGRectGetMaxX(_seckillLabel.frame)+10*SCALE, 5*SCALE, 20*SCALE, 20*SCALE)];
        
        [_minuteLabel setFrame:CGRectMake(CGRectGetMaxX(_hourLabel.frame)+4.5*SCALE, 5*SCALE, 20*SCALE, 20*SCALE)];
        
        [_secondLabel setFrame:CGRectMake(CGRectGetMaxX(_minuteLabel.frame)+5*SCALE, 5*SCALE, 20*SCALE, 20*SCALE)];
        
        //分割线
        [lineView1 setFrame:CGRectMake(0, 29, SCREEN_WIDTH, 1)];
        
        [_scrImage removeFromSuperview];
        _scrImage = [[SeckillScrollView alloc] initWithFrame:CGRectMake(0, 30*SCALE, 100*SCALE, 110*SCALE) withArray:_productArray];
        _scrImage.delegate = self;
        [self addSubview:_scrImage];
        
        [saleBtn setFrame:CGRectMake(0, CGRectGetMaxY(_scrImage.frame)+40*SCALE+1, SCREEN_WIDTH/2, 125*SCALE)];
        [halfBtn setFrame:CGRectMake(SCREEN_WIDTH/2, saleBtn.frame.origin.y, SCREEN_WIDTH/2, 125*SCALE)];
        [freeBtn setFrame:CGRectMake(0, CGRectGetMaxY(saleBtn.frame)+1, SCREEN_WIDTH/2, 125*SCALE)];
        [newBtn setFrame:CGRectMake(SCREEN_WIDTH/2, freeBtn.frame.origin.y, SCREEN_WIDTH/2, 125*SCALE)];
        
        [_saleImage setFrame:CGRectMake(0, CGRectGetMaxY(_scrImage.frame)+40*SCALE+1, SCREEN_WIDTH/2, 125*SCALE)];
        [_halfImage setFrame:CGRectMake(SCREEN_WIDTH/2, saleBtn.frame.origin.y, SCREEN_WIDTH/2, 125*SCALE)];
        [_freeImage setFrame:CGRectMake(0, CGRectGetMaxY(saleBtn.frame)+1, SCREEN_WIDTH/2, 125*SCALE)];
        [_nnewImage setFrame:CGRectMake(SCREEN_WIDTH/2, freeBtn.frame.origin.y, SCREEN_WIDTH/2, 125*SCALE)];
        
        //分割线
        [lineView2 setFrame:CGRectMake(0, CGRectGetMaxY(_scrImage.frame)+40*SCALE, SCREEN_WIDTH, 1)];
        [lineView3 setFrame:CGRectMake(0, CGRectGetMaxY(saleBtn.frame), SCREEN_WIDTH, 1)];
        [lineView4 setFrame:CGRectMake(SCREEN_WIDTH/2, CGRectGetMaxY(_scrImage.frame)+40*SCALE, 1, 250*SCALE)];
    }else {
        
        
        //兔悠秒杀图标
        [_seckillImageView setFrame:CGRectZero];
        //兔悠秒杀标题
        [_seckillLabel setFrame:CGRectZero];
        
        //秒杀倒计时背景
        [_timeImageView setFrame:CGRectZero];
        
        //兔悠秒杀倒计时
        [_hourLabel setFrame:CGRectZero];
        
        [_minuteLabel setFrame:CGRectZero];
        
        [_secondLabel setFrame:CGRectZero];
        
        //分割线
        [lineView1 setFrame:CGRectZero];
        
        _scrImage = [[SeckillScrollView alloc] initWithFrame:CGRectZero];
        [_scrImage removeFromSuperview];
        
        [saleBtn setFrame:CGRectMake(0, 1, SCREEN_WIDTH/2, 125*SCALE)];
        [halfBtn setFrame:CGRectMake(SCREEN_WIDTH/2, saleBtn.frame.origin.y, SCREEN_WIDTH/2, 125*SCALE)];
        [freeBtn setFrame:CGRectMake(0, CGRectGetMaxY(saleBtn.frame)+1, SCREEN_WIDTH/2, 125*SCALE)];
        [newBtn setFrame:CGRectMake(SCREEN_WIDTH/2, freeBtn.frame.origin.y, SCREEN_WIDTH/2, 125*SCALE)];
        
        [_saleImage setFrame:CGRectMake(0, 1, SCREEN_WIDTH/2, 125*SCALE)];
        [_halfImage setFrame:CGRectMake(SCREEN_WIDTH/2, saleBtn.frame.origin.y, SCREEN_WIDTH/2, 125*SCALE)];
        [_freeImage setFrame:CGRectMake(0, CGRectGetMaxY(saleBtn.frame)+1, SCREEN_WIDTH/2, 125*SCALE)];
        [_nnewImage setFrame:CGRectMake(SCREEN_WIDTH/2, freeBtn.frame.origin.y, SCREEN_WIDTH/2, 125*SCALE)];
        
        //分割线
        [lineView2 setFrame:CGRectMake(0, CGRectGetMaxY(_scrImage.frame), SCREEN_WIDTH, 1)];
        [lineView3 setFrame:CGRectMake(0, CGRectGetMaxY(saleBtn.frame), SCREEN_WIDTH, 1)];
        [lineView4 setFrame:CGRectMake(SCREEN_WIDTH/2, CGRectGetMaxY(_scrImage.frame)+0*SCALE, 1, 250*SCALE)];
    }
}

#pragma mark - SeckillCellDelegate
- (void)didSelectItemAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndex:)]) {
        [self.delegate didSelectItemAtIndex:index];
    }
}

- (void)saleBtnClick {
    self.saleBtnEvent();
}

- (void)halfBtnClick {
    self.halfBtnEvent();
}

- (void)freeBtnClick {
    self.freeBtnEvent();
}

- (void)newBtnClick {
    self.newBtnEvent();
}


@end
