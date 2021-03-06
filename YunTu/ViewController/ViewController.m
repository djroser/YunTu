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
#import "Pods/MBProgressHUD/MBProgressHUD.h"
#import "AppUtil.h"
#import "YTExamResultViewController.h"
@interface ViewController ()


@property (nonatomic, strong)NSArray *questionArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"云图";
    
    UIButton *btnSyncDB = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSyncDB.frame = CGRectMake(0, 0, 80, 40);
    [btnSyncDB setTitle:@"同步题库" forState:UIControlStateNormal];
    [btnSyncDB addTarget:self action:@selector(didPressedSyncDataBase) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSyncDB];
    
//    [UserInfo sharedInstance].isOriginalDataBase = NO;
    
    
    
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
    AFJSONResponseSerializer *jsonReponseSerializer = [AFJSONResponseSerializer serializer];
    // This will make the AFJSONResponseSerializer accept any content type
    jsonReponseSerializer.acceptableContentTypes = nil;
    manager.responseSerializer = jsonReponseSerializer;
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:VersionNumKey]) {
        paras[@"versionNum"] = [[NSUserDefaults standardUserDefaults] objectForKey:VersionNumKey];
    } else {
        paras[@"versionNum"] = @"0";
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在同步";
    // 设置图片
    //    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    [manager GET:YTQuestionListUrl parameters:paras success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [hud hide:YES];
        NSLog(@"res---%@",responseObject);
        NSLog(@"isOriginalDataBase--------%d",[UserInfo sharedInstance].isOriginalDataBase);
        if ([responseObject[@"versionNum"] integerValue] > [[[NSUserDefaults standardUserDefaults] objectForKey:VersionNumKey] integerValue]) {
            
            //服务端版本号高于本地则更新题库
            NSMutableArray *dicArray = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"questionList"]) {
                YTQuestionItem *item = [YTQuestionItem questionWithDict:dict];
                [dicArray addObject:item];
            }
            if (dicArray) {
                self.questionArray = dicArray;
                [UserInfo sharedInstance].isOriginalDataBase = NO;
                [[YTDataBaseManager sharedInstance] openDatabase];
                [WeakSelf cacheQuestionListWithUpdateType:responseObject[@"updateType"]];
                [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"versionNum"] forKey:VersionNumKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [AppUtil show:@"同步成功" icon:@"" view:self.view];
            }
            
        }
//                    NSMutableArray *dicArray = [NSMutableArray array];
//                    for (NSDictionary *dict in responseObject[@"questionList"]) {
//                        YTQuestionItem *item = [YTQuestionItem questionWithDict:dict];
//                        [dicArray addObject:item];
//                    }
//                    if (dicArray) {
//                        self.questionArray = dicArray;
//                        [UserInfo sharedInstance].isOriginalDataBase = NO;
//                        [WeakSelf cacheQuestionListWithUpdateType:responseObject[@"updateType"]];
//                        [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"versionNum"] forKey:VersionNumKey];
//                        [[NSUserDefaults standardUserDefaults] synchronize];
//                        [AppUtil show:@"同步成功" icon:@"" view:self.view];
//                    }
//
        NSLog(@"success");
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [hud hide:YES];
        [AppUtil show:@"同步失败" icon:@"" view:self.view];
        NSLog(@"failed");
    }];
}

- (void)cacheQuestionListWithUpdateType:(NSString *)updateType
{
    if ([updateType integerValue] == 1) {
        //全量更新
            [[YTDataBaseManager sharedInstance]saveQuestionListDataBaseWithArray:self.questionArray];
        
    } else {
        //增量更新
            [[YTDataBaseManager sharedInstance]saveQuestionListDataBaseWithArray:self.questionArray];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//根据不同的枚举类型进入不同的练习模式
- (void)pushToTestWithType:(YTAnswerType)type section:(NSUInteger)section
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YTQuestionViewController *questionVC = [storyboard instantiateViewControllerWithIdentifier:@"question_vc"];
    questionVC.answerType = type;
    questionVC.sectionNum = section;
    questionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:questionVC animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self pushToTestWithType:YTAnswerSection section:1];
            break;
        case 1:
            [self pushToTestWithType:YTAnswerSection section:2];
            break;
        case 2:
            [self pushToTestWithType:YTAnswerSection section:3];
            break;
        default:
            break;
    }
}

- (void)didPressedSyncDataBase
{
//    [UserInfo sharedInstance].isOriginalDataBase = NO;
//    [[YTDataBaseManager sharedInstance] openDatabase];
//    YTQuestionItem *item = [[YTQuestionItem alloc] init];
//    item.QNum = @"1";
//    item.QTitle = @"12354343443";
//    item.QOption1 = @"QOption1";
//    item.QOption2 = @"QOption2";
//    NSMutableArray *itemArray = [NSMutableArray arrayWithObject:item];
//    [[YTDataBaseManager sharedInstance]saveQuestionListDataBaseWithArray:itemArray];
    [self getQuestionListRequest];
}

- (IBAction)showQuestions:(id)sender {
    [self pushToTestWithType:YTAnswerExam section:0];
}

- (IBAction)didPressedOrderPractise:(id)sender {
    [self pushToTestWithType:YTAnswerOrder section:0];
}

- (IBAction)didPressedSectionPractise:(id)sender {
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"请选择要练习的章节" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"第一章",@"第二章",@"第三章", nil];
    [actionsheet showInView:self.view];
}

- (IBAction)didPressedRandomPractise:(id)sender {
    [self pushToTestWithType:YTAnswerRandom section:0];
}

- (IBAction)didPressedWrongPractise:(id)sender {
    [self pushToTestWithType:YTAnswerWrong section:0];
}


- (IBAction)didPressedExamCount:(id)sender {
    YTExamResultViewController *examResultVC = [[YTExamResultViewController alloc] initWithNibName:@"YTExamResultViewController" bundle:nil];
    examResultVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:examResultVC animated:YES];
}

- (IBAction)didPressedFavorites:(id)sender {
    [self pushToTestWithType:YTAnswerStore section:0];
}




@end
