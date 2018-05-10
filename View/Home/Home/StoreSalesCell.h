//
//  StoreSalesCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/6/19.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface StoreSalesCell : BaseTableViewCell

@property (nonatomic, strong) UIImageView *salesImageView;
@property (nonatomic, strong) UILabel *salesText;
@property (nonatomic, strong) UIButton *open;
@property (nonatomic, strong) UILabel *salesEtc;

@property (nonatomic, strong) NSMutableArray *storeSalesArray;

@property (copy, nonatomic) void (^openBlock)();

@end
