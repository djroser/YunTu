//
//  UserInfo.m
//  YunTu
//
//  Created by 丁健 on 16/4/3.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import "UserInfo.h"
#import "YTGlobal.h"
@implementation UserInfo

+ (instancetype)sharedInstance
{
    static id _shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[self alloc]init];
    });
    return _shareManager;
}

- (void)setIsLogin:(BOOL)isLogin
{
    if (_isLogin != isLogin) {
        _isLogin = isLogin;
    }
}

@end
