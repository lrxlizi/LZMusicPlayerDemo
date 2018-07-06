//
//  LZMusicDetailVIewController.h
//  LZMusicPlayerDemo
//
//  Created by 栗子 on 2017/12/22.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/.     https://github.com/lrxlizi/. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZMusicDetailVIewController : UIViewController
//返回按钮
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
//歌曲名
@property (weak, nonatomic) IBOutlet UILabel *songLB;
//歌手名
@property (weak, nonatomic) IBOutlet UILabel *songerLB;
//背景高斯模糊图片
@property (weak, nonatomic) IBOutlet UIImageView *bgImageVIew;
//歌曲icon(中间转圈的图片)
@property (weak, nonatomic) IBOutlet UIImageView *songIcon;
//当前播放时间
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLB;
//总时间
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLB;
//歌曲播放进度条
@property (weak, nonatomic) IBOutlet UISlider *sliderProgress;
//最近播放按钮
@property (weak, nonatomic) IBOutlet UIButton *singlecycleBtn;
//上一首按钮
@property (weak, nonatomic) IBOutlet UIButton *previousBtn;
//播放和暂停按钮
@property (weak, nonatomic) IBOutlet UIButton *playAndPauseBtn;
//下一首按钮
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end
