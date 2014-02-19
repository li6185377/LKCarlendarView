//
//  SYCalendarView.m
//  Seeyou
//
//  Created by upin on 13-10-22.
//  Copyright (c) 2013年 linggan. All rights reserved.
//

#import "LKCalendarView.h"

@interface LKCalendarView()<UIScrollViewDelegate>
{
    int currentShowRowCount;
    NSDateComponents* tempDateComponents;
}
@end

@implementation LKCalendarView
@synthesize currentDateComponents = _currentDateComponents;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self initViews];
    }
    return self;
}
-(void)initViews
{
    CGRect bounds = self.bounds;
    self.scrollView = [[UIScrollView alloc]initWithFrame:bounds];
    _scrollView.bounces =NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.contentSize = CGSizeMake(3*bounds.size.width,0);
    [self addSubview:_scrollView];
    
    
    self.leftMonth = [[LKCalendarMonth alloc]initWithFrame:bounds];
    [_scrollView addSubview:_leftMonth];
    
    self.centerMonth = [[LKCalendarMonth alloc]initWithFrame:CGRectMake(bounds.size.width, 0, bounds.size.width, bounds.size.height)];
    [_scrollView addSubview:_centerMonth];
    
    self.rightMonth = [[LKCalendarMonth alloc]initWithFrame:CGRectMake(2*bounds.size.width, 0, bounds.size.width, bounds.size.height)];
    [_scrollView addSubview:_rightMonth];
    
    [_scrollView setContentOffset:CGPointMake(bounds.size.width, 0) animated:NO];
}

-(void)setDelegate:(id<LKCalendarViewDelegate>)delegate
{
    _delegate = delegate;
    if([_delegate conformsToProtocol:@protocol(LKCalendarMonthDelegate)])
    {
        _leftMonth.delegate  = (id)_delegate;
        _centerMonth.delegate = (id)_delegate;
        _rightMonth.delegate = (id)_delegate;
    }
}

-(void)startLoadingView
{
    [self.centerMonth startLoadingView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.leftMonth startLoadingView];
        [self.rightMonth startLoadingView];
        
        if(tempDateComponents)
        {
            self.currentDateComponents = tempDateComponents;
            tempDateComponents = nil;
        }
        else if (self.currentDateComponents == nil) {
            self.currentDateComponents = [currentLKCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:[NSDate date]];
        }
    });
}
-(void)reloadViewDate
{
    [self.centerMonth reloadMonthViewDate];
    dispatch_async(dispatch_get_main_queue(),^{
        [self.leftMonth reloadMonthViewDate];
        [self.rightMonth reloadMonthViewDate];
    });
}
-(void)refreshView
{
    [self.centerMonth refreshMonthView];
    dispatch_async(dispatch_get_main_queue(),^{
        [self.leftMonth refreshMonthView];
        [self.rightMonth refreshMonthView];
    });
}
#pragma mark- 当前显示的时间点
-(NSDateComponents *)currentDateComponents
{
    if (tempDateComponents) {
        return tempDateComponents;
    }
    return _currentDateComponents;
}
-(void)setCurrentDateComponents:(NSDateComponents *)com
{
    [self setCurrentDateComponents:com animation:NO];
}
-(void)setCurrentDateComponents:(NSDateComponents *)com animation:(BOOL)animation
{
    if(com == nil || _rightMonth.contentView == nil)
    {
        tempDateComponents = [com copy];
        return;
    }
    tempDateComponents = nil;
    if(com.month > 12 || com.month < 1)
    {
        NSDate* date = [currentLKCalendar dateFromComponents:com];
        com = [currentLKCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:date];
    }
    if(_currentDateComponents != nil)
    {
        int monthdiff = monthDiffWithDateComponents(_currentDateComponents,com);
        if(monthdiff==0)
            return;
        
        int contentOffsetX = 320;
        if(monthdiff > 0)
        {
            self.rightMonth.currentMonth = com;
            contentOffsetX = 2*_scrollView.bounds.size.width;
        }
        else if(monthdiff < 0)
        {
            self.leftMonth.currentMonth = com;
            contentOffsetX = 0;
        }
        
        _currentDateComponents = [com copy];
        [_scrollView setContentOffset:CGPointMake(contentOffsetX, 0) animated:animation];
        if(animation == NO)
        {
            [self resetLRCalendarView];
        }
        else
        {
            double delayInSeconds = 0.3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self resetLRCalendarView];
            });
        }
        
    }
    else
    {
        _currentDateComponents = [com copy];
        self.centerMonth.currentMonth = com;
        
        com.month -= 1;
        self.leftMonth.currentMonth = com;
        
        com.month +=2;
        self.rightMonth.currentMonth = com;
        
        [self checkViewHeight];
    }
}

#pragma mark- scrollView delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int x = _scrollView.contentOffset.x;
    int sw = _scrollView.bounds.size.width;
    if(x==sw)
        return;
    
    NSDateComponents* com = [_currentDateComponents copy];
    if( x == 0)
    {
        com.month -= 1;
    }
    else if(x ==  2*sw )
    {
        com.month += 1;
    }
    if(com.month > 12 || com.month < 1)
    {
        NSDate* date = [currentLKCalendar dateFromComponents:com];
        com = [currentLKCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:date];
    }
    _currentDateComponents = com;
    [self resetLRCalendarView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate==NO)
    {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

#pragma mark - 重置View 的位置
-(void)resetLRCalendarView
{
    int x = _scrollView.contentOffset.x;
    int sw = _scrollView.bounds.size.width;
    
    if( x == 0)
    {
        id tmp = self.rightMonth;
        self.rightMonth = self.centerMonth;
        self.centerMonth = self.leftMonth;
        self.leftMonth = tmp;
    }
    else if(x ==  2*sw )
    {
        id tmp = self.leftMonth;
        self.leftMonth = self.centerMonth;
        self.centerMonth = self.rightMonth;
        self.rightMonth = tmp;
    }
    CGRect frame = self.leftMonth.frame;
    frame.origin.x = 0;
    self.leftMonth.frame = frame;
    
    frame = self.centerMonth.frame;
    frame.origin.x = sw;
    self.centerMonth.frame = frame;
    
    frame = self.rightMonth.frame;
    frame.origin.x = sw*2;
    self.rightMonth.frame = frame;
    
    self.scrollView.contentOffset = CGPointMake(sw, 0);
    
    NSDateComponents* com = [_currentDateComponents copy];
    com.month -= 1;
    _leftMonth.currentMonth = com;
    
    com.month += 2;
    _rightMonth.currentMonth = com;
    
    
    if([self.delegate respondsToSelector:@selector(calendarViewDidChangedMonth:)])
    {
        [self.delegate calendarViewDidChangedMonth:self];
    }
    
    [self checkViewHeight];
}
-(void)checkViewHeight
{
    int checkShowRow =  [self.centerMonth getValidRow];
    if(checkShowRow == currentShowRowCount)
    {
        return;
    }
    currentShowRowCount = checkShowRow;
    
    float height = 0;
    
    height = (SYCC_DayHeight*currentShowRowCount + SYCC_DayOffsetHeight*(currentShowRowCount+1));

    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.size.height = height;
        self.frame = frame;
    }];
    if([self.delegate respondsToSelector:@selector(calendarView:showHeight:)])
    {
        [self.delegate calendarView:self showHeight:height];
    }
}
#pragma mark- move to date
-(id)moveToDate:(NSDate *)date
{
    NSDateComponents* com = [currentLKCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    int monthdiff = monthDiffWithDateComponents(_currentDateComponents,com);
    
    [self setCurrentDateComponents:com animation:YES];
    
    date = [currentLKCalendar dateFromComponents:com];
    
    id dayview = nil;
    LKCalendarMonth* monthView = nil;
    if(monthdiff > 0)
    {
        monthView = self.rightMonth;
    }
    else if(monthdiff < 0)
    {
        monthView = self.leftMonth;
    }
    else
    {
        monthView = self.centerMonth;
    }
    int  index = [monthView.dates indexOfObject:date];
    dayview = [monthView.dayViews objectAtIndex:index];
    
    return dayview;
}

@end
