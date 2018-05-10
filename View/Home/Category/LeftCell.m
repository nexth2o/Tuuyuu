//
//  LeftCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/6/1.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "LeftCell.h"

@implementation LeftCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _leftTitle = [[UILabel alloc] initWithFrame:CGRectMake(9*SCALE, 0*SCALE, 67*SCALE, 47*SCALE)];
        _leftTitle.textColor = MAIN_TEXT_COLOR;
        _leftTitle.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_leftTitle];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 45*SCALE-1, 80*SCALE, 1)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:line];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

@end
