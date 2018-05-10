//
//  OrderReturnFooterCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/3.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface OrderReturnFooterCell : BaseTableViewCell

@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UILabel *reason;
@property (copy, nonatomic) void (^reasonBtnBlock)();

@end
