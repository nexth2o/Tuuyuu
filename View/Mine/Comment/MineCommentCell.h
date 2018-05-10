//
//  MineCommentCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/26.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MineCommentCell : BaseTableViewCell

@property (strong, nonatomic) UILabel *storeName;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UILabel *time;

@property (strong, nonatomic) UIImageView *star1;
@property (strong, nonatomic) UIImageView *star2;
@property (strong, nonatomic) UIImageView *star3;
@property (strong, nonatomic) UIImageView *star4;
@property (strong, nonatomic) UIImageView *star5;

@property (strong, nonatomic) UIImageView *staffStar1;
@property (strong, nonatomic) UIImageView *staffStar2;
@property (strong, nonatomic) UIImageView *staffStar3;
@property (strong, nonatomic) UIImageView *staffStar4;
@property (strong, nonatomic) UIImageView *staffStar5;

@property (strong, nonatomic) UILabel *type;

@property (copy, nonatomic) void (^shareBtnBlock)();
@property (copy, nonatomic) void (^deleteBtnBlock)();

@property (strong, nonatomic) UILabel *storeTitle;
@property (strong, nonatomic) UIImageView *userIcon;
@property (strong, nonatomic) UILabel *type2;
@property (strong, nonatomic) UIView *line2;
@property (strong, nonatomic) UIImageView *shareIcon;
@property (strong, nonatomic) UILabel *shareLabel;
@property (strong, nonatomic) UIButton *shareBtn;
@property (strong, nonatomic) UIImageView *deleteIcon;
@property (strong, nonatomic) UILabel *deleteLabel;
@property (strong, nonatomic) UIButton *deleteBtn;
@property (strong, nonatomic) UIView *line3;

@end
