//
//  userRegisterViewController.m
//  CarBaDa
//
//  Created by Zayn on 15/6/11.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppUtil.h"
#import "YTGlobal.h"
#import "Pods/AFNetworking/AFNetworking/AFNetworking.h"
#import "UserInfo.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBaseView];
    [self loadDefaultData];
}

-(void)createBaseView
{
    self.title = @"注册";
    self.navigationItem.leftBarButtonItem = [AppUtil leftBarItemWithTarget:self action:@selector(popBack)];
    
    //button
    UIImage *imgRest = [UIImage imageNamed:@"btn_action_common_rest"];
    UIImage *imgDisable = [UIImage imageNamed:@"btn_action_common_disable"];
    UIImage *imgPressed = [UIImage imageNamed:@"btn_action_common_pressed"];
    UIEdgeInsets edge=UIEdgeInsetsMake(10, 10, 10, 10);
    imgDisable = [imgDisable resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    imgRest = [imgRest resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    imgPressed = [imgPressed resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    [_btnRegisterUser setBackgroundImage:imgRest forState:UIControlStateNormal];
    [_btnRegisterUser setBackgroundImage:imgPressed forState:UIControlStateHighlighted];
    [_btnRegisterUser setBackgroundImage:imgDisable forState:UIControlStateDisabled];
    
//    [_txtMobileFirst becomeFirstResponder];
}
-(void)loadDefaultData
{
    
}

- (void)initRequestRegister
{
    __weak typeof(self) WeakSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    AFJSONResponseSerializer *jsonReponseSerializer = [AFJSONResponseSerializer serializer];
    // This will make the AFJSONResponseSerializer accept any content type
    jsonReponseSerializer.acceptableContentTypes = nil;
    manager.responseSerializer = jsonReponseSerializer;
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"stuNum"] = _txtfStuNum.text;
    paras[@"stuName"] = _txtfStuName.text;
    paras[@"stuMajor"] = _txtfStuMajor.text;
    paras[@"stuPwd"] = _txtfPwd.text;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在注册";
    // 设置图片
    //    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    [manager GET:YTUserRegisterUrl parameters:paras success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [hud hide:YES];
        [WeakSelf.navigationController popViewControllerAnimated:YES];
        if (WeakSelf.delegate && [WeakSelf.delegate respondsToSelector:@selector(didUserRegisterDone)]) {
            [UserInfo sharedInstance].stuNum = _txtfStuNum.text;
            [UserInfo sharedInstance].stuName = _txtfStuName.text;
            [UserInfo sharedInstance].stuMajor = _txtfStuNum.text;
            [WeakSelf.delegate didUserRegisterDone];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"注册失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];

}

//点键盘外部endEditing
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    if (touch.tapCount >= 1) {
        [self.view endEditing:YES];
    }
}

#pragma mark - TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _txtfStuNum) {
        if (string.length == 0) {
            return YES;
        }
        if(textField.text.length+string.length==11)
        {
            return YES;
        }else if (textField.text.length+string.length>11)
        {
            if(textField.text.length<=10)
            {
                textField.text=[NSString stringWithFormat:@"%@%@",textField.text,[string substringToIndex:(11-textField.text.length)]];
            }
            return NO;
        }else
        {
            return YES;
        }
    }
    return YES;
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didPressedRegister:(id)sender {
    NSString *sErrorMsg = @"";
    if (_txtfStuNum.text.length <= 0) {
        sErrorMsg = txt_Sign_NoStuNum;
    }
    else if (_txtfStuName.text.length <= 0) {
        sErrorMsg = txt_Sign_NoStuName;//@"姓名不能为空"
    }
    else if (_txtfStuMajor.text.length <= 0) {
        sErrorMsg = txt_Sign_NoStuMajor;//@"专业不能为空"
    }
    else if (_txtfPwd.text.length <= 0) {
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
        [self initRequestRegister];
    }
}
@end
