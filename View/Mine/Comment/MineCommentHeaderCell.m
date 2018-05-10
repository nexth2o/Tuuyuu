//
//  MineCommentHeaderCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/26.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "MineCommentHeaderCell.h"

@implementation MineCommentHeaderCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //cell 150
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150*SCALE)];
        bg.image = [UIImage imageNamed:@"mine_comment_header"];
        [self addSubview:bg];
        
        //头像
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH- 70*SCALE)/2, 20*SCALE, 70*SCALE, 70*SCALE)];
        
        if ([[[UserDefaults service] getGender] isEqualToString:@"1"]) {
            icon.image = [UIImage imageNamed:@"test_head"];
        }else {
            icon.image = [UIImage imageNamed:@"test_head2"];
        }
        [self addSubview:icon];
        
        //姓名
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0*SCALE, CGRectGetMaxY(icon.frame)+5*SCALE, SCREEN_WIDTH, 20*SCALE)];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [UIFont systemFontOfSize:15*SCALE];
        [self addSubview:_title];
        
        _subTitle = [[UILabel alloc] initWithFrame:CGRectMake(0*SCALE, CGRectGetMaxY(_title.frame)+0*SCALE, SCREEN_WIDTH, 20*SCALE)];
        _subTitle.textAlignment = NSTextAlignmentCenter;
        _subTitle.textColor = [UIColor darkGrayColor];
        _subTitle.font = [UIFont systemFontOfSize:12*SCALE];
        [self addSubview:_subTitle];
        
    }
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
}

@end
