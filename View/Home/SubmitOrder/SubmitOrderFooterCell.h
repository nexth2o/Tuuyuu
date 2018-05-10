//
//  SubmitOrderFooterCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/6/23.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SubmitOrderFooterCell : BaseTableViewCell

@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *subTitle;
@property (nonatomic,strong) UISwitch *switchBtn;

@property (copy, nonatomic) void (^switchActionBlock)();

@end
