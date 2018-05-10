//
//  OrderDetailCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/6/15.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface OrderDetailCell : BaseTableViewCell

@property (nonatomic, strong) UIImageView *productIcon;
@property (nonatomic, strong) UILabel *productName;
@property (nonatomic, strong) UILabel *subTitle;
@property (nonatomic, strong) UILabel *productCount;
@property (nonatomic, strong) UILabel *price;

@end
