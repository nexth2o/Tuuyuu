//
//  SecSegmentView.m
//  Tuuyuu
//
//  Created by Neusoft on 2017/6/26.
//  Copyright © 2017年 JapanI. All rights reserved.
//

#define windowContentWidth  SCREEN_WIDTH
#define SFQRedColor [UIColor colorWithRed:255/255.0 green:92/255.0 blue:79/255.0 alpha:1]
#define MAX_TitleNumInWindow 2

#import "SecSegmentView.h"
#import "Common.h"


@interface SecSegmentView()

@property (nonatomic,strong) NSMutableArray *btns;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) UIButton *titleBtn;
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) UIView *selectLine;
@property (nonatomic,assign) CGFloat btn_w;
@end


@implementation SecSegmentView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray clickBlick:(btnClickBlock)block{
    self = [super initWithFrame:frame];
    if (self) {
        
        //        self.layer.shadowColor=[UIColor blackColor].CGColor;
        //        self.layer.shadowOffset=CGSizeMake(2, 2);
        //        self.layer.shadowRadius=2;
        //        self.layer.shadowOpacity=.2;
        
        _btn_w=0.0;
        if (titleArray.count<MAX_TitleNumInWindow+1) {
            _btn_w=windowContentWidth/titleArray.count;
        }else{
            _btn_w=windowContentWidth/MAX_TitleNumInWindow;
        }
        _titles=titleArray;
        _defaultIndex=1;
        _titleFont=[UIFont systemFontOfSize:18*SCALE];
        _btns=[[NSMutableArray alloc] initWithCapacity:0];
        _titleNomalColor=[UIColor whiteColor];//文字非选中色
        //        _titleSelectColor=SFQRedColor;
        _titleSelectColor=MAIN_COLOR;//文字选中色
        _bgScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, windowContentWidth, self.frame.size.height)];
        _bgScrollView.backgroundColor=MAIN_COLOR;

        _bgScrollView.showsHorizontalScrollIndicator=NO;
        _bgScrollView.contentSize=CGSizeMake(_btn_w*titleArray.count, self.frame.size.height);
        [self addSubview:_bgScrollView];
        
//        _selectLine=[[UIView alloc] initWithFrame:CGRectMake(_btn_w, self.frame.size.height-2, _btn_w, 2)];
        _selectLine=[[UIView alloc] initWithFrame:CGRectMake(_btn_w, 0*SCALE, _btn_w, self.frame.size.height)];
        
        _selectLine.backgroundColor=[UIColor whiteColor];
        
        [_bgScrollView addSubview:_selectLine];
        
        for (int i=0; i<titleArray.count; i++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(_btn_w*i, 0, _btn_w, self.frame.size.height-2);
            //            btn.tag=i+1;
            btn.tag=i;
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:_titleNomalColor forState:UIControlStateNormal];
            [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
//            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setBackgroundColor:[UIColor clearColor]];
            btn.titleLabel.font=_titleFont;
            
            [_bgScrollView addSubview:btn];
            [_btns addObject:btn];
            if (i==1) {
                _titleBtn=btn;
                btn.selected=YES;
            }
            self.block=block;
            
        }
    }
    
    return self;
}

-(void)btnClick:(UIButton *)btn{
    
    if (self.block) {
        self.block(btn.tag);
    }
    
    if (btn.tag==_defaultIndex) {
        return;
    }else{
        _titleBtn.selected=!_titleBtn.selected;
        _titleBtn=btn;
        _titleBtn.selected=YES;
        _defaultIndex=btn.tag;
    }
    
    //计算偏移量
    CGFloat offsetX=btn.frame.origin.x - 2*_btn_w;
    if (offsetX<0) {
        offsetX=0;
    }
    CGFloat maxOffsetX= _bgScrollView.contentSize.width-windowContentWidth;
    if (offsetX>maxOffsetX) {
        offsetX=maxOffsetX;
    }
    
    [UIView animateWithDuration:.2 animations:^{
        
        [_bgScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
//        _selectLine.frame=CGRectMake(btn.frame.origin.x, self.frame.size.height-2, btn.frame.size.width, 2);
        _selectLine.frame = CGRectMake(btn.frame.origin.x, 0*SCALE, btn.frame.size.width, self.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)setTitleNomalColor:(UIColor *)titleNomalColor{
    _titleNomalColor=titleNomalColor;
    [self updateView];
}

-(void)setTitleSelectColor:(UIColor *)titleSelectColor{
    _titleSelectColor=titleSelectColor;
    [self updateView];
}

-(void)setTitleFont:(UIFont *)titleFont{
    _titleFont=titleFont;
    [self updateView];
}

-(void)setDefaultIndex:(NSInteger)defaultIndex{
    _defaultIndex=defaultIndex;
    [self updateView];
}

-(void)updateView{
    for (UIButton *btn in _btns) {
        [btn setTitleColor:_titleNomalColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
        btn.titleLabel.font=_titleFont;
        _selectLine.backgroundColor=MAIN_COLOR;
        
        if (btn.tag-1==_defaultIndex-1) {
            _titleBtn=btn;
            btn.selected=YES;
//            _selectLine.frame=CGRectMake(btn.frame.origin.x, self.frame.size.height-2, btn.frame.size.width, 2);
            _selectLine.frame = CGRectMake(btn.frame.origin.x, 0*SCALE, btn.frame.size.width, self.frame.size.height);
        }else{
            btn.selected=NO;
        }
    }
}



@end
