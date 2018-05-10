//
//  CustomEmptyView.m
//  Tuuyuu
//
//  Created by WishU on 2018/4/16.
//  Copyright © 2018年 WishU. All rights reserved.
//

#import "CustomEmptyView.h"
#import "Common.h"

@interface CustomEmptyView () {
    UIImageView *emptyViewImage;
    UILabel *emptyViewTitle;
    UIButton *emptyViewButton;
}

@end

@implementation CustomEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        emptyViewImage = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200*SCALE)/2, 200*SCALE, 200*SCALE, 200*SCALE)];
        [emptyViewImage setHidden:YES];
        [self addSubview:emptyViewImage];
        
        emptyViewTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(emptyViewImage.frame)+0*SCALE, SCREEN_WIDTH, 20*SCALE)];
        emptyViewTitle.textColor = [UIColor darkGrayColor];
        emptyViewTitle.font = [UIFont systemFontOfSize:15*SCALE];
        emptyViewTitle.textAlignment = NSTextAlignmentCenter;
        [emptyViewTitle setHidden:YES];
        [self addSubview:emptyViewTitle];
        
        emptyViewButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [emptyViewButton setFrame:CGRectMake((SCREEN_WIDTH-200*SCALE)/2, CGRectGetMaxY(emptyViewTitle.frame)+10*SCALE, 200*SCALE, 44*SCALE)];
        [emptyViewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        emptyViewButton.titleLabel.font = [UIFont systemFontOfSize:17.0*SCALE];
        [emptyViewButton setBackgroundImage:[UIImage imageNamed:@"order_appraise"] forState:UIControlStateNormal];
        [emptyViewButton addTarget:self action:@selector(reloadBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [emptyViewButton setHidden:YES];
        [self addSubview:emptyViewButton];
        
    }
    return self;
}

- (void)setEmptyViewTitle:(NSString *)title {
    [emptyViewTitle setText:title];
}

- (void)setEmptyViewStyle:(EmptyViewStyle)style {
    switch (style) {
        case EmptyViewStyleNetworkUnreachable:
            [emptyViewImage setImage:[UIImage imageNamed:@"no_net"]];
            [emptyViewTitle setText:@"您的网络好像不太给力，请稍后再试"];
            [emptyViewButton setTitle:@"重新加载" forState:UIControlStateNormal];
            [emptyViewImage setHidden:NO];
            [emptyViewTitle setHidden:NO];
            [emptyViewButton setHidden:NO];
            break;
            
        case EmptyViewStyleNoResults:
            [emptyViewImage setImage:[UIImage imageNamed:@"no_goods"]];
            [emptyViewImage setHidden:NO];
            [emptyViewTitle setHidden:NO];
            [emptyViewButton setHidden:YES];
            break;
            
        case EmptyViewStyleNoAddress:
            [emptyViewImage setImage:[UIImage imageNamed:@"no_gps"]];
            [emptyViewImage setHidden:NO];
            [emptyViewTitle setHidden:NO];
            [emptyViewButton setHidden:YES];
            
            break;
            
        case EmptyViewStyleLogout:
            [emptyViewImage setImage:[UIImage imageNamed:@"no_net"]];
            [emptyViewTitle setText:@""];
            [emptyViewButton setTitle:@"登录后查看订单" forState:UIControlStateNormal];
            [emptyViewImage setHidden:NO];
            [emptyViewTitle setHidden:NO];
            [emptyViewButton setHidden:NO];
            
            break;
            
        default:
            break;
    }
    
}

- (void)reloadBtnEvent {
    self.reloadBlock();
}



@end
