//
//  OrderScoreHeaderCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/8.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "TTextView.h"

@interface OrderScoreHeaderCell : BaseTableViewCell

@property (strong, nonatomic) UIImageView *staffIcon;
@property (strong, nonatomic) UILabel *staffLabel;
@property (strong, nonatomic) UILabel *storeLabel;

@property (strong, nonatomic) TTextView *storeTextView;

@property (strong, nonatomic) UIButton *staffBtn1;
@property (strong, nonatomic) UIButton *staffBtn2;
@property (strong, nonatomic) UIButton *staffBtn3;
@property (strong, nonatomic) UIButton *staffBtn4;
@property (strong, nonatomic) UIButton *staffBtn5;

@property (strong, nonatomic) UIButton *storeBtn1;
@property (strong, nonatomic) UIButton *storeBtn2;
@property (strong, nonatomic) UIButton *storeBtn3;
@property (strong, nonatomic) UIButton *storeBtn4;
@property (strong, nonatomic) UIButton *storeBtn5;

@property (copy, nonatomic) void (^staffBtn1Block)();
@property (copy, nonatomic) void (^staffBtn2Block)();
@property (copy, nonatomic) void (^staffBtn3Block)();
@property (copy, nonatomic) void (^staffBtn4Block)();
@property (copy, nonatomic) void (^staffBtn5Block)();

@property (copy, nonatomic) void (^storeBtn1Block)();
@property (copy, nonatomic) void (^storeBtn2Block)();
@property (copy, nonatomic) void (^storeBtn3Block)();
@property (copy, nonatomic) void (^storeBtn4Block)();
@property (copy, nonatomic) void (^storeBtn5Block)();


@end
