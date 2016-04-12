//
//  userRegisterViewController.m
//  CarBaDa
//
//  Created by Zayn on 15/6/11.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController (){
    int ipage;//注册进行中的页数
}

@property (nonatomic,strong) UIImage *imgBtnDisable;
@property (nonatomic,strong) UIImage *imgBtnEnable;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSDate *beginDate;

-(void)createBaseView;
-(void)createScrollerContent;
-(void)loadDefaultData;
-(NSString*)validatePWD;
-(void)refreshTitleColor:(NSUInteger)index;
-(void)sendVerifyCode;

@end

@implementation RegisterViewController
@synthesize delegate;

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self createBaseView];
//    [self loadDefaultData];
//    // Do any additional setup after loading the view from its nib.
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//-(void)createBaseView
//{
//    [AppDelegateEntity event:@"cbd_026" tag:enumUmen_1_0_0 label:@"shoujihao"];
//    self.title = @"注册";
//    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:_btnBack];
//    self.navigationItem.leftBarButtonItem = leftBar;
//    
//    [self createScrollerContent];
//    
//    _btnFirstNext.enabled = NO;
//    _btnSecondNext.enabled = NO;
//    //_btnThirdNext.enabled = NO;
//    
//    [_txtMobileFirst becomeFirstResponder];
//}
//
//-(void)createScrollerContent
//{
//    //SCREEN_WIDTH
//    [_viewStepFirst setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _viewStepFirst.frame.size.height)];
//    [_viewStepSecond setFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, _viewStepSecond.frame.size.height)];
//    [_viewStepThird setFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, _viewStepThird.frame.size.height)];
//    
//    [_contentScroller addSubview:_viewStepFirst];
//    [_contentScroller addSubview:_viewStepSecond];
//    [_contentScroller addSubview:_viewStepThird];
//    
//    [_contentScroller setContentSize:CGSizeMake(SCREEN_WIDTH*3, 200)];
//    
//    UIImage *imgRest = [UIImage imageNamed:@"btn_action_common_rest"];
//    UIImage *imgDisable = [UIImage imageNamed:@"btn_action_common_disable"];
//    UIImage *imgEnable = [UIImage imageNamed:@"btn_action_common_pressed"];
//    
//    UIEdgeInsets edge=UIEdgeInsetsMake(10, 10, 10,10);
//    imgDisable= [imgDisable resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
//    imgEnable= [imgEnable resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
//    imgRest= [imgRest resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
//
//    [_btnFirstNext setBackgroundImage:imgRest forState:UIControlStateNormal];
//    [_btnSecondNext setBackgroundImage:imgRest forState:UIControlStateNormal];
//    [_btnThirdNext setBackgroundImage:imgRest forState:UIControlStateNormal];
//    
//    [_btnFirstNext setBackgroundImage:imgEnable forState:UIControlStateHighlighted];
//    [_btnSecondNext setBackgroundImage:imgEnable forState:UIControlStateHighlighted];
//    [_btnThirdNext setBackgroundImage:imgEnable forState:UIControlStateHighlighted];
//    
//    [_btnFirstNext setBackgroundImage:imgDisable forState:UIControlStateDisabled];
//    [_btnSecondNext setBackgroundImage:imgDisable forState:UIControlStateDisabled];
//    [_btnThirdNext setBackgroundImage:imgDisable forState:UIControlStateDisabled];
//    
//    [self refreshTitleColor:0];
//}
//
//-(void)loadDefaultData
//{
//    ipage = 0;//表示第一页
//}
//
//#pragma mark - TextField Delegate
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField == _txtMobileFirst) {
//        if (string.length == 0) {
//            _btnFirstNext.enabled = NO;
//            return YES;
//        }
//        if(textField.text.length+string.length==11)
//        {
//            _btnFirstNext.enabled = YES;
//            return YES;
//        }else if (textField.text.length+string.length>11)
//        {
//            if(textField.text.length<=10)
//            {
//                textField.text=[NSString stringWithFormat:@"%@%@",textField.text,[string substringToIndex:(11-textField.text.length)]];
//                _btnFirstNext.enabled = YES;
//            }
//            return NO;
//        }else
//        {
//            _btnFirstNext.enabled = NO;
//            return YES;
//        }
//    }
//    else if (textField == _txtPwdSecond) {
//        if (string.length == 0 && textField.text.length <= 1) {
//            [_btnSecondNext setEnabled:NO];
//            return YES;
//        }
//        if (string.length == 0) {
//            return YES;
//        }
//        
//        if (textField.text.length >= 18) {
//            return NO;
//        } else {
//            _btnSecondNext.enabled = YES;
//            return YES;
//        }
//    }
//    return YES;
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField.text.length == 10) {
//        _btnFirstNext.enabled = YES;
//    }
//}
//
//-(void)refreshTitleColor:(NSUInteger)index
//{
//    _lblFirstTitle.textColor = RGBA(102, 102, 102, 1);
//    _lblSecondTitle.textColor = RGBA(102, 102, 102, 1);
//    _lblThird.textColor = RGBA(102, 102, 102, 1);
//    
//    switch (index) {
//        case 0:
//            _lblFirstTitle.textColor = def_color_Blue;
//            break;
//        case 1:
//            _lblSecondTitle.textColor = def_color_Blue;
//            break;
//        case 2:
//            _lblThird.textColor = def_color_Blue;
//            break;
//            
//        default:
//            break;
//    }
//}
//
//#pragma mark - IBAction
//
//- (IBAction)didPressedSwitch:(id)sender
//{
//    _txtPwdSecond.secureTextEntry = !_switchPwd.on;
//}
//
//- (IBAction)didPressedFirstNext:(id)sender
//{
//    if (_txtMobileFirst.text > 0 && [Utility isPhoneNumber:_txtMobileFirst.text]) {
//        [TCTRequestAlert showWithMessage:@"正在查询信息" withRequest:nil needCancel:YES];
//        RequestCheckmobile *req = [[RequestCheckmobile alloc] init];
//        req.mobileNo = _txtMobileFirst.text;
//        [req startWithSuccessBlock:^(id responseObject, NSDictionary *options) {
//            ResponseCheckmobile *response = (ResponseCheckmobile*)responseObject;
//            if ([response.isSuccess integerValue] == 1) {
//                [TCTRequestAlert hide:YES];
//                [_txtMobileFirst resignFirstResponder];
//                [self performSelector:@selector(txtBecomFirstResponder:) withObject:_txtPwdSecond afterDelay:0.5];
//                [_contentScroller setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
//                [self refreshTitleColor:1];
//                ipage = 1;
//                [AppDelegateEntity event:@"cbd_026" tag:enumUmen_1_0_0 label:@"mima"];
//            } else {
//                [TCTRequestAlert hide:YES];
//                //手机号已存在
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                message:txt_UpMobile_Exists
//                                                               delegate:self
//                                                      cancelButtonTitle:@"确定"
//                                                      otherButtonTitles:nil];//@"手机号已存在"
//                [alert show];
//            }
//            
//            _txtMobileSecond.text = _txtMobileFirst.text;
//        } failBlock:^(TCTNetworkError *error, NSDictionary *options) {
//            [TCTRequestAlert hide:YES];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                            message:error.description
//                                                           delegate:self
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//            [alert show];
//            NSDebugLog(@"error %@",error.description);
//        }];
//    }else {
//        _txtMobileFirst.text = nil;
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
//                                                        message:txt_Registered_ErrMobile
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil, nil];//@"请输入正确的手机号码"
//        
//        [alert show];
//    }
//}
//
//- (IBAction)didPressedSecondNext:(id)sender
//{
//    NSString *sError = [self validatePWD];
//    if (sError.length > 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                        message:sError
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//    } else {
//        [AppDelegateEntity event:@"cbd_026" tag:enumUmen_1_0_0 label:@"huoquyzm"];
//        [_txtPwdSecond resignFirstResponder];
//        [_contentScroller setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
//        [self performSelector:@selector(txtBecomFirstResponder:) withObject:_txtVerifyCode afterDelay:0.5];
//        [self refreshTitleColor:2];
//        ipage = 2;
//        [self sendVerifyCode];
//    }
//}
//
//- (NSString*)validatePWD
//{
//    NSString* message = nil;
//    //正则判断密码规则
//    if (![_txtPwdSecond.text isMatchedByRegex:@"^[0-9a-zA-Z]{6,18}$"]) {
//        message = @"请输入6-18位字母或数字";
//    }
////    if (_txtPwdSecond.text.length<6 || _txtPwdSecond.text.length > 18) {
////        message = @"请输入6-18位字母或数字";
////    }
//    return message;
//}
//
//- (IBAction)didPressedThirdNext:(id)sender
//{
//    [AppDelegateEntity event:@"cbd_026" tag:enumUmen_1_0_0 label:@"zhuce"];
//    if (_txtVerifyCode.text.length > 0 ) {
//        RequestRegisterMember *request = [[RequestRegisterMember alloc] init];
//        request.mobileNo = _txtMobileFirst.text;
//        request.password = [NSString tc_aesEncryptAndBase64EncodeByCBD:_txtPwdSecond.text withKey:SelectKey_PWD];
//        request.tokenCode = _txtVerifyCode.text;
//        request.resetCert = @"";
//        [request startWithSuccessBlock:^(id responseObject, NSDictionary *options) {
//            ResponseRegisterMember *response = (ResponseRegisterMember*)responseObject;
//            [UserMember getInstance].isLogin = YES;
//            [UserMember getInstance].memberId = response.memberId;
//            [UserMember getInstance].userInfoObj = [[UserInfoObj alloc] initWithRegisterMember:response];
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                            message:@"注册成功"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//            alert.tag = 112;
//            [alert show];
//            
//        } failBlock:^(TCTNetworkError *error, NSDictionary *options) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                            message:error.description
//                                                           delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alert show];
//        }];
//    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                        message:txt_Registered_NoValidate
//                                                       delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];//@"验证码不能为空"
//        [alert show];
//    }
//}
//
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag == 112) {
//        //注册成功
//        [_txtVerifyCode resignFirstResponder];
//        [self.timer invalidate];
//        self.timer=nil;
//        [self.navigationController popViewControllerAnimated:NO];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(didUserRegisterDone)]) {
//            [self.delegate didUserRegisterDone];
//        }
//    }
//}
//
//- (IBAction)didPressedSendVerifyCode:(id)sender
//{
//    [self sendVerifyCode];
//}
//
//-(void)sendVerifyCode
//{
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshVerifyCode) userInfo:nil repeats:YES];
//    self.beginDate = [NSDate date];
//    [self.timer fire];
//    _btnSendVerifyCode.enabled = NO;
//    RequestGetVerifyCode *request = [[RequestGetVerifyCode alloc] init];
//    request.mobileNo = _txtMobileSecond.text;
//    //注册写死1
//    request.typeId = @"1";
//    [request startWithSuccessBlock:^(id responseObject, NSDictionary *options) {
//        _lblVerifyCodeMsg.text = [NSString stringWithFormat:@"已发送短信到%@",_txtMobileFirst.text];
//    } failBlock:^(TCTNetworkError *error, NSDictionary *options) {
//        NSDebugLog(@"code error %@",error.description);
//    }];
//}
//
//-(void)refreshVerifyCode
//{
//    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] - [self.beginDate timeIntervalSince1970];
//    NSInteger second = 60-time;
//    NSDebugLog(@"time %f",time);
//    if (second <= 0) {
//        [self.timer invalidate];
//        [_btnSendVerifyCode setTitle:@"发送验证码" forState:UIControlStateNormal];
//        _btnSendVerifyCode.enabled = YES;
//    } else {
//        _btnSendVerifyCode.titleLabel.text = [NSString stringWithFormat:@"%ld秒后重发",(long)second];
//        [_btnSendVerifyCode setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)second] forState:UIControlStateNormal];
//    }
//    
//}
//
//- (IBAction)didPressedBack:(id)sender
//{
//    if (ipage > 0) {
//        [_contentScroller setContentOffset:CGPointMake(SCREEN_WIDTH*(ipage-1), 0) animated:YES];
//        ipage -=1;
//    }else {
//        [self.timer invalidate];
//        self.timer=nil;
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}
//
//- (IBAction)didPressToAttention:(id)sender {
//    ShuttleBusViewController *webVC = [[ShuttleBusViewController alloc] initWithNibName:@"ShuttleBusViewController" bundle:nil];
//    webVC.sOpenWebUrl = [RegisterHelpUrl H5WebUrlWithString];
//    webVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:webVC animated:YES];
//    
//}
//
////-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
////{
////    NSInteger page = scrollView.contentOffset.y/SCREEN_WIDTH;
////    switch (page) {
////        case 0:
////            [self txtBecomFirstResponder:_txtMobileFirst];
////            break;
////        case 1:
////            [self txtBecomFirstResponder:_txtPwdSecond];
////            break;
////        case 2:
////            [self txtBecomFirstResponder:_txtVerifyCode];
////            break;
////            
////        default:
////            break;
////    }
////}
//
//
//-(void)txtBecomFirstResponder:(UITextField*)txt
//{
//    [txt becomeFirstResponder];
//}
@end
