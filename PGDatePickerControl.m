//
//  NSDatePickerView.m
//  MYDatePicker
//
//  Created by ianc-ios on 15/12/22.
//  Copyright © 2015年 彭雄辉10/9. All rights reserved.
//

#import "PGDatePickerControl.h"
#import "PGCyleScrollView.h"
#import "NSDate+PG.h"

#define baseTag 111
#define COLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define SCROLLVIEW_HEIGHT 223
#define SCROLLVIEW_WIDTH (self.datePickerMode == UIPGDatePickerModeDate ? 290.0/3.0 :(self.datePickerMode == UIPGDatePickerModeDateMonth ? 290.0/2.0 :290))

@interface PGDatePickerControl()<PGCyleScrollViewDataSource,PGCyleScrollViewDelegate>{
    UIView *timeBroadcastView;
    PGCyleScrollView *yearScrollView;
    PGCyleScrollView *monthScrollView;
    PGCyleScrollView *dayScrollView;
    PGCyleScrollView *weekScrollView;
    NSDateFormatter *dateFormatter;
    NSArray *weeksOfYearStrArray;
    NSArray *weeksLastDayOfYeaerArray;
}

@end

@implementation PGDatePickerControl

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}
//选择器上面的 YYYY年MM月DD日。将选择的时间转换成需要的格式显示。
-(NSString *)selectDateStr{
    switch (self.datePickerMode) {
        case UIPGDatePickerModeDate:
        {
            dateFormatter.dateFormat = @"yyyy年MM月dd日";
            NSString *dateStr = [dateFormatter stringFromDate:self.selecteDate];
            NSString *weekdayStr = [NSDate dateToWeekDay:self.selecteDate];
            dateStr = [dateStr stringByAppendingString:weekdayStr];
            dateFormatter.dateFormat = @"yyyyMMdd";
            return dateStr;
        }
            break;
        case UIPGDatePickerModeDateMonth:
        {
            dateFormatter.dateFormat = @"yyyy年MM月";
            NSString *dateStr = [dateFormatter stringFromDate:self.selecteDate];
            dateFormatter.dateFormat = @"yyyyMM";
            return dateStr;
        }
            break;
        case UIPGDatePickerModeDateWeekOfYear:
        {
            
        }break;
            
        default:
            break;
    }
    return @"";
}

-(void)show{
    [self setTimeBroadCaseView];
}

#pragma mark - Custom picker
//设置定义的datepicker界面。
-(void)setTimeBroadCaseView{
    
    timeBroadcastView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 290, 223)];
    [timeBroadcastView setBackgroundColor:COLOR(249, 249, 249, 1)];
    [self addSubview:timeBroadcastView];
    
    UIView *leftTimeBroadCastViewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 223)];
    leftTimeBroadCastViewLine.backgroundColor = COLOR(207, 207, 207, 1);
    [timeBroadcastView addSubview:leftTimeBroadCastViewLine];
    
    UIView *middleSepView = [[UIView alloc]initWithFrame:CGRectMake(0, 87, 290, 48)];
    [middleSepView setBackgroundColor:COLOR(255.0, 255.0, 255.0, 1)];
    [timeBroadcastView addSubview:middleSepView];
    
    UIView *beforeSepLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 290, 1)];
    [beforeSepLine setBackgroundColor:COLOR(237, 237, 237, 1)];
    [middleSepView addSubview:beforeSepLine];
    
    UIView *bottomSepLine = [[UIView alloc]initWithFrame:CGRectMake(0, 48, 290, 1)];
    [bottomSepLine setBackgroundColor:COLOR(237, 237, 237, 1)];
    [middleSepView addSubview:bottomSepLine];
    
    UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 48)];
    leftLine.backgroundColor = COLOR(236, 103, 36, 1);
    [middleSepView addSubview:leftLine];
    self.selecteDate = self.date;
    switch (self.datePickerMode) {
        case UIPGDatePickerModeDate:
            [self layoutDateModeView:middleSepView];
            break;
        case UIPGDatePickerModeDateMonth:
            [self layoutDateMonthModeView:middleSepView];
            break;
        case UIPGDatePickerModeDateWeekOfYear:
            weeksOfYearStrArray = [NSDate getWeekOfYearStringArray];
            weeksLastDayOfYeaerArray = [NSDate getWeekLastDayOfYearArray];
            [self layoutDateWeekOfYearModeView:middleSepView];
            break;
        default:
            break;
    }
}
//布局年月日格式。
-(void)layoutDateModeView:(UIView *)middleSepView{
    UILabel *lblYear = [[UILabel alloc]initWithFrame:CGRectMake(75, 1, 290/3.0, 40)];
    lblYear.font = [UIFont systemFontOfSize:10];
    lblYear.textColor = COLOR(236, 103, 36, 1);
    lblYear.text = @"年";
    [middleSepView addSubview:lblYear];
    
    UILabel *lblMonth = [[UILabel alloc]initWithFrame:CGRectMake(290/3.0+60, 1, 290/3.0, 40)];
    lblMonth.font = [UIFont systemFontOfSize:10];
    lblMonth.textColor = COLOR(236, 103, 36, 1);
    lblMonth.text = @"月";
    [middleSepView addSubview:lblMonth];
    
    UILabel *lblDay = [[UILabel alloc]initWithFrame:CGRectMake(580/3.0+60, 1, 290/3.0,40)];
    lblDay.font = [UIFont systemFontOfSize:10];
    lblDay.textColor = COLOR(236, 103, 36, 1);
    lblDay.text = @"日";
    [middleSepView addSubview:lblDay];
    
    //右边、上边、下面。线条给timeBroadCastView.
    UIView *rightTimeBroadCastViewLine = [[UIView alloc]initWithFrame:CGRectMake(289, 0, 1, 223)];
    rightTimeBroadCastViewLine.backgroundColor = COLOR(207, 207, 207, 1);
    [timeBroadcastView addSubview:rightTimeBroadCastViewLine];
    
    UIView *topTimeBroadCastViewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 290, 1)];
    topTimeBroadCastViewLine.backgroundColor = COLOR(207, 207, 207, 1);
    [timeBroadcastView addSubview:topTimeBroadCastViewLine];
    
    UIView *bottomTimeBroadCastViewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 222, 290, 1)];
    bottomTimeBroadCastViewLine.backgroundColor = COLOR(207, 207, 207, 1);
    bottomTimeBroadCastViewLine.backgroundColor = COLOR(207, 207, 207,1);
    [timeBroadcastView addSubview:bottomTimeBroadCastViewLine];
    
    //年月日中间的线条。
    UIView *middleLeftLine = [[UIView alloc]initWithFrame:CGRectMake(290/3.0, 0, 1, 223)];
    middleLeftLine.backgroundColor = COLOR(207, 207, 207, 1);
    [timeBroadcastView addSubview:middleLeftLine];
    
    UIView *middleRightLine = [[UIView alloc]initWithFrame:CGRectMake(580/3.0, 0, 1, 223)];
    middleRightLine.backgroundColor = COLOR(207, 207, 207, 1);
    [timeBroadcastView addSubview:middleRightLine];
    
    dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    
    [self setYearScrollView];
    [self setMonthScrollView];
    [self setDayScrollView];
    
}
//dateMonthMode布局。年月。
-(void)layoutDateMonthModeView:(UIView *)middleSepView{
    UILabel *lblYear = [[UILabel alloc]initWithFrame:CGRectMake(100, 1, 290.0/2.0, 40)];
    lblYear.font = [UIFont systemFontOfSize:10];
    lblYear.textColor = COLOR(236, 103, 36, 1);
    lblYear.text = @"年";
    [middleSepView addSubview:lblYear];
    
    UILabel *lblMonth = [[UILabel alloc]initWithFrame:CGRectMake(290.0/2.0+85, 1, 290.0/2.0, 40)];
    lblMonth.font = [UIFont systemFontOfSize:10];
    lblMonth.textColor = COLOR(236, 103, 36, 1);
    lblMonth.text = @"月";
    [middleSepView addSubview:lblMonth];
    
    //线。
    UIView *rightTimeBroadCastViewLine = [[UIView alloc]initWithFrame:CGRectMake(289, 0, 1, 223)];
    rightTimeBroadCastViewLine.backgroundColor = COLOR(207, 207, 207, 1);
    [timeBroadcastView addSubview:rightTimeBroadCastViewLine];
    UIView *topTimeBroadcastViewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 1)];
    topTimeBroadcastViewLine.backgroundColor = COLOR(207, 207, 207, 207);
    [timeBroadcastView addSubview:topTimeBroadcastViewLine];
    UIView *bottomTimeBroadcastViewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 222, 290, 1)];
    bottomTimeBroadcastViewLine.backgroundColor = COLOR(207, 207, 207, 207);
    [timeBroadcastView addSubview:bottomTimeBroadcastViewLine];
    
    //中间的线
    UIView *middleTimeBroadcaseViewLine = [[UIView alloc] initWithFrame:CGRectMake(290.0/2.0-1, 0, 1, 223)];
    middleTimeBroadcaseViewLine.backgroundColor = COLOR(207, 207, 207, 207);
    [timeBroadcastView addSubview:middleTimeBroadcaseViewLine];
    
    dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyyMM";
    
    [self setYearScrollView];
    [self setMonthScrollView];
}

//DateWeekOfYearMode 的布局。
-(void)layoutDateWeekOfYearModeView:(UIView *)middleSepView{
    UIView *rightTimeBroadCastViewLine = [[UIView alloc]initWithFrame:CGRectMake(289, 0, 1, 223)];
    rightTimeBroadCastViewLine.backgroundColor = COLOR(207, 207, 207, 1);
    [timeBroadcastView addSubview:rightTimeBroadCastViewLine];
    
    UIView *topTimeBroadCastViewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 290, 1)];
    topTimeBroadCastViewLine.backgroundColor = COLOR(207, 207, 207, 1);
    [timeBroadcastView addSubview:topTimeBroadCastViewLine];
    
    UIView *bottomTimeBroadCastViewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 222, 290, 1)];
    bottomTimeBroadCastViewLine.backgroundColor = COLOR(207, 207, 207, 1);
    [timeBroadcastView addSubview:bottomTimeBroadCastViewLine];
    
    [self setWeekScrollView];
}

//设置滚动视图-----年
-(void)setYearScrollView{
    yearScrollView = [[PGCyleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
    
    NSInteger yearint = [self setNowTimeShow:0];
    yearScrollView.currentPage = yearint-2000;
    yearScrollView.delegate = self;
    yearScrollView.datasource = self;
    [self setAfterScrollShowView:yearScrollView andCurrentPage:3];
    yearScrollView.tag = baseTag + 0;
    [timeBroadcastView addSubview:yearScrollView];
}
//设置滚动视图-----月
-(void)setMonthScrollView{
    monthScrollView = [[PGCyleScrollView alloc]initWithFrame:CGRectMake(SCROLLVIEW_WIDTH, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
    NSInteger monthint = [self setNowTimeShow:1];
    monthScrollView.currentPage = monthint -1;
    monthScrollView.delegate = self;
    monthScrollView.datasource = self;
    [self setAfterScrollShowView:monthScrollView andCurrentPage:3];
    monthScrollView.tag = baseTag + 1;
    [timeBroadcastView addSubview:monthScrollView];
}
//设置滚动视图-----日
-(void)setDayScrollView{
    dayScrollView = [[PGCyleScrollView alloc]initWithFrame:CGRectMake(SCROLLVIEW_WIDTH *2, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
    NSInteger dayint = [self setNowTimeShow:2];
    dayScrollView.currentPage = dayint - 1;
    dayScrollView.delegate = self;
    dayScrollView.datasource = self;
    [self setAfterScrollShowView:dayScrollView andCurrentPage:3];
    dayScrollView.tag = baseTag + 2;
    [timeBroadcastView addSubview:dayScrollView];
}
//设置周日起的滚动图。
-(void)setWeekScrollView{
    weekScrollView = [[PGCyleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
    NSDateComponents *todayDateComponents = [NSDate dateComponentsFromDate:self.date];
    NSInteger todayWeekOfYear = todayDateComponents.weekOfYear;
    if(todayDateComponents.weekday == 1){//因为NSDateComponents 是从星期日到星期六计算为一周的。
        todayWeekOfYear--;
    }
    todayWeekOfYear = todayWeekOfYear - 1;
    weekScrollView.currentPage = todayWeekOfYear;
    weekScrollView.delegate = self;
    weekScrollView.datasource = self;
    [self setAfterScrollShowView:weekScrollView andCurrentPage:3];
    weekScrollView.tag = baseTag+3;
    [timeBroadcastView addSubview:weekScrollView];
}

//设置现在时间。
-(NSInteger)setNowTimeShow:(NSInteger)timeType{
    NSDate *now = self.date;
    NSString *dateString = [dateFormatter stringFromDate:now];
    switch (timeType) {
        case 0://年
        {
            NSRange range = NSMakeRange(0, 4);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 1://月
        {
            NSRange range = NSMakeRange(4, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 2://日
        {
            NSRange range = NSMakeRange(6, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
            
        default:
            break;
    }
    return 0;
}
//截取年、月、日。
-(NSInteger)setNowTimeShow:(NSInteger)timeType withDate:(NSDate *)date{
    NSDate *now = date;
    NSString *dateString = [dateFormatter stringFromDate:now];
    switch (timeType) {
        case 0:
        {
            NSRange range = NSMakeRange(0, 4);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 1:
        {
            NSRange range = NSMakeRange(4, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 2:
        {
            NSRange range = NSMakeRange(6, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

-(void)setAfterScrollShowView:(PGCyleScrollView *)scrollView andCurrentPage:(NSInteger)currentPage{
    UILabel *lblPre3 = (UILabel *)scrollView.subviews[0].subviews[currentPage-3];
    lblPre3.font = [UIFont systemFontOfSize:15];
    lblPre3.textColor = COLOR(185, 184, 184, 1);
    
    UILabel *lblPre2 = (UILabel *)scrollView.subviews[0].subviews[currentPage-2];
    lblPre2.font = [UIFont systemFontOfSize:15];
    lblPre2.textColor = COLOR(185, 184, 184, 1);
    
    UILabel *lblPre1 = (UILabel *)scrollView.subviews[0].subviews[currentPage-1];
    lblPre1.font = [UIFont systemFontOfSize:17];
    lblPre1.textColor = COLOR(147, 152, 156, 1);
    
    UILabel *lblCurrent = (UILabel *)scrollView.subviews[0].subviews[currentPage];
    lblCurrent.font = [UIFont systemFontOfSize:20];
    lblCurrent.textColor = COLOR(236, 103, 36, 1);
    
    UILabel *lblLast1 = (UILabel *)scrollView.subviews[0].subviews[currentPage+1];
    lblLast1.font = [UIFont systemFontOfSize:17];
    lblLast1.textColor = COLOR(147, 152, 156, 1);
    
    UILabel *lblLast2 = (UILabel *)scrollView.subviews[0].subviews[currentPage+2];
    lblLast2.font = [UIFont systemFontOfSize:15];
    lblLast2.textColor = COLOR(185, 184, 184, 1);
    
    UILabel *lblLast3 = (UILabel *)scrollView.subviews[0].subviews[currentPage+3];
    lblLast3.font = [UIFont systemFontOfSize:15];
    lblLast3.textColor = COLOR(185, 184, 184, 1);
}

#pragma mark -PGCycleScrollView DataSource
-(NSInteger)numberOfCells:(PGCyleScrollView *)scrollView{
    switch (self.datePickerMode) {
        case UIPGDatePickerModeDate:
        {
            if([scrollView isEqual:yearScrollView]){
                return 99;
            }else if ([scrollView isEqual:monthScrollView]){
                return 12;
            }else{
                return [NSDate daysfromYear:yearScrollView.currentPage+2000 andMonth:monthScrollView.currentPage+1];
            }
        }
            break;
        case UIPGDatePickerModeDateMonth:
        {
            if([scrollView isEqual:yearScrollView]){
                return 99;
            }else if ([scrollView isEqual:monthScrollView]){
                return 12;
            }
        }
        case UIPGDatePickerModeDateWeekOfYear:
        {
            if([scrollView isEqual:weekScrollView]){
                return 53;
            }
        }
        default:
            break;
    }
    return 0;
}
-(UIView *)cellAtIndex:(NSInteger)index andScrollView:(PGCyleScrollView *)scrollView{
    
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, scrollView.bounds.size.width, scrollView.bounds.size.height/5.0)];
    l.tag = index;
    switch (self.datePickerMode) {
        case UIPGDatePickerModeDate:
        {
            if([scrollView isEqual:yearScrollView]){
                l.text = [NSString stringWithFormat:@"%d",(int)(index+2000)];
            }else if([scrollView isEqual:monthScrollView]){
                l.text = [NSString stringWithFormat:@"%d",(int)(index+1)];
            }else if([scrollView isEqual:dayScrollView]){
                l.text = [NSString stringWithFormat:@"%d",(int)(index+1)];
            }
        }
            break;
        case UIPGDatePickerModeDateMonth:
        {
            if([scrollView isEqual:yearScrollView]){
                l.text = [NSString stringWithFormat:@"%d",(int)(index+2000)];
            }else if([scrollView isEqual:monthScrollView]){
                l.text = [NSString stringWithFormat:@"%d",(int)(index + 1)];
            }
        }break;
            
        case UIPGDatePickerModeDateWeekOfYear:
        {
            if([scrollView isEqual:weekScrollView]){
                l.text = weeksOfYearStrArray[index];
            }
        }
        default:
            break;
    }
    l.textAlignment = NSTextAlignmentCenter;
    return l;
}
#pragma mark -PGCyleScrollView Delegate
-(void)scrollViewDidChangeNumber{//UIScrollView滑动之后、应该做的操作。
    switch (self.datePickerMode) {
        case UIPGDatePickerModeDate:
        {
            [self dealDateModeChange];
        }
            break;
        case UIPGDatePickerModeDateMonth:
        {
            [self dealDateMonthModeChange];
        }
            break;
        case UIPGDatePickerModeDateWeekOfYear:
        {
            [self dealWeekOfYearModeChange];
        }
            break;
            
        default:
            break;
    }
}

-(void)dealDateModeChange{
    UILabel *yearLabel = [[(UILabel *)[[yearScrollView subviews] objectAtIndex:0] subviews]objectAtIndex:3];
    UILabel *monthLabel = [[(UILabel *)[[monthScrollView subviews] objectAtIndex:0]subviews]objectAtIndex:3];
    UILabel *dayLabel = [[(UILabel *)[[dayScrollView subviews] objectAtIndex:0]subviews]objectAtIndex:3];
    
    NSInteger yearInt = yearLabel.text.integerValue;
    NSInteger monthInt = monthLabel.text.integerValue;
    NSInteger dayInt = dayLabel.text.integerValue;
    
    yearScrollView.currentPage = yearLabel.tag;
    monthScrollView.currentPage = monthLabel.tag;
    NSInteger days = [NSDate daysfromYear:yearInt andMonth:monthInt];
    if(dayInt >days){
        dayInt = days;
    }
    NSDate *selectedDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%02d%02d%02d",(int)yearInt,(int)monthInt,(int)dayInt]];
    
    if(self.isNext){
        if([selectedDate compare:[NSDate date]]==NSOrderedDescending){
            yearInt = [self setNowTimeShow:0  withDate:[NSDate date]];
            monthInt = [self setNowTimeShow:1 withDate:[NSDate date]];
            dayInt = [self setNowTimeShow:2 withDate:[NSDate date]];
            
            yearScrollView.currentPage = yearInt -2000;
            monthScrollView.currentPage = monthInt-1;
            dayScrollView.currentPage = dayInt-1;
            
        }else{
            dayScrollView.currentPage = dayInt -1;
            [dayScrollView reloadDate];
            [self setAfterScrollShowView:dayScrollView andCurrentPage:3];
        }
    }else{
        
        if([selectedDate compare:[NSDate date]]==NSOrderedDescending){
            NSLog(@"--------123");
            yearInt = [self setNowTimeShow:0  withDate:[NSDate date]];
            monthInt = [self setNowTimeShow:1 withDate:[NSDate date]];
            dayInt = [self setNowTimeShow:2 withDate:[NSDate date]];
            
            yearScrollView.currentPage = yearInt -2000;
            monthScrollView.currentPage = monthInt-1;
            dayScrollView.currentPage = dayInt-1;
            
            [yearScrollView reloadDate];
            [self setAfterScrollShowView:yearScrollView andCurrentPage:3];
            
            [monthScrollView reloadDate];
            [self setAfterScrollShowView:monthScrollView andCurrentPage:3];
            
            [dayScrollView reloadDate];
            [self setAfterScrollShowView:dayScrollView andCurrentPage:3];
            selectedDate = [NSDate date];
        }else{
            dayScrollView.currentPage = dayInt -1;
            [dayScrollView reloadDate];
            [self setAfterScrollShowView:dayScrollView andCurrentPage:3];
        }
    }
    self.selecteDate = selectedDate;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
}
//处理DateMonthMode时间
-(void)dealDateMonthModeChange{
    UILabel *yearLabel = [[(UILabel *)[[yearScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *monthLabel = [[(UILabel *)[[monthScrollView subviews]objectAtIndex:0] subviews]objectAtIndex:3];
    NSInteger yearInt = yearLabel.text.integerValue;
    NSInteger monthInt = monthLabel.text.integerValue;
    
    NSDate *selectedDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%02d%02d",(int)yearInt,(int)monthInt]];
    if([selectedDate compare:[NSDate date]] == NSOrderedDescending){
        yearInt = [self setNowTimeShow:0 withDate:[NSDate date]];
        monthInt = [self setNowTimeShow:1 withDate:[NSDate date]];
        yearScrollView.currentPage = yearInt -2000;
        monthScrollView.currentPage = monthInt -1;
        
        [yearScrollView reloadDate];
        [self setAfterScrollShowView:yearScrollView andCurrentPage:3];
        [monthScrollView reloadDate];
        [self setAfterScrollShowView:monthScrollView andCurrentPage:3];
        selectedDate = [NSDate date];
    }
    self.selecteDate = selectedDate;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
}
-(void)dealWeekOfYearModeChange{
    UILabel *weekOfYearLabel = [[(UILabel *)[[weekScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    NSInteger weekOfYear = weekOfYearLabel.tag;
    
    NSDateComponents *todayDateComponents = [NSDate dateComponentsFromDate:[NSDate date]];
    NSInteger todayWeekOfYear = todayDateComponents.weekOfYear;
    if(todayDateComponents.weekday == 1){
        todayWeekOfYear--;
    }
    todayWeekOfYear = todayWeekOfYear-1;
    if(weekOfYear >todayWeekOfYear){
        weekScrollView.currentPage = todayWeekOfYear;
        [weekScrollView reloadDate];
        [self setAfterScrollShowView:weekScrollView andCurrentPage:3];
        weekOfYear = todayWeekOfYear;
    }
    self.selecteDate = weeksLastDayOfYeaerArray[weekOfYear];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end





