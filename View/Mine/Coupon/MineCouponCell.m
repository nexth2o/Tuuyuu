//
//  MineCouponCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/8/30.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "MineCouponCell.h"

@implementation MineCouponCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        //竖线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        line.backgroundColor = [UIColor orangeColor];
        [bgView addSubview:line];
        
        //20元
        UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        moneyLabel.font = [UIFont systemFontOfSize:20];
        moneyLabel.textColor = [UIColor orangeColor];
        [bgView addSubview:moneyLabel];
        
        //满20可用
        UILabel *moneyTips = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        moneyTips.font = [UIFont systemFontOfSize:15];
        [bgView addSubview:moneyTips];
        
        //同享 不同享
        UIImageView *tipsImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        tipsImage.image = [UIImage imageNamed:@""];
        [bgView addSubview:tipsImage];
        
        //优惠劵名称
        UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        title1.font = [UIFont systemFontOfSize:18];
        [bgView addSubview:title1];
        
        //满30元可用
        UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        title2.font = [UIFont systemFontOfSize:10];
        [bgView addSubview:title2];
        
        //有效期至2017.08.08
        UILabel *title3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        title3.font = [UIFont systemFontOfSize:10];
        [bgView addSubview:title3];
        
        //注意事项
        UILabel *title4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        title4.font = [UIFont systemFontOfSize:10];
        title4.textColor = [UIColor darkGrayColor];
        [bgView addSubview:title4];
        
        //已领取图片
        UIImageView *statusImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        statusImage.image = [UIImage imageNamed:@""];
        [bgView addSubview:statusImage];
        
        //环形图
        
        //已领取按钮
        
        
        
        
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
}

@end
