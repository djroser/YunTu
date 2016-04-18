//
//  answeredCollectionCell.m
//  YunTu
//
//  Created by 丁健 on 16/3/9.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import "answeredCollectionCell.h"

@implementation answeredCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setQuestionItem:(YTQuestionItem *)questionItem
{
    _questionItem = questionItem;
    if (_questionItem.isAnswered) {
        if (_questionItem.isAnsweredRight) {
            [_btnAnswerNum setBackgroundImage:[UIImage imageNamed:@"yuntu_practise_true"] forState:UIControlStateNormal];
            [_btnAnswerNum setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
        } else {
            [_btnAnswerNum setBackgroundImage:[UIImage imageNamed:@"yuntu_practise_false"] forState:UIControlStateNormal];
            [_btnAnswerNum setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
        }
    } else {
        [_btnAnswerNum setBackgroundImage:[UIImage imageNamed:@"yuntu_practise_bg_n"] forState:UIControlStateNormal];
        [_btnAnswerNum setTitle:[NSString stringWithFormat:@"%zd",[_questionItem.QNum integerValue]] forState:UIControlStateNormal];
    }
}


@end
