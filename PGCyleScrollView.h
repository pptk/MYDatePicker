//
//  PGCyleScrollView.h
//  MYDatePicker
//
//  Created by ianc-ios on 15/12/21.
//  Copyright © 2015年 彭雄辉10/9. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PGCyleScrollViewDelegate;
@protocol PGCyleScrollViewDataSource;

@interface PGCyleScrollView : UIView

@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,strong,nullable)UIScrollView *scrollView;
@property(nonatomic,weak,nullable)id<PGCyleScrollViewDataSource>datasource;
@property(nonatomic,weak,nullable)id<PGCyleScrollViewDelegate>delegate;

-(void)reloadDate;//刷新数据。

@end

//协议
@protocol PGCyleScrollViewDelegate <NSObject>

@optional
-(void)scrollViewDidChangeNumber;

@end

@protocol PGCyleScrollViewDataSource <NSObject>

@required
-(NSInteger)numberOfCells:(nonnull PGCyleScrollView *)scrollView;
-(nonnull UIView *)cellAtIndex:(NSInteger)index andScrollView:(nonnull PGCyleScrollView *)scrollView;

@end