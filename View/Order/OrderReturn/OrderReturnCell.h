//
//  OrderReturnCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/3.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface OrderReturnCell : BaseTableViewCell


@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subTitle;
@property (nonatomic, strong) UILabel *orderCount;
@property (nonatomic, strong) UIButton *plus;
@property (nonatomic, strong) UIButton *minus;
@property (assign, nonatomic) NSUInteger amount;

@property (copy, nonatomic) void (^plusBlock)(NSInteger count,BOOL animated);

@end
