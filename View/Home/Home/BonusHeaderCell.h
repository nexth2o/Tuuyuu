//
//  BonusHeaderCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/9.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BonusHeaderCell : BaseTableViewCell

@property (copy, nonatomic) void (^wxBtnBlock)(void);
@property (copy, nonatomic) void (^qqBtnBlock)(void);
@property (copy, nonatomic) void (^faceBtnBlock)(void);
@property (copy, nonatomic) void (^friendBtnBlock)(void);
@property (copy, nonatomic) void (^tipsBtnBlock)(void);

@end
