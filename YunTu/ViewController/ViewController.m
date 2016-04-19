//
//  ViewController.m
//  YunTu
//
//  Created by 丁健 on 15/11/1.
//  Copyright © 2015年 丁健. All rights reserved.
//

#import "ViewController.h"
#import "YTQuestionViewController.h"
#import "Pods/AFNetworking/AFNetworking/AFNetworking.h"
#import "YTQuestionItem.h"
#import "YTGlobal.h"
#import "YTDataBaseManager.h"
#import "UserInfo.h"
@interface ViewController ()


@property (nonatomic, strong)NSArray *questionArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"云图";
    
//    [UserInfo sharedInstance].isOriginalDataBase = NO;
//    
//    YTQuestionItem *item = [[YTQuestionItem alloc] init];
//    item.QNum = @"1";
//    item.QTitle = @"12354343443";
//    item.QOption1 = @"QOption1";
//    item.QOption2 = @"QOption2";
//    NSMutableArray *itemArray = [NSMutableArray arrayWithObject:item];
//    [[YTDataBaseManager sharedInstance]saveQuestionListDataBaseWithArray:itemArray];
    
}

- (NSArray *)questionArray
{
    if (_questionArray == nil) {
        _questionArray = [NSArray array];
    }
    return _questionArray;
}

- (void)getQuestionListRequest
{
    __weak typeof(self) WeakSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *url = @"";
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:VersionNumKey]) {
        paras[@"versionNum"] = [[NSUserDefaults standardUserDefaults] objectForKey:VersionNumKey];
    } else {
        paras[@"versionNum"] = @"0";
    }
    [manager GET:url parameters:paras success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject[@"versionNum"] integerValue] > [[[NSUserDefaults standardUserDefaults] objectForKey:VersionNumKey] integerValue]) {
            
            //服务端版本号高于本地则更新题库
            NSMutableArray *dicArray = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"questionList"]) {
                YTQuestionItem *item = [YTQuestionItem questionWithDict:dict];
                [dicArray addObject:item];
            }
            self.questionArray = dicArray;
            
            
            
            [WeakSelf cacheQuestionListWithUpdateType:responseObject[@"updateType"]];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
    
}

- (void)cacheQuestionListWithUpdateType:(NSString *)updateType
{
    if ([updateType integerValue] == 1) {
        //全量更新
        
        
    } else {
        //增量更新
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//根据不同的枚举类型进入不同的练习模式
- (void)pushToTestWithType:(YTAnswerType)type
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YTQuestionViewController *questionVC = [storyboard instantiateViewControllerWithIdentifier:@"question_vc"];
    questionVC.answerType = type;
    questionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:questionVC animated:YES];
}

- (IBAction)showQuestions:(id)sender {
    [self pushToTestWithType:YTAnswerExam];
}

- (IBAction)didPressedOrderPractise:(id)sender {
    
}

- (IBAction)didPressedSectionPractise:(id)sender {
}

- (IBAction)didPressedRandomPractise:(id)sender {
    [self pushToTestWithType:YTAnswerRandom];
}
















@end
