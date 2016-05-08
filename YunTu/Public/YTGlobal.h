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
//用于考试底部tab
#define def_BG_DarkBlue                    RGBA(46,64,85,1)



//用于答对的文字
#define def_text_trueAnswer                  RGBA(85,196,192,1)
//用于答错的文字
#define def_text_falseAnswer                  RGBA(238,93,93,1)


//=======================================注册登录界面======================================
#define txt_Sign_NoUserName                   @"用户名不能为空"
#define txt_Sign_NoPassWord                   @"密码不能为空"
#define txt_Sign_ErrUnPd                      @"用户名不合法"


#define VersionNumKey                       @"yuntu_versionNum"
#define isOriginalDataBaseKey               @"isOriginalDataBaseKey"

#define ScreenWidth                      [UIScreen mainScreen].bounds.size.width
#define ScreenHeight                     [UIScreen mainScreen].bounds.size.height

typedef enum YTAnswerType {
    YTAnswerExam = 1,       // 1:模拟考试
    YTAnswerOrder = 2,      // 2:顺序练习
    YTAnswerSection = 3,    // 3:章节练习
    YTAnswerRandom = 4,     // 4:随机练习
    YTAnswerWrong = 5,      // 5:错题练习
    YTAnswerStore = 6,      // 6:收藏练习
}YTAnswerType;

typedef enum YTGlobalType {
    YTGlobalCJY = 1,
    YTGlobalJYY = 2,
    YTGlobalJY = 3,
}YTGlobalType;

//=======================================URL======================================
#define YTUserLoginUrl                       @""
#define YTUserRegisterUrl                    @""
#define YTQuestionListUrl                    @"http://172.16.102.176:83/WebService1.asmx/DownLoadQuestion"
#define YTImportScoreUrl                     @"http://172.16.102.176:83/WebService1.asmx/ImportScore"






