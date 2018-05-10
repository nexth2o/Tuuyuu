//
//  UserDefaults.h
//  Tuuyuu
//
//  Created by WishU on 2017/5/8.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject

+ (UserDefaults *)service;

- (BOOL)getLoginStatus;

//网络状态
- (NSString *)getNetworkStatus;
- (void)updateNetworkStatus:(NSString *)string;

//首次安装
- (BOOL)getFirstLaunch;
- (void)updateFirstLaunch:(BOOL)status;

//session_id
- (NSString *)getSessionId;
- (void)updateSessionId:(NSString *)string;

//店铺促销活动
- (NSMutableArray *)getStoreSales;
- (void)updateStoreSales:(NSMutableArray *)mutableArray;

//纬度
- (NSString *)getLatitude;
- (void)updateLatitude:(NSString *)string;

//经度
- (NSString *)getLongitude;
- (void)updateLongitude:(NSString *)string;

//默认地址纬度
- (NSString *)getAddressLatitude;
- (void)updateAddressLatitude:(NSString *)string;

//默认地址经度
- (NSString *)getAddressLongitude;
- (void)updateAddressLongitude:(NSString *)string;

//默认店铺纬度
- (NSString *)getStoreLatitude;
- (void)updateStoreLatitude:(NSString *)string;

//默认店铺经度
- (NSString *)getStoreLongitude;
- (void)updateStoreLongitude:(NSString *)string;

//店铺ID
- (NSString *)getStoreId;
- (void)updateStoreId:(NSString *)string;

//店铺名
- (NSString *)getStoreName;
- (void)updateStoreName:(NSString *)string;

//店铺电话
- (NSString *)getStoreTel;
- (void)updateStoreTel:(NSString *)string;

//配送性别
- (NSString *)getAddressGender;
- (void)updateAddressGender:(NSString *)string;

//配送电话
- (NSString *)getAddressPhone;
- (void)updateAddressPhone:(NSString *)string;

//姓名
- (NSString *)getName;
- (void)updateName:(NSString *)string;

//性别
- (NSString *)getGender;
- (void)updateGender:(NSString *)string;

//电话
- (NSString *)getPhone;
- (void)updatePhone:(NSString *)string;

//地址
- (NSString *)getAddress;
- (void)updateAddress:(NSString *)string;

//建筑
- (NSString *)getBuilding;
- (void)updateBuilding:(NSString *)string;


//编辑用地址id
- (NSString *)getEditAddressId;
- (void)updateEditAddressId:(NSString *)string;

//编辑用姓名
- (NSString *)getEditName;
- (void)updateEditName:(NSString *)string;

//编辑用性别
- (NSString *)getEditGender;
- (void)updateEditGender:(NSString *)string;

//编辑用电话
- (NSString *)getEditPhone;
- (void)updateEditPhone:(NSString *)string;

//编辑用地址
- (NSString *)getEditAddress;
- (void)updateEditAddress:(NSString *)string;

//编辑用建筑物
- (NSString *)getEditBuilding;
- (void)updateEditBuilding:(NSString *)string;

//编辑用纬度
- (NSString *)getEditLatitude;
- (void)updateEditLatitude:(NSString *)string;

//编辑用经度
- (NSString *)getEditLongitude;
- (void)updateEditLongitude:(NSString *)string;

//兔币
- (NSString *)getIntegral;
- (void)updateIntegral:(NSString *)string;

//星级
- (NSString *)getValueStar;
- (void)updateValueStar:(NSString *)string;

//会员等级 0 注册会员1铜牌会员2银牌会员,3 金牌会员,4 钻石会员,
- (NSString *)getGrade;
- (void)updateGrade:(NSString *)string;

//昵称
- (NSString *)getNickName;
- (void)updateNickName:(NSString *)string;

//订单备注
- (NSString *)getOrderNote;
- (void)updateOrderNote:(NSString *)string;

//是否重新定位
- (BOOL)relocation;
- (void)updateRelocation:(BOOL)status;

//删除堆栈
- (BOOL)getSelectedViewController;
- (void)updatesSelectedViewController:(BOOL)status;

//店铺打烊
- (BOOL)getOperatingState;
- (void)updateOperatingState:(BOOL)status;

//deviceToken
- (NSString *)getDeviceToken;
- (void)updateDeviceToken:(NSString *)string;

//送货时间段
- (NSMutableArray *)getDeliveryDates;
- (void)updateDeliveryDates:(NSMutableArray *)mutableArray;


@end
