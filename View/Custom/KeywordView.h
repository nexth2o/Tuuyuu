//
//  KeywordView.h
//  Tuuyuu
//
//  Created by WishU on 2017/7/27.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyWordsDelegate <NSObject>

-(void)tagBtnClick:(UIButton *)button;
-(void)tagBtnChangeColor:(UIButton *)button;

@end


@interface KeywordView : UIView

@property (nonatomic,assign) id<KeyWordsDelegate>keyWordsDelegate;

- (id)initWithframe:(CGRect)frame Keywords:(NSMutableArray *) keywords;


@end
