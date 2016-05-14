//
//  YTGlobalKindViewController.m
//  YunTu
//
//  Created by 丁健 on 16/5/5.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import "YTGlobalKindViewController.h"
#import "AppUtil.h"
#import "YTGlobalDetailViewController.h"

@interface YTGlobalKindViewController ()

@end

@implementation YTGlobalKindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"国际学分类法";
    self.navigationItem.leftBarButtonItem = [AppUtil leftBarItemWithTarget:self action:@selector(popBack)];
    self.yunArray = [NSArray arrayWithObjects:@"层积云",@"积雨云",@"积云", nil];
    self.mainTableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.yunArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"yun_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.yunArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushToDetailVCWithIndexPath:indexPath];
}

- (void)pushToDetailVCWithIndexPath:(NSIndexPath *)indexPath
{
    YTGlobalDetailViewController *globalDetailVC = [[YTGlobalDetailViewController alloc] initWithNibName:@"YTGlobalDetailViewController" bundle:nil];
    switch (indexPath.row) {
        case 0:
            globalDetailVC.globalType = YTGlobalCJY;
            break;
        case 1:
            globalDetailVC.globalType = YTGlobalJYY;
            break;
        case 2:
            globalDetailVC.globalType = YTGlobalJY;
            break;
        default:
            break;
    }
    globalDetailVC.sTitle = self.yunArray[indexPath.row];
    [self.navigationController pushViewController:globalDetailVC animated:YES];
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
