//
//  SeckillScrollView.h
//  Tuuyuu
//
//  Created by WishU on 2017/5/22.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseView.h"

@protocol SeckillScrollViewDelegate <NSObject>

@optional

/** 点击图片回调 */
- (void)didSelectItemAtIndex:(NSInteger)index;

@end

@interface SeckillScrollView : BaseView

@property (nonatomic, weak) id<SeckillScrollViewDelegate> delegate;
@property (nonatomic, strong) NSArray *productArray;

- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)array;

@end
