//
//  PGDatePickerAlertView.m
//  MYDatePicker
//
//  Created by ianc-ios on 15/12/22.
//  Copyright © 2015年 彭雄辉10/9. All rights reserved.
//

#import "PGDatePickerAlertView.h"
#import "NSDate+PG.h"
#import "UIButton+Back.h"

#define COLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:r/255.0 blue:b/255.0 alpha:a]
#define PickerView_WIDTH 290
#define PickerView_HEIGHT 223

@interface PGDatePickerAlertView(){
    UILabel *_tipSelectLabel;//题头。
    UILabel *_selectTimeLabel;//选择之后时间显示。
    PGDatePickerControl *_pgDatePickerView;//PGDatePickerControl。
    UIButton *_sureBtn;//确定按钮
    UIButton *_cancelBtn;//取消按钮
}

@end

@implementation PGDatePickerAlertView
-(void)show{
    [self initUI];
}

-(void)initUI{
    self.backgroundColor = COLOR(255, 255, 255, 1);
    if(_tipSelectLabel == nil){
        _tipSelectLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 22, self.bounds.size.width, 17)];
        _tipSelectLabel.font = [UIFont boldSystemFontOfSize:17];
        _tipSelectLabel.textColor = COLOR(37, 38, 40, 1);
        switch (self.datePickerMode) {
            case UIPGDatePickerModeDate:
                _tipSelectLabel.text = NSLocalizedString(@"选择日期", nil);
                break;
            case UIPGDatePickerModeDateMonth:
                _tipSelectLabel.text = NSLocalizedString(@"选择日期", nil);
                break;
            case UIPGDatePickerModeDateWeekOfYear:
                _tipSelectLabel.text = NSLocalizedString(@"选择日期", nil);
                break;
            default:
                break;
        }
        _tipSelectLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipSelectLabel];
    }
    if(_selectTimeLabel == nil && self.datePickerMode != UIPGDatePickerModeDateWeekOfYear){
        _selectTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _tipSelectLabel.frame.origin.y+_tipSelectLabel.frame.size.height+18, self.bounds.size.width, 12)];
        _selectTimeLabel.font = [UIFont boldSystemFontOfSize:12];
        _selectTimeLabel.textColor = COLOR(25, 26, 28, 1);
        _selectTimeLabel.hidden = NO;
        _selectTimeLabel.textAlignment = NSTextAlignmentCenter;
        if(self.datePickerMode == UIPGDatePickerModeDate){
            NSString *dateStr = [NSDate dateToString:self.date formatString:@"yyyy年MM月dd日"];
            NSString *weekdayStr = [NSDate dateToWeekDay:self.date];
            dateStr = [dateStr stringByAppendingString:weekdayStr];
            _selectTimeLabel.text = dateStr;
        }else{
            _selectTimeLabel.text = [NSDate dateToString:self.date formatString:@"yyyy年MM月"];
        }
        [self addSubview:_selectTimeLabel];
    }
    if(_pgDatePickerView == nil){
        if(self.datePickerMode == UIPGDatePickerModeDateWeekOfYear){
            _pgDatePickerView = [[PGDatePickerControl alloc]initWithFrame:CGRectMake((self.bounds.size.width-PickerView_WIDTH)/2.0, _tipSelectLabel.frame.origin.y+_tipSelectLabel.frame.size.height+18, PickerView_WIDTH, PickerView_HEIGHT)];
        }else{
            _pgDatePickerView = [[PGDatePickerControl alloc]initWithFrame:CGRectMake((self.bounds.size.width-PickerView_WIDTH)/2.0, _selectTimeLabel.frame.origin.y+_selectTimeLabel.frame.size.height+8, PickerView_WIDTH, PickerView_HEIGHT)];
        }
        _pgDatePickerView.isNext = self.isNext;
        _pgDatePickerView.date = self.date;
        _pgDatePickerView.datePickerMode = self.datePickerMode;
        [_pgDatePickerView show];
        [_pgDatePickerView addTarget:self action:@selector(pgDatePickerSelectAction:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pgDatePickerView];
    }
    //确定和取消按钮
    if(_sureBtn == nil){
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(0, self.bounds.size.height-48, self.bounds.size.width/2.0, 48);
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sureBtn setTitleColor:COLOR(255, 255, 255, 1) forState:UIControlStateNormal];
        [_sureBtn setBackgroundColor:COLOR(243, 164, 80, 1) forState:UIControlStateNormal];
        [_sureBtn setBackgroundColor:COLOR(245, 245, 245, 1) forState:UIControlStateHighlighted];
        [_sureBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sureBtn];
        
    }
    if(_cancelBtn == nil){
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(self.bounds.size.width/2.0, self.bounds.size.height-48, self.bounds.size.width/2.0, 48);
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn setTitleColor:COLOR(117, 123, 128, 1) forState:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:COLOR(255, 255, 255, 1) forState:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:COLOR(245, 255, 245, 1) forState:UIControlStateHighlighted];
        
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.layer.borderWidth = 0.8;
        _cancelBtn.layer.borderColor = COLOR(207, 207, 207, 1).CGColor;
        [self addSubview:_cancelBtn];
    }
}
-(void)sureBtnAction{
    if([self.delegate respondsToSelector:@selector(pgDatePickerAlertViewConfirm:param:)]){
        [self.delegate pgDatePickerAlertViewConfirm:self param:_pgDatePickerView.selecteDate];
    }
}
-(void)cancelBtnAction{
    if([self.delegate respondsToSelector:@selector(pgDatePickerAlertViewCancel:)]){
        [self.delegate pgDatePickerAlertViewCancel:self];
    }
}
-(void)pgDatePickerSelectAction:(PGDatePickerControl *)pgDatePickerView{
    if(_selectTimeLabel){
        _selectTimeLabel.text = pgDatePickerView.selectDateStr;
    }
}

@end
