//
//  ViewController.h
//  YunTu
//
//  Created by 丁健 on 15/11/1.
//  Copyright © 2015年 丁健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ViewController : BaseViewController

- (IBAction)showQuestions:(id)sender;//模拟考试
- (IBAction)didPressedOrderPractise:(id)sender;//顺序练习
- (IBAction)didPressedSectionPractise:(id)sender;//章节练习
- (IBAction)didPressedRandomPractise:(id)sender;//随机练习
- (IBAction)didPressedWrongPractise:(id)sender;//错题练习
- (IBAction)didPressedExamCount:(id)sender;//统计

- (IBAction)didPressedFavorites:(id)sender;//收藏


@end

