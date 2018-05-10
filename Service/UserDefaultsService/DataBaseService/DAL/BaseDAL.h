//
//  BaseDAL.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/23.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "FMDatabase.h"
#import "AppDelegate.h"
#import "BaseEntity.h"
#import "UserDefaults.h"


@interface BaseDAL : NSObject

- (BOOL)createTable;

- (BOOL)insertDB:(id)entity;;

@end
