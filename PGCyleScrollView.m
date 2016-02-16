//
//  PGCyleScrollView.m
//  MYDatePicker
//
//  Created by ianc-ios on 15/12/21.
//  Copyright © 2015年 彭雄辉10/9. All rights reserved.
//

#import "PGCyleScrollView.h"
#define COLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface PGCyleScrollView()<UIScrollViewDelegate>{
    NSInteger _totalPages;
    NSMutableArray *_curViews;
}
@end

@implementation PGCyleScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width, (self.bounds.size.height/5.0)*7);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(0, self.bounds.size.height/5.0);
        [self addSubview:_scrollView];
    }
    return self;
}
//初始化当前是那一页被选中。
-(void)setCurrentPage:(NSInteger)currentPage{
    if(_currentPage != currentPage){
        _currentPage = currentPage;
    }
}
-(void)setDatasource:(id<PGCyleScrollViewDataSource>)datasource{
    _datasource = datasource;
    [self reloadDate];
}

-(void)reloadDate{
    _totalPages = [self.datasource numberOfCells:self];
    if(_totalPages == 0){
        return;
    }
    [self loadData];
}
-(void)loadData{
    NSArray *subViews = _scrollView.subviews;
    if(subViews.count){
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self getDisplayViewWithCurrentPage:self.currentPage];//给curViews赋值。
    for(int i = 0;i<7;++i){//获取起跳数据。
        UIView *v = _curViews[i];
        v.frame = CGRectOffset(v.frame, 0, v.frame.size.height * i);
        [_scrollView addSubview:v];
    }
    _scrollView.contentOffset = CGPointMake(0, self.bounds.size.height/5.0);
}

-(void)getDisplayViewWithCurrentPage:(NSInteger)curPage{
    NSInteger pre3 = [self validCellIndexValue:curPage-3];
    NSInteger pre2 = [self validCellIndexValue:curPage-2];
    NSInteger pre1 = [self validCellIndexValue:curPage-1];
    NSInteger current = [self validCellIndexValue:curPage];
    NSInteger last1 = [self validCellIndexValue:curPage+1];
    NSInteger last2 = [self validCellIndexValue:curPage+2];
    NSInteger last3 = [self validCellIndexValue:curPage+3];
    if(!_curViews){
        _curViews = [NSMutableArray array];
    }
    [_curViews removeAllObjects];
    
    [_curViews addObject:[_datasource cellAtIndex:pre3 andScrollView:self]];
    [_curViews addObject:[_datasource cellAtIndex:pre2 andScrollView:self]];
    [_curViews addObject:[_datasource cellAtIndex:pre1 andScrollView:self]];
    [_curViews addObject:[_datasource cellAtIndex:current andScrollView:self]];
    [_curViews addObject:[_datasource cellAtIndex:last1 andScrollView:self]];
    [_curViews addObject:[_datasource cellAtIndex:last2 andScrollView:self]];
    [_curViews addObject:[_datasource cellAtIndex:last3 andScrollView:self]];
}

-(NSInteger)validCellIndexValue:(NSInteger)value{
    value = (value + _totalPages)%_totalPages;
    return value;
}

-(void)setAfterScrollView:(UIScrollView *)scrollView andCurrentPage:(NSInteger)curPage{
    UILabel *lblPre3 = (UILabel *)scrollView.subviews[curPage-3];
    lblPre3.font = [UIFont systemFontOfSize:15];
    lblPre3.textColor = COLOR(185, 184, 184, 1);
    
    UILabel*lblPre2 = (UILabel *)scrollView.subviews[curPage-2];
    lblPre2.font = [UIFont systemFontOfSize:15];
    lblPre2.textColor = COLOR(185, 184, 184, 1);
    
    UILabel *lblPre1 = (UILabel *)scrollView.subviews[curPage - 1];
    lblPre1.font = [UIFont systemFontOfSize:17];
    lblPre1.textColor = COLOR(147, 152, 156, 1);
    UILabel *lblCurrent = (UILabel *)scrollView.subviews[curPage];
    lblCurrent.font = [UIFont systemFontOfSize:20];
    lblCurrent.textColor = COLOR(236,103,36,1);
    UILabel *lblLast1 = (UILabel *)scrollView.subviews[curPage + 1];
    lblLast1.font = [UIFont systemFontOfSize:17];
    lblLast1.textColor = COLOR(147, 152, 156, 1);
    UILabel *lblLast2 = (UILabel *)scrollView.subviews[curPage + 2];
    lblLast2.font = [UIFont systemFontOfSize:15];
    lblLast2.textColor = COLOR(185, 184, 184, 1);
    
    UILabel *lblLast3 = (UILabel *)scrollView.subviews[curPage + 3];
    lblLast3.font = [UIFont systemFontOfSize:15];
    lblLast3.textColor = COLOR(185, 184, 184, 1);
}
#pragma mark -UIScrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    NSInteger page = (NSInteger)y/(self.bounds.size.height/5.0);
    if(y>2*(self.bounds.size.height/5.0)){//当滑动到大于2个view的时候。
        _currentPage = [self validCellIndexValue:_currentPage+1];
        [self loadData];
    }
    if(y<=0){
        _currentPage = [self validCellIndexValue:_currentPage-1];
        [self loadData];
    }
    if(page > 1 || page <= 0){
        [self setAfterScrollView:scrollView andCurrentPage:3];
    }
}
//开始拖动。
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self setAfterScrollView:scrollView andCurrentPage:3];
}
//结束拖动。
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_scrollView setContentOffset:CGPointMake(0, self.bounds.size.height/5.0) animated:NO];
    [self setAfterScrollView:scrollView andCurrentPage:3];
    if(decelerate == NO){
        if([self.delegate respondsToSelector:@selector(scrollViewDidChangeNumber)]){
            [self.delegate scrollViewDidChangeNumber];
        }
    }
}
//减速。
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self setAfterScrollView:scrollView andCurrentPage:3];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [UIView animateWithDuration:0.3 animations:^{
        [_scrollView setContentOffset:CGPointMake(0, self.bounds.size.height/5.0) animated:NO];
    }];
    [self setAfterScrollView:scrollView andCurrentPage:3];
    if([self.delegate respondsToSelector:@selector(scrollViewDidChangeNumber)]){//判断self.delegate中是否有scrollViewDidChangeNumber的方法。
        [self.delegate scrollViewDidChangeNumber];
    }
}

@end










