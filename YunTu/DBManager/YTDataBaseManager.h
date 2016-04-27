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
+ (instancetype)sharedInstance;

- (void)saveQuestionListDataBaseWithArray:(NSArray *)array;
- (void)saveWrongQuestionListDataBaseWithItem:(YTQuestionItem *)item;
@end
