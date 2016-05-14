//
//  ExamResultCell.m
//  YunTu
//
//  Created by 丁健 on 16/5/14.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import "ExamResultCell.h"

@implementation ExamResultCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(YTExamResultItem *)item
{
    _item = item;
    _lblStuNum.text = _item.stuNum;
    _lblStuName.text = _item.stuName;
    _lblMajor.text = _item.stuMajor;
    _lblScore.text = item.examScore;
    _lblDate.text = _item.examDate;
}

@end
