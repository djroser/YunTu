//
//  YTButton.m
//  YunTu
//
//  Created by 丁健 on 15/11/3.
//  Copyright © 2015年 丁健. All rights reserved.
//

#import "YTButton.h"

@implementation YTButton

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
    CGFloat titleX = 0;
    CGFloat titleY = self.frame.size.height * 0.5;
    CGFloat titleW = self.frame.size.width;
    CGFloat titleH = self.frame.size.height *0.5;
    return CGRectMake(titleX, titleY, titleW, titleH);
    
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = self.frame.size.width;
    CGFloat imageH = self.frame.size.height *0.5;
    return CGRectMake(imageX, imageY, imageW, imageH);

}


@end
