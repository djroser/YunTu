//
//  YTMyViewController.m
//  YunTu
//
//  Created by 丁健 on 16/3/8.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import "YTMyViewController.h"
#import "MyHeadView.h"
#import "UserInfo.h"

@interface YTMyViewController ()
@property (nonatomic,strong)MyHeadView *myHeaderView;
@end

@implementation YTMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBaseView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.tabBarController.tabBar.hidden = NO;
    [_mainTableview setContentOffset:(CGPoint){0,-44} animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)createBaseView
{
    self.title = @"我";
    _myHeaderView = [[[NSBundle mainBundle]loadNibNamed:@"MyHeadView" owner:nil options:nil] firstObject];
    _myHeaderView.frame = CGRectMake(0, 0, _mainTableview.frame.size.width, 175);
    [_myHeaderView.btnLogin addTarget:self action:@selector(didPressLogin) forControlEvents:UIControlEventTouchUpInside];
    [_mainTableview setTableHeaderView:_myHeaderView];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"my_about_yuntu"];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y <-44) {//如果当前位移大于缓存位移，说明scrollView向上滑动
        [_mainTableview setContentOffset:(CGPoint){0,-44} animated:NO];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshUserInfo
{
    _myHeaderView.lblUserName.text = [UserInfo sharedInstance].stuName;
//    _myHeaderView.imgvUserType.image = [[UserInfo sharedInstance].stuMale isEqualToString:@"0"] ? [UIImage imageNamed:@"女的"] : [UIImage imageNamed:@"女的"];
}

#pragma mark - LoginDelegate
- (void)didLoginDone
{
    [self refreshUserInfo];
}

- (void)didPressLogin
{
    if ([UserInfo sharedInstance].isLogin) {
        //个人信息界面（可不做）、退出登录等
    } else {
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginVC.delegate = self;
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

@end
