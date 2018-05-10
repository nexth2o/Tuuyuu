//
//  AppDelegate.h
//  Tuuyuu
//
//  Created by WishU on 2017/5/8.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "FMDatabaseQueue.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (atomic, strong) FMDatabaseQueue *dbQueue;


@end

