//
//  YTQuestionItem.h
//  YunTu
//
//  Created by 丁健 on 15/11/2.
//  Copyright © 2015年 丁健. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTQuestionItem : NSObject
@property(nonatomic,assign)NSInteger questionID;
@property(nonatomic,copy)NSString *question;
@property(nonatomic,copy)NSString *option1;
@property(nonatomic,copy)NSString *option2;
@property(nonatomic,copy)NSString *option3;
@property(nonatomic,copy)NSString *option4;
@property(nonatomic,copy)NSString *answer;
@property(nonatomic,copy)NSString *answer_explain;
@property(nonatomic,copy)NSString *imageStr;
@property(nonatomic,assign)NSInteger type;

//逻辑判断
@property(nonatomic,assign)BOOL isAnswered;
@property(nonatomic,assign)BOOL isAnsweredRight;
@property(nonatomic,assign)BOOL isShowAnswerExplain;
@property(nonatomic,assign)BOOL isOption1Selected;
@property(nonatomic,assign)BOOL isOption2Selected;
@property(nonatomic,assign)BOOL isOption3Selected;
@property(nonatomic,assign)BOOL isOption4Selected;
@end
