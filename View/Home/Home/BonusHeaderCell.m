//
//  BonusHeaderCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/9.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "BonusHeaderCell.h"
#import "HomeButton.h"


@implementation BonusHeaderCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        headerImage.image = [UIImage imageNamed:@"home_bonus_banner"];
        [self addSubview:headerImage];
        
        
        //微信按钮
        
        HomeButton *_faceBtn = [HomeButton buttonWithType:UIButtonTypeCustom];
        [_faceBtn setFrame:CGRectMake(30*SCALE, SCREEN_HEIGHT-170*SCALE, 80*SCALE, 80*SCALE)];
        [_faceBtn setImage:[UIImage imageNamed:@"home_bonus_face"] forState:UIControlStateNormal];
        [_faceBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_faceBtn setTitle:@"面对面邀请" forState:UIControlStateNormal];
        [_faceBtn.titleLabel setFont:[UIFont systemFontOfSize:9*SCALE]];
        [_faceBtn verticalImageAndTitle:6*SCALE];
        [_faceBtn addTarget:self action:@selector(faceBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_faceBtn];
        
        
        
        HomeButton *_wxBtn = [HomeButton buttonWithType:UIButtonTypeCustom];
        [_wxBtn setFrame:CGRectMake(CGRectGetMaxX(_faceBtn.frame)+0*SCALE, SCREEN_HEIGHT-170*SCALE, 80*SCALE, 80*SCALE)];
        [_wxBtn setImage:[UIImage imageNamed:@"home_bonus_wx"] forState:UIControlStateNormal];
        [_wxBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_wxBtn setTitle:@"邀请微信好友" forState:UIControlStateNormal];
        [_wxBtn.titleLabel setFont:[UIFont systemFontOfSize:9*SCALE]];
        [_wxBtn verticalImageAndTitle:6*SCALE];
        [_wxBtn addTarget:self action:@selector(wxBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_wxBtn];
        
        HomeButton *_qqBtn = [HomeButton buttonWithType:UIButtonTypeCustom];
        [_qqBtn setFrame:CGRectMake(CGRectGetMaxX(_wxBtn.frame)+0*SCALE, SCREEN_HEIGHT-170*SCALE, 80*SCALE, 80*SCALE)];
        [_qqBtn setImage:[UIImage imageNamed:@"home_bonus_qq"] forState:UIControlStateNormal];
        [_qqBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_qqBtn setTitle:@"邀请QQ好友" forState:UIControlStateNormal];
        [_qqBtn.titleLabel setFont:[UIFont systemFontOfSize:9*SCALE]];
        [_qqBtn verticalImageAndTitle:6*SCALE];
        [_qqBtn addTarget:self action:@selector(qqBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_qqBtn];
        
        HomeButton *_friendBtn = [HomeButton buttonWithType:UIButtonTypeCustom];
        [_friendBtn setFrame:CGRectMake(CGRectGetMaxX(_qqBtn.frame)+0*SCALE, SCREEN_HEIGHT-170*SCALE, 80*SCALE, 80*SCALE)];
        [_friendBtn setImage:[UIImage imageNamed:@"home_bonus_friend"] forState:UIControlStateNormal];
        [_friendBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_friendBtn setTitle:@"朋友圈" forState:UIControlStateNormal];
        [_friendBtn.titleLabel setFont:[UIFont systemFontOfSize:9*SCALE]];
        [_friendBtn verticalImageAndTitle:6*SCALE];
        [_friendBtn addTarget:self action:@selector(friendBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_friendBtn];
        
        UIButton *_tipsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tipsBtn setFrame:CGRectMake((SCREEN_WIDTH -100*SCALE)/2, CGRectGetMaxY(_friendBtn.frame)+5*SCALE, 100*SCALE, 40*SCALE)];
        
        NSAttributedString *registerStr =[[NSAttributedString alloc]initWithString:@"活动规则"
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f*SCALE],NSForegroundColorAttributeName:[UIColor darkGrayColor], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:[UIColor darkGrayColor],NSBaselineOffsetAttributeName:@(0)}];
        
        [_tipsBtn setAttributedTitle:registerStr forState:UIControlStateNormal];
        
        [_tipsBtn addTarget:self action:@selector(tipsBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_tipsBtn];
        
    }
    
    return self;
}

- (void)wxBtn:(id)sender {
    self.wxBtnBlock();
}

- (void)qqBtn:(id)sender {
    self.qqBtnBlock();
}

- (void)faceBtn:(id)sender {
    self.faceBtnBlock();
}

- (void)friendBtn:(id)sender {
    self.friendBtnBlock();
}

- (void)tipsBtn:(id)sender {
    self.tipsBtnBlock();
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
}

@end
