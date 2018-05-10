//
//  StoreSalesCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/19.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "StoreSalesCell.h"

@implementation StoreSalesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //促销区区 高度20
        //图标
        _salesImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20*SCALE, 3*SCALE, 14*SCALE, 14*SCALE)];
        [self addSubview:_salesImageView];
        
        //促销说明
        _salesText = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_salesImageView.frame)+5*SCALE, 0*SCALE, SCREEN_WIDTH-127*SCALE, 20*SCALE)];
        _salesText.textColor = [UIColor whiteColor];
        [_salesText setFont:[UIFont systemFontOfSize:8*SCALE]];
        _salesText.numberOfLines = 2;
        [self addSubview:_salesText];
        
        _open = [UIButton buttonWithType:UIButtonTypeCustom];
        [_open setFrame:CGRectMake(SCREEN_WIDTH -100*SCALE, 0, 85*SCALE, 25*SCALE)];
        [_open setBackgroundImage:[UIImage imageNamed:@"sales_down"] forState:UIControlStateNormal];
        
        [_open addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
        [_open setHidden:YES];
        [self addSubview:_open];
        
        //等2个活动
        _salesEtc = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100*SCALE, 3*SCALE, 60*SCALE, 14*SCALE)];
        _salesEtc.textColor = [UIColor whiteColor];
        _salesEtc.textAlignment = NSTextAlignmentRight;
        [_salesEtc setFont:[UIFont systemFontOfSize:10*SCALE]];
        [self addSubview:_salesEtc];
        
        _storeSalesArray = [NSMutableArray array];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)open:(id)sender {
    self.openBlock();
}

@end
