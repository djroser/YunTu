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
#import "YTGlobal.h"
#import "UserInfo.h"
#import "AppUtil.h"
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
    if ([UserInfo sharedInstance].isOriginalDataBase) {
        //原始题库
        NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSLog(@"docPath--%@",docsdir);
        //    NSString* dbpath = [docsdir stringByAppendingPathComponent:@"AppConfig.sqlite"];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"yuntu0314" ofType:@"db3"];
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    } else {
        //题库曾经更新过
        [self checkTableQuestion];
        
    }
    
}

+ (NSString *)databaseFilePath {
    return [[AppUtil cachesDirectory] stringByAppendingPathComponent:@"yuntu0520.db3"];
}

-(void)checkTableQuestion
{
    //获取Document文件夹下的数据库文件，没有则创建
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:[[self class] databaseFilePath]];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        //监测数据库中我要需要的表是否已经存在
        NSString *existsSql = [NSString stringWithFormat:@"select count(name) as countNum from sqlite_master where type = 'table' and name = '%@'", @"Question"];
        FMResultSet *rs = [db executeQuery:existsSql];
        
        while ([rs next]) {
            NSInteger count = [rs intForColumn:@"countNum"];
            NSLog(@"The table count: %li", count);
            if (count == 1) {
                NSLog(@"log_keepers table is existed.");
                return;
            }
            NSLog(@"log_keepers is not existed.");
            //创建表
            //[membersDB executeUpdate:@"CREATE TABLE PersonList (Name text, Age integer, Sex integer,Phone text, Address text, Photo blob)"];
//            [db executeUpdate:@"CREATE TABLE Question (QNum text NOT NULL PRIMARY KEY,QTitle text,QOption1 text,QOption2 text,QOption3 text,QOption4 text,QAnswer text,QExplain text,QRightNum text,QLargeImgUrl text,QShortImgUrl text,QSection text,QType text,QVersion text)"];
        }
        [rs close];
//        [db executeUpdate:@"CREATE TABLE Question (QNum text NOT NULL PRIMARY KEY,QTitle text,QOption1 text,QOption2 text,QOption3 text,QOption4 text,QAnswer text,QExplain text,QRightNum text,QLargeImgUrl text,QShortImgUrl text,QSection text,QType text,QVersion text)"];
    }];
    
}

- (NSMutableArray *)questionsList
{
    if (!_questionsList) {
        _questionsList = [NSMutableArray new];
        [_dbQueue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:@"select * from Question"];
            while ([rs next]) {
                YTQuestionItem *questionItem = [YTQuestionItem new];
                questionItem.QNum = [rs stringForColumn:@"QNum"];
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
                questionItem.QSection = [rs stringForColumn:@"QSection"];
                questionItem.QType = [rs stringForColumn:@"QType"];
                questionItem.QVersion = [rs stringForColumn:@"QVersion"];
                [_questionsList addObject:questionItem];
            }
            [rs close];
        }];
    }
    return _questionsList;
}

- (void)saveQuestionListDataBaseWithArray:(NSArray *)array
{
    //删除全部数据
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM Question"];
    }];
    
    //插入数据
    [_dbQueue inDatabase:^(FMDatabase *db) {
        for (YTQuestionItem *item in array) {
            [db executeUpdate:@"insert into Question (QNum,QTitle,QOption1,QOption2,QOption3, QOption4,QAnswer, QExplain,QRightNum,QLargeImgUrl,QShortImgUrl,QSection,QType,QVersion) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",item.QNum,item.QTitle,item.QOption1,item.QOption2,item.QOption3,item.QOption4,item.QAnswer,item.QExplain,item.QRightNum,item.QLargeImgUrl,item.QShortImgUrl,item.QSection,item.QType,item.QVersion];
        }
    }];
}








@end
