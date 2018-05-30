//
//  SingleProductCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/5/24.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SingleProductCell : BaseTableViewCell

@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *rightImageView;
@property (strong, nonatomic) UIImageView *leftImageView2;
@property (strong, nonatomic) UIImageView *rightImageView2;
@property (strong, nonatomic) UILabel *leftTitle;
@property (strong, nonatomic) UILabel *rightTitle;
@property (nonatomic) float leftPrice;
@property (nonatomic) float rightPrice;

@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *rightBtn;

@property (copy, nonatomic) void (^leftBtnEvent)(void);
@property (copy, nonatomic) void (^rightBtnEvent)(void);
@property (copy, nonatomic) void (^leftCartBtnEvent)(void);
@property (copy, nonatomic) void (^rightCartBtnEvent)(void);


@end
