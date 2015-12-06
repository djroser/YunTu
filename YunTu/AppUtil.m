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


@end
