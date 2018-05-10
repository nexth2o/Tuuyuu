//
//  OrderFooterView.h
//  Tuuyuu
//
//  Created by WishU on 2017/6/13.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface OrderFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subTitle;
@property (nonatomic, strong) UILabel *price;

@property (nonatomic, strong) UIButton *aBtn;
@property (nonatomic, strong) UIButton *bBtn;
@property (nonatomic, strong) UIButton *cBtn;

@property (copy, nonatomic) void (^aBlock)();
@property (copy, nonatomic) void (^bBlock)();
@property (copy, nonatomic) void (^cBlock)();

@end
