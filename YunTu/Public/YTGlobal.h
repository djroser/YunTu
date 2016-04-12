//
//  YTGlobal.h
//  YunTu
//
//  Created by 丁健 on 16/1/24.
//  Copyright © 2016年 丁健. All rights reserved.
//

#define RGBA(r,g,b,a)						[UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
//用于导航栏
#define def_BG_Blue                        RGBA(55,145,231,1)




//用于答对的文字
#define def_text_trueAnswer                  RGBA(85,196,192,1)
//用于答错的文字
#define def_text_falseAnswer                  RGBA(238,93,93,1)

//=======================================注册登录界面======================================
#define txt_Sign_NoUserName                   @"手机号不能为空"
#define txt_Sign_NoPassWord                   @"密码不能为空"
#define txt_Sign_ErrUnPd                      @"手机号不合法"


#define VersionNumKey                       @"yuntu_versionNum"

#define ScreenWidth                      [UIScreen mainScreen].bounds.size.width
#define ScreenHeight                     [UIScreen mainScreen].bounds.size.height