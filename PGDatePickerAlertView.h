//
//  PGDatePickerAlertView.h
//  MYDatePicker
//
//  Created by ianc-ios on 15/12/22.
//  Copyright © 2015年 彭雄辉10/9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGDatePickerControl.h"

@protocol PGDatePickerAlertViewDelegate;

@interface PGDatePickerAlertView : UIView

@property(nonatomic,weak,nullable) id <PGDatePickerAlertViewDelegate>delegate;
@property(nonatomic,assign)PGUIDatePickerMode datePickerMode;
@property(nonatomic,strong,nullable)NSDate *date;
@property(nonatomic)BOOL isNext;
-(void)show;

@end

@protocol PGDatePickerAlertViewDelegate <NSObject>

@optional
-(void)pgDatePickerAlertViewCancel:(nonnull PGDatePickerAlertView *)pgDatePickerAlertView;
-(void)pgDatePickerAlertViewConfirm:(nonnull PGDatePickerAlertView *)pgDatePickerAlertView param:(nonnull id)param;
@end
