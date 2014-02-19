//
//  SYCalendarDayView.h
//  Seeyou
//
//  Created by upin on 13-10-22.
//  Copyright (c) 2013年 linggan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKCalendarDayView;
@protocol LKCalendarDayViewDelegate <NSObject>
@optional
-(void)calendarDayViewWillSelected:(LKCalendarDayView*)dayView;
@end

@interface LKCalendarDayView : UIView

@property(weak,nonatomic)id<LKCalendarDayViewDelegate>delegate;

@property(nonatomic,getter = isSelected) BOOL selected;
@property(strong,nonatomic)NSDate* date;

@property(strong,nonatomic)UILabel* lb_date;
@property(strong,nonatomic)UIImageView* backgroupView;
@end