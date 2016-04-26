//
//  YTTabButton.m
//  YunTu
//
//  Created by 丁健 on 16/4/26.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import "YTTabButton.h"

@implementation YTTabButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = self.frame.size.width * 0.25;
    CGFloat titleY = 0;
    CGFloat titleW = self.frame.size.width * 0.5;
    CGFloat titleH = self.frame.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
    
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = self.frame.size.height * 0.25;
    CGFloat imageW = self.frame.size.width * 0.25;
    CGFloat imageH = self.frame.size.height * 0.5;
    return CGRectMake(imageX, imageY, imageW, imageH);
    
}


@end
