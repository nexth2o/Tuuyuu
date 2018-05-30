//
//  PopularCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/5/24.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface PopularCell : BaseTableViewCell

@property (copy, nonatomic) void (^friedBtnEvent)(void);
@property (copy, nonatomic) void (^fastBtnEvent)(void);
@property (copy, nonatomic) void (^breadBtnEvent)(void);
@property (copy, nonatomic) void (^juiceBtnEvent)(void);
@property (copy, nonatomic) void (^fruitBtnEvent)(void);
@property (copy, nonatomic) void (^healthBtnEvent)(void);

@property (strong, nonatomic) UIImageView *friedImage;
@property (strong, nonatomic) UIImageView *fastImage;
@property (strong, nonatomic) UIImageView *breadImage;
@property (strong, nonatomic) UIImageView *juiceImage;
@property (strong, nonatomic) UIImageView *fruitImage;
@property (strong, nonatomic) UIImageView *healthImage;

@end
