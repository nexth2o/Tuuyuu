//
//  ShoppingCartView.h
//  Tuuyuu
//
//  Created by WishU on 2017/6/1.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseView.h"
#import "ZFReOrderTableView.h"

@class BadgeView;

@protocol ShoppingCartViewDelegate <NSObject>

@optional

- (void)cashBtnClick:(id)sender;

@end

@interface ShoppingCartView : BaseView

@property (nonatomic, strong) BadgeView *badge;

@property (nonatomic, strong) UIButton *shoppingCartBtn;

@property (nonatomic, strong) UIView *parentView;

@property (nonatomic, strong) ZFReOrderTableView *OrderList;

@property (nonatomic, strong) id<ShoppingCartViewDelegate>delegate;


- (instancetype) initWithFrame:(CGRect)frame inView:(UIView *)parentView withObjects:(NSMutableArray *)objects;

- (void)updateFrame:(UIView *)view;

- (void)setTotalMoney:(float)nTotal;

- (void)setCartImage:(NSString *)imageName;

- (void)dismissAnimated:(BOOL) animated;

- (void)clickCartBtn;

@end
