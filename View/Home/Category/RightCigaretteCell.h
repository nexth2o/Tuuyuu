//
//  RightCigaretteCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/10/28.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface RightCigaretteCell : BaseTableViewCell

@property (nonatomic, strong) UILabel *rightTitle;
@property (nonatomic, strong) UILabel *rightSubTitle;
@property (nonatomic, strong) UIImageView *label1;
@property (nonatomic, strong) UIImageView *label2;
@property (nonatomic, strong) UIImageView *label3;
@property (nonatomic, strong) UIImageView *label4;
@property (nonatomic, strong) UIImageView *label5;
@property (nonatomic, strong) UIImageView *label6;
@property (nonatomic, strong) NSArray *salesArray;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UILabel *oldPriceLabel;
@property(assign, nonatomic) float oldPrice;
@property (nonatomic, strong) UIButton *packageBtn;
@property (nonatomic, strong) UILabel *orderCount;
@property (nonatomic, strong) UIButton *plus;
@property (nonatomic, strong) UIButton *minus;
@property (assign, nonatomic) NSUInteger amount;
@property (nonatomic, strong) UIImageView *soldOut;

@property (copy, nonatomic) void (^plusBlock)(NSInteger count,BOOL animated);
@property (copy, nonatomic) void (^packageBlock)(NSInteger count,BOOL animated);

@end
