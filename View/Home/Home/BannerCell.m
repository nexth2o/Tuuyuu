//
//  BannerCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/5/9.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BannerCell.h"

@implementation BannerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //广告区
        _cycleScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200*SCALE)];
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        [self addSubview:_cycleScrollView];
        
        //弧形遮罩
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 177*SCALE, SCREEN_WIDTH, 23*SCALE)];
        bg.image = [UIImage imageNamed:@"home_banner_bg"];
        [self addSubview:bg];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}


@end
