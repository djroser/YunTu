//
//  YTUserViewController.m
//  YunTu
//
//  Created by 丁健 on 16/5/13.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import "YTUserViewController.h"
#import "UserInfo.h"
#import "AppUtil.h"

@interface YTUserViewController ()

@end

@implementation YTUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
    _lblStuNum.text = [UserInfo sharedInstance].stuNum;
    _lblStuName.text = [UserInfo sharedInstance].stuName;
    _lblStuMajor.text = [[UserInfo sharedInstance].stuMajor isEqualToString:@""] ? @"计算机科学与技术" : [UserInfo sharedInstance].stuMajor;
    //button
    UIImage *imgRest = [UIImage imageNamed:@"btn_action_common_rest"];
    UIImage *imgDisable = [UIImage imageNamed:@"btn_action_common_disable"];
    UIImage *imgPressed = [UIImage imageNamed:@"btn_action_common_pressed"];
    UIEdgeInsets edge=UIEdgeInsetsMake(10, 10, 10, 10);
    imgDisable = [imgDisable resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    imgRest = [imgRest resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    imgPressed = [imgPressed resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    [_btnQuit setBackgroundImage:imgRest forState:UIControlStateNormal];
    [_btnQuit setBackgroundImage:imgPressed forState:UIControlStateHighlighted];
    [_btnQuit setBackgroundImage:imgDisable forState:UIControlStateDisabled];
    
    self.navigationItem.leftBarButtonItem = [AppUtil leftBarItemWithTarget:self action:@selector(popBack)];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return _cellStuNum;
            break;
        case 1:
            return _cellStuName;
            break;
        case 2:
            return _cellStuMajor;
            break;
        default:
            return _cellQuit;
            break;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return _cellStuNum.frame.size.height;
            break;
        case 1:
            return _cellStuName.frame.size.height;
            break;
        case 2:
            return _cellStuMajor.frame.size.height;
            break;
        default:
            return _cellQuit.frame.size.height;
            break;
    }
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didPressedQuit:(id)sender {
    [UserInfo sharedInstance].isLogin = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
