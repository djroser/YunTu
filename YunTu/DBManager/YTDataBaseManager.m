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
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"docPath--%@",docsdir);
//    NSString* dbpath = [docsdir stringByAppendingPathComponent:@"AppConfig.sqlite"];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"yuntu0314" ofType:@"db3"];
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
}

- (NSMutableArray *)questionsList
{
    if (!_questionsList) {
        _questionsList = [NSMutableArray new];
        [_dbQueue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:@"select * from Question"];
            while ([rs next]) {
                YTQuestionItem *questionItem = [YTQuestionItem new];
                questionItem.QNum = [rs intForColumn:@"QNum"];
                questionItem.QTitle = [rs stringForColumn:@"QTitle"];
                questionItem.QOption1 = [rs stringForColumn:@"QOption1"];
                questionItem.QOption2 = [rs stringForColumn:@"QOption2"];
                questionItem.QOption3 = [rs stringForColumn:@"QOption3"];
                questionItem.QOption4 = [rs stringForColumn:@"QOption4"];
                questionItem.QAnswer = [rs stringForColumn:@"QAnswer"];
                questionItem.QExplain = [rs stringForColumn:@"QExplain"];
                questionItem.QRightNum = [rs stringForColumn:@"QRightNum"];
                questionItem.QLargeImgUrl = [rs stringForColumn:@"QLargeImgUrl"];
                questionItem.QShortImgUrl = [rs stringForColumn:@"QShortImgUrl"];
                questionItem.QSection = [rs intForColumn:@"QSection"];
                questionItem.QType = [rs intForColumn:@"QType"];
                questionItem.QVersion = [rs stringForColumn:@"QVersion"];
                [_questionsList addObject:questionItem];
            }
            [rs close];
        }];
    }
    return _questionsList;
}

@end
