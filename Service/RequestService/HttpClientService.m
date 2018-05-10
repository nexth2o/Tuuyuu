//
//  HttpClientService.m
//  Tuuyuu
//
//  Created by WishU on 2017/5/8.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "HttpClientService.h"
#import "Common.h"
#import "UserDefaults.h"

@implementation HttpClientService

+ (void)testDome:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];

    NSString *URL = @"http://tuuyuuapp.xicp.io:6000/storelist";
//     NSString *URL = @"http://www.tuuyuu.vip:6000/storelist";
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
             
             if (success) {
                 
                 success(responseObject);
             }
             
         }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
             
             if (failure) {
                 
                 failure(error);
             }
             
         }];
}

//首页接口
+ (void)requestIndex:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"index"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//分类菜单
+ (void)requestLevel:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"classification"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//分类商品
+ (void)requestProduct:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"cateproduct"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//特色商品
+ (void)requestSpecialProduct:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"specialgoods"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//获取验证码
+ (void)requestRegisterCode:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:@"0" forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"registercode"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//获取验证码
+ (void)requestVerificationCode:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:@"0" forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"verficationcode"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//注册
+ (void)requestRegister:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:@"0" forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"register"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//登录
+ (void)requestLogin:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:@"0" forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"login"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//地址列表
+ (void)requestAddress:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"address"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//新增地址
+ (void)requestAddressadd:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"addressadd"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//删除地址
+ (void)requestAddressdelete:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"addressdelete"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}


//商品详情
+ (void)requestProductinfo:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"productinfo"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//确认订单
+ (void)requestSettle:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"settle"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//提交订单
+ (void)requestOrdersubmit:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"ordersubmit"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//微信支付接口
+ (void)requestPrepay:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"prepay"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//门店列表
+ (void)requestStoreaddress:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"storeaddress"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//历史订单
+ (void)requestOrderlist:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"orderlist"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//订单详情
+ (void)requestOrderdetail:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"orderdetail"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//退款申请
+ (void)requestReturnsummary:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"returnsummary"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//退款合计
+ (void)requestReturnsettle:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"returnsettle"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//退款提交
+ (void)requestReturnsubmit:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"returnsubmit"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//退款详情
+ (void)requestReturnstate:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"returnstate"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//我的收藏
+ (void)requestWishlist:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"wishlist"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//新增收藏
+ (void)requestWishlistadd:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"wishlistadd"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//删除收藏
+ (void)requestWishlistdelete:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"wishlistdelete"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//通知消息
+ (void)requestNoticemsg:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"noticemsg"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//悠荐
+ (void)requestNewsmsg:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"newsmsg"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//我的好友
+ (void)requestFriendslist:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"friendslist"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//个人详情
+ (void)requestGetpersonalinfo:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"getpersonalinfo"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//服务指南
+ (void)requestServiceterms:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"serviceterms"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//取消订单
+ (void)requestOrdercancel:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"ordercancel"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//催单
+ (void)requestOrderurge:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"orderurge"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//确认收货
+ (void)requestConfirmreceipt:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"confirmreceipt"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//评价信息
+ (void)requestOrderrate:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"orderrate"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//评价动作
+ (void)requestOrderratesubmit:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"orderratesubmit"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//签到
+ (void)requestSingin:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"signin"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//联系客服
+ (void)requestStoresummary:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"storesummary"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//邀请奖励
+ (void)requestSharelink:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"sharelink"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//兔币支付
+ (void)requestQrcode:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"qrcode"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//兔币明细
+ (void)requestTuucoinconsume:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"tuucoinconsume"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//我的评价
+ (void)requestMyrateinfo:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"myrateinfo"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//去支付
+ (void)requestOrderpay:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"orderpay"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//热门搜索
+ (void)requestHotsearch:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"hotsearch"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//搜索动作
+ (void)requestSearch:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"search"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//我的积分
+ (void)requestIntegraldetails:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"integraldetails"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//我的兔币
+ (void)requestTuucoindetails:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"tuucoindetails"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
                  
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//订单状态
+ (void)requestLogisticsinfo:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"logisticsinfo"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
                  
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//忘记密码
+ (void)requestForgetpassword:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"forgetpassword"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
                  
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//修改地址
+ (void)requestAddressmodify:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"addressmodify"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
                  
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}
//删除评论
+ (void)requestOrderratedelete:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"orderratedelete"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
                  
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}
//分享评论
+ (void)requestOrderrateshare:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"orderrateshare"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
                  
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//支付宝支付
+ (void)requestAlitrade:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"alitrade"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
                  
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//我的信息
+ (void)requestMine:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"mine"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
                  
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//高德地址反编码
+ (void)requestGeoAddress:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    NSString *URL = @"http://restapi.amap.com/v3/place/text";
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
                  
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//高德经纬度地址反编码
+ (void)requestGeoAddressWithPoint:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    NSString *URL = @"http://restapi.amap.com/v3/geocode/regeo";
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
                  
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//积分提醒信息取得
+ (void)requestIntegralconfig:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"integralconfig"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
                  
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//设置积分提醒
+ (void)requestIntegralconfigure:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"integralconfigure"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
                  
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//修改昵称性别
+ (void)requestSetpersonalinfo:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"setpersonalinfo"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
                  
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//修改密码
+ (void)requestPasswordmodify:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"passwordmodify"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
                  
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//检查更新
+ (void)requestCheckVersion:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *URL = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@&country=cn", APPID];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}

//意见反馈
+ (void)requestSuggestion:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_OUT];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [manager.requestSerializer setValue:[[UserDefaults service] getSessionId] forHTTPHeaderField:@"SessionID"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", HYPERLINK, @"suggestion"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
              
              if (success) {
                  
                  success(responseObject);
                  
              }
              
          }failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
              
              if (failure) {
                  
                  failure(error);
              }
              
          }];
}


@end

