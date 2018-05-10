//
//  CustomNavigationBar.h
//  Tuuyuu
//
//  Created by WishU on 2017/5/8.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseView.h"
#import "Common.h"

@protocol TitleViewDelegate <NSObject>

@optional

- (void)locationBtnClick:(id)sender;
- (void)searchBtnClick:(id)sender;
- (void)leftBtnClick:(id)sender;
- (void)rightBtnClick:(id)sender;
- (void)shareBtnClick:(id)sender;
- (void)editBtnClick:(id)sender;

@end

@interface CustomNavigationBar : BaseView

@property (nonatomic, strong) id<TitleViewDelegate>delegate;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UIButton *locationButton;
@property (strong, nonatomic) UIButton *searchButton;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UIButton *editButton;

@end
