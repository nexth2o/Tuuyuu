//
//  OrderStatusCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/31.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface OrderStatusCell : BaseTableViewCell

@property (nonatomic, strong) UIImageView *statusIcon;

@property (nonatomic, strong) UILabel *info;

@property (nonatomic, strong) UILabel *time;

@end
