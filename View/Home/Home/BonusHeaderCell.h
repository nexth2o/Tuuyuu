//
//  BonusHeaderCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/9.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BonusHeaderCell : BaseTableViewCell

@property (copy, nonatomic) void (^wxBtnBlock)();
@property (copy, nonatomic) void (^qqBtnBlock)();
@property (copy, nonatomic) void (^faceBtnBlock)();
@property (copy, nonatomic) void (^friendBtnBlock)();
@property (copy, nonatomic) void (^tipsBtnBlock)();

@end
