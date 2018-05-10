//
//  SubmitOrderFooterCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/23.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "SubmitOrderFooterCell.h"

@implementation SubmitOrderFooterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //60
        _title = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE, 0*SCALE, 250*SCALE, 40*SCALE)];
        _title.text = [NSString stringWithFormat:@"支付方式"];
        _title.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_title];
        
        _subTitle = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 190*SCALE, 0*SCALE, 150*SCALE, 40*SCALE)];
        _subTitle.text = [NSString stringWithFormat:@"在线支付"];
        _subTitle.textAlignment = NSTextAlignmentRight;
        _subTitle.textColor = [UIColor darkGrayColor];
        _subTitle.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_subTitle];
        
        
        _switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 61*SCALE, 5*SCALE, 51*SCALE, 31*SCALE)];
        [_switchBtn setOnTintColor:ICON_COLOR];
        _switchBtn.transform = CGAffineTransformMakeScale( 0.8, 0.8);//缩放
        [_switchBtn addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_switchBtn];
        
        
    }
    return self;
    
}

- (void)switchAction {
    self.switchActionBlock();
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
