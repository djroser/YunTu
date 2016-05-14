//
//  YTExamResultViewController.h
//  YunTu
//
//  Created by 丁健 on 16/5/13.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface YTExamResultViewController : BaseViewController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic,strong) NSArray *examResultList;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;



@end
