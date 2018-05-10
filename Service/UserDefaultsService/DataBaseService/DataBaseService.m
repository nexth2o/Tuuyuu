//
//  DataBaseService.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/23.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "DataBaseService.h"
#import "BaseDAL.h"

@implementation DataBaseService

+ (BOOL)createTableByName:(NSString *)name {
    
    NSString *className = [NSString stringWithFormat:@"%@%@",name,@"DAL"];
    
    Class class = NSClassFromString(className);
    
    BaseDAL *dal = [[class alloc] init];
    
    return  [dal createTable];
}

+ (BOOL)DataBaseAlreadyExists {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"TuuyuuDataBase.db"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:dbPath];
}

+ (FMDatabaseQueue *)createDataBase {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"TuuyuuDataBase.db"];
    
    FMDatabaseQueue *dbQueue = [[FMDatabaseQueue alloc] initWithPath:dbPath];
    
    return dbQueue;
}

@end
