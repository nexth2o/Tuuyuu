//
//  CartInfoDAL.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/23.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseDAL.h"
#import "CartInfoEntity.h"

@interface CartInfoDAL : BaseDAL

- (BOOL)createTable;

- (BOOL)insertIntoTable:(id)entity;

- (NSMutableArray *)queryCartInfo;
- (NSMutableArray *)queryCartInfoGift;

- (BOOL)cleanCartInfo;
- (void)updateCartInfo;

- (BOOL)deleteGift;

@end
