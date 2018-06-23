//
//  KeywordView.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/27.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "KeywordView.h"
#import "Common.h"

@implementation KeywordView

- (id)initWithframe:(CGRect)frame Keywords:(NSMutableArray *) keywords
{
    self = [super initWithFrame:frame];
    if (self) {
        int width = 0;
        int height = 0;
        int number = 0;
        int rowWidth = 0;
        
        //创建button
        for (int i = 0; i < keywords.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            //        button.tag = 300 + i;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            
            CGSize titleSize = [keywords[i][@"condition"] boundingRectWithSize:CGSizeMake((SCREEN_WIDTH - 20*SCALE), 20*SCALE) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f * SCALE]} context:nil].size;
            
            if (titleSize.width < 30*SCALE) {
                
                titleSize.width = 30*SCALE;
            }
            
            //自动的折行
            rowWidth = rowWidth + titleSize.width + 20*SCALE;
            if (rowWidth > (SCREEN_WIDTH - 20*SCALE)) {
                rowWidth = 0;
                rowWidth = rowWidth + titleSize.width;
                height++;
                width = 0;
                width = width+titleSize.width;
                number = 0;
                button.frame = CGRectMake(10*SCALE, 10*SCALE + 25*SCALE * height, titleSize.width + 10*SCALE, 20*SCALE);
            }else{
                button.frame = CGRectMake(width + 10*SCALE + (number * 20*SCALE), 10*SCALE + 25*SCALE * height, titleSize.width + 10*SCALE, 20*SCALE);
                width = width+titleSize.width;
            }
            number++;
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 3.0f;
            button.backgroundColor = [UIColor whiteColor];
            button.layer.borderWidth = 1.0f;
            button.layer.borderColor = [[UIColor colorWithRed:222.0f/255.0f green:222.0f/255.0f blue:222.0f/255.0f alpha:1.0f] CGColor];
            button.titleLabel.font = [UIFont systemFontOfSize:12.0f * SCALE];
            button.tag = i;
            [button setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [button setTitle:keywords[i][@"condition"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(changeButtonColor:) forControlEvents:UIControlEventTouchDown];
            button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            
            [self addSubview:button];
        }
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10*SCALE + 25*SCALE * (height + 1) + 5*SCALE);
    }
    
    return self;
}

-(void)ButtonClick:(UIButton *)sender
{
    if (self.keyWordsDelegate && [self.keyWordsDelegate respondsToSelector:@selector(tagBtnClick:)]) {
        [self.keyWordsDelegate tagBtnClick:sender];
    }
}

//-(void)changeButtonColor:(UIButton *)sender
//{
//    if (self.keyWordsDelegate && [self.keyWordsDelegate respondsToSelector:@selector(tagBtnChangeColor:)]) {
//        [self.keyWordsDelegate tagBtnChangeColor:sender];
//    }
//}

@end
