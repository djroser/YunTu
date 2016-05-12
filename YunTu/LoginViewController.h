//
//  LoginViewController.h
//  CarBaDa
//
//  Created by Zayn on 15/6/11.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import "BaseViewController.h"
#import "RegisterViewController.h"
@protocol LoginVCDelegate <NSObject>

-(void)didLoginDone;

@end

@interface LoginViewController : BaseViewController
<
    RegisterUserDelegate
>

@property (nonatomic,weak) id<LoginVCDelegate> delegate;
@property (nonatomic,strong) NSString *sTel;//修改手机号后带过来的手机号码
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtPwd;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIButton *btnSumbit;

-(IBAction)didPressedRegister:(id)sender;

-(IBAction)done:(UITextField*)sender;

@end

