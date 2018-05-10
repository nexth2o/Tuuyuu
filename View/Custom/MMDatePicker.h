//
//  MMDatePickerView.h
//  Tuuyuu
//
//  Created by WishU on 2017/5/19.
//  Copyright © 2017年 WishU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMDatePicker;

@protocol MMDatePickerDelegate <NSObject>

-(void)didPressDismissButtonOfDatePicker:(MMDatePicker*)datePicker;
-(void)datePicker:(MMDatePicker*)datePicker didSelectDate:(NSDate*)date;

@end

@interface MMDatePicker : UIView

@property(nonatomic, strong) NSString *cancelTitleButton;
@property(nonatomic, strong) NSString *acceptTitleButton;
@property(nonatomic, strong) UIFont *toolBarFont;

@property(nonatomic, assign) UIBarStyle toolBarStyle;
@property(nonatomic, strong) UIDatePicker *datePicker;

@property(nonatomic, assign) IBOutlet id<MMDatePickerDelegate>delegate;

- (id)initAtPosition:(CGPoint)origin;

@end
