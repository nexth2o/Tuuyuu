//
//  TYPageControl.m
//  Tuuyuu
//
//  Created by WishU on 2017/5/26.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "TYPageControl.h"

@implementation TYPageControl

- (void) setCurrentPage:(NSInteger)page {
    
    [super setCurrentPage:page];
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        
        UIImageView *subview = [self.subviews objectAtIndex:subviewIndex];
        
        CGSize size;
        
        size.height = 6;
        
        size.width = 6;
        
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y, size.width,size.height)];
    }
}


@end
