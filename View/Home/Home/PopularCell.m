//
//  PopularCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/5/24.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "PopularCell.h"

@implementation PopularCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //标题区 高度30
        //特色悠选图标
        UIImageView *popularImageView = [[UIImageView alloc] initWithFrame:CGRectMake(140*SCALE, 7*SCALE, 16*SCALE, 16*SCALE)];
        popularImageView.image = [UIImage imageNamed:@"home_special"];
        [self addSubview:popularImageView];
        //特色悠选标题
        UILabel *popularLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(popularImageView.frame)+6*SCALE, 5*SCALE, 80*SCALE, 20*SCALE)];
        popularLabel.text = @"特色悠选";
        [popularLabel setFont:[UIFont systemFontOfSize:15*SCALE]];
        popularLabel.textColor = [UIColor redColor];
        [self addSubview:popularLabel];
        
        //分割线
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 29, SCREEN_WIDTH, 1)];
        lineView1.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineView1];
        
        //炸鸡美食
        _friedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30*SCALE, SCREEN_WIDTH/2, 125*SCALE)];
        [self addSubview:_friedImage];
        
        UIButton *friedBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 30*SCALE, SCREEN_WIDTH/2, 125*SCALE)];
        [friedBtn addTarget:self action:@selector(friedBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:friedBtn];
        
        //熟食快餐
        _fastImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 30*SCALE, SCREEN_WIDTH/4, 125*SCALE)];
        [self addSubview:_fastImage];
        
        UIButton *fastBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 30*SCALE, SCREEN_WIDTH/4, 125*SCALE)];
        [fastBtn addTarget:self action:@selector(fastBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fastBtn];
        
        //烘培面包
        _breadImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4*3, 30*SCALE, SCREEN_WIDTH/4, 125*SCALE)];
        [self addSubview:_breadImage];
        
        UIButton *breadBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4*3, 30*SCALE, SCREEN_WIDTH/4, 125*SCALE)];
        [breadBtn addTarget:self action:@selector(breadBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:breadBtn];
        
        //分割线
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(friedBtn.frame), SCREEN_WIDTH, 1)];
        lineView2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineView2];
        
        
        
        //鲜榨果汁
        _juiceImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(friedBtn.frame)+1, SCREEN_WIDTH/2, 125*SCALE)];
        [self addSubview:_juiceImage];
        
        UIButton *juiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(friedBtn.frame)+1, SCREEN_WIDTH/2, 125*SCALE)];
        [juiceBtn addTarget:self action:@selector(juiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:juiceBtn];
        
        //水果
        _fruitImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, juiceBtn.frame.origin.y, SCREEN_WIDTH/4, 125*SCALE)];
        [self addSubview:_fruitImage];
        
        UIButton *fruitBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, juiceBtn.frame.origin.y, SCREEN_WIDTH/4, 125*SCALE)];
        [fruitBtn addTarget:self action:@selector(fruitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fruitBtn];
        
        //美妆保健
        _healthImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4*3, juiceBtn.frame.origin.y, SCREEN_WIDTH/4, 125*SCALE)];
        [self addSubview:_healthImage];
        
        UIButton *healthBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4*3, juiceBtn.frame.origin.y, SCREEN_WIDTH/4, 125*SCALE)];
        [healthBtn addTarget:self action:@selector(healthBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:healthBtn];
        
        //竖分割线
        UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 30*SCALE, 1, 250*SCALE)];
        lineView3.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineView3];
        
        //竖分割线
        UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4*3, 30*SCALE, 1, 250*SCALE)];
        lineView4.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineView4];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)friedBtnClick {
    self.friedBtnEvent();
}

- (void)fastBtnClick {
    self.fastBtnEvent();
}

- (void)breadBtnClick {
    self.breadBtnEvent();
}

- (void)juiceBtnClick {
    self.juiceBtnEvent();
}

- (void)fruitBtnClick {
    self.fruitBtnEvent();
}

- (void)healthBtnClick {
    self.healthBtnEvent();
}

@end
