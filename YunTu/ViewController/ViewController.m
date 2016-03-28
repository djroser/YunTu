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
@interface ViewController ()
- (IBAction)showQuestions:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"云图";
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)getQuestionListRequest
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *url = @"";
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"versionNum"] = @"0";
    
    [manager GET:url parameters:paras success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showQuestions:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YTQuestionViewController *questionVC = [storyboard instantiateViewControllerWithIdentifier:@"question_vc"];
    questionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:questionVC animated:YES];
}
@end
