//
//  ProductCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/6/8.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ProductCell : BaseTableViewCell

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

@property (nonatomic, strong) NSArray *salesArray;
@property (nonatomic, strong) UILabel *price;

@property (nonatomic, strong) UILabel *oldPriceLabel;
@property(assign, nonatomic) float oldPrice;

@property (nonatomic, strong) UILabel *orderCount;
@property (nonatomic, strong) UIButton *plus;
@property (nonatomic, strong) UIButton *minus;

@property (assign, nonatomic) NSUInteger amount;

@property (nonatomic, strong) UIButton *packageBtn;

@property (copy, nonatomic) void (^plusBlock)(NSInteger count,BOOL animated);
@property (copy, nonatomic) void (^packageBlock)(NSInteger count,BOOL animated);


@end
