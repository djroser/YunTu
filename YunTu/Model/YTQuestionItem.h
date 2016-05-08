//
//  YTQuestionItem.h
//  YunTu
//
//  Created by 丁健 on 15/11/2.
//  Copyright © 2015年 丁健. All rights reserved.
//
#define YTDEBUG                              @"YTDEBUG"
#import <Foundation/Foundation.h>

@interface YTQuestionItem : NSObject
@property(nonatomic,copy)NSString *QNum;
@property(nonatomic,copy)NSString *QTitle;
@property(nonatomic,copy)NSString *QOption1;
@property(nonatomic,copy)NSString *QOption2;
@property(nonatomic,copy)NSString *QOption3;
@property(nonatomic,copy)NSString *QOption4;
@property(nonatomic,copy)NSString *QAnswer;
@property(nonatomic,copy)NSString *QExplain;
@property(nonatomic,copy)NSString *QRightNum;
@property(nonatomic,copy)NSString *QLargeImgUrl;
@property(nonatomic,copy)NSString *QShortImgUrl;
@property(nonatomic,copy)NSString *QSection;
@property(nonatomic,copy)NSString *QType;
@property(nonatomic,copy)NSString *QVersion;


@property(nonatomic,copy)NSString *YTBeforeUrl;
//逻辑判断
@property(nonatomic,assign)BOOL isAnswered;
@property(nonatomic,assign)BOOL isAnsweredRight;
@property(nonatomic,assign)BOOL isShowAnswerExplain;
@property(nonatomic,assign)BOOL isOption1Selected;
@property(nonatomic,assign)BOOL isOption2Selected;
@property(nonatomic,assign)BOOL isOption3Selected;
@property(nonatomic,assign)BOOL isOption4Selected;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)questionWithDict:(NSDictionary *)dict;


@end
