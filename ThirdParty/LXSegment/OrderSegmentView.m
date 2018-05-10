//
//  OrderSegmentView.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/9.
//  Copyright © 2017年 WishU. All rights reserved.
//


#define windowContentWidth  SCREEN_WIDTH
#define SFQRedColor [UIColor colorWithRed:255/255.0 green:92/255.0 blue:79/255.0 alpha:1]
#define MAX_TitleNumInWindow 3

#import "OrderSegmentView.h"
#import "Common.h"

@interface OrderSegmentView()

@property (nonatomic,strong) NSMutableArray *btns;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) UIButton *titleBtn;
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) UIView *selectLine;
@property (nonatomic,assign) CGFloat btn_w;
@end

@implementation OrderSegmentView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray clickBlick:(btnClickBlock)block{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.shadowColor=[UIColor blackColor].CGColor;
        self.layer.shadowOffset=CGSizeMake(1, 1);
        self.layer.shadowRadius=.5;
        self.layer.shadowOpacity=.1;
        
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
        _defaultIndex=0;
        _titleFont=[UIFont systemFontOfSize:15*SCALE];
        _btns=[[NSMutableArray alloc] initWithCapacity:0];
        _titleNomalColor=[UIColor grayColor];//文字非选中色
        //        _titleSelectColor=SFQRedColor;
        _titleSelectColor=MAIN_COLOR;//文字选中色
        _bgScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, windowContentWidth, self.frame.size.height)];
        _bgScrollView.backgroundColor=[UIColor whiteColor];
        _bgScrollView.showsHorizontalScrollIndicator=NO;
        _bgScrollView.contentSize=CGSizeMake(_btn_w*titleArray.count, self.frame.size.height);
        [self addSubview:_bgScrollView];
        
        _selectLine = [[UIView alloc] init];
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15*SCALE]};
        CGSize size = [_titles[0] boundingRectWithSize:CGSizeMake(100, 1000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        //        [_selectLine setFrame:CGRectMake(0, self.frame.size.height-2, _btn_w, 2)];
        [_selectLine setFrame:CGRectMake((_btn_w-size.width)/2, self.frame.size.height-2, size.width, 2)];
//        _selectLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2, _btn_w, 2)];
        _selectLine.backgroundColor=_titleSelectColor;
        [_bgScrollView addSubview:_selectLine];
        
        for (int i=0; i<titleArray.count; i++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(_btn_w*i, 0, _btn_w, self.frame.size.height-2);
            btn.tag=i+1;
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:_titleNomalColor forState:UIControlStateNormal];
            [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
            [btn setBackgroundColor:[UIColor whiteColor]];
            btn.titleLabel.font=_titleFont;
            [_bgScrollView addSubview:btn];
            [_btns addObject:btn];
            if (i==0) {
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
    CGFloat offsetX=btn.frame.origin.x - 1*_btn_w;
    if (offsetX<0) {
        offsetX=0;
    }
    CGFloat maxOffsetX= _bgScrollView.contentSize.width-windowContentWidth;
    if (offsetX>maxOffsetX) {
        offsetX=maxOffsetX;
    }
    
    [UIView animateWithDuration:.2 animations:^{
        
        [_bgScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        
        
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15*SCALE]};
        CGSize size = [_titles[btn.tag-1] boundingRectWithSize:CGSizeMake(100, 1000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        [_selectLine setFrame:CGRectMake(btn.frame.origin.x+(_btn_w-size.width)/2, self.frame.size.height-2, size.width, 2)];
        
//        _selectLine.frame=CGRectMake(btn.frame.origin.x, self.frame.size.height-2, btn.frame.size.width, 2);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

@end
