//
//  YTMyViewController.h
//  YunTu
//
//  Created by 丁健 on 16/3/8.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LoginViewController.h"
@interface YTMyViewController : BaseViewController
<
UITableViewDataSource,
UITableViewDelegate,
LoginVCDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *mainTableview;


@end
