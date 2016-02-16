//
//  PGButton.m
//  MYDatePicker
//
//  Created by ianc-ios on 15/12/23.
//  Copyright © 2015年 彭雄辉10/9. All rights reserved.
//

#import "UIButton+Back.h"

@implementation UIButton(Back)

-(void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state{
    
    [self setBackgroundImage:[UIButton imageWithColor:color] forState:state];
}

+(UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [color set];
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
