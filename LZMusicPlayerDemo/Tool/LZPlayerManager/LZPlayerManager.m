//
//  LZPlayerManager.m
//  LZMusicPlayerDemo
//
//  Created by 栗子 on 2017/12/20.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/.     https://github.com/lrxlizi/. All rights reserved.
//

#import "LZPlayerManager.h"

static LZPlayerManager *_lzPlayerManager = nil;

@implementation LZPlayerManager

+(instancetype)lzPlayerManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _lzPlayerManager = [[LZPlayerManager alloc]init];
        
    });
    return _lzPlayerManager;
}
/*初始化播放器*/
- (instancetype)init
{
    if (self = [super init]) {
        _player = [[AVPlayer alloc] init];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session  setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
    }
    return self;
}

// 播放
- (void)playerPlay
{
    [_player play];
    _isPlay = YES;
    
}
//暂停
- (void)playerPause
{
    [_player pause];
    _isPlay = NO;
  
}
//播放和暂停
- (void)playAndPause
{
    if (self.isPlay) {
        [self playerPause];
        if (self.isStartPlayer) {
            self.isStartPlayer(1);
        }
    }else{
        [self playerPlay];
        if (self.isStartPlayer) {
            self.isStartPlayer(0);
        }
    }
}
//前一首
- (void)playPrevious
{
    if (self.index == 0) {
        self.index = self.musicArray.count - 1;
    }else{
        self.index--;
    }
}
//下一首
- (void)playNext
{
    if (self.index == self.musicArray.count - 1) {
        self.index = 0;
    }else{
        self.index++;
    }
}

//音量
- (void)playerVolumeWithVolumeFloat:(CGFloat)volumeFloat
{
    self.player.volume = volumeFloat;
}
//进度
- (void)playerProgressWithProgressFloat:(CGFloat)progressFloat
{
    [self.player seekToTime:CMTimeMakeWithSeconds(progressFloat, 1) completionHandler:^(BOOL finished) {
        [self playerPlay];
    }];
}
//当前播放
- (void)replaceItemWithUrlString:(NSString *)urlString
{

   __block NSURL *url ;
   __block AVPlayerItem *item;
    [self localUrlIsSave:urlString save:^(NSString *str) {//已下载播放本地文件
        url  = [NSURL fileURLWithPath:str];
        AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:url options:nil];
        item = [AVPlayerItem playerItemWithAsset:movieAsset];
    } noSave:^{//未下载
        url  = [NSURL URLWithString:urlString];
        item = [[AVPlayerItem alloc] initWithURL:url];
    }];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self playerPlay];
    
}

//判断音乐是不是已经下载到本地
- (void)localUrlIsSave:(NSString *)url save:(void(^)(NSString *str))fileStr noSave:(void(^)(void))toDownLoad{
    
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *str        = [url lastPathComponent];//截取文件名wKgDa1ZfFi-gRNYMABuxsyS4ea4688.mp3
    NSString *filePath   = [NSString stringWithFormat:@"%@/%@",docDirPath,str];
    BOOL isHave          = [[NSFileManager defaultManager] fileExistsAtPath:filePath];//判断是不是已经存在
    if (isHave) {
        fileStr(filePath);//播放本地文件
    }else{
        //没下载去下载
        [LZNetWorking downLoadUrlString:url returnStr:^(NSString *data) {
            
        }];
        toDownLoad();//没下载去播放未下载的文件
    }
    
}

@end
