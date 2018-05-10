//
//  CartInfoDAL.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/23.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "CartInfoDAL.h"
#import "FMDatabaseAdditions.h"


@implementation CartInfoDAL

- (BOOL)createTable {
    
    __block BOOL result = NO;
    
    [APPDELEGATE.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        result = [db executeUpdate:@"CREATE TABLE CartInfo (product_no text PRIMARY KEY, cvs_no text, orderCount text, description text, dis_price text, gift_flag text)"];
//        NSLog(@"创建CartInfo表成功");
    }];
    return result;
}

- (void)updateCartInfo {

    [APPDELEGATE.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        if (![db columnExists:@"cvs_no" inTableWithName:@"CartInfo"]) {
            
            [db executeUpdate:@"ALTER TABLE CartInfo RENAME TO temp_CartInfo"];
            
            [db executeUpdate:@"CREATE TABLE CartInfo (product_no text PRIMARY KEY, cvs_no text, orderCount text, description text, dis_price text, gift_flag text)"];
            
            [db executeUpdate:@"insert into CartInfo(product_no, cvs_no, orderCount, description, dis_price, gift_flag) select product_no, '', orderCount, description, dis_price, gift_flag from temp_CartInfo"];
            
            [db executeUpdate:@"drop table temp_CartInfo"];
        }
    }];
}

- (BOOL)insertIntoTable:(id)entity {
    
    CartInfoEntity *tempEntity = entity;
    
    __block BOOL result = NO;
    
    NSDictionary *paraDic = [self convertToDictionary:tempEntity];
    
    [APPDELEGATE.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:@"REPLACE INTO CartInfo (product_no, cvs_no, orderCount, description, dis_price, gift_flag) VALUES (:product_no, :cvs_no, :orderCount, :description, :dis_price, :gift_flag)" withParameterDictionary:paraDic];
    }];
    
    return result;
}

- (NSDictionary *)convertToDictionary:(id)entity {
    
    CartInfoEntity *tempEntity = entity;
    
    return [[NSDictionary alloc]initWithObjectsAndKeys:
            tempEntity.product_no,@"product_no",
            tempEntity.cvs_no,@"cvs_no",
            tempEntity.orderCount, @"orderCount",
            tempEntity.descriptionn, @"description",
            tempEntity.dis_price, @"dis_price",
            tempEntity.gift_flag, @"gift_flag",nil];
}

- (NSMutableArray *)queryCartInfo {
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    [APPDELEGATE.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *result = [db executeQuery:@"SELECT * FROM CartInfo WHERE cvs_no = ? AND orderCount <> 0 AND gift_flag = 0", [[UserDefaults service] getStoreId]];
        
        while ([result next]) {
            
            CartInfoEntity *entity = [[CartInfoEntity alloc] init];
            
            entity.product_no = [result stringForColumn:@"product_no"];
            
            entity.cvs_no = [result stringForColumn:@"cvs_no"];
            
            entity.orderCount = [result stringForColumn:@"orderCount"];
            
            entity.descriptionn = [result stringForColumn:@"description"];
            
            entity.dis_price = [result stringForColumn:@"dis_price"];
            
            entity.gift_flag = [result stringForColumn:@"gift_flag"];
            
            [tempArray addObject:entity];
        }
    }];
    
    return tempArray;
}

- (NSMutableArray *)queryCartInfoGift {
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    [APPDELEGATE.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *result = [db executeQuery:@"SELECT * FROM CartInfo WHERE cvs_no = ? AND orderCount <> 0 AND gift_flag = 1", [[UserDefaults service] getStoreId]];
        
        while ([result next]) {
            
            CartInfoEntity *entity = [[CartInfoEntity alloc] init];
            
            entity.product_no = [result stringForColumn:@"product_no"];
            
            entity.cvs_no = [result stringForColumn:@"cvs_no"];
            
            entity.orderCount = [result stringForColumn:@"orderCount"];
            
            entity.descriptionn = [result stringForColumn:@"description"];
            
            entity.dis_price = [result stringForColumn:@"dis_price"];
            
            entity.gift_flag = [result stringForColumn:@"gift_flag"];

            [tempArray addObject:entity];
        }
    }];
    
    return tempArray;
}

- (BOOL)deleteGift {
    
    __block BOOL result = NO;
    
    [APPDELEGATE.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate: @"DELETE FROM CartInfo WHERE cvs_no = ? AND gift_flag = 1", [[UserDefaults service] getStoreId]];
    }];
    
    return result;
}

- (BOOL)cleanCartInfo {
    
    __block BOOL result = NO;
    
    [APPDELEGATE.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        result = [db executeUpdate:@"DELETE FROM CartInfo"];
    }];
    
    return result;
}

@end
