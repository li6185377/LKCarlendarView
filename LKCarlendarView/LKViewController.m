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
@property(strong,nonatomic)UIView* weekNameView;
@end

@implementation LKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.weekNameView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 320, 30)];
    [self.view addSubview:_weekNameView];
    
    self.calendarView = [[LKCalendarView alloc]initWithFrame:CGRectMake(0, 50, 320, SYCC_MonthHeight)];
    
    [self createWeekName:(arc4random()%7)];
    
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

-(void)createWeekName:(int)tag
{
    NSMutableArray* array = [NSMutableArray arrayWithArray:@[@"日",@"一",@"二",@"三",@"四",@"五",@"六"]];

    NSMutableArray* showArray = [NSMutableArray array];
    int index = tag;
    while (showArray.count<7) {
        [showArray addObject:[array objectAtIndex:index%7]];
        index ++;
    }
    
    while (_weekNameView.subviews.count) {
        [[_weekNameView.subviews objectAtIndex:0] removeFromSuperview];
    }
    
    _calendarView.leftMonth.firstDayWeek = tag;
    _calendarView.centerMonth.firstDayWeek = tag;
    _calendarView.rightMonth.firstDayWeek = tag;
    
    int i =0;
    for (NSString* title in showArray) {
        UILabel* lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20,14)];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.center = CGPointMake(SYCC_DayOffsetWidth + (SYCC_DayOffsetWidth+SYCC_DayWidth)*i  + SYCC_DayWidth/2, 30/2) ;
        lb.backgroundColor = [UIColor clearColor];
        lb.font = [UIFont systemFontOfSize:12];
        if([title isEqualToString:@"六"] || [title isEqualToString:@"日"])
        {
            lb.textColor = [UIColor redColor];
        }
        else
        {
            lb.textColor = [UIColor blackColor];
        }
        lb.text = title;
        [_weekNameView addSubview:lb];
        i++;
    }
}

-(void)calendarViewDidChangedMonth:(LKCalendarView *)sender
{
    _lb_show.text = [NSString stringWithFormat:@"%d年%d月",sender.currentDateComponents.year,sender.currentDateComponents.month];
}
-(void)calendarMonth:(LKCalendarMonth *)month dayView:(LKCalendarDayView *)dayView date:(NSDate *)date
{
   int monthdiff = monthDiffWithDateComponents(month.currentMonth,getYearMonthDateComponents(date));
    dayView.backgroundColor = [UIColor grayColor];
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
