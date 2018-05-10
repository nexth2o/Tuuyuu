//
//  DataBaseService.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/23.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface DataBaseService : NSObject

+ (BOOL)createTableByName:(NSString *)name;

+ (BOOL)DataBaseAlreadyExists;

+ (FMDatabaseQueue *)createDataBase;

@end
