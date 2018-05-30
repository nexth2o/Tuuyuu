//
//  CustomEmptyView.h
//  Tuuyuu
//
//  Created by WishU on 2018/4/16.
//  Copyright © 2018年 WishU. All rights reserved.
//

#import "BaseView.h"

@interface CustomEmptyView : BaseView

@property (copy, nonatomic) void (^reloadBlock)(void);

- (void)setEmptyViewTitle:(NSString *)title;
- (void)setEmptyViewStyle:(EmptyViewStyle)style;

@end
