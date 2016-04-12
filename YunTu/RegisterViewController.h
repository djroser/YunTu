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

@property (strong,nonatomic) IBOutlet UIButton *btnBack;

@property (weak, nonatomic) IBOutlet UILabel *lblFirstTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSecondTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblThird;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScroller;



@property (strong, nonatomic) IBOutlet UIView *viewStepFirst;
@property (weak, nonatomic) IBOutlet UITextField *txtMobileFirst;
@property (weak, nonatomic) IBOutlet UIButton *btnFirstNext;

@property (strong, nonatomic) IBOutlet UIView *viewStepSecond;
@property (weak, nonatomic) IBOutlet UITextField *txtMobileSecond;
@property (weak, nonatomic) IBOutlet UITextField *txtPwdSecond;
@property (weak, nonatomic) IBOutlet UISwitch *switchPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnSecondNext;

@property (strong, nonatomic) IBOutlet UIView *viewStepThird;
@property (weak, nonatomic) IBOutlet UITextField *txtVerifyCode;
@property (weak, nonatomic) IBOutlet UIButton *btnThirdNext;
@property (weak, nonatomic) IBOutlet UILabel *lblVerifyCodeMsg;
@property (weak, nonatomic) IBOutlet UIButton *btnSendVerifyCode;

@property (nonatomic,weak) id<RegisterUserDelegate> delegate;


- (IBAction)didPressedFirstNext:(id)sender;
- (IBAction)didPressedSecondNext:(id)sender;
- (IBAction)didPressedThirdNext:(id)sender;
- (IBAction)didPressedSendVerifyCode:(id)sender;
- (IBAction)didPressedSwitch:(id)sender;
- (IBAction)didPressedBack:(id)sender;

- (IBAction)didPressToAttention:(id)sender;

@end


