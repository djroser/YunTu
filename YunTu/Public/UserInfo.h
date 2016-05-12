//
//  UserInfo.h
//  YunTu
//
//  Created by 丁健 on 16/4/3.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, assign)BOOL isOriginalDataBase;


+ (instancetype)sharedInstance;
//登录相关参数
@property (nonatomic,strong) NSString *stuNum;
@property (nonatomic,strong) NSString *stuName;
@property (nonatomic,strong) NSString *stuMajor;//性别

@property (nonatomic) BOOL isLogin;
@end
