//
//  AppUtil.m
//  YunTu
//
//  Created by 丁健 on 15/11/26.
//  Copyright © 2015年 丁健. All rights reserved.
//

#import "AppUtil.h"

@implementation AppUtil

+ (CGFloat)contentHeightWithText:(NSString*)text constraintWidth:(CGFloat)width fontSize:(CGFloat)fontSize {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    
    size =[text boundingRectWithSize:size
                             options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                          attributes:tdic
                             context:nil].size;
    
    
    return ceilf(size.height);
}

+ (UIBarButtonItem *)leftBarItemWithTarget:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:[UIImage imageNamed:@"arrow_common_left"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"arrow_common_left_pressed"] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return backItem;
}

+ (NSString *)cachesDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
#ifdef DEBUG
    NSLog(@"%@", path);
#endif
    return path;
}

//判断手机号是否合法
+(BOOL)isPhoneNumber:(NSString *)phoneNumber
{
    if ([phoneNumber length]==0||phoneNumber==nil||phoneNumber.length<11) {
        return NO;
    }
    NSString *Regex = @"^(13[0-9]|15[0-9]|18[0-9]|17[0-9]|147)\\d{8}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [emailTest evaluateWithObject:phoneNumber];
}

@end
