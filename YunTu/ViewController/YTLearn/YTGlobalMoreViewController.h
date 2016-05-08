//
//  YTGlobalMoreViewController.h
//  YunTu
//
//  Created by 丁健 on 16/5/8.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "YTGlobalDetailItem.h"

@interface YTGlobalMoreViewController :BaseViewController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) YTGlobalDetailItem *globalItem;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UITableViewCell *cellImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgvMore;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellDetailTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDetailTitle;

@end
