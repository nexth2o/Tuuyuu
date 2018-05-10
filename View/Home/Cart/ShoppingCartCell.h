//
//  ShoppingCartCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/6/1.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "Common.h"

@interface ShoppingCartCell : BaseTableViewCell

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *dotLabel;

@property (strong, nonatomic) UILabel *priceLabel;

@property (strong, nonatomic) UILabel *numberLabel;

@property (strong, nonatomic) UIButton *minus;

@property (strong, nonatomic) UIButton *plus;

@property (nonatomic,copy) void (^operationBlock)(NSUInteger number,BOOL isPlus);

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,assign) NSInteger number;

-(void)showNumber:(NSUInteger)count;

@end

