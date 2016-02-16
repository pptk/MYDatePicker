//
//  ViewController.m
//  MYDatePicker
//
//  Created by ianc-ios on 15/12/17.
//  Copyright © 2015年 彭雄辉10/9. All rights reserved.
//
#define kMaxCellCount 20
#define COLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define PGDatePickerAlertView_WIDTH SCREEN_WIDTH

#define PGDatePickerAlertView_HEIGHT (self.dateMode == UIPGDatePickerModeDateWeekOfYear ? 369.0f : 389.0f)

#import "ViewController.h"
#import "PGDatePickerAlertView.h"
#import "PGCyleScrollView.h"
@interface ViewController ()<PGDatePickerAlertViewDelegate>
{
    PGDatePickerAlertView *pgDatePickerAlertView;
    NSDateFormatter *dateFormatter;
}

@property(nonatomic,assign)PGUIDatePickerMode dateMode;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.dateMode = UIPGDatePickerModeDateMonth;
    self.dateMode = UIPGDatePickerModeDate;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(show) userInfo:nil repeats:NO];
    
}

-(void)show{
    NSLog(@"12");
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //    [window addSubview:_overlayoutView];
    
    pgDatePickerAlertView = [[PGDatePickerAlertView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT + PGDatePickerAlertView_HEIGHT, PGDatePickerAlertView_WIDTH,PGDatePickerAlertView_HEIGHT)];
    pgDatePickerAlertView.date = [NSDate date];//设置当前显示时间。
    pgDatePickerAlertView.datePickerMode = self.dateMode;//日期格式。
    pgDatePickerAlertView.delegate = self;//确定和取消按钮的代理。
    pgDatePickerAlertView.isNext = YES;//是否可以选择本日之后的日期。
    [pgDatePickerAlertView show];
    [window addSubview:pgDatePickerAlertView];
    [UIView animateWithDuration:0.5 animations:^{
        pgDatePickerAlertView.frame = CGRectMake(0,SCREEN_HEIGHT - PGDatePickerAlertView_HEIGHT, PGDatePickerAlertView_WIDTH,PGDatePickerAlertView_HEIGHT);
    }];
}
-(void)dismissPGDatePickerAlertView{
    [UIView animateWithDuration:0.25 animations:^{
        pgDatePickerAlertView.frame = CGRectMake(0, SCREEN_HEIGHT+PGDatePickerAlertView_HEIGHT, PGDatePickerAlertView_WIDTH, PGDatePickerAlertView_HEIGHT);
        
    }completion:^(BOOL finished) {
        [pgDatePickerAlertView removeFromSuperview];
        pgDatePickerAlertView = nil;
    }];
}

#pragma mark delegate
//取消
-(void)pgDatePickerAlertViewCancel:(PGDatePickerAlertView *)pgDatePickerAlertView{
    
    [self dismissPGDatePickerAlertView];
    
}
//确定。
-(void)pgDatePickerAlertViewConfirm:(PGDatePickerAlertView *)pgDatePickerAlertView param:(id)param{
    [self dismissPGDatePickerAlertView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
