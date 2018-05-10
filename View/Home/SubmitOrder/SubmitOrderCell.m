//
//  SubmitOrderCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/23.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SubmitOrderCell.h"

@implementation SubmitOrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.contentView.backgroundColor = UIColorFromRGB(250, 250, 250);
        
        //图片
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, 10*SCALE, 70*SCALE, 70*SCALE)];
        [self addSubview:_image];
        
        //商品名称
        _title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_image.frame)+10*SCALE, 10*SCALE, 200*SCALE, 20*SCALE)];
        _title.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_title];
        
        //规格
        _subTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_image.frame)+10*SCALE, CGRectGetMaxY(_title.frame)+3*SCALE, 200*SCALE, 20*SCALE)];
        _subTitle.textColor = [UIColor darkGrayColor];
        _subTitle.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_subTitle];
        
        //数量
        _count = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_image.frame)+10*SCALE, CGRectGetMaxY(_subTitle.frame)+8*SCALE, 200*SCALE, 20*SCALE)];
        _count.textColor = [UIColor darkGrayColor];
        _count.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_count];
        
        //原价
        _oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10*SCALE-60*SCALE, _subTitle.frame.origin.y, 60*SCALE, 20*SCALE)];
        _oldPriceLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_oldPriceLabel];
        
        
        //现价
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10*SCALE-60*SCALE, 10*SCALE, 60*SCALE, 20*SCALE)];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.font = [UIFont systemFontOfSize:13*SCALE];
        
        [self addSubview:_priceLabel];
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //原价
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
   
    NSString *oldPriceStr = [formatter stringFromNumber:[NSNumber numberWithFloat:_oldPrice]];
    NSAttributedString *oldPriceString =[[NSAttributedString alloc]initWithString:oldPriceStr
                                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f*SCALE],NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                                                                    NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:[UIColor lightGrayColor],NSBaselineOffsetAttributeName:@(0)}];
    
    
    [_oldPriceLabel setAttributedText:oldPriceString];
    
    //现价
    NSString *newPriceStr = [formatter stringFromNumber:[NSNumber numberWithFloat:_newPrice]];
    NSMutableAttributedString *newPriceString =[[NSMutableAttributedString alloc]initWithString:newPriceStr
                                                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f*SCALE],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [newPriceString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9.0f] range:NSMakeRange(0, 1)];
    [_priceLabel setAttributedText:newPriceString];
}

@end
