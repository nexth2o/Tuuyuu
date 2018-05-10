//
//  SearchHistoryDAL.h
//  Tuuyuu
//
//  Created by WishU on 2017/8/16.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseDAL.h"

@interface SearchHistoryDAL : BaseDAL

- (BOOL)insertIntoTable:(id)entity;

- (NSMutableArray *)queryCartInfo;

- (BOOL)cleanCartInfo;

@end
