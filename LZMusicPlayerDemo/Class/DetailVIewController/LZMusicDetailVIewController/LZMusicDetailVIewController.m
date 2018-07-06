//
//  LZMusicDetailVIewController.m
//  LZMusicPlayerDemo
//
//  Created by 栗子 on 2017/12/22.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/.     https://github.com/lrxlizi/. All rights reserved.
//

#import "LZMusicDetailVIewController.h"

@interface LZMusicDetailVIewController ()

@end

@implementation LZMusicDetailVIewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([LZPlayerBottomView lzPlayerBottomView].isSinglecycle) {
        [self.singlecycleBtn setImage:[UIImage imageNamed:@"singlecycleSel"] forState:UIControlStateNormal];
    }else{
        [self.singlecycleBtn setImage:[UIImage imageNamed:@"singlecycle1"] forState:UIControlStateNormal];
    }
    
    [self initData];
    
}
#pragma mark 初始化
-(void)initData{
    self.songIcon.layer.cornerRadius = 150;
    self.songIcon.layer.masksToBounds = YES;
    [HealpClass blurEffrct:self.bgImageVIew];
    self.sliderProgress.minimumTrackTintColor = [UIColor colorWithRed:255 / 255.0 green:209 / 255.0 blue:2 / 255.0 alpha:1.0];
    [self.sliderProgress setThumbImage:[UIImage imageNamed:@"icon_point1"] forState:UIControlStateNormal];
    NSTimer *timer =[NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(timerAct) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    
}
-(void)timerAct{
  
    UIImage *image = [LZPlayerBottomView lzPlayerBottomView].headerIV.image;
    self.songIcon.image = image;
    self.bgImageVIew.image = image;
   
    self.songLB.text = [NSString stringWithFormat:@"%@",[LZPlayerBottomView lzPlayerBottomView].songNameLB.text];
    self.songerLB.text = [NSString stringWithFormat:@"-- %@ --",[LZPlayerBottomView lzPlayerBottomView].songerLB.text];
    long long int totalTime = [LZPlayerManager lzPlayerManager].player.currentItem.duration.value / [LZPlayerManager lzPlayerManager].player.currentItem.duration.timescale;
    NSString *time = [NSString stringWithFormat:@"%lld",totalTime];
    self.totalTimeLB.text = [NSString stringWithFormat:@"%02ld:%02ld", [time integerValue] / 60, [time integerValue] % 60];;
    self.sliderProgress.maximumValue =[time doubleValue];
    long long int currentTime = [LZPlayerManager lzPlayerManager].player.currentTime.value / [LZPlayerManager lzPlayerManager].player.currentTime.timescale;
    self.currentTimeLB.text = [NSString stringWithFormat:@"%02lld:%02lld", currentTime / 60, currentTime % 60];
    self.sliderProgress.minimumValue = 0;
    self.sliderProgress.value = currentTime;//当前播放进度
    
    if (self.sliderProgress.value == [time integerValue]) {//如果progressSlider的值=总时长 就直接下一首
        [[LZPlayerBottomView lzPlayerBottomView] autoNext];
    }
    if ([LZPlayerManager lzPlayerManager].isPlay) {//正在播放歌曲时头像转动
        [UIView beginAnimations:@"rzoration" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.songIcon.transform = CGAffineTransformRotate(self.songIcon.transform, 0.02);
        [UIView commitAnimations];
    }
}
//返回
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sliderProgress:(id)sender {
    
    [[LZPlayerManager lzPlayerManager]playerProgressWithProgressFloat:((UISlider*)sender).value];
}

//上一首
- (IBAction)previous:(id)sender {
    [[LZPlayerBottomView lzPlayerBottomView] previousBtnClicked:sender];
}
//播放暂停
- (IBAction)playAndPause:(id)sender {
    [[LZPlayerBottomView lzPlayerBottomView] playAndPauseBtnClicekd:sender];
}

//下一首
- (IBAction)nextAction:(id)sender {
    [[LZPlayerBottomView lzPlayerBottomView] nextBtnClicked:sender];
}
//单曲循环
- (IBAction)singlecycle:(UIButton *)sender {

    if ([LZPlayerBottomView lzPlayerBottomView].isSinglecycle) {
        [self.singlecycleBtn setImage:[UIImage imageNamed:@"singlecycle1"] forState:UIControlStateNormal];
    }else{
        [self.singlecycleBtn setImage:[UIImage imageNamed:@"singlecycleSel"] forState:UIControlStateNormal];
    }
    [LZPlayerBottomView lzPlayerBottomView].isSinglecycle = ![LZPlayerBottomView lzPlayerBottomView].isSinglecycle;
}

@end
