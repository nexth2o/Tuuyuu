//
//  HttpClientService.h
//  Tuuyuu
//
//  Created by WishU on 2017/5/8.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol RequestDataDelegate <NSObject>

@optional

- (void)requestSuccess:(id)responseObject;
- (void)requestFailure:(NSError *)error;

@end

@interface HttpClientService : NSObject

@property(nonatomic, strong) id<RequestDataDelegate> delegate;

//http://118.190.98.165:8080/

+ (void)testDome:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

//首页接口
+ (void)requestIndex:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//分类一级菜单
+ (void)requestLevel:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//分类商品
+ (void)requestProduct:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//特色商品
+ (void)requestSpecialProduct:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//地址列表
+ (void)requestAddress:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//新增地址
+ (void)requestAddressadd:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//删除地址
+ (void)requestAddressdelete:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//登录
+ (void)requestLogin:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//注册获取验证码
+ (void)requestRegisterCode:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//忘记密码获取验证码
+ (void)requestVerificationCode:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//注册
+ (void)requestRegister:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//商品详情
+ (void)requestProductinfo:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//确认订单
+ (void)requestSettle:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//提交订单
+ (void)requestOrdersubmit:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//微信支付接口
+ (void)requestPrepay:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//门店列表
+ (void)requestStoreaddress:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//历史订单
+ (void)requestOrderlist:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//订单详情
+ (void)requestOrderdetail:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//退款申请
+ (void)requestReturnsummary:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//退款合计
+ (void)requestReturnsettle:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//退款提交
+ (void)requestReturnsubmit:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//退款详情
+ (void)requestReturnstate:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//我的收藏
+ (void)requestWishlist:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//新增收藏
+ (void)requestWishlistadd:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//删除收藏
+ (void)requestWishlistdelete:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//通知消息
+ (void)requestNoticemsg:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//悠荐
+ (void)requestNewsmsg:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//我的好友
+ (void)requestFriendslist:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//个人详情
+ (void)requestGetpersonalinfo:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//服务指南
+ (void)requestServiceterms:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//取消订单
+ (void)requestOrdercancel:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//催单
+ (void)requestOrderurge:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//确认收货
+ (void)requestConfirmreceipt:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//评价信息
+ (void)requestOrderrate:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//评价动作
+ (void)requestOrderratesubmit:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//签到
+ (void)requestSingin:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//联系客服
+ (void)requestStoresummary:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//邀请奖励
+ (void)requestSharelink:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//兔币支付
+ (void)requestQrcode:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//兔币明细
+ (void)requestTuucoinconsume:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//我的评价
+ (void)requestMyrateinfo:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//去支付
+ (void)requestOrderpay:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//热门搜索
+ (void)requestHotsearch:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//搜索动作
+ (void)requestSearch:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//我的积分
+ (void)requestIntegraldetails:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//我的兔币
+ (void)requestTuucoindetails:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//订单状态
+ (void)requestLogisticsinfo:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//忘记密码
+ (void)requestForgetpassword:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//修改地址
+ (void)requestAddressmodify:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//删除评论
+ (void)requestOrderratedelete:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//分享评论
+ (void)requestOrderrateshare:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//支付宝支付
+ (void)requestAlitrade:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//我的信息
+ (void)requestMine:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//高德地址反编码
+ (void)requestGeoAddress:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//高德经纬度地址反编码
+ (void)requestGeoAddressWithPoint:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//积分提醒信息取得
+ (void)requestIntegralconfig:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//设置积分提醒
+ (void)requestIntegralconfigure:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//修改昵称性别
+ (void)requestSetpersonalinfo:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//修改密码
+ (void)requestPasswordmodify:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//检查更新
+ (void)requestCheckVersion:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//意见反馈
+ (void)requestSuggestion:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


@end
