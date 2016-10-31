//
//  GGLoopViewLayout.m
//  图片轮播器测试
//
//  Created by Mr.Gu on 16/10/31.
//  Copyright © 2016年 Mr.Gu. All rights reserved.
//

#import "GGLoopViewLayout.h"

@implementation GGLoopViewLayout

- (void)prepareLayout {
    
    [super prepareLayout];
    
    self.itemSize = self.collectionView.bounds.size;
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.bounces = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}

@end
