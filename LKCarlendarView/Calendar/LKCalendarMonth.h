//
//  SYCalendarMonth.h
//  Seeyou
//
//  Created by upin on 13-10-22.
//  Copyright (c) 2013年 linggan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCalendarDefine.h"

@class LKCalendarMonth;
@protocol LKCalendarMonthDelegate <NSObject>
@optional
-(void)calendarMonthDidReload:(LKCalendarMonth*)month;
-(UIView*)calendarMonth:(LKCalendarMonth*)month createDayViewWithFrame:(CGRect)frame;
-(void)calendarMonth:(LKCalendarMonth*)month dayView:(UIView*)dayView date:(NSDate*)date;
-(void)calendarMonthRefreshView:(LKCalendarMonth*)month;
@end

@interface LKCalendarMonth : UIView
//日历第一天是周几
@property int firstDayWeek;//0:周日 1:周1 2:周2 ...  6:周6

@property(strong,nonatomic)NSDateComponents* currentMonth;

@property(strong,nonatomic)UIView* contentView;
@property(strong,nonatomic)NSMutableArray* dayViews;
@property(strong,nonatomic)NSMutableArray* dates;

//返回有效的行数
-(int)getValidRow;

-(void)startLoadingView;

-(void)reloadMonthViewDate;
-(void)refreshMonthView;

@property(weak,nonatomic)id<LKCalendarMonthDelegate> delegate;

-(id)dayViewWithDate:(NSDate*)date;
@end