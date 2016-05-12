//
//  userRegisterViewController.h
//  CarBaDa
//
//  Created by Zayn on 15/6/11.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol RegisterUserDelegate <NSObject>

-(void)didUserRegisterDone;

@end


@interface RegisterViewController : BaseViewController
<
    UITextFieldDelegate,
    UIScrollViewDelegate,
    UIAlertViewDelegate
>

@property (weak, nonatomic) IBOutlet UITextField *txtfStuNum;
@property (weak, nonatomic) IBOutlet UITextField *txtfStuName;
@property (weak, nonatomic) IBOutlet UITextField *txtfStuMajor;
@property (weak, nonatomic) IBOutlet UITextField *txtfPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnRegisterUser;


@property (nonatomic,weak) id<RegisterUserDelegate> delegate;


- (IBAction)didPressedRegister:(id)sender;


@end


