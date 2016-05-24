//
//  YTLearnViewController.m
//  YunTu
//
//  Created by 丁健 on 16/3/8.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import "YTLearnViewController.h"
#import "WebViewController.h"
#import "YTGlobalKindViewController.h"

@interface YTLearnViewController ()

@end

@implementation YTLearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBaseView];
    [self initMusic];
}

- (void)initMusic
{
    //从bundle路径下读取音频文件
    NSString *string = [[NSBundle mainBundle] pathForResource:@"yunxueMusic" ofType:@"m4a"];
    //把音频文件转换成url格式
    NSURL *url = [NSURL fileURLWithPath:string];
    //初始化音频类 并且添加播放文件
    avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    //设置代理
    avAudioPlayer.delegate = self;
    //设置初始音量大小
    // avAudioPlayer.volume = 1;
    //设置音乐播放次数  -1为一直循环
    avAudioPlayer.numberOfLoops = -1;
    //预播放
    [avAudioPlayer prepareToPlay];
    
    [avAudioPlayer play];
}

- (void)createBaseView
{
    self.title = @"云学";

    UIImage *imgRest = [UIImage imageNamed:@"submit_btn_rest"];
    UIImage *imgPressed = [UIImage imageNamed:@"submit_btn_pressed"];
    UIEdgeInsets edge=UIEdgeInsetsMake(10, 10, 10, 10);
    imgRest = [imgRest resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    imgPressed = [imgPressed resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    [_btnInternational setBackgroundImage:imgRest forState:UIControlStateNormal];
    [_btnInternational setBackgroundImage:imgPressed forState:UIControlStateHighlighted];
    [_btnMorphology setBackgroundImage:imgRest forState:UIControlStateNormal];
    [_btnMorphology setBackgroundImage:imgPressed forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didPressedMorphology:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *webVC = [storyboard instantiateViewControllerWithIdentifier:@"web_view_scene"];
    webVC.title = @"形态学分类法";
    webVC.isAboutYuntu = NO;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)didPressedInternational:(id)sender {
    YTGlobalKindViewController *globalVC = [[YTGlobalKindViewController alloc]initWithNibName:@"YTGlobalKindViewController" bundle:nil];
    globalVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:globalVC animated:YES];
}

- (IBAction)didPressedStartMusic:(id)sender {
    [avAudioPlayer play];
}

- (IBAction)didPressedStopMusic:(id)sender {
    [avAudioPlayer pause];
}
@end
