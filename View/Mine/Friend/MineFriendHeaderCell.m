//
//  MineFriendHeaderCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/27.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "MineFriendHeaderCell.h"

@implementation MineFriendHeaderCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -150*SCALE)/2, 50*SCALE, 150*SCALE, 150*SCALE)];
        
        if ([[[UserDefaults service] getGender] isEqualToString:@"1"]) {
            _icon.image = [UIImage imageNamed:@"test_head"];
        }else {
            _icon.image = [UIImage imageNamed:@"test_head2"];
        }
        
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = _icon.frame.size.width / 2;
        [self addSubview:_icon];
        
        //姓名
        _name = [[UILabel alloc] initWithFrame:CGRectMake(90*SCALE, CGRectGetMaxY(_icon.frame)+10*SCALE, 80*SCALE, 20*SCALE)];
        _name.textAlignment = NSTextAlignmentRight;
        _name.textColor = [UIColor darkGrayColor];
        _name.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_name];
        
        _gradeImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_name.frame)+10*SCALE, CGRectGetMaxY(_icon.frame)+10*SCALE, 20*SCALE, 20*SCALE)];
        [self addSubview:_gradeImage];
        
        //等级
        _grade = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_name.frame)+30*SCALE, CGRectGetMaxY(_icon.frame)+10*SCALE, 60*SCALE, 20*SCALE)];
        _grade.textColor = [UIColor darkGrayColor];
        _grade.font = [UIFont systemFontOfSize:13*SCALE];
        [self addSubview:_grade];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

@end
