//
//  GGLoopView.h
//  Created by Mr.Gu on 16/10/31.
//  Copyright © 2016年 Mr.Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGLoopView : UIView


/**
 图片轮播器初始化方法

 @param didSelectedIndex 选中索引的回调
 */
- (instancetype)initWithSelectedIndex:(void(^)(NSInteger index))didSelectedIndex;

/// 轮播图片地址数组
@property (nonatomic, strong)NSArray <NSURL *> *urls;

/// 是否开启定时器
@property (nonatomic, assign) BOOL hasTimer;

@end
