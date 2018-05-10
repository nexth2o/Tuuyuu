//
//  SettingCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/16.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SettingCell : BaseTableViewCell

@property(strong, nonatomic) UILabel *titleLabel;
@property(strong, nonatomic) UILabel *subTitleLabel;
@property(strong, nonatomic) UISwitch *switchBtn;

@property (copy, nonatomic) void (^switchActionBlock)();

@end
