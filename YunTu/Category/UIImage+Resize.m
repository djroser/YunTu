//
//  UIImage+Resize.m
//  YunTu
//
//  Created by 丁健 on 15/11/29.
//  Copyright © 2015年 丁健. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *)resizeToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
