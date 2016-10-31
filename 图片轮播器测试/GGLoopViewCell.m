//
//  GGLoopViewCell.m
//  Created by Mr.Gu on 16/10/31.
//  Copyright © 2016年 Mr.Gu. All rights reserved.
//

#import "GGLoopViewCell.h"
#import "YYWebImage.h"

@implementation GGLoopViewCell {
    /// 成员变量
    UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    
    [_imageView yy_setImageWithURL:url placeholder:[UIImage imageNamed:@"loopViewPlaceholder"]];
}

@end
