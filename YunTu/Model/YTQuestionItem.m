//
//  YTQuestionItem.m
//  YunTu
//
//  Created by 丁健 on 15/11/2.
//  Copyright © 2015年 丁健. All rights reserved.
//

#import "YTQuestionItem.h"

@implementation YTQuestionItem

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.QNum = dict[@"QNum"];
        self.QTitle = dict[@"QTitle"];
        self.QOption1 = dict[@"QOption1"];
        self.QOption2 = dict[@"QOption2"];
        self.QOption3 = dict[@"QOption3"];
        self.QOption4 = dict[@"QOption4"];

        self.QAnswer = dict[@"QAnswer"];
        self.QExplain = dict[@"QExplain"];
        self.QRightNum = dict[@"QRightNum"];

        self.QLargeImgUrl = dict[@"QLargeImgUrl"];
        self.QShortImgUrl = dict[@"QShortImgUrl"];
        self.QSection = dict[@"QSection"];
        self.QType = dict[@"QType"];
        self.QVersion = dict[@"QVersion"];

    }
    return self;
}

+ (instancetype)questionWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
