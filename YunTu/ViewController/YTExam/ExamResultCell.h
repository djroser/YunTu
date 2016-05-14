//
//  ExamResultCell.h
//  YunTu
//
//  Created by 丁健 on 16/5/14.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTExamResultItem.h"

@interface ExamResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblStuNum;
@property (weak, nonatomic) IBOutlet UILabel *lblStuName;
@property (weak, nonatomic) IBOutlet UILabel *lblMajor;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblScore;

@property (nonatomic, strong) YTExamResultItem *item;

@end
