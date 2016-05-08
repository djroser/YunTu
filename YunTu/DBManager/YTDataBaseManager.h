//
//  YTDataBaseManager.h
//  YunTu
//
//  Created by 丁健 on 15/11/1.
//  Copyright © 2015年 丁健. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTQuestionItem.h"
@interface YTDataBaseManager : NSObject

@property (nonatomic,strong)NSMutableArray *questionsList;
@property (nonatomic,strong)NSMutableArray *wrongQuestionsList;
@property (nonatomic,strong)NSMutableArray *storeQuestionsList;
+ (instancetype)sharedInstance;

- (void)openDatabase;
- (void)saveQuestionListDataBaseWithArray:(NSArray *)array;
//增量更新数据库
- (void)saveQuestionListDataBaseIncreUpdateWithArray:(NSArray *)array;
- (void)saveWrongQuestionListDataBaseWithItem:(YTQuestionItem *)item;
- (void)saveStoreQuestionListDataBaseWithItem:(YTQuestionItem *)item;
//错题表中删除某条错题
- (void)deleteWrongQuestionListWithItem:(YTQuestionItem *)item;
- (NSMutableArray *)questionsListWithSectionNum:(NSUInteger)section;//按章节取题
@end
