//
//  OrderHeaderView.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/13.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "OrderHeaderView.h"


@implementation OrderHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6*SCALE)];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineView];

        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, 13*SCALE, 26*SCALE, 26*SCALE)];
        _imageView.image = [UIImage imageNamed:@"order_logo"];
        [self addSubview:_imageView];

        _title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)+5*SCALE, 13*SCALE, 200*SCALE, 26*SCALE)];
        _title.textColor = [UIColor darkGrayColor];
        _title.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_title];

        _status = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10*SCALE-80*SCALE, 13*SCALE, 80*SCALE, 26*SCALE)];
        _status.textColor = MAIN_COLOR;
        _status.font = [UIFont systemFontOfSize:13*SCALE];
        _status.textAlignment = NSTextAlignmentRight;
        [self addSubview:_status];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
