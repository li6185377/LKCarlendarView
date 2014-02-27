LKCarlendarView
===============

simple and quick‘ calendar

把以前写的日历控件改了改，   大家可以看看  里面的时间处理方式  个人觉得  比github上面 的其他的算法简单多了

主要代码 我加了下注释

```objective-c
-(void)reloadMonthViewDate
{
    NSDateComponents* dateComponents = [_currentMonth copy];
    dateComponents.day = 1;
    
    //获得当前月的第一天时间
    NSDate* firstDay =  [currentLKCalendar dateFromComponents:dateComponents];
    
    //获得第一天 是周几
    int firstWeekDay = [currentLKCalendar components:NSWeekdayCalendarUnit fromDate:firstDay].weekday;
    
    //获取第一天 在日历中的位置。。     （根据你的设置去换算周几） :_firstDayWeek 是可设置的
    int firstDayPosition = (firstWeekDay - _firstDayWeek + 8)%8;
    
    //第一行第一天  跟  当前月第一天    的差距天数
    int dayDiff = 1 - firstDayPosition + 1;
    
    int size = _dayViews.count;
    NSMutableArray* dateArray = [NSMutableArray arrayWithCapacity:size];
    for (int i=0;i&lt;size; i++) {
        //剩下的简单了  将第一行第一天  不断的加一  然后 保存起来  就可以 获得整个月的 时间集合了
        dateComponents.day = dayDiff;
        NSDate* date = [currentLKCalendar dateFromComponents:dateComponents];
        [dateArray addObject:date];
        
        dayDiff ++;
    }
    [self.dates removeAllObjects];
    self.dates = [NSMutableArray arrayWithArray:dateArray];
    
    //有时间集合了 剩下的 就是显示了
    [self refreshMonthView];
}
```

加入了 随机  周几开始 

![](http://img.blog.csdn.net/20140227103454156?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGk2MTg1Mzc3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)
