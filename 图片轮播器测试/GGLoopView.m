//
//  GGLoopView.m
//  Created by Mr.Gu on 16/10/31.
//  Copyright © 2016年 Mr.Gu. All rights reserved.
//

#import "GGLoopView.h"
#import "GGLoopViewLayout.h"
#import "GGLoopViewCell.h"

#define GGLoopViewCellReuserReuseIdentifier @"GGLoopViewCell"

@interface GGLoopView() <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation GGLoopView{
    /// 成员变量列表
    
    // collectionView
    UICollectionView *_collectionView;
    // 多页控件
    UIPageControl *_pageControl;
    // 定时器
    NSTimer *_timer;
    
    // 选中回调
    void(^didSelectedCallBack)(NSInteger);
    // 记录当前页
    NSInteger currentPage;
}

- (instancetype)initWithSelectedIndex:(void(^)(NSInteger index))didSelectedIndex
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        didSelectedCallBack = didSelectedIndex;
        [self prepareForCollectionView];
        [self prepareForPageControl];
    }
    return self;
}
-(void)setUrls:(NSArray<NSURL *> *)urls
{
    _urls = urls;
    _pageControl.numberOfPages = urls.count;
    
    [_collectionView reloadData];
}

- (void)setHasTimer:(BOOL)hasTimer
{
    if (hasTimer) {
        [self prepareForTimer];
    }
}

/// 准备 collectionView 的方法
- (void)prepareForCollectionView {
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[GGLoopViewLayout alloc] init]];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor colorWithRed:240/255 green:239/255 blue:245/255 alpha:1.0];
    [collectionView registerClass:[GGLoopViewCell class] forCellWithReuseIdentifier:GGLoopViewCellReuserReuseIdentifier];
    
    _collectionView = collectionView;
    
    [self addSubview:collectionView];
    
    //异步主队列,让数据源的方法限制性完之后,再执行初始化选中操作
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_urls.count > 1) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_urls.count inSection:0];
            
            // 默认选中第三中图片.
            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
        }
    });
    
}
/// 准备多页控件
- (void)prepareForPageControl {
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:255/255 green:39/255 blue:65/255 alpha:1.0];
    pageControl.currentPage = 0;
    _pageControl = pageControl;
    
    [self addSubview:pageControl];
}
/// 准备定时器
- (void)prepareForTimer {
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
    _timer = timer;
}

- (void)scrollToNextPage {
    
    NSInteger page = currentPage;
    
    if (page == 0 || page == [_collectionView numberOfItemsInSection:0 - 1]) {
        page = _urls.count - (_urls.count == 0 ? 0 : 1);
    }else {
        page ++;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page inSection:0];
    [_collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
    
}
/// 在这个方法中给 collectionView 设置 frame
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _collectionView.frame = self.bounds;
    _pageControl.frame = CGRectMake((self.bounds.size.width - 50) / 2, self.bounds.size.height - 20, 50, 20);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _urls.count * (_urls.count ==1 ? 1 : 100000);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GGLoopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GGLoopViewCellReuserReuseIdentifier forIndexPath:indexPath];
    
    cell.url = _urls[indexPath.item % _urls.count];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
/// 滑动停止的时候调用这个方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger currentIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    //当显示第一张图片的时候,跳转到 _urls.count ,当显示最后一张的时候,跳转到 _urls.count - 1 .
    if (currentIndex == 0 || currentIndex == ([_collectionView numberOfItemsInSection:0] - 1 )) {
        currentIndex = _urls.count - (currentIndex == 0 ? 0 : 1);
        scrollView.contentOffset = CGPointMake(currentIndex * scrollView.bounds.size.width, 0);
    }
}
/// 选中 item 的时候调用这个方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (didSelectedCallBack != nil) {
        didSelectedCallBack(indexPath.item % _urls.count);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger page = (NSInteger)((scrollView.contentOffset.x + scrollView.bounds.size.width/2) / scrollView.bounds.size.width) % _urls.count;
    
    currentPage = (NSInteger)((scrollView.contentOffset.x + scrollView.bounds.size.width/2) / scrollView.bounds.size.width);
    
    _pageControl.currentPage = page;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (self.hasTimer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (self.hasTimer) {
        [self prepareForTimer];
    }
}
@end
