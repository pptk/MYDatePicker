//
//  NSDatePickerView.h
//  MYDatePicker
//
//  Created by ianc-ios on 15/12/22.
//  Copyright © 2015年 彭雄辉10/9. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,PGUIDatePickerMode){
    UIPGDatePickerModeDate,
    UIPGDatePickerModeDateMonth,
    UIPGDatePickerModeDateWeekOfYear
};
@interface PGDatePickerControl : UIControl

@property(nonatomic)PGUIDatePickerMode datePickerMode;
@property(nullable,nonatomic,strong)NSDate *date;
@property(nonatomic,copy,nullable)NSString *selectDateStr;
@property(nullable,nonatomic)NSDate *selecteDate;
@property(nonatomic)BOOL isNext;

-(void)show;

@end
