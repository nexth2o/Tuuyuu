//
//  SaleProductCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/18.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SaleProductCell : BaseTableViewCell

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

@property (nonatomic, strong) UIImageView *giftImageView;
@property (nonatomic, strong) UIImageView *giftImageView2;
@property (nonatomic, strong) UILabel *giftTitle;
@property (nonatomic, strong) UILabel *giftSubTitle;
@property (nonatomic, strong) UILabel *giftPrice;
@property (nonatomic, strong) UILabel *giftOldPriceLabel;
@property (nonatomic, strong) UILabel *giftLabel;

@property (nonatomic, strong) NSArray *salesArray;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *oldPriceLabel;

@property(assign, nonatomic) float oldPrice;
@property(assign, nonatomic) float giftOldPrice;
@property(assign, nonatomic) float newPrice;
@property (nonatomic, strong) UILabel *orderCount;
@property (nonatomic, strong) UIButton *plus;
@property (nonatomic, strong) UIButton *minus;

@property (assign, nonatomic) NSUInteger amount;

@property (copy, nonatomic) void (^plusBlock)(NSInteger count,BOOL animated);

@end
