//
//  SYCalendarView.h
//  Seeyou
//
//  Created by upin on 13-10-22.
//  Copyright (c) 2013年 linggan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCalendarDefine.h"

@class LKCalendarView;
@class LKCalendarMonth;

@protocol LKCalendarViewDelegate <NSObject>
@optional
-(void)calendarView:(LKCalendarView*)sender showHeight:(float)height;
-(void)calendarViewDidChangedMonth:(LKCalendarView*)sender;
@end

@interface LKCalendarView : UIView

@property(weak,nonatomic)id<LKCalendarViewDelegate> delegate;

@property(strong,nonatomic)UIScrollView* scrollView;

@property(strong,nonatomic)LKCalendarMonth* leftMonth;
@property(strong,nonatomic)LKCalendarMonth* centerMonth;
@property(strong,nonatomic)LKCalendarMonth* rightMonth;

-(void)reloadViewDate;
-(void)refreshView;

-(void)startLoadingView;

@property(strong,nonatomic)NSDateComponents* currentDateComponents;
-(void)setCurrentDateComponents:(NSDateComponents *)com animation:(BOOL)animation;
-(id)moveToDate:(NSDate*)date;

-(void)checkViewHeight;
@end
