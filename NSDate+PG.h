//
//  NSDate+PG.h
//  MYDatePicker
//
//  Created by ianc-ios on 15/12/21.
//  Copyright © 2015年 彭雄辉10/9. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(PG)

+(NSString *)dateToString:(NSDate *)date;
+(NSString *)dateToWeekDay:(NSDate *)date;
+(NSString *)dateToString:(NSDate *)date formatString:(NSString *)formatStr;
+(NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+(NSDate *)dateWithYear:(NSInteger)yearNum;
+(NSInteger)daysfromYear:(NSInteger)year andMonth:(NSInteger)month;
+(NSDateComponents *)dateComponentsFromDate:(NSDate *)date;
+(NSArray *)getWeekOfYearStringArray;
+(NSArray *)getWeekOfYearStringBestArray;
+(NSArray *)getWeekLastDayOfYearArray;

@end
