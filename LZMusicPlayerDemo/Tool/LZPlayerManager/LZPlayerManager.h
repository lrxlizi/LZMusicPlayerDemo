//
//  LZPlayerManager.h
//  LZMusicPlayerDemo
//
//  Created by 栗子 on 2017/12/20.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/.     https://github.com/lrxlizi/. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZPlayerManager : NSObject

/*存放歌曲数组*/
@property (nonatomic, strong) NSMutableArray *musicArray;
/*播放下标*/
@property (nonatomic, assign) NSInteger index;
/*是不是正在播放*/
@property (nonatomic, assign) BOOL isPlay;
/*播放器*/
@property (nonatomic, strong) AVPlayer *player;
/*标记是不是没点列表直接点了播放按钮如果是就默认播放按钮*/
@property (nonatomic, assign) BOOL isFristPlayerPauseBtn;
/*开始播放*/
@property (nonatomic,copy)void(^isStartPlayer)(NSInteger index);//0是开始 1 暂停
/*播放工具单利*/
+(instancetype)lzPlayerManager;
/*播放和暂停*/
- (void)playAndPause;
/*前一首*/
- (void)playPrevious;
/*后一首*/
- (void)playNext;
/*当前播放项*/
- (void)replaceItemWithUrlString:(NSString *)urlString;
/*声音*/
- (void)playerVolumeWithVolumeFloat:(CGFloat)volumeFloat;
/*进度条*/
- (void)playerProgressWithProgressFloat:(CGFloat)progressFloat;


@end
