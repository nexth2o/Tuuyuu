//
//  ButtonCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/5/25.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ButtonCell : BaseTableViewCell

@property (copy, nonatomic) void (^categoryBtnEvent)(void);
@property (copy, nonatomic) void (^friedBtnEvent)(void);
@property (copy, nonatomic) void (^fastBtnEvent)(void);
@property (copy, nonatomic) void (^couponBtnEvent)(void);
@property (copy, nonatomic) void (^bonusBtnEvent)(void);
@property (copy, nonatomic) void (^pointBtnEvent)(void);
@property (copy, nonatomic) void (^signBtnEvent)(void);
@property (copy, nonatomic) void (^favoriteBtnEvent)(void);

@end
