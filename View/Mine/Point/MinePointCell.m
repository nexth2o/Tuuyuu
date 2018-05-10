//
//  MinePointCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/28.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "MinePointCell.h"

@implementation MinePointCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = UIColorFromRGB(255,247,226);
        
        //类型
        _title = [[UILabel alloc] initWithFrame:CGRectMake(20*SCALE, 10*SCALE, 200*SCALE, 20*SCALE)];
        _title.text = @"兔币退款";
        _title.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_title];
        
        _gradeImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-130*SCALE, CGRectGetMaxY(_title.frame)+0*SCALE, 20*SCALE, 20*SCALE)];
        [self addSubview:_gradeImage];
        
        _grageLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-105*SCALE, CGRectGetMaxY(_title.frame)+0*SCALE, 50*SCALE, 20*SCALE)];
        _grageLabel.textColor = [UIColor darkGrayColor];
        _grageLabel.font = [UIFont systemFontOfSize:12*SCALE];
        [self addSubview:_grageLabel];
         
         _radixImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50*SCALE, CGRectGetMaxY(_title.frame)+2*SCALE, 16*SCALE, 16*SCALE)];
        _radixImage.image = [UIImage imageNamed:@"mine_radix"];
         [self addSubview:_radixImage];
        
        _radix = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30*SCALE, CGRectGetMaxY(_title.frame)+0*SCALE, 20*SCALE, 20*SCALE)];
        _radix.textColor = [UIColor darkGrayColor];
        _radix.font = [UIFont systemFontOfSize:12*SCALE];
        [self addSubview:_radix];
        
        _detail = [[UILabel alloc] initWithFrame:CGRectMake(20*SCALE, CGRectGetMaxY(_title.frame)+20*SCALE, 100*SCALE, 20*SCALE)];
        _detail.textColor = [UIColor darkGrayColor];
        _detail.font = [UIFont systemFontOfSize:12*SCALE];
        [self addSubview:_detail];
        
        _info = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_detail.frame)+40*SCALE, CGRectGetMaxY(_title.frame)+20*SCALE, 120*SCALE, 20*SCALE)];
        _info.textAlignment = NSTextAlignmentRight;
        _info.textColor = [UIColor darkGrayColor];
        _info.font = [UIFont systemFontOfSize:12*SCALE];
        [self addSubview:_info];
        
        _subTitle = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100*SCALE, 10*SCALE, 90*SCALE, 20*SCALE)];
        _subTitle.textAlignment = NSTextAlignmentRight;
        _subTitle.textColor = MAIN_COLOR;
        _subTitle.font = [UIFont boldSystemFontOfSize:15*SCALE];
        [self addSubview:_subTitle];
        
        _time = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100*SCALE, CGRectGetMaxY(_title.frame)+20*SCALE, 80*SCALE, 20*SCALE)];
        _time.textAlignment = NSTextAlignmentRight;
        _time.textColor = [UIColor darkGrayColor];
        _time.font = [UIFont systemFontOfSize:12*SCALE];
        [self addSubview:_time];
        
    }
    
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
}

@end
