//
//  ButtonCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/5/25.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "ButtonCell.h"
#import "HomeButton.h"

@implementation ButtonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        HomeButton *categoryBtn = [[HomeButton alloc] initWithFrame:CGRectMake(0, 6*SCALE, SCREEN_WIDTH/4, 90*SCALE)];
        [categoryBtn setImage:[UIImage imageNamed:@"home_category"] forState:UIControlStateNormal];
        [categoryBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [categoryBtn setTitle:@"商品分类" forState:UIControlStateNormal];
        [categoryBtn.titleLabel setFont:[UIFont systemFontOfSize:12*SCALE]];
        [categoryBtn verticalImageAndTitle:6*SCALE];
        [categoryBtn addTarget:self action:@selector(categoryBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:categoryBtn];
        
        HomeButton *friedBtn = [[HomeButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(categoryBtn.frame), categoryBtn.frame.origin.y, SCREEN_WIDTH/4, 90*SCALE)];
        [friedBtn setImage:[UIImage imageNamed:@"home_fried"] forState:UIControlStateNormal];
        [friedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [friedBtn setTitle:@"炸鸡美食" forState:UIControlStateNormal];
        [friedBtn.titleLabel setFont:[UIFont systemFontOfSize:12*SCALE]];
        [friedBtn verticalImageAndTitle:6*SCALE];
        [friedBtn addTarget:self action:@selector(friedBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:friedBtn];
        
        HomeButton *fastBtn = [[HomeButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(friedBtn.frame), categoryBtn.frame.origin.y, SCREEN_WIDTH/4, 90*SCALE)];
        [fastBtn setImage:[UIImage imageNamed:@"home_fast"] forState:UIControlStateNormal];
        [fastBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [fastBtn setTitle:@"熟食快餐" forState:UIControlStateNormal];
        [fastBtn.titleLabel setFont:[UIFont systemFontOfSize:12*SCALE]];
        [fastBtn verticalImageAndTitle:6*SCALE];
        [fastBtn addTarget:self action:@selector(fastBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fastBtn];
        
        HomeButton *couponBtn = [[HomeButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fastBtn.frame), categoryBtn.frame.origin.y, SCREEN_WIDTH/4, 90*SCALE)];
        [couponBtn setImage:[UIImage imageNamed:@"home_bread"] forState:UIControlStateNormal];
        [couponBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [couponBtn setTitle:@"烘焙面包" forState:UIControlStateNormal];
        [couponBtn.titleLabel setFont:[UIFont systemFontOfSize:12*SCALE]];
        [couponBtn verticalImageAndTitle:6*SCALE];
        [couponBtn addTarget:self action:@selector(couponBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:couponBtn];
        
        HomeButton *bonusBtn = [[HomeButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(categoryBtn.frame), SCREEN_WIDTH/4, 90*SCALE)];
        [bonusBtn setImage:[UIImage imageNamed:@"home_bonus"] forState:UIControlStateNormal];
        [bonusBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [bonusBtn setTitle:@"邀请奖励" forState:UIControlStateNormal];
        [bonusBtn.titleLabel setFont:[UIFont systemFontOfSize:12*SCALE]];
        [bonusBtn verticalImageAndTitle:6*SCALE];
        [bonusBtn addTarget:self action:@selector(bonusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bonusBtn];
        
        HomeButton *pointBtn = [[HomeButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(categoryBtn.frame), CGRectGetMaxY(categoryBtn.frame), SCREEN_WIDTH/4, 90*SCALE)];
        [pointBtn setImage:[UIImage imageNamed:@"home_point"] forState:UIControlStateNormal];
        [pointBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [pointBtn setTitle:@"兔币支付" forState:UIControlStateNormal];
        [pointBtn.titleLabel setFont:[UIFont systemFontOfSize:12*SCALE]];
        [pointBtn verticalImageAndTitle:6*SCALE];
        [pointBtn addTarget:self action:@selector(pointBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pointBtn];
        
        HomeButton *signBtn = [[HomeButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(friedBtn.frame), CGRectGetMaxY(categoryBtn.frame), SCREEN_WIDTH/4, 90*SCALE)];
        [signBtn setImage:[UIImage imageNamed:@"home_sign"] forState:UIControlStateNormal];
        [signBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [signBtn setTitle:@"我的签到" forState:UIControlStateNormal];
        [signBtn.titleLabel setFont:[UIFont systemFontOfSize:12*SCALE]];
        [signBtn verticalImageAndTitle:6*SCALE];
        [signBtn addTarget:self action:@selector(signBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:signBtn];
        
        HomeButton *favoriteBtn = [[HomeButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fastBtn.frame), CGRectGetMaxY(categoryBtn.frame), SCREEN_WIDTH/4, 90*SCALE)];
        [favoriteBtn setImage:[UIImage imageNamed:@"home_favorite"] forState:UIControlStateNormal];
        [favoriteBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [favoriteBtn setTitle:@"我的收藏" forState:UIControlStateNormal];
        [favoriteBtn.titleLabel setFont:[UIFont systemFontOfSize:12*SCALE]];
        [favoriteBtn verticalImageAndTitle:6*SCALE];
        [favoriteBtn addTarget:self action:@selector(favoriteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:favoriteBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)categoryBtnClick {
    self.categoryBtnEvent();
}

- (void)friedBtnClick {
    self.friedBtnEvent();
}

- (void)fastBtnClick {
    self.fastBtnEvent();
}

- (void)couponBtnClick {
    self.couponBtnEvent();
}

- (void)bonusBtnClick {
    self.bonusBtnEvent();
}

- (void)pointBtnClick {
    self.pointBtnEvent();
}

- (void)signBtnClick {
    self.signBtnEvent();
}

- (void)favoriteBtnClick {
    self.favoriteBtnEvent();
}


@end
