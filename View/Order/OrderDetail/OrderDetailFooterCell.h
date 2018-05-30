//
//  OrderDetailFooterCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/6/15.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface OrderDetailFooterCell : BaseTableViewCell

@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *address;
@property (nonatomic, strong) UILabel *number;
@property (nonatomic, strong) UILabel *orderTime;
@property (nonatomic, strong) UILabel *pay;

@property (copy, nonatomic) void (^phoneBlock)(void);

@end
