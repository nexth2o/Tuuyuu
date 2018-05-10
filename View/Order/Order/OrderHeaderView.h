//
//  OrderHeaderView.h
//  Tuuyuu
//
//  Created by WishU on 2017/6/13.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface OrderHeaderView : UITableViewHeaderFooterView

@property NSUInteger section;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *status;


@end
