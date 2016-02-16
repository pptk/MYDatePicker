//
//  NSDate+PG.m
//  MYDatePicker
//
//  Created by ianc-ios on 15/12/21.
//  Copyright © 2015年 彭雄辉10/9. All rights reserved.
//

#import "NSDate+PG.h"
#define PG_FORMAT @"yyyy-MM-dd"
#define PG_FORMATSTR @"%@-%@-%@"
#define PG_DATESTR @"%@-%@-%@"


@implementation NSDate(PG)

//日期转str
+(NSString *)dateToString:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = PG_FORMAT;
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}
//日期转str
+(NSString *)dateToString:(NSDate *)date formatString:(NSString *)formatStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = formatStr;
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}
//单位
+(unsigned)UnitFlags{
    unsigned unitFlags = 0;
#ifdef isIOS8
    unitFlags = kCFCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond|NSCalendarUnitWeekday|kCFCalendarUnitWeekdayOrdinal|kCFCalendarUnitWeekOfMonth|kCFCalendarUnitWeekOfYear;
#else
    unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekOfYear;
#endif
    return unitFlags;
}

//获得每个单位
+(NSDateComponents *)dateComponentsFromDate:(NSDate *)date{
    if(!date){
        date = [NSDate date];
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone localTimeZone];
    NSDateComponents *_dateComponents = [calendar components:self.UnitFlags fromDate:date];
    return _dateComponents;
}
//日期星期字符
+(NSString *)dateToWeekDay:(NSDate *)date{
    NSArray *weekdayArray = [NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSInteger weekday = [NSDate dateComponentsFromDate:date].weekday;
    NSString *weekdayStr = weekdayArray[weekday - 1];
    weekdayArray = nil;
    return weekdayStr;
}
//str转日期
+(NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.formatterBehavior = NSDateFormatterBehavior10_4;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.dateFormat = format;
    return [dateFormatter dateFromString:string];
}
//返回每个月的天数
+(NSInteger)daysfromYear:(NSInteger)year andMonth:(NSInteger)month{
    NSAssert(!(month<1 || month>12), @"invalid month number");
    NSAssert(!(year<1), @"invalid year number");
    month = month - 1;
    static int daysOfMonth[12] = {31,29,31,30,31,30,31,31,30,31,30,31};//12个月。
    int days = daysOfMonth[month];
    //对二月进行再判断
    if(month == 1){
        if([self isLeapYear:year]){
            days = 29;
        }else{
            days = 28;
        }
    }
    return days;
}
//判断是不是闰年
+(BOOL)isLeapYear:(NSInteger)year{
    NSAssert(!(year < 1), @"invalid year number");
    BOOL leap = false;
    if((0 == (year %400))){
        leap = true;
    }else if ((0 == (year %4)) && (0!= (year%100))){
        leap = true;
    }
    return leap;
}
//得到某年的一年之内的周日起。XXXX年第XX周 XX/XX-XX/XX的数组。
+(NSArray *)getWeekOfYearStringArray{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    dateFormatter.calendar = [NSCalendar currentCalendar];
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    NSString *dateString = [dateFormatter stringFromDate:now];
    NSRange range = NSMakeRange(0, 4);
    NSString *yearString = [dateString substringWithRange:range];
    
    NSString *theFirstDateOfYearStr = [yearString stringByAppendingString:@"0101"];
    NSDate *theFirstDateOfYear = [dateFormatter dateFromString:theFirstDateOfYearStr];
    NSDateComponents *theFirstDateOfYearComponents = [self dateComponentsFromDate:theFirstDateOfYear];
    NSInteger weekday = theFirstDateOfYearComponents.weekday;
    weekday = (weekday - 1) == 0 ? 7 :(weekday - 1);
    NSMutableArray *weekOfYearArray = [NSMutableArray arrayWithCapacity:53];
    
    dateFormatter.dateFormat = @"MM/dd";
    NSDate *weekPreDate = theFirstDateOfYear;
    NSDate *weekLastDate = theFirstDateOfYear;
    int weekIndex = 1;
    NSInteger preMonthLeftDays = 0;
    for(NSInteger month = 1;month<=12;++month){
        NSInteger daysOfMonth = [self daysfromYear:yearString.integerValue andMonth:month];
        if(month == 1){
            daysOfMonth = daysOfMonth - 1;//一开始1月1号包含本身一天
        }
        while (daysOfMonth>=7) {//七天为一周
            if(preMonthLeftDays>0){//上月剩余天数
                daysOfMonth += preMonthLeftDays;//多余天数到这个月来。
                preMonthLeftDays = 0;
            }
            daysOfMonth = daysOfMonth - (7-weekday);
            weekPreDate = weekLastDate;
            
            weekLastDate = [weekPreDate dateByAddingTimeInterval:(7-weekday)*24*60*60];//计算这周的结束时间
            if(weekIndex >1){
                weekPreDate = [weekPreDate dateByAddingTimeInterval:24*60*60];//计算这周开始时间，出了第一周之外都用此方法计算。
            }
            weekday = 0;
            if(daysOfMonth < 7){
                preMonthLeftDays = daysOfMonth;
            }
            //转换为 XXXX年第XX周 XX/XX-XX/XX格式的字符串
            NSString *weekFirstDateAndLastDateStr = [self aWeekFirstDateAndLastDateToStr:weekPreDate lastDate:weekLastDate dateFormatter:dateFormatter];
            NSString *aWeekOfYearString = [NSString stringWithFormat:@"%@年第%d%@%@",yearString,weekIndex,NSLocalizedString(@"friend_week_format_title", nil),weekFirstDateAndLastDateStr];
            weekIndex++;
            [weekOfYearArray addObject:aWeekOfYearString];
        }
        if(preMonthLeftDays > 0 && month == 12){//这年最后一周日期的计算
            weekPreDate = weekLastDate;
            weekLastDate = [weekPreDate dateByAddingTimeInterval:(preMonthLeftDays)*24*60*60];//计算这周结束的时间。
            weekPreDate = [weekPreDate dateByAddingTimeInterval:24*60*60];//计算这一周开始的时间，出了第一周之外都用此方法计算。
            preMonthLeftDays = 0;
            
            //转换为XXXX年第XX周  XX/XX-XX/XX格式的字符串
            NSString *weekFirstDateAndLastDateStr = [self aWeekFirstDateAndLastDateToStr:weekPreDate lastDate:weekLastDate dateFormatter:dateFormatter];
            NSString *aWeekOfYearString = [NSString stringWithFormat:@"%@年第%d%@ %@",yearString,weekIndex,NSLocalizedString(@"friend_week_format_title", nil),weekFirstDateAndLastDateStr];
            [weekOfYearArray addObject:aWeekOfYearString];
        }
     }
    return [weekOfYearArray copy];
}



//一周的开始日期和结束日期转换为xx/XX-XX/XX格式的字符串
+(NSString *)aWeekFirstDateAndLastDateToStr:(NSDate *)firstDate lastDate:(NSDate *)lastDate dateFormatter:(NSDateFormatter *)dateFormatter{
    NSString *firstDateStr = [dateFormatter stringFromDate:firstDate];
    NSString *lastDateStr = [dateFormatter stringFromDate:lastDate];
    return [[firstDateStr stringByAppendingString:@"-"] stringByAppendingString:lastDateStr];
}
//一周的开始日期和结束日期转换为XX-XX到XX-XX最佳格式字符串。
+(NSString *)aWeekFirstDateAndLastDateToBestStr:(NSDate *)firstDate lastDate:(NSDate *)lastDate dateFormatter:(NSDateFormatter *)dateFormatter{
    NSString *firstDateStr = [dateFormatter stringFromDate:firstDate];
    NSString *lastDateStr = [dateFormatter stringFromDate:lastDate];
    return [[[firstDateStr stringByAppendingString:@"到"] stringByAppendingString:lastDateStr] stringByAppendingString:@"最佳"];
}
@end











