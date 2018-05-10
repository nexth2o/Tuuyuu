//
//  MineFriendCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/10.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MineFriendCell : BaseTableViewCell

@property(strong, nonatomic) UIImageView *icon;
@property(strong, nonatomic) UILabel *name;
@property(strong, nonatomic) UILabel *type;
@property(strong, nonatomic) UILabel *coinCount;
@property(strong, nonatomic) UILabel *time;

@end
