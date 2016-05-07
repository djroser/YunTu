//
//  YTGlobalDetailViewController.h
//  YunTu
//
//  Created by 丁健 on 16/5/5.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTGlobal.h"
#import "BaseViewController.h"

@interface YTGlobalDetailViewController :BaseViewController
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, copy) NSString *sTitle;

@property (nonatomic, strong) NSArray *detailArray;

@property (nonatomic,assign) YTGlobalType globalType;
@end
