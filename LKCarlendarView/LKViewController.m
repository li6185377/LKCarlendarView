//
//  LKViewController.m
//  LKCarlendarView
//
//  Created by ljh on 14-2-19.
//  Copyright (c) 2014年 LJH. All rights reserved.
//

#import "LKViewController.h"

#import "LKCalendarDefine.h"
@interface LKViewController ()<LKCalendarMonthDelegate,LKCalendarDayViewDelegate,LKCalendarViewDelegate>
@property(strong,nonatomic)LKCalendarView* calendarView;
@property(weak,nonatomic)LKCalendarDayView* lastSelectedDayView;

@property(strong,nonatomic)UILabel* lb_show;
@end

@implementation LKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.calendarView = [[LKCalendarView alloc]initWithFrame:CGRectMake(0, 50, 320, SYCC_MonthHeight)];
    _calendarView.backgroundColor = [UIColor grayColor];
    _calendarView.currentDateComponents = getYearMonthDateComponents([NSDate date]);
    [_calendarView startLoadingView];
    
    [self.view addSubview:_calendarView];
    
    _calendarView.delegate  = self;
    
    self.lb_show = [[UILabel alloc]initWithFrame:CGRectMake(0, SYCC_MonthHeight + 100, 320, 50)];
    _lb_show.font = [UIFont systemFontOfSize:24];
    _lb_show.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lb_show];

    [self calendarViewDidChangedMonth:_calendarView];
}
-(void)calendarViewDidChangedMonth:(LKCalendarView *)sender
{
    _lb_show.text = [NSString stringWithFormat:@"%d年%d月",sender.currentDateComponents.year,sender.currentDateComponents.month];
}
-(void)calendarMonth:(LKCalendarMonth *)month dayView:(LKCalendarDayView *)dayView date:(NSDate *)date
{
   int monthdiff = monthDiffWithDateComponents(month.currentMonth,getYearMonthDateComponents(date));
    dayView.date = date;
    dayView.lb_date.hidden = (monthdiff != 0);
}
-(void)calendarDayViewWillSelected:(LKCalendarDayView *)dayView
{
    if([_lastSelectedDayView isEqual:dayView])
        return;
    
    if(_lastSelectedDayView)
        _lastSelectedDayView.selected = NO;
    
    _lastSelectedDayView = dayView;
    
    int monthdiff = monthDiffWithDateComponents(_calendarView.currentDateComponents,getYearMonthDateComponents(dayView.date));
    if(monthdiff != 0)
    {
        dayView.selected = NO;
        LKCalendarDayView* selectedView = [_calendarView moveToDate:dayView.date];
        
        selectedView.selected = YES;
        _lastSelectedDayView = selectedView;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
