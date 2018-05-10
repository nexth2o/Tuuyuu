//
//  OrderCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/6/9.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface OrderCell : BaseTableViewCell

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subTitle;
@property (nonatomic, strong) UILabel *price;

@end
