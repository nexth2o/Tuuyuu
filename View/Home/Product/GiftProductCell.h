//
//  GiftProductCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/20.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface GiftProductCell : BaseTableViewCell

@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIImageView *rightImageView2;
@property (nonatomic, strong) UILabel *rightTitle;
@property (nonatomic, strong) UILabel *rightSubTitle;
@property (nonatomic, strong) UILabel *tipsTitle;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UILabel *oldPriceLabel;
@property(assign, nonatomic) float oldPrice;
@property (nonatomic, strong) UILabel *orderCount;
@property (nonatomic, strong) UIButton *plus;
@property (nonatomic, strong) UIButton *minus;
@property (assign, nonatomic) NSUInteger amount;

@property (copy, nonatomic) void (^plusBlock)(NSInteger count,BOOL animated);

@end
