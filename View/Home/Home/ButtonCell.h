//
//  ButtonCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/5/25.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ButtonCell : BaseTableViewCell

@property (copy, nonatomic) void (^categoryBtnEvent)();
@property (copy, nonatomic) void (^friedBtnEvent)();
@property (copy, nonatomic) void (^fastBtnEvent)();
@property (copy, nonatomic) void (^couponBtnEvent)();
@property (copy, nonatomic) void (^bonusBtnEvent)();
@property (copy, nonatomic) void (^pointBtnEvent)();
@property (copy, nonatomic) void (^signBtnEvent)();
@property (copy, nonatomic) void (^favoriteBtnEvent)();

@end
