//
//  OrderScoreCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/8.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface OrderScoreCell : BaseTableViewCell

@property (strong, nonatomic) UILabel *product;
@property (strong, nonatomic) UIButton *upBtn;
@property (strong, nonatomic) UIButton *downBtn;

@property (copy, nonatomic) void (^upBtnBlock)();
@property (copy, nonatomic) void (^downBtnBlock)();

@end
