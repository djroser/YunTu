//
//  YTLearnViewController.h
//  YunTu
//
//  Created by 丁健 on 16/3/8.
//  Copyright © 2016年 丁健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface YTLearnViewController : BaseViewController
<
AVAudioPlayerDelegate
>
{
    AVAudioPlayer *avAudioPlayer;   //播放器player
    UIProgressView *progressV;      //播放进度
    UISlider *volumeSlider;         //声音控制
    NSTimer *timer;                 //监控音频播放进度
}
@property (weak, nonatomic) IBOutlet UIButton *btnMorphology;
@property (weak, nonatomic) IBOutlet UIButton *btnInternational;


- (IBAction)didPressedMorphology:(id)sender;
- (IBAction)didPressedInternational:(id)sender;

- (IBAction)didPressedStartMusic:(id)sender;
- (IBAction)didPressedStopMusic:(id)sender;

@end
