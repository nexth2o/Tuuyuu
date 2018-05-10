//
//  SubmitOrderCell.h
//  Tuuyuu
//
//  Created by WishU on 2017/6/23.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SubmitOrderCell : BaseTableViewCell

//图片
@property(strong, nonatomic) UIImageView *image;
//商品名
@property(strong, nonatomic) UILabel *title;
//规格
@property(strong, nonatomic) UILabel *subTitle;
//数量
@property(strong, nonatomic) UILabel *count;
//原价
@property(strong, nonatomic) UILabel *oldPriceLabel;
//现价
@property(strong, nonatomic) UILabel *priceLabel;

@property(assign, nonatomic)float oldPrice;
@property(assign, nonatomic)float newPrice;



@end
