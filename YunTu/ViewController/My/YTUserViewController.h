//
//  YTUserViewController.h
//  YunTu
//
//  Created by 丁健 on 16/5/13.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface YTUserViewController : BaseViewController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellStuNum;
@property (weak, nonatomic) IBOutlet UILabel *lblStuNum;

@property (strong, nonatomic) IBOutlet UITableViewCell *cellStuName;
@property (weak, nonatomic) IBOutlet UILabel *lblStuName;

@property (strong, nonatomic) IBOutlet UITableViewCell *cellStuMajor;
@property (weak, nonatomic) IBOutlet UILabel *lblStuMajor;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellQuit;
@property (weak, nonatomic) IBOutlet UIButton *btnQuit;

- (IBAction)didPressedQuit:(id)sender;

@end
