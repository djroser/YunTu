//
//  answeredCollectionCell.h
//  YunTu
//
//  Created by 丁健 on 16/3/9.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTQuestionItem.h"

@interface answeredCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnAnswerNum;

@property (strong, nonatomic) YTQuestionItem *questionItem;

@end
