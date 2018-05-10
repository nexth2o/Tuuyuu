//
//  SearchHistoryDAL.m
//  Tuuyuu
//
//  Created by WishU on 2017/8/16.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SearchHistoryDAL.h"
#import "SearchHistoryEntity.h"

@implementation SearchHistoryDAL

- (BOOL)createTable {
    
    __block BOOL result = NO;
    
    [APPDELEGATE.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:@"CREATE TABLE SearchHistory (history_no text PRIMARY KEY, word text)"];
//        NSLog(@"创建SearchHistory表成功");
    }];
    
    return result;
}

- (BOOL)insertIntoTable:(id)entity {
    
    SearchHistoryEntity *tempEntity = entity;
    
    __block BOOL result = NO;
    
    NSDictionary *paraDic = [self convertToDictionary:tempEntity];
    
    [APPDELEGATE.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:
                  @"REPLACE INTO SearchHistory (history_no, word) VALUES (:history_no, :word)" withParameterDictionary:paraDic];
    }];
    
    return result;
}

- (NSDictionary *)convertToDictionary:(id)entity {
    
    SearchHistoryEntity *tempEntity = entity;

    return [[NSDictionary alloc]initWithObjectsAndKeys:
            tempEntity.history_no,@"history_no",
            tempEntity.word, @"word",nil];
}

- (NSMutableArray *)queryCartInfo {
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    [APPDELEGATE.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *result = [db executeQuery:@"SELECT * FROM SearchHistory "];
        
        while ([result next]) {
            
            SearchHistoryEntity *entity = [[SearchHistoryEntity alloc] init];
            
            entity.history_no = [result stringForColumn:@"history_no"];
            
            entity.word = [result stringForColumn:@"word"];
            
            [tempArray addObject:entity];
        }
    }];
    
    return tempArray;
}

- (BOOL)cleanCartInfo {
    
    __block BOOL result = NO;
    
    [APPDELEGATE.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate: @"DELETE FROM SearchHistory"];
    }];
    
    return result;
}

@end
