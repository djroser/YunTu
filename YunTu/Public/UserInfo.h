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

@end
