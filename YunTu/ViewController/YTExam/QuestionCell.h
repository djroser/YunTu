//
//  QuestionCell.h
//  YunTu
//
//  Created by 丁健 on 15/11/3.
//  Copyright © 2015年 丁健. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *questionStatement;
@property (weak, nonatomic) IBOutlet UIImageView *questionView;
@property (weak, nonatomic) IBOutlet UILabel *option1;
@property (weak, nonatomic) IBOutlet UILabel *option2;
@property (weak, nonatomic) IBOutlet UILabel *option3;
@property (weak, nonatomic) IBOutlet UILabel *option4;
@property (weak, nonatomic) IBOutlet UIButton *option1Btn;
@property (weak, nonatomic) IBOutlet UIButton *option2Btn;
@property (weak, nonatomic) IBOutlet UIButton *option3Btn;
@property (weak, nonatomic) IBOutlet UIButton *option4Btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *option1TopContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *option4TopContraint;

@end
