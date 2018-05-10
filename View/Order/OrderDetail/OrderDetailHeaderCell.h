//
//  OrderDetailHeaderCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/6/15.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface OrderDetailHeaderCell : BaseTableViewCell


@property (nonatomic, strong) UIButton *statusBtn;
@property (nonatomic, strong) UILabel *tips;
@property (nonatomic, strong) UIImageView *staffIcon;
@property (nonatomic, strong) UILabel *staffName;
@property (nonatomic, strong) UILabel *staffMark;
@property (nonatomic, strong) UILabel *score;

@property (nonatomic, strong) UIButton *telBtn;

@property (nonatomic, strong) UIImageView *star1;
@property (nonatomic, strong) UIImageView *star2;
@property (nonatomic, strong) UIImageView *star3;
@property (nonatomic, strong) UIImageView *star4;
@property (nonatomic, strong) UIImageView *star5;

@property (nonatomic, strong) UIButton *aBtn;
@property (nonatomic, strong) UIButton *bBtn;
@property (nonatomic, strong) UIButton *cBtn;
@property (nonatomic, strong) UIButton *dBtn;
@property (nonatomic, strong) UIButton *eBtn;

@property (copy, nonatomic) void (^aBlock)();
@property (copy, nonatomic) void (^bBlock)();
@property (copy, nonatomic) void (^cBlock)();
@property (copy, nonatomic) void (^dBlock)();
@property (copy, nonatomic) void (^eBlock)();

@property (copy, nonatomic) void (^phoneBlock)();
@property (copy, nonatomic) void (^statusBlock)();


@end
