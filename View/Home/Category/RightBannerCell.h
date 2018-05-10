//
//  RightBannerCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/6/1.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface RightBannerCell : BaseTableViewCell

@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIButton *tipsBtn;
@property (copy, nonatomic) void (^plusBlock)();

@end
