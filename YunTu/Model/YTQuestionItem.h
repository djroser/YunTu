//
//  YTQuestionItem.h
//  YunTu
//
//  Created by 丁健 on 15/11/2.
//  Copyright © 2015年 丁健. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTQuestionItem : NSObject
@property(nonatomic,assign)NSInteger QNum;
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
@property(nonatomic,assign)NSInteger QSection;
@property(nonatomic,assign)NSInteger QType;
@property(nonatomic,copy)NSString *QVersion;


//逻辑判断
@property(nonatomic,assign)BOOL isAnswered;
@property(nonatomic,assign)BOOL isAnsweredRight;
@property(nonatomic,assign)BOOL isShowAnswerExplain;
@property(nonatomic,assign)BOOL isOption1Selected;
@property(nonatomic,assign)BOOL isOption2Selected;
@property(nonatomic,assign)BOOL isOption3Selected;
@property(nonatomic,assign)BOOL isOption4Selected;
@end
