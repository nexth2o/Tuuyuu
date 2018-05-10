//
//  OrderReturnDetailCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/6.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface OrderReturnDetailCell : BaseTableViewCell

@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UILabel *returnTitle;
@property (nonatomic, strong) UILabel *returnTime;
@property (nonatomic, strong) UILabel *returnReason;

@end
