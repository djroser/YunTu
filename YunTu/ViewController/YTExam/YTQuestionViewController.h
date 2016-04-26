//
//  YTQuestionViewController.h
//  YunTu
//
//  Created by 丁健 on 15/11/1.
//  Copyright © 2015年 丁健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "YTGlobal.h"

@interface YTQuestionViewController : BaseViewController
<
UIAlertViewDelegate
>

@property (nonatomic, assign) YTAnswerType answerType;//练习模式

@end
