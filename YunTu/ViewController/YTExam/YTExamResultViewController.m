//
//  YTExamResultViewController.m
//  YunTu
//
//  Created by 丁健 on 16/5/13.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import "YTExamResultViewController.h"
#import "YTDataBaseManager.h"
#import "YTExamResultItem.h"
#import "AppUtil.h"
#import "ExamResultCell.h"

@interface YTExamResultViewController ()

@end

@implementation YTExamResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"做题记录";
    self.navigationItem.leftBarButtonItem = [AppUtil leftBarItemWithTarget:self action:@selector(popBack)];
    self.examResultList = [YTDataBaseManager sharedInstance].examResultList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.examResultList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTExamResultItem *item = self.examResultList[indexPath.row];
    static NSString *ID = @"exam_result_cell";
    ExamResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"ExamResultCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.item = item;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103;
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
