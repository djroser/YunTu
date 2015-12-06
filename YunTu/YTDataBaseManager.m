//
//  YTDataBaseManager.m
//  YunTu
//
//  Created by 丁健 on 15/11/1.
//  Copyright © 2015年 丁健. All rights reserved.
//

#import "YTDataBaseManager.h"
#import "FMDB.h"
#import "YTQuestionItem.h"
@interface YTDataBaseManager()
{
    FMDatabaseQueue *_dbQueue;
}
@end
@implementation YTDataBaseManager

+ (instancetype)sharedInstance
{
    static id _shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[self alloc]init];
    });
    return _shareManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self openDatabase];
    }
    return self;
}

- (FMDatabaseQueue *)dbQueue
{
    if (!_dbQueue) {
        [self openDatabase];
    }
    return _dbQueue;
}

- (void)openDatabase
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"yuntu" ofType:@"db3"];
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
}

- (NSMutableArray *)questionsList
{
    if (!_questionsList) {
        _questionsList = [NSMutableArray new];
        [_dbQueue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:@"select * from questions"];
            while ([rs next]) {
                YTQuestionItem *questionItem = [YTQuestionItem new];
                questionItem.questionID = [rs intForColumn:@"id"];
                questionItem.question = [rs stringForColumn:@"question"];
                questionItem.option1 = [rs stringForColumn:@"option1"];
                questionItem.option2 = [rs stringForColumn:@"option2"];
                questionItem.option3 = [rs stringForColumn:@"option3"];
                questionItem.option4 = [rs stringForColumn:@"option4"];
                questionItem.answer = [rs stringForColumn:@"answer"];
                questionItem.answer_explain = [rs stringForColumn:@"answer_explain"];
                questionItem.imageStr = [rs stringForColumn:@"image"];
                questionItem.type = [rs intForColumn:@"type"];
                [_questionsList addObject:questionItem];
            }
            [rs close];
        }];
    }
    return _questionsList;
}

@end
