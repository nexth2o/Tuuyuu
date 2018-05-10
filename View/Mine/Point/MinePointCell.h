//
//  MinePointCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/28.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MinePointCell : BaseTableViewCell

@property(strong, nonatomic) UILabel *title;
@property(strong, nonatomic) UILabel *subTitle;
@property(strong, nonatomic) UILabel *point;
@property(strong, nonatomic) UILabel *time;
@property(strong, nonatomic) UILabel *detail;
@property(strong, nonatomic) UILabel *info;
@property(strong, nonatomic) UILabel *grageLabel;
@property(strong, nonatomic) UIImageView *gradeImage;
@property(strong, nonatomic) UIImageView *radixImage;
@property(strong, nonatomic) UILabel *radix;

@end
