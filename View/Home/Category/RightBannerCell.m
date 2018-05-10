//
//  RightBannerCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/1.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "RightBannerCell.h"

@implementation RightBannerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, 10*SCALE, SCREEN_WIDTH-100*SCALE, 80*SCALE)];
        [self addSubview:_bannerImageView];
        
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5*SCALE, 10*SCALE, SCREEN_WIDTH-100*SCALE-145*SCALE, 15*SCALE)];
        [_tipsLabel setFont:[UIFont systemFontOfSize:10*SCALE]];
        _tipsLabel.backgroundColor = UIColorFromRGB(255, 241, 213);
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.textColor = [UIColor darkGrayColor];
        [_tipsLabel setHidden:YES];
        [self addSubview:_tipsLabel];
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_tipsLabel.frame) + 10*SCALE, 12*SCALE, 12*SCALE, 12*SCALE)];
        _icon.image = [UIImage imageNamed:@"order_selected"];
        [_icon setHidden:YES];
        [self addSubview:_icon];
        
        _tipsBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_tipsBtn setFrame:CGRectMake(CGRectGetMaxX(_icon.frame) - 6*SCALE, 8*SCALE, 150*SCALE, 20*SCALE)];
        [_tipsBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        //下划线
        NSMutableAttributedString *tipsString =[[NSMutableAttributedString alloc]initWithString:@"同意并接受《帮买服务协议》"
                                                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10*SCALE],NSForegroundColorAttributeName:MAIN_COLOR}];
        [tipsString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 5)];
        [tipsString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(5, 8)];
        [_tipsBtn setAttributedTitle:tipsString forState:UIControlStateNormal];
        [_tipsBtn addTarget:self action:@selector(tipsEvent) forControlEvents:UIControlEventTouchUpInside];
        [_tipsBtn setHidden:YES];
        [self addSubview:_tipsBtn];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)tipsEvent {
    
    self.plusBlock();
    
}

@end
