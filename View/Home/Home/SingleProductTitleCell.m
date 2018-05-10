//
//  SingleProductTitleCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/5/24.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SingleProductTitleCell.h"

@implementation SingleProductTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //标题区 高度30
        //单品精选图标
        UIImageView *popularImageView = [[UIImageView alloc] initWithFrame:CGRectMake(140*SCALE, 7*SCALE, 16*SCALE, 16*SCALE)];
        popularImageView.image = [UIImage imageNamed:@"home_single"];
        [self addSubview:popularImageView];
        //单品精选标题
        UILabel *popularLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(popularImageView.frame)+6*SCALE, 5*SCALE, 80*SCALE, 20*SCALE)];
        popularLabel.text = @"单品精选";
        [popularLabel setFont:[UIFont systemFontOfSize:15*SCALE]];
        popularLabel.textColor = [UIColor colorWithRed:(255)/255.0 green:(122)/255.0 blue:(52)/255.0 alpha:1];
        [self addSubview:popularLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

@end
