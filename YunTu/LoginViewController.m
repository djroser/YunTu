//
//  LoginViewController.m
//  CarBaDa
//
//  Created by Zayn on 15/6/11.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import "LoginViewController.h"
#import "YTGlobal.h"
#import "AppUtil.h"
#import "Pods/AFNetworking/AFNetworking/AFNetworking.h"
#import "UserInfo.h"
#import <MBProgressHUD.h>

@interface LoginViewController ()
@end

@implementation LoginViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    [self createBaseView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _btnRegister.hidden=NO;
}


- (void)createBaseView{
    self.navigationItem.leftBarButtonItem = [AppUtil leftBarItemWithTarget:self action:@selector(popBack)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_btnRegister];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //button
    UIImage *imgRest = [UIImage imageNamed:@"btn_action_common_rest"];
    UIImage *imgDisable = [UIImage imageNamed:@"btn_action_common_disable"];
    UIImage *imgPressed = [UIImage imageNamed:@"btn_action_common_pressed"];
    UIEdgeInsets edge=UIEdgeInsetsMake(10, 10, 10, 10);
    imgDisable = [imgDisable resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    imgRest = [imgRest resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    imgPressed = [imgPressed resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    
    //bus
    [_btnSumbit setBackgroundImage:imgRest forState:UIControlStateNormal];
    [_btnSumbit setBackgroundImage:imgPressed forState:UIControlStateHighlighted];
    [_btnSumbit setBackgroundImage:imgDisable forState:UIControlStateDisabled];
}


#pragma mark - Button Event
- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)didPressedRegister:(id)sender
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    registerVC.delegate = self;
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)didPressLogin:(id)sender {
    NSString *sErrorMsg = @"";
    if (_txtMobile.text.length <= 0) {
        sErrorMsg = txt_Sign_NoUserName;//@"手机号不能为空"
        
    }
    else if (_txtPwd.text.length <= 0) {
        sErrorMsg = txt_Sign_NoPassWord;//@"密码不能为空"
    }
    
    if (sErrorMsg.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:sErrorMsg
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
    } else {
        [self initRequestLogin];
    }
}

- (IBAction)didPressForgetPWD:(id)sender
{
//    [AppDelegateEntity event:@"cbd_025" tag:enumUmen_1_0_0 label:@"wangjimima"];
//    ForgetPwdViewController *vc = [[ForgetPwdViewController alloc] initWithNibName:@"ForgetPwdViewController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)done:(UITextField*)sender
{
    [sender resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _txtMobile) {
        if (string.length <= 0) {
            return YES;
        } else {
            if (textField.text.length >= 11) {
                return NO;
            } else {
                return YES;
            }
        }

    }
    return YES;
}

-(void)didUserRegisterDone
{
    [self.navigationController popViewControllerAnimated:NO];
}

//点键盘外部endEditing
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    if (touch.tapCount >= 1) {
        [self.view endEditing:YES];
    }
}

- (void)initRequestLogin{
    __weak typeof(self) WeakSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"stuNum"] = _txtMobile.text;
    paras[@"stuPwd"] = _txtPwd.text;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在登录";
    // 设置图片
//    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    [manager GET:YTUserLoginUrl parameters:paras success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [hud hide:YES];
        [WeakSelf.navigationController popViewControllerAnimated:YES];
        if (WeakSelf.delegate && [WeakSelf.delegate respondsToSelector:@selector(didLoginDone)]) {
            [UserInfo sharedInstance].stuNum = _txtMobile.text;
            [UserInfo sharedInstance].stuName = _txtPwd.text;
            [WeakSelf.delegate didLoginDone];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"登录失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
}


@end
