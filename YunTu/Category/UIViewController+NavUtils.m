//
//  UIViewController+NavUtils.m
//  YunTu
//
//  Created by 丁健 on 16/1/24.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import "UIViewController+NavUtils.h"

@implementation UIViewController (NavUtils)

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
