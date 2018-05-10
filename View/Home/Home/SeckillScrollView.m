//
//  SeckillScrollView.m
//  Tuuyuu
//
//  Created by WishU on 2017/5/22.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SeckillScrollView.h"
#import "UIImageView+WebCache.h"

@interface SeckillScrollView ()<UIScrollViewDelegate> {
    CGRect imageFrame; //
    CGFloat Margin; // margin为两边空隙宽度
}

@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation SeckillScrollView

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, imageFrame.size.height+30)];
        _scrollView.contentSize = CGSizeMake(imageFrame.size.width * _productArray.count+Margin, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
//        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)array {
    self = [super initWithFrame:frame];
    if (self) {
        Margin = 10*SCALE;
        _productArray = array;
        imageFrame = frame;//0, 30, 100, 110
        CGFloat kWidth = frame.size.width * _productArray.count+Margin;
        CGRect Frame = self.frame;
        Frame.size.width = kWidth;
        self.frame = Frame;
        // 触发懒加载
        self.scrollView.backgroundColor = [UIColor clearColor];
        [self addProduct];
    }
    return self;
}

- (void)addProduct {
    NSInteger index = 0;
    for (NSDictionary *dic in _productArray) {
        UIImageView *imageV = [[UIImageView alloc] init];
        UIImageView *imageV2 = [[UIImageView alloc] init];
        
        imageV.frame = CGRectMake(index * imageFrame.size.width+Margin, Margin, imageFrame.size.width-Margin, imageFrame.size.height-Margin*2);
        // 给图片加手势
        imageV.userInteractionEnabled = YES;
        imageV.tag = index;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
//        [imageV addGestureRecognizer:tap];
        [_scrollView addSubview:imageV];
        
        
        imageV2.frame = CGRectMake(index * imageFrame.size.width+Margin, Margin, imageFrame.size.width-Margin, imageFrame.size.height-Margin*2);
        imageV2.image = [UIImage imageNamed:@"stock_qty"];
//        // 给图片加手势
        imageV2.userInteractionEnabled = YES;
        imageV2.tag = index;
////        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [imageV2 addGestureRecognizer:tap];
        
        
        
        [imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"product_url"]]
                  placeholderImage:[UIImage imageNamed:@""]
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             //TODO
                             if ([dic[@"stock_qty"] intValue] > 0) {
                                 //hidden
                                 [imageV2 removeFromSuperview];
                                 [imageV addGestureRecognizer:tap];
                             }else {
                                 //show
                                 [imageV2 addGestureRecognizer:tap];
                                 [_scrollView addSubview:imageV2];
                                 
                             }
                         }];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(index * imageFrame.size.width+Margin, imageFrame.size.height-Margin, imageFrame.size.width-Margin, 20*SCALE)];
        name.text = dic[@"description"];
        name.textColor = [UIColor darkGrayColor];
//        name.backgroundColor = [UIColor lightGrayColor];
        [name setFont:[UIFont systemFontOfSize:10*SCALE]];
        [_scrollView addSubview:name];
        
        //现价
        UILabel *newPricelabel = [[UILabel alloc] initWithFrame:CGRectMake(index * imageFrame.size.width+Margin, CGRectGetMaxY(name.frame), (imageFrame.size.width-Margin)/2, 20*SCALE)];
        newPricelabel.textAlignment = NSTextAlignmentRight;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        float newPrice = [dic[@"dis_price"] floatValue];
        NSString *newPriceStr = [formatter stringFromNumber:[NSNumber numberWithFloat:newPrice]];
        NSMutableAttributedString *newPriceString =[[NSMutableAttributedString alloc]initWithString:newPriceStr
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f*SCALE],NSForegroundColorAttributeName:[UIColor redColor]}];
        [newPriceString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9.0f] range:NSMakeRange(0, 1)];
        [newPricelabel setAttributedText:newPriceString];
        [_scrollView addSubview:newPricelabel];

        //原价
        UILabel *oldPricelabel = [[UILabel alloc] initWithFrame:CGRectMake(index * imageFrame.size.width+Margin+(imageFrame.size.width-Margin)/2+3*SCALE, CGRectGetMaxY(name.frame)+5*SCALE, (imageFrame.size.width-Margin)/2-3*SCALE, 15*SCALE)];
        float oldPrice = [dic[@"sa_price"] floatValue];
        NSString *oldPriceStr = [formatter stringFromNumber:[NSNumber numberWithFloat:oldPrice]];
        NSAttributedString *oldPriceString =[[NSAttributedString alloc]initWithString:oldPriceStr
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9.f*SCALE],NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                                                                     NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:[UIColor lightGrayColor],NSBaselineOffsetAttributeName:@(0)}];
        [oldPricelabel setAttributedText:oldPriceString];
        [_scrollView addSubview:oldPricelabel];
        
        index++;
        
        //NSBaselineOffsetAttributeName:@(0)
    }
}
- (void)click:(UITapGestureRecognizer *)sender {
    UIImageView *imageVV = (UIImageView *)sender.view;
    
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndex:)]) {
        [self.delegate didSelectItemAtIndex:imageVV.tag];
    }
}

@end
