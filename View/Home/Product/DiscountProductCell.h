//
//  DiscountProductCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/19.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface DiscountProductCell : BaseTableViewCell

@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIImageView *rightImageView2;
@property (nonatomic, strong) UILabel *rightTitle;
@property (nonatomic, strong) UILabel *rightSubTitle;
@property (nonatomic, strong) UIImageView *label1;
@property (nonatomic, strong) UIImageView *label2;
@property (nonatomic, strong) UIImageView *label3;
@property (nonatomic, strong) UIImageView *label4;
@property (nonatomic, strong) UIImageView *label5;
@property (nonatomic, strong) UIImageView *label6;
@property (nonatomic, strong) UIImageView *label7;


@property (nonatomic, strong) UILabel *giftLabel;
@property (nonatomic, strong) UILabel *giftLabel2;
@property (nonatomic, strong) UIImageView *giftImageView;
@property (nonatomic, strong) UIImageView *giftImageView2;
@property (nonatomic, strong) UILabel *giftTitle;
@property (nonatomic, strong) UILabel *giftSubTitle;
@property (nonatomic, strong) UILabel *giftPrice;
@property (nonatomic, strong) UILabel *giftOldPrice;

@property (nonatomic, strong) NSArray *salesArray;

@property (nonatomic, strong) UILabel *priceLabel;


@property(assign, nonatomic) float oldPrice;
@property(assign, nonatomic) float newPrice;

@property (nonatomic, strong) UILabel *orderCount;
@property (nonatomic, strong) UIButton *plus;
@property (nonatomic, strong) UIButton *minus;

@property (assign, nonatomic) NSUInteger amount;

@property (nonatomic, strong) UIButton *packageBtn;
@property (copy, nonatomic) void (^packageBlock)(NSInteger count,BOOL animated);

@property (copy, nonatomic) void (^plusBlock)(NSInteger count,BOOL animated);
//第二件折扣
@property (nonatomic, strong) UILabel *orderCount2;
@property (nonatomic, strong) UIButton *plus2;
@property (nonatomic, strong) UIButton *minus2;

@property (assign, nonatomic) NSUInteger amount2;

@property (copy, nonatomic) void (^plusBlock2)(NSInteger count, BOOL animated, BOOL show);

@end
