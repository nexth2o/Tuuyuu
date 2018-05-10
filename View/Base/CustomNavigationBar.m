//
//  CustomNavigationBar.m
//  Tuuyuu
//
//  Created by WishU on 2017/5/8.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "CustomNavigationBar.h"

@implementation CustomNavigationBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        //底部阴影
//        self.layer.shadowColor=[UIColor blackColor].CGColor;
//        self.layer.shadowOffset=CGSizeMake(1, 1);
//        self.layer.shadowRadius=2;
//        self.layer.shadowOpacity=.2;
        
        //底色
//        [self setBackgroundColor:MAIN_COLOR];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        //标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64.0f*SCALE, STATUS_BAR_HEIGHT, SCREEN_WIDTH - 64.0f*SCALE*2, NAV_BAR_HEIGHT)];
        [_titleLabel setFont:[UIFont systemFontOfSize:18*SCALE]];
        [_titleLabel setTextColor:[UIColor darkGrayColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLabel];
        
        //定位按钮
        _locationButton = [[UIButton alloc] initWithFrame:CGRectMake(10*SCALE, STATUS_BAR_HEIGHT, 180*SCALE, NAV_BAR_HEIGHT)];
        [_locationButton setBackgroundImage:[UIImage imageNamed:@"home_location_btn"] forState:UIControlStateNormal];
        [_locationButton addTarget:self action:@selector(locationBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_locationButton setHidden:YES];
//        _locationButton.backgroundColor = [UIColor blueColor];
        [self addSubview:_locationButton];
        
        //定位文言
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(42*SCALE, STATUS_BAR_HEIGHT, 122*SCALE, NAV_BAR_HEIGHT)];
        [_locationLabel setFont:[UIFont systemFontOfSize:17*SCALE]];
        [_locationLabel setTextColor:[UIColor whiteColor]];
        _locationLabel.textAlignment = NSTextAlignmentCenter;
//                _locationLabel.backgroundColor = [UIColor purpleColor];
        [_locationLabel setHidden:YES];
        [self addSubview:_locationLabel];
        
        //搜索按钮
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - (88+5)*SCALE, STATUS_BAR_HEIGHT, 44*SCALE, NAV_BAR_HEIGHT)];
        [_searchButton setBackgroundImage:[UIImage imageNamed:@"home_search"] forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(searchBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_searchButton setHidden:YES];
//        _searchButton.backgroundColor = [UIColor greenColor];
        [self addSubview:_searchButton];
        
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, STATUS_BAR_HEIGHT, 44.0f*SCALE, NAV_BAR_HEIGHT)];
        [_leftButton setImage:[UIImage imageNamed:@"navigation_back_gray"] forState:UIControlStateNormal];
        [_leftButton setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [_leftButton.titleLabel setFont:[UIFont systemFontOfSize:16*SCALE]];
        [_leftButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setHidden:YES];
        [self addSubview:_leftButton];
        
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44.0f*SCALE, STATUS_BAR_HEIGHT, 44.0f*SCALE, NAV_BAR_HEIGHT)];
        [_rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [_rightButton addTarget:self action:@selector(rightBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
//        _rightButton.backgroundColor = [UIColor blueColor];
        [_rightButton setHidden:YES];
        [self addSubview:_rightButton];
        
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 88.0f*SCALE, STATUS_BAR_HEIGHT, 44.0f*SCALE, NAV_BAR_HEIGHT)];
        [_shareButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [_shareButton addTarget:self action:@selector(shareBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        //        _rightButton.backgroundColor = [UIColor blueColor];
        [_shareButton setHidden:YES];
        [self addSubview:_shareButton];
        
        _editButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 88.0f*SCALE, STATUS_BAR_HEIGHT, 88.0f*SCALE, NAV_BAR_HEIGHT)];
        [_editButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_editButton setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [_editButton.titleLabel setFont:[UIFont systemFontOfSize:16*SCALE]];
        [_editButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(editBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
//        _editButton.backgroundColor = [UIColor blueColor];
        [_editButton setHidden:YES];
        [self addSubview:_editButton];
    }
    return self;
}

- (void)locationBtnEvent:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(locationBtnClick:)]) {
        [_delegate locationBtnClick:sender];
    }
}

- (void)searchBtnEvent:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(searchBtnClick:)]) {
        [_delegate searchBtnClick:sender];
    }
}

- (void)leftBtnEvent:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(leftBtnClick:)]) {
        [_delegate leftBtnClick:sender];
    }
}

- (void)rightBtnEvent:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(rightBtnClick:)]) {
        [_delegate rightBtnClick:sender];
    }
}

- (void)shareBtnEvent:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(shareBtnClick:)]) {
        [_delegate shareBtnClick:sender];
    }
}

- (void)editBtnEvent:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(editBtnClick:)]) {
        [_delegate editBtnClick:sender];
    }
}


@end
