//
//  YTGlobalKindViewController.h
//  YunTu
//
//  Created by 丁健 on 16/5/5.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface YTGlobalKindViewController :BaseViewController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic, strong) NSArray *yunArray;

@end
