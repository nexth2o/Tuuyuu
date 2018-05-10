//
//  ProductDetailCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/6/22.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ProductDetailCell : BaseTableViewCell

@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIImageView *rightImageView2;
@property (nonatomic, strong) UILabel *rightTitle;
@property (nonatomic, strong) UILabel *rightSubTitle;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UILabel *rate;
@property (nonatomic, strong) UILabel *infoTitle;
@property (nonatomic, strong) UILabel *info;
@property (nonatomic, strong) UILabel *orderCount;
@property (nonatomic, strong) UIButton *plus;
@property (nonatomic, strong) UIButton *minus;
@property (assign, nonatomic) NSUInteger amount;
@property (assign, nonatomic) float newPrice;
@property (nonatomic, strong) UILabel *oldPriceLabel;
@property(assign, nonatomic) float oldPrice;

@property (copy, nonatomic) void (^plusBlock)(NSInteger count,BOOL animated);

@property (assign, nonatomic) NSUInteger amount2;

@end
