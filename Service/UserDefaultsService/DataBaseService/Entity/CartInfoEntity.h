//
//  CartInfoEntity.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/23.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseEntity.h"

@interface CartInfoEntity : BaseEntity

@property(nonatomic, strong) NSString *cvs_no;
@property(nonatomic, strong) NSString *product_no;
@property(nonatomic, strong) NSString *orderCount;//份数
@property(nonatomic, strong) NSString *descriptionn;
@property(nonatomic, strong) NSString *dis_price;
@property(nonatomic, strong) NSString *gift_flag;

@end
