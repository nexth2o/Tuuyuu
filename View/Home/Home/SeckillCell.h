//
//  SeckillCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/5/19.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "SeckillScrollView.h"

@protocol SeckillCellDelegate <NSObject>

@optional

/** 点击图片回调 */
- (void)didSelectItemAtIndex:(NSInteger)index;

@end

@interface SeckillCell : BaseTableViewCell

@property (copy, nonatomic) void (^saleBtnEvent)();
@property (copy, nonatomic) void (^halfBtnEvent)();
@property (copy, nonatomic) void (^freeBtnEvent)();
@property (copy, nonatomic) void (^newBtnEvent)();

@property (strong, nonatomic) SeckillScrollView *scrImage;

@property (strong, nonatomic) UIImageView *seckillImageView;
@property (strong, nonatomic) UILabel *seckillLabel;

@property (strong, nonatomic) UILabel *hourLabel;
@property (strong, nonatomic) UILabel *minuteLabel;
@property (strong, nonatomic) UILabel *secondLabel;
@property (strong, nonatomic) NSArray *productArray;
@property (strong, nonatomic) UIImageView *timeImageView;

@property (strong, nonatomic) UIImageView *saleImage;
@property (strong, nonatomic) UIImageView *halfImage;
@property (strong, nonatomic) UIImageView *freeImage;
@property (strong, nonatomic) UIImageView *nnewImage;

@property (nonatomic, weak) id<SeckillCellDelegate> delegate;


@end
