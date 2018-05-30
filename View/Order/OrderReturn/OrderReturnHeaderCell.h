//
//  OrderReturnHeaderCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/3.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface OrderReturnHeaderCell : BaseTableViewCell

@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *subTitle;
@property (strong, nonatomic) UILabel *pay;

@property (strong, nonatomic) UIImageView *allIcon;
@property (strong, nonatomic) UIImageView *otherIcon;

@property (copy, nonatomic) void (^allBtnBlock)(void);
@property (copy, nonatomic) void (^otherBtnBlock)(void);

@end
