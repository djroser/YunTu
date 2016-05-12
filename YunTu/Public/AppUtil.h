//
//  AppUtil.h
//  YunTu
//
//  Created by 丁健 on 15/11/26.
//  Copyright © 2015年 丁健. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Pods/MBProgressHUD/MBProgressHUD.h"
@interface AppUtil : NSObject

//计算高度
+ (CGFloat)contentHeightWithText:(NSString*)text constraintWidth:(CGFloat)width fontSize:(CGFloat)fontSize;

+ (UIBarButtonItem *)leftBarItemWithTarget:(id)target action:(SEL)action;

+ (NSString *)cachesDirectory;
//判断手机号是否合法
+(BOOL)isPhoneNumber:(NSString *)phoneNumber;

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view;
@end
