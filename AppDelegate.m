//
//  AppDelegate.m
//  Tuuyuu
//
//  Created by WishU on 2017/5/8.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "AppDelegate.h"
#import "Common.h"
#import "UserDefaults.h"
#import "Reachability.h"
#import "CustomController.h"
#import "GuideViewController.h"
#import <UserNotifications/UserNotifications.h>
//#import <CoreLocation/CoreLocation.h>
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import <TencentOpenAPI/TencentOAuth.h>

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

//DB
#import "DataBaseService.h"
#import "CartInfoDAL.h"


@interface AppDelegate ()<UNUserNotificationCenterDelegate, AMapLocationManagerDelegate, WXApiDelegate> {
    UIViewController *rootViewController;
    Reachability *hostReachability;
    Reachability *internetReachability;
    AMapLocationManager *locationManager;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:@"kNetworkReachabilityChangedNotification" object:nil];
    
    //Change the host name here to change the server you want to monitor.
    NSString *remoteHostName = @"www.baidu.com";
    
    hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [hostReachability startNotifier];
    [self updateInterfaceWithReachability:hostReachability];
    
    internetReachability = [Reachability reachabilityForInternetConnection];
    [internetReachability startNotifier];
    [self updateInterfaceWithReachability:internetReachability];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    
    //引导画面
    if(![[UserDefaults service] getFirstLaunch]) {
        rootViewController = [[GuideViewController alloc] initWithNibName:nil bundle:nil];
        [[UserDefaults service] updateFirstLaunch:YES];
        [[UserDefaults service] updateSessionId:@"0"];
//        [[UserDefaults service] updateFirstLocation:YES];
        
    }else {
        rootViewController = [[CustomController alloc] initWithNibName:nil bundle:nil];
    }

    self.window.rootViewController = rootViewController;
    
    [self.window makeKeyAndVisible];
    
    //DB 建表
    if (![DataBaseService DataBaseAlreadyExists]) {
        self.dbQueue = [DataBaseService createDataBase];
        
        [DataBaseService createTableByName:@"CartInfo"];
        [DataBaseService createTableByName:@"SearchHistory"];
    }
    self.dbQueue = [DataBaseService createDataBase];
    
    CartInfoDAL *dal = [[CartInfoDAL alloc] init];
    [dal updateCartInfo];
    
    
    //推送
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@", settings);
                }];
            }else {
                // 点击不允许
                NSLog(@"注册失败");
            }
        }];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] > 8.0){
        //iOS8 - iOS10
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
        
    }else if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        //iOS8系统以下
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    [AMapServices sharedServices].apiKey = @"baa40c9f5e74a18d2b060eec9f2c1e0e";
    
    locationManager = [[AMapLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    [self startLocation];
    
    
    //注册微信 支付
    //向微信注册
    [WXApi registerApp:@"wx2dfcfacf8decaaf4"];
//    [WXApi registerApp:@"wxd8ff4e03924feec6"];
    //注册QQ
//    [[TencentOAuth alloc] initWithAppId:@"1106065357" andDelegate:nil];
    [[TencentOAuth alloc] initWithAppId:@"1106102598" andDelegate:nil];
    
    
    [[UserDefaults service] updateRelocation:YES];
    
    return YES;
}

#pragma mark - 推送通知
// 处理推送消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"userinfo:%@",userInfo);
    NSLog(@"后台收到远程通知:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadOrderNotification" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadOrderListNotification" object:nil];
}

// 获得Device Token失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    NSLog(@"Registfail%@",error);
}
// 获得Device Token成功
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"deviceToken:%@",deviceToken);
    NSString *deviceTokenStr = [self stringWithDeviceToken:deviceToken];
    [[UserDefaults service] updateDeviceToken:deviceTokenStr];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"iOS7及以上系统，收到通知:%@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadOrderNotification" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadOrderListNotification" object:nil];
}
// iOS 10收到通知
//前台
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0 ;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 前台收到远程通知:%@", userInfo);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadOrderNotification" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadOrderListNotification" object:nil];
    }else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

//点击推送消息后回调
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
    
    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
    
    //deselect the selected table cell
}

- (NSString *)stringWithDeviceToken:(NSData *)deviceToken {
    const char *data = [deviceToken bytes];
    NSMutableString *token = [NSMutableString string];
    for (int i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    return [token copy];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UserDefaults service] updateRelocation:YES];
    [self startLocation];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kNetworkReachabilityChangedNotification" object:nil];
}

#pragma mark - Reachability
- (void)reachabilityChanged:(NSNotification *)note {
    
    Reachability *curReach = [note object];

    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    [self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability {
    
//    区分reachability == hostReachability, internetReachability
    NetworkStatus NetStatus = [reachability currentReachabilityStatus];
    
    switch (NetStatus) {
            
        case NotReachable: {
            [[UserDefaults service] updateNetworkStatus:NOTREACHABLE];
        }
            break;
        case ReachableViaWiFi: {
            [[UserDefaults service] updateNetworkStatus:REACHABLEVIAWIFI];
        }
            break;
        case ReachableViaWWAN: {
            [[UserDefaults service] updateNetworkStatus:REACHABLEVIAWWAN];
        }
            break;
        default: {
            break;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_STATUS_NOTIFICATION object:nil];
}


#pragma mark Location and Delegate
- (void)startLocation {

//    if ([CLLocationManager locationServicesEnabled]) {
//        //        NSLog(@"位置服务启用");
//
//        [locationManager startUpdatingLocation];
//
//        switch ([CLLocationManager authorizationStatus]) {
//            case kCLAuthorizationStatusAuthorizedAlways:
//                                NSLog(@"开启定位常驻");
//                break;
//            case kCLAuthorizationStatusAuthorizedWhenInUse:
//                                NSLog(@"开启定位仅用户使用时候");
//                break;
//            case kCLAuthorizationStatusNotDetermined:
//                                NSLog(@"开启定位未授权");
//                //授权
////                [locationManager requestWhenInUseAuthorization];
//                break;
//            case kCLAuthorizationStatusDenied:
//                                NSLog(@"位置服务是在设置中禁用");
//
//                break;
//            default:
//
//                break;
//        }
//
//    }else {
//                NSLog(@"位置服务未启用");
        [locationManager startUpdatingLocation];
//    }
    
//    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//    if ([[UIApplication sharedApplication] canOpenURL:url]) {
//        [[UIApplication sharedApplication] openURL:url];
//    }
}

#pragma mark - AMapLocationManager Delegate
//- (void)locationManager:(CLLocationManager *)manager
//     didUpdateLocations:(NSArray *)locations
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    //获取用户位置的对象
//    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
    
    //装载纬经度
    NSString *latitudeStr = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitudeStr = [NSString stringWithFormat:@"%f", coordinate.longitude];
    [[UserDefaults service] updateLatitude:latitudeStr];
    [[UserDefaults service] updateLongitude:longitudeStr];
    
    //    self.longitute = [NSNumber numberWithDouble:coordinate.longitude];
    //    self.latitude = [NSNumber numberWithDouble:coordinate.latitude];
    
    //停止定位
    [manager stopUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadStore" object:nil];
  
}

//- (void)locationManager:(CLLocationManager *)manager
//       didFailWithError:(NSError *)error


- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}


//支付回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        //微信支付回调
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"11result = %@",resultDic);
            
            NSString * strTitle = [NSString stringWithFormat:@"支付结果"];
            NSString *strMsg;
            
            //【callback处理支付结果】
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                strMsg = @"恭喜您，支付成功!";
            }else if([resultDic[@"resultStatus"] isEqualToString:@"8000"]) {
                strMsg = @"正在处理中";
            }else if([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
                strMsg = @"已取消支付!";
            }else if([resultDic[@"resultStatus"] isEqualToString:@"6002"]) {
                strMsg = @"网络连接出错";
            }else if([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {
                strMsg = @"支付失败!";
            }else{
                strMsg = @"支付失败!";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            //            NSLog(@"12result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"9.0以前授权结果 authCode = %@", authCode?:@"");
        }];
    }else {
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    
    if ([[options objectForKey:@"UIApplicationOpenURLOptionsSourceApplicationKey"] isEqualToString:@"com.tencent.xin"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"21result = %@",resultDic);
            
            //【callback处理支付结果】
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                
                //发送一个通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
                
            }else if([resultDic[@"resultStatus"] isEqualToString:@"8000"]) {
                //                strMsg = @"正在处理中";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
                
            }else if([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
                //                strMsg = @"已取消支付!";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
                
            }else if([resultDic[@"resultStatus"] isEqualToString:@"6002"]) {
                //                strMsg = @"网络连接出错";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
                
            }else if([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {
                //                strMsg = @"支付失败!";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
                
            }else{
                //                strMsg = @"支付失败!";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
                
            }
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            //            NSLog(@"9.0以后授权结果 = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"9.0以后授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}


#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
                
                break;
                
            default:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"payFail" object:nil];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    
}



@end
