//
//  Common.h
//  Tuuyuu
//
//  Created by WishU on 2017/5/8.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "sys/utsname.h"

#define NETWORK_STATUS_NOTIFICATION  @"networkStatusNotification"
#define NOTREACHABLE  @"notReachable"
#define REACHABLEVIAWIFI  @"reachableViaWiFi"
#define REACHABLEVIAWWAN  @"reachableViaWWAN"

#define APPDELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define PUSH(x) [self.navigationController pushViewController:x animated:YES];
#define POP     [self.navigationController popViewControllerAnimated:YES];

#define SCALE             (([DEVICE isEqualToString:@"iPhone X"])? [UIScreen mainScreen].bounds.size.height/(812.0f-34):[UIScreen mainScreen].bounds.size.height/667.0f)

#define STATUS_BAR_HEIGHT      (([DEVICE isEqualToString:@"iPhone X"])? 44.0f:20.0f)
#define NAV_BAR_HEIGHT         44.0f
#define BOTTOM_BAR_HEIGHT      (([DEVICE isEqualToString:@"iPhone X"])? 83:49)
#define BOTTOM_BAR_HEIGHT2       (([UIScreen mainScreen].bounds.size.height-20 == [UIScreen mainScreen].applicationFrame.size.height) ? (49):(49.0f+20.0f))

#define SCREEN_WIDTH           [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT          [UIScreen mainScreen].bounds.size.height

#define STORE_CELL_HEIGHT      20*SCALE

#define UIColorFromRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define UIColorFromHex(h)        [UIColor colorWithRed:(((h & 0xFF0000) >> 16))/255.0 green:(((h & 0xFF00) >> 8))/255.0 blue:((h & 0xFF))/255.0 alpha:1.0]

#define MAIN_COLOR            UIColorFromHex(0xff8a1a)//按钮色 字体色
#define MAIN_TEXT_COLOR       UIColorFromHex(0x41210f)//棕色
#define ICON_COLOR            UIColorFromRGB(255,206,114)//按钮色
#define LOGO_COLOR            UIColorFromHex(0xffe200)//logo色

typedef enum{
    EmptyViewStyleNetworkUnreachable = 0,
    EmptyViewStyleNoResults,
    EmptyViewStyleNoAddress,
    EmptyViewStyleLogout
}EmptyViewStyle;

#define weakify(var) __weak typeof(var) weak_##var = var;

#define strongify(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = weak_##var; \
_Pragma("clang diagnostic pop")

#define TIME_OUT              10

#define APPID   @"1216044317"

//#define HYPERLINK              @"http://tuuyuuapp.xicp.io:6000/"
#define HYPERLINK              @"http://app.tuuyuu.com/"

#define DEVICE \
({\
NSString *device=@"";\
struct utsname systemInfo;\
uname(&systemInfo);\
NSString *machine = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];\
if ([machine isEqualToString:@"iPhone3,1"])\
device = @"iPhone 4";\
else if ([machine isEqualToString:@"iPhone3,2"])\
device = @"iPhone 4";\
else if ([machine isEqualToString:@"iPhone3,3"])\
device = @"iPhone 4";\
else if ([machine isEqualToString:@"iPhone4,1"])\
device = @"iPhone 4S";\
else if ([machine isEqualToString:@"iPhone5,1"])\
device = @"iPhone 5";\
else if ([machine isEqualToString:@"iPhone5,2"])\
device = @"iPhone 5";\
else if ([machine isEqualToString:@"iPhone5,3"])\
device = @"iPhone 5c";\
else if ([machine isEqualToString:@"iPhone5,4"])\
device = @"iPhone 5c";\
else if ([machine isEqualToString:@"iPhone6,1"])\
device = @"iPhone 5s";\
else if ([machine isEqualToString:@"iPhone6,2"])\
device = @"iPhone 5s";\
else if ([machine isEqualToString:@"iPhone7,1"])\
device = @"iPhone 6 Plus";\
else if ([machine isEqualToString:@"iPhone7,2"])\
device = @"iPhone 6";\
else if ([machine isEqualToString:@"iPhone8,1"])\
device = @"iPhone 6s";\
else if ([machine isEqualToString:@"iPhone8,2"])\
device = @"iPhone 6s Plus";\
else if ([machine isEqualToString:@"iPhone8,4"])\
device = @"iPhone SE";\
else if ([machine isEqualToString:@"iPhone9,1"])\
device = @"iPhone 7";\
else if ([machine isEqualToString:@"iPhone9,2"])\
device = @"iPhone 7 Plus";\
else if ([machine isEqualToString:@"iPhone9,3"])\
device = @"iPhone 7";\
else if ([machine isEqualToString:@"iPhone9,4"])\
device = @"iPhone 7 Plus";\
else if ([machine isEqualToString:@"iPhone10,1"])\
device = @"iPhone 8";\
else if ([machine isEqualToString:@"iPhone10,2"])\
device = @"iPhone 8 Plus";\
else if ([machine isEqualToString:@"iPhone10,3"])\
device = @"iPhone X";\
else if ([machine isEqualToString:@"iPhone10,4"])\
device = @"iPhone 8";\
else if ([machine isEqualToString:@"iPhone10,5"])\
device = @"iPhone 8 Plus";\
else if ([machine isEqualToString:@"iPhone10,6"])\
device = @"iPhone X";\
else if ([machine isEqualToString:@"iPod1,1"])\
device = @"iPod Touch 1G";\
else if ([machine isEqualToString:@"iPod2,1"])\
device = @"iPod Touch 2G";\
else if ([machine isEqualToString:@"iPod3,1"])\
device = @"iPod Touch 3G";\
else if ([machine isEqualToString:@"iPod4,1"])\
device = @"iPod Touch 4G";\
else if ([machine isEqualToString:@"iPod5,1"])\
device = @"iPod Touch 5G";\
else if ([machine isEqualToString:@"iPad1,1"])\
device = @"iPad";\
else if ([machine isEqualToString:@"iPad1,2"])\
device = @"iPad 3G";\
else if ([machine isEqualToString:@"iPad2,1"])\
device = @"iPad 2";\
else if ([machine isEqualToString:@"iPad2,2"])\
device = @"iPad 2";\
else if ([machine isEqualToString:@"iPad2,3"])\
device = @"iPad 2";\
else if ([machine isEqualToString:@"iPad2,4"])\
device = @"iPad 2";\
else if ([machine isEqualToString:@"iPad2,5"])\
device = @"iPad Mini";\
else if ([machine isEqualToString:@"iPad2,6"])\
device = @"iPad Mini";\
else if ([machine isEqualToString:@"iPad2,7"])\
device = @"iPad Mini";\
else if ([machine isEqualToString:@"iPad3,1"])\
device = @"iPad 3";\
else if ([machine isEqualToString:@"iPad3,2"])\
device = @"iPad 3";\
else if ([machine isEqualToString:@"iPad3,3"])\
device = @"iPad 3";\
else if ([machine isEqualToString:@"iPad3,4"])\
device = @"iPad 4";\
else if ([machine isEqualToString:@"iPad3,5"])\
device = @"iPad 4";\
else if ([machine isEqualToString:@"iPad3,6"])\
device = @"iPad 4";\
else if ([machine isEqualToString:@"iPad4,1"])\
device = @"iPad Air";\
else if ([machine isEqualToString:@"iPad4,2"])\
device = @"iPad Air";\
else if ([machine isEqualToString:@"iPad4,4"])\
device = @"iPad Mini 2";\
else if ([machine isEqualToString:@"iPad4,5"])\
device = @"iPad Mini 2";\
else if ([machine isEqualToString:@"iPad4,6"])\
device = @"iPad Mini 2";\
else if ([machine isEqualToString:@"iPad4,7"])\
device = @"iPad Mini 3";\
else if ([machine isEqualToString:@"iPad4,8"])\
device = @"iPad Mini 3";\
else if ([machine isEqualToString:@"iPad4,9"])\
device = @"iPad Mini 3";\
else if ([machine isEqualToString:@"iPad5,1"])\
device = @"iPad Mini 4";\
else if ([machine isEqualToString:@"iPad5,2"])\
device = @"iPad Mini 4";\
else if ([machine isEqualToString:@"iPad5,3"])\
device = @"iPad Air 2";\
else if ([machine isEqualToString:@"iPad5,4"])\
device = @"iPad Air 2";\
else if ([machine isEqualToString:@"iPad6,3"])\
device = @"iPad Pro 9.7";\
else if ([machine isEqualToString:@"iPad6,4"])\
device = @"iPad Pro 9.7";\
else if ([machine isEqualToString:@"iPad6,7"])\
device = @"iPad Pro 12.9";\
else if ([machine isEqualToString:@"iPad6,8"])\
device = @"iPad Pro 12.9";\
else if ([machine isEqualToString:@"iPad6,11"])\
device = @"iPad 5";\
else if ([machine isEqualToString:@"iPad6,12"])\
device = @"iPad 5";\
else if ([machine isEqualToString:@"iPad7,1"])\
device = @"iPad Pro 12.9 2nd";\
else if ([machine isEqualToString:@"iPad7,2"])\
device = @"iPad Pro 12.9 2nd";\
else if ([machine isEqualToString:@"iPad7,3"])\
device = @"iPad Pro 10.5";\
else if ([machine isEqualToString:@"iPad7,4"])\
device = @"iPad Pro 10.5";\
else if ([machine isEqualToString:@"AppleTV2,1"])\
device = @"Apple TV 2";\
else if ([machine isEqualToString:@"AppleTV3,1"])\
device = @"Apple TV 3";\
else if ([machine isEqualToString:@"AppleTV3,2"])\
device = @"Apple TV 3";\
else if ([machine isEqualToString:@"AppleTV5,3"])\
device = @"Apple TV 4";\
else if ([machine isEqualToString:@"i386"])\
device = @"Simulator";\
else if ([machine isEqualToString:@"x86_64"])\
device = @"Simulator";\
(device);\
})\



// 获取设备型号然后手动转化为对应名称
//#define DEVICE \
//- (NSString *)getDeviceName {\
//    struct utsname systemInfo;\
//    uname(&systemInfo);\
//    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];\
//    if ([machine isEqualToString:@"iPhone3,1"]) return @"iPhone 4";\
//    if ([machine isEqualToString:@"iPhone3,2"]) return @"iPhone 4";\
//    if ([machine isEqualToString:@"iPhone3,3"]) return @"iPhone 4";\
//    if ([machine isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";\
//    if ([machine isEqualToString:@"iPhone5,1"]) return @"iPhone 5";\
//    if ([machine isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (GSM+CDMA)";\
//    if ([machine isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (GSM)";\
//    if ([machine isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (GSM+CDMA)";\
//    if ([machine isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (GSM)";\
//    if ([machine isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (GSM+CDMA)";\
//    if ([machine isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";\
//    if ([machine isEqualToString:@"iPhone7,2"]) return @"iPhone 6";\
//    if ([machine isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";\
//    if ([machine isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";\
//    if ([machine isEqualToString:@"iPhone8,4"]) return @"iPhone SE";\
//    if ([machine isEqualToString:@"iPhone9,1"]) return @"国行、日版、港行iPhone 7";\
//    if ([machine isEqualToString:@"iPhone9,2"]) return @"港行、国行iPhone 7 Plus";\
//    if ([machine isEqualToString:@"iPhone9,3"]) return @"美版、台版iPhone 7";\
//    if ([machine isEqualToString:@"iPhone9,4"]) return @"美版、台版iPhone 7 Plus";\
//    if ([machine isEqualToString:@"iPhone10,1"]) return @"国行(A1863)、日行(A1906)iPhone 8";\
//    if ([machine isEqualToString:@"iPhone10,2"]) return @"国行(A1864)、日行(A1898)iPhone 8 Plus";\
//    if ([machine isEqualToString:@"iPhone10,3"]) return @"国行(A1865)、日行(A1902)iPhone X";\
//    if ([machine isEqualToString:@"iPhone10,4"]) return @"美版(Global/A1905)iPhone 8";\
//    if ([machine isEqualToString:@"iPhone10,5"]) return @"美版(Global/A1897)iPhone 8 Plus";\
//    if ([machine isEqualToString:@"iPhone10,6"]) return @"美版(Global/A1901)iPhone X";\
//    if ([machine isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";\
//    if ([machine isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";\
//    if ([machine isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";\
//    if ([machine isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";\
//    if ([machine isEqualToString:@"iPod5,1"]) return @"iPod Touch (5 Gen)";\
//    if ([machine isEqualToString:@"iPad1,1"]) return @"iPad";\
//    if ([machine isEqualToString:@"iPad1,2"]) return @"iPad 3G";\
//    if ([machine isEqualToString:@"iPad2,1"]) return @"iPad 2 (WiFi)";\
//    if ([machine isEqualToString:@"iPad2,2"]) return @"iPad 2";\
//    if ([machine isEqualToString:@"iPad2,3"]) return @"iPad 2 (CDMA)";\
//    if ([machine isEqualToString:@"iPad2,4"]) return @"iPad 2";\
//    if ([machine isEqualToString:@"iPad2,5"]) return @"iPad Mini (WiFi)";\
//    if ([machine isEqualToString:@"iPad2,6"]) return @"iPad Mini";\
//    if ([machine isEqualToString:@"iPad2,7"]) return @"iPad Mini (GSM+CDMA)";\
//    if ([machine isEqualToString:@"iPad3,1"]) return @"iPad 3 (WiFi)";\
//    if ([machine isEqualToString:@"iPad3,2"]) return @"iPad 3 (GSM+CDMA)";\
//    if ([machine isEqualToString:@"iPad3,3"]) return @"iPad 3";\
//    if ([machine isEqualToString:@"iPad3,4"]) return @"iPad 4 (WiFi)";\
//    if ([machine isEqualToString:@"iPad3,5"]) return @"iPad 4";\
//    if ([machine isEqualToString:@"iPad3,6"]) return @"iPad 4 (GSM+CDMA)";\
//    if ([machine isEqualToString:@"iPad4,1"]) return @"iPad Air (WiFi)";\
//    if ([machine isEqualToString:@"iPad4,2"]) return @"iPad Air (Cellular)";\
//    if ([machine isEqualToString:@"iPad4,4"]) return @"iPad Mini 2 (WiFi)";\
//    if ([machine isEqualToString:@"iPad4,5"]) return @"iPad Mini 2 (Cellular)";\
//    if ([machine isEqualToString:@"iPad4,6"]) return @"iPad Mini 2";\
//    if ([machine isEqualToString:@"iPad4,7"]) return @"iPad Mini 3";\
//    if ([machine isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";\
//    if ([machine isEqualToString:@"iPad4,9"]) return @"iPad Mini 3";\
//    if ([machine isEqualToString:@"iPad5,1"]) return @"iPad Mini 4 (WiFi)";\
//    if ([machine isEqualToString:@"iPad5,2"]) return @"iPad Mini 4 (LTE)";\
//    if ([machine isEqualToString:@"iPad5,3"]) return @"iPad Air 2";\
//    if ([machine isEqualToString:@"iPad5,4"]) return @"iPad Air 2";\
//    if ([machine isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7";\
//    if ([machine isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7";\
//    if ([machine isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9";\
//    if ([machine isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9";\
//    if ([machine isEqualToString:@"iPad6,11"]) return @"iPad 5 (WiFi)";\
//    if ([machine isEqualToString:@"iPad6,12"]) return @"iPad 5 (Cellular)";\
//    if ([machine isEqualToString:@"iPad7,1"]) return @"iPad Pro 12.9 inch 2nd gen (WiFi)";\
//    if ([machine isEqualToString:@"iPad7,2"]) return @"iPad Pro 12.9 inch 2nd gen (Cellular)";\
//    if ([machine isEqualToString:@"iPad7,3"]) return @"iPad Pro 10.5 inch (WiFi)";\
//    if ([machine isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5 inch (Cellular)";\
//    if ([machine isEqualToString:@"AppleTV2,1"]) return @"Apple TV 2";\
//    if ([machine isEqualToString:@"AppleTV3,1"]) return @"Apple TV 3";\
//    if ([machine isEqualToString:@"AppleTV3,2"]) return @"Apple TV 3";\
//    if ([machine isEqualToString:@"AppleTV5,3"]) return @"Apple TV 4";\
//    if ([machine isEqualToString:@"i386"]) return @"Simulator";\
//    if ([machine isEqualToString:@"x86_64"]) return @"Simulator";\
//    return deviceString;\
//}

