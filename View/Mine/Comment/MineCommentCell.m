//
//  MineCommentCell.m
//  Tuuyuu
//
//  Created by WishU on 2017/7/26.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import "MineCommentCell.h"

@implementation MineCommentCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //cell 180
        
        //店铺区 40
        //店铺头像
        UIImageView *storeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, 10*SCALE, 20*SCALE, 20*SCALE)];
        storeIcon.image = [UIImage imageNamed:@"order_logo"];
        [self addSubview:storeIcon];
        
        //店铺名称
        _storeName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(storeIcon.frame)+10*SCALE, 10*SCALE, 100*SCALE, 20*SCALE)];
        _storeName.font = [UIFont systemFontOfSize:14*SCALE];
        _storeName.textColor = [UIColor darkGrayColor];
        [self addSubview:_storeName];

        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 39*SCALE, SCREEN_WIDTH, 1)];
        line1.backgroundColor = UIColorFromRGB(244, 244, 244);
        [self addSubview:line1];
        
        //用户评价区 90
        _userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, CGRectGetMaxY(line1.frame) +10*SCALE, 40*SCALE, 40*SCALE)];
        
        if ([[[UserDefaults service] getGender] isEqualToString:@"1"]) {
            _userIcon.image = [UIImage imageNamed:@"test_head"];
        }else {
            _userIcon.image = [UIImage imageNamed:@"test_head2"];
        }
        
        [self addSubview:_userIcon];
        
        //姓名
        _name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userIcon.frame)+10*SCALE, _userIcon.frame.origin.y+0*SCALE, 150*SCALE, 20*SCALE)];
        _name.font = [UIFont systemFontOfSize:14*SCALE];
        [self addSubview:_name];
        
        //时间
        _time = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-(80+10)*SCALE, _userIcon.frame.origin.y+0*SCALE, 80*SCALE, 20*SCALE)];
        _time.textAlignment = NSTextAlignmentRight;
        _time.textColor = [UIColor darkGrayColor];
        _time.font = [UIFont systemFontOfSize:12*SCALE];
        [self addSubview:_time];
        
        
        //商家
        _storeTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userIcon.frame)+10*SCALE, CGRectGetMaxY(_name.frame)+5*SCALE, 30*SCALE, 20*SCALE)];
        _storeTitle.text = @"商家:";
        _storeTitle.textColor = [UIColor darkGrayColor];
        _storeTitle.font = [UIFont systemFontOfSize:12*SCALE];
        [self addSubview:_storeTitle];
        
        _star1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_storeTitle.frame)+5*SCALE, CGRectGetMaxY(_name.frame)+10*SCALE, 8*SCALE, 8*SCALE)];
        _star1.image = [UIImage imageNamed:@"score_star_yellow"];
        [self addSubview:_star1];
        
        _star2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_star1.frame)+5*SCALE, CGRectGetMaxY(_name.frame)+10*SCALE, 8*SCALE, 8*SCALE)];
        _star2.image = [UIImage imageNamed:@"score_star_yellow"];
        [self addSubview:_star2];
        
        _star3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_star2.frame)+5*SCALE, CGRectGetMaxY(_name.frame)+10*SCALE, 8*SCALE, 8*SCALE)];
        _star3.image = [UIImage imageNamed:@"score_star_yellow"];
        [self addSubview:_star3];
        
        _star4 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_star3.frame)+5*SCALE, CGRectGetMaxY(_name.frame)+10*SCALE, 8*SCALE, 8*SCALE)];
        _star4.image = [UIImage imageNamed:@"score_star_yellow"];
        [self addSubview:_star4];
        
        _star5 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_star4.frame)+5*SCALE, CGRectGetMaxY(_name.frame)+10*SCALE, 8*SCALE, 8*SCALE)];
        _star5.image = [UIImage imageNamed:@"score_star_yellow"];
        [self addSubview:_star5];
        
        
        UILabel *_staffTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_star5.frame)+20*SCALE, CGRectGetMaxY(_name.frame)+5*SCALE, 30*SCALE, 20*SCALE)];
        _staffTitle.text = @"骑手:";
        _staffTitle.textColor = [UIColor darkGrayColor];
        _staffTitle.font = [UIFont systemFontOfSize:12*SCALE];
        //        _storeTitle.backgroundColor = [UIColor greenColor];
        [self addSubview:_staffTitle];
        
        _staffStar1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_staffTitle.frame)+5*SCALE, CGRectGetMaxY(_name.frame)+10*SCALE, 8*SCALE, 8*SCALE)];
        _staffStar1.image = [UIImage imageNamed:@"score_star_yellow"];
        [self addSubview:_staffStar1];
        
        _staffStar2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_staffStar1.frame)+5*SCALE, CGRectGetMaxY(_name.frame)+10*SCALE, 8*SCALE, 8*SCALE)];
        _staffStar2.image = [UIImage imageNamed:@"score_star_yellow"];
        [self addSubview:_staffStar2];
        
        _staffStar3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_staffStar2.frame)+5*SCALE, CGRectGetMaxY(_name.frame)+10*SCALE, 8*SCALE, 8*SCALE)];
        _staffStar3.image = [UIImage imageNamed:@"score_star_yellow"];
        [self addSubview:_staffStar3];
        
        _staffStar4 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_staffStar3.frame)+5*SCALE, CGRectGetMaxY(_name.frame)+10*SCALE, 8*SCALE, 8*SCALE)];
        _staffStar4.image = [UIImage imageNamed:@"score_star_yellow"];
        [self addSubview:_staffStar4];
        
        _staffStar5 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_staffStar4.frame)+5*SCALE, CGRectGetMaxY(_name.frame)+10*SCALE, 8*SCALE, 8*SCALE)];
        _staffStar5.image = [UIImage imageNamed:@"score_star_yellow"];
        [self addSubview:_staffStar5];
        
        
        
        
        
        
        _type2 = [[UILabel alloc] init];
        _type2.textColor = [UIColor darkGrayColor];
        _type2.font = [UIFont systemFontOfSize:12*SCALE];
        _type2.backgroundColor = UIColorFromRGB(244, 244, 244);
        _type2.numberOfLines = 0 ;
        
        [self addSubview:_type2];
        
        //兔悠专送
        _type = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userIcon.frame)+10*SCALE, CGRectGetMaxY(_storeTitle.frame)+0*SCALE, 260*SCALE, 60*SCALE)];
        _type.text = @"兔悠专送 21分钟送达";
        _type.numberOfLines = 4;
        _type.textColor = [UIColor darkGrayColor];
        _type.font = [UIFont systemFontOfSize:12*SCALE];
        _type.backgroundColor = [UIColor whiteColor];
        [self addSubview:_type];
        
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = UIColorFromRGB(244, 244, 244);
        [self addSubview:_line2];
        
        //分享
        _shareIcon = [[UIImageView alloc] init];
        _shareIcon.image = [UIImage imageNamed:@"mine_comment_share"];
        [self addSubview:_shareIcon];
        
        _shareLabel = [[UILabel alloc] init];
        _shareLabel.font = [UIFont systemFontOfSize:12*SCALE];
        _shareLabel.textColor = [UIColor darkGrayColor];
        _shareLabel.text = @"分享";
        [self addSubview:_shareLabel];
        
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_shareBtn addTarget:self action:@selector(shareBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_shareBtn];
        
        
        
        //删除
        _deleteIcon = [[UIImageView alloc] init];
        _deleteIcon.image = [UIImage imageNamed:@"mine_comment_delete"];
        [self addSubview:_deleteIcon];
        
        _deleteLabel = [[UILabel alloc] init];
        _deleteLabel.font = [UIFont systemFontOfSize:12*SCALE];
        _deleteLabel.textColor = [UIColor darkGrayColor];
        _deleteLabel.text = @"删除";
        [self addSubview:_deleteLabel];
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteBtn];
        
        _line3 = [[UIView alloc] init];
        _line3.backgroundColor = UIColorFromRGB(244, 244, 244);
        [self addSubview:_line3];
        
        
        
    }
    
    return self;
}

- (void)shareBtn:(id)sender {
    self.shareBtnBlock();
}

- (void)deleteBtn:(id)sender {
    self.deleteBtnBlock();
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_line2 setFrame:CGRectMake(0, CGRectGetMaxY(_type2.frame)+5*SCALE, SCREEN_WIDTH, 1)];
    
    [_shareIcon setFrame:CGRectMake(SCREEN_WIDTH-10*SCALE-80*SCALE-80*SCALE, CGRectGetMaxY(_line2.frame)+0*SCALE, 40*SCALE, 40*SCALE)];

    [_shareLabel setFrame:CGRectMake(SCREEN_WIDTH-10*SCALE-40*SCALE-80*SCALE, CGRectGetMaxY(_line2.frame)+0*SCALE, 40*SCALE, 40*SCALE)];
    
    [_shareBtn setFrame:CGRectMake(SCREEN_WIDTH-10*SCALE-80*SCALE-80*SCALE, CGRectGetMaxY(_line2.frame)+0*SCALE, 80*SCALE, 40*SCALE)];
    
    [_deleteIcon setFrame:CGRectMake(SCREEN_WIDTH-80*SCALE, CGRectGetMaxY(_line2.frame)+0*SCALE, 40*SCALE, 40*SCALE)];
    
    [_deleteLabel setFrame:CGRectMake(SCREEN_WIDTH-40*SCALE, CGRectGetMaxY(_line2.frame)+0*SCALE, 40*SCALE, 40*SCALE)];
    
    [_deleteBtn setFrame:CGRectMake(SCREEN_WIDTH-80*SCALE, CGRectGetMaxY(_line2.frame)+0*SCALE, 80*SCALE, 40*SCALE)];
    
    [_line3 setFrame:CGRectMake(0, CGRectGetMaxY(_line2.frame)+40*SCALE, SCREEN_WIDTH, 10*SCALE)];
}


@end
