//
//  UserDefaults.m
//  Tuuyuu
//
//  Created by WishU on 2017/5/8.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "UserDefaults.h"

@implementation UserDefaults

static UserDefaults *sharedInstance;

+ (UserDefaults *)service {
    
    if (sharedInstance == nil) {
        
        sharedInstance = [[UserDefaults alloc] init];
    }
    
    return sharedInstance;
}


- (BOOL)getLoginStatus {
    
    if ([self getSessionId] && [self getSessionId].length > 0 && ![[self getSessionId] isEqualToString:@"0"]) {
        
        return YES;
        
    }else {
        
        return NO;
    }
}

//网络状态
- (NSString *)getNetworkStatus {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"networkStatus"];
}

- (void)updateNetworkStatus:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"networkStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//首次安装
- (BOOL)getFirstLaunch {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"];
}

- (void)updateFirstLaunch:(BOOL)status {
    
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"firstLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//session_id
- (NSString *)getSessionId {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"session"];
}

- (void)updateSessionId:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"session"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//店铺促销活动
- (NSMutableArray *)getStoreSales {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"storeSales"];
}

- (void)updateStoreSales:(NSMutableArray *)mutableArray {
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableArray forKey:@"storeSales"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//纬度
- (NSString *)getLatitude {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
}

- (void)updateLatitude:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//经度
- (NSString *)getLongitude {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
}

- (void)updateLongitude:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//默认店铺纬度
- (NSString *)getStoreLatitude {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"storeLatitude"];
}
- (void)updateStoreLatitude:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"storeLatitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//默认店铺经度
- (NSString *)getStoreLongitude {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"storeLongitude"];
}
- (void)updateStoreLongitude:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"storeLongitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//店铺ID
- (NSString *)getStoreId {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"storeId"];
}

- (void)updateStoreId:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"storeId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//店铺名
- (NSString *)getStoreName {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"storeName"];
}

- (void)updateStoreName:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"storeName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//店铺电话
- (NSString *)getStoreTel {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"storeTel"];
}

- (void)updateStoreTel:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"storeTel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//配送信息
//配送姓名
- (NSString *)getName {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
}

- (void)updateName:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//配送性别
- (NSString *)getAddressGender {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"addressGender"];
}

- (void)updateAddressGender:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"addressGender"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//配送电话
- (NSString *)getAddressPhone {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"addressPhone"];
}

- (void)updateAddressPhone:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"addressPhone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//配送地址
- (NSString *)getAddress {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
}

- (void)updateAddress:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"address"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//配送建筑
- (NSString *)getBuilding {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"building"];
}

- (void)updateBuilding:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"building"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//配送纬度
- (NSString *)getAddressLatitude {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"addressLatitude"];
}
- (void)updateAddressLatitude:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"addressLatitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//配送经度
- (NSString *)getAddressLongitude {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"addressLongitude"];
}
- (void)updateAddressLongitude:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"addressLongitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//编辑用地址id
- (NSString *)getEditAddressId {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"editAddressId"];
}

- (void)updateEditAddressId:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"editAddressId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//编辑用姓名
- (NSString *)getEditName {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"editName"];
}

- (void)updateEditName:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"editName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//编辑用性别
- (NSString *)getEditGender {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"editGender"];
}

- (void)updateEditGender:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"editGender"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//编辑用电话
- (NSString *)getEditPhone {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"editPhone"];
}

- (void)updateEditPhone:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"editPhone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//编辑用地址
- (NSString *)getEditAddress {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"editAddress"];
}

- (void)updateEditAddress:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"editAddress"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//编辑用建筑物
- (NSString *)getEditBuilding {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"editBuilding"];
}

- (void)updateEditBuilding:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"editBuilding"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//编辑用纬度
- (NSString *)getEditLatitude {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"editLatitude"];
}

- (void)updateEditLatitude:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"editLatitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//编辑用经度
- (NSString *)getEditLongitude {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"editLongitude"];
}

- (void)updateEditLongitude:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"editLongitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//用户信息
//性别
- (NSString *)getGender {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
}

- (void)updateGender:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"gender"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//电话
- (NSString *)getPhone {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
}

- (void)updatePhone:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//兔币
- (NSString *)getIntegral {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"integral"];
}

- (void)updateIntegral:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"integral"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//星级
- (NSString *)getValueStar {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"valueStar"];
}

- (void)updateValueStar:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"valueStar"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//会员等级 0 注册会员1铜牌会员2银牌会员,3 金牌会员,4 钻石会员,
- (NSString *)getGrade {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"grade"];
}

- (void)updateGrade:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"grade"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//昵称
- (NSString *)getNickName {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
}

- (void)updateNickName:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"nickName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//订单备注
- (NSString *)getOrderNote {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"orderNote"];
}

- (void)updateOrderNote:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"orderNote"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//是否重新定位
- (BOOL)relocation {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"relocation"];
}

- (void)updateRelocation:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"relocation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//删除堆栈
- (BOOL)getSelectedViewController {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"selectedViewController"];
}

- (void)updatesSelectedViewController:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"selectedViewController"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//店铺打烊
- (BOOL)getOperatingState {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"operatingState"];
}

- (void)updateOperatingState:(BOOL)status {
    
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"operatingState"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//deviceToken
- (NSString *)getDeviceToken {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
}

- (void)updateDeviceToken:(NSString *)string {
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//送货时间段
- (NSMutableArray *)getDeliveryDates {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"deliveryDates"];
}

- (void)updateDeliveryDates:(NSMutableArray *)mutableArray {
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableArray forKey:@"deliveryDates"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
