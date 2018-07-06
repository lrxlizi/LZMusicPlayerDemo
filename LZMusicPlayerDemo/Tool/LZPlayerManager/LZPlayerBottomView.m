//
//  LZPlayerBottomView.m
//  LZMusicPlayerDemo
//
//  Created by 栗子 on 2017/12/20.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/.     https://github.com/lrxlizi/. All rights reserved.
//
#define ksingerWH  44.0f
#define kbtnWH     35.0f
#define kToolBarH  65.0f

#import "LZPlayerBottomView.h"

@implementation LZPlayerBottomView
+(instancetype)lzPlayerBottomView{
    static LZPlayerBottomView *bottomBarView=nil;
    static dispatch_once_t onceToken;
   
    dispatch_once(&onceToken, ^{
        if (!bottomBarView) {
            bottomBarView=[[LZPlayerBottomView alloc]initWithFrame:CGRectMake(0, LZSCREENH-kToolBarH, LZSCREENW, kToolBarH)];
        }
    });
    return bottomBarView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubviews];
    }
    return self;
}

#pragma mark 布局
-(void)addSubviews{
    
    self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.7];

    /*封面头像*/
    _headerIV=[[UIImageView alloc]init];
    [self addSubview:_headerIV];
    [_headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(3);
        make.size.mas_equalTo(CGSizeMake(ksingerWH, ksingerWH));
        
    }];
    _headerIV.image=[UIImage imageNamed:@"musicicon"];
    _headerIV.layer.masksToBounds=YES;
    _headerIV.layer.cornerRadius=ksingerWH/2;
    //进度条
    self.progressSlider=[[UISlider alloc]init];
    [self addSubview:self.progressSlider];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.equalTo(self.headerIV.mas_right).offset(10);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(5);
    }];
    self.progressSlider.maximumTrackTintColor = [UIColor grayColor];
    self.progressSlider.minimumTrackTintColor = [UIColor colorWithRed:255 / 255.0 green:209 / 255.0 blue:2 / 255.0 alpha:1.0];
    [self.progressSlider setThumbImage:[UIImage new] forState:UIControlStateNormal];
    [self.progressSlider setThumbImage:[UIImage new] forState:UIControlStateHighlighted];
    self.progressSlider.value=0;

    //下一首
    self.nextBtn=[[UIButton alloc]init];
    [self addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo((kToolBarH - kbtnWH+15)/2);
        make.size.mas_equalTo(CGSizeMake(kbtnWH, kbtnWH));
    }];
    [self.nextBtn setImage:[UIImage imageNamed:@"icons_next_music1"] forState:UIControlStateNormal];
    [self.nextBtn setImage:[UIImage imageNamed:@"icons_next_music1"] forState:UIControlStateHighlighted];
    [self.nextBtn addTarget:self action:@selector(nextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //暂停播放
    self.playAndPauseBtn=[[UIButton alloc]init];
    [self addSubview:self.playAndPauseBtn];
    [self.playAndPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nextBtn.mas_left).offset(-15);
        make.top.equalTo(self.nextBtn);
        make.size.mas_equalTo(CGSizeMake(kbtnWH, kbtnWH));
    }];
    [self.playAndPauseBtn  setImage:[UIImage imageNamed:@"icons_play_music1"] forState:(UIControlStateNormal)];
    [self.playAndPauseBtn addTarget:self action:@selector(playAndPauseBtnClicekd:) forControlEvents:UIControlEventTouchUpInside];
    
    //歌名
    self.songNameLB=[[UILabel alloc]init];
    [self addSubview:self.songNameLB];
    [self.songNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(10);
        make.top.equalTo(self.progressSlider.mas_bottom).offset(5);
        make.right.equalTo(self.playAndPauseBtn.mas_left).offset(-3);
        make.height.mas_equalTo(17);
    }];
    self.songNameLB.text=@"SongName";
    self.songNameLB.textColor=LZColor(0xCD, 0XA2, 0X25,1);
    self.songNameLB.font=[UIFont systemFontOfSize:15];
    //歌手名
    self.songerLB=[[UILabel alloc]init];
    [self addSubview:self.songerLB];
    [self.songerLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.songNameLB.mas_bottom).offset(3);
        make.left.equalTo(self.songNameLB);
        make.right.equalTo(self.songNameLB);
        make.height.mas_equalTo(15);
        
    }];
    self.songerLB.text = @"songer";
    self.songerLB.font=[UIFont systemFontOfSize:12];
    self.songerLB.textColor=LZColor(142, 138, 138,1);
    //跳转按钮
    self.jumpBtn = [[UIButton alloc]init];
    [self addSubview:self.jumpBtn];
    [self.jumpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.songNameLB);
        make.right.equalTo(self.songNameLB);
        make.top.bottom.mas_offset(0);
    }];
    
    LZPlayerManager *manager = [LZPlayerManager lzPlayerManager];
    manager.isStartPlayer = ^(NSInteger index) {//0是开始 1 暂停
        if (index==0) {//开启定时器
             [self startTimer];
            //存储歌曲总时间
            long long int totalTime = [LZPlayerManager lzPlayerManager].player.currentItem.duration.value / [LZPlayerManager lzPlayerManager].player.currentItem.duration.timescale;
            NSString *str = [NSString stringWithFormat:@"%lld",totalTime];
            LZUserDefaultsSET(str, TOTALTIME);
            LZUserDefaultsSynchronize;
        }else if(index==1){
        }else{
            
        }
    };
    
    //监听耳机事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];
}
#pragma mark 监听耳机事件
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            NSLog(@"AVAudioSessionRouteChangeReasonNewDeviceAvailable");
            NSLog(@"耳机插入");
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            [self stop];
            NSLog(@"耳机拔出，停止播放操作");
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}
//耳机拔出，停止播放
- (void)stop{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[LZPlayerManager lzPlayerManager] playAndPause];
        [LZPlayerBottomView lzPlayerBottomView].isSongPlayer = NO;
    });
}

#pragma mark 下一首按钮点击
-(void)nextBtnClicked:(UIButton *)btn{
    
    if ([LZPlayerManager lzPlayerManager].isPlay) {
        [[LZPlayerManager lzPlayerManager] playNext];
        [self reloadDataWithIndex:[LZPlayerManager lzPlayerManager].index];
    }
    [LZSignSongIdSimple lzSignSongIdSimple].isFirstClickedListPlayer=0;//第一次点击列表播放

}
#pragma mark 上一首按钮点击
-(void)previousBtnClicked:(UIButton *)btn{
    
    [[LZPlayerManager lzPlayerManager] playPrevious];
    [self reloadDataWithIndex:[LZPlayerManager lzPlayerManager].index];
    
}
#pragma 播放暂停点击事件(底部和详情页共用)
-(void)playAndPauseBtnClicekd:(UIButton *)btn{
    
    if ([LZPlayerManager lzPlayerManager].isPlay) {
        [btn setImage:[UIImage imageNamed:@"icons_play_music1"] forState:(UIControlStateNormal)];
        [self.playAndPauseBtn setImage:[UIImage imageNamed:@"icons_play_music1"] forState:(UIControlStateNormal)];
    }else{
        [btn setImage:[UIImage imageNamed:@"icons_stop_music1"] forState:(UIControlStateNormal)];
        [self.playAndPauseBtn setImage:[UIImage imageNamed:@"icons_stop_music1"] forState:(UIControlStateNormal)];
         
    }
    if ([LZPlayerManager lzPlayerManager].isFristPlayerPauseBtn==NO) {
        [self reloadDataWithIndex:0];//标记是不是没点列表直接点了播放按钮如果是就默认播放按钮
    }else{
        [[LZPlayerManager lzPlayerManager] playAndPause];
    }
    [LZSignSongIdSimple lzSignSongIdSimple].isFirstClickedListPlayer=0;
    
}
//是否在播放歌曲(主要作用是替换播放暂停按钮的图片)
-(void)setIsSongPlayer:(BOOL)isSongPlayer{
    
    if (isSongPlayer) {
         [self.playAndPauseBtn setImage:[UIImage imageNamed:@"icons_stop_music1"] forState:(UIControlStateNormal)];
    }else{
         [self.playAndPauseBtn setImage:[UIImage imageNamed:@"icons_play_music1"] forState:(UIControlStateNormal)];
    }
}
#pragma mark 定时器
//开启定时器
-(void)startTimer{
    self.timer =[NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(timerAct) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
//关闭定时器
-(void)stopTimer{
    
    [self.timer invalidate];
    self.timer = nil;
}
//执行定时器
-(void)timerAct{
    
    if ([LZPlayerManager lzPlayerManager].player.currentTime.timescale == 0 || [LZPlayerManager lzPlayerManager].player.currentItem.duration.timescale == 0 ) {
        return;
    }
    // 获得当前时间
    long long int currentTime = [LZPlayerManager lzPlayerManager].player.currentTime.value / [LZPlayerManager lzPlayerManager].player.currentTime.timescale;
    
    // 获得音乐总时长
    long long int totalTime = [LZPlayerManager lzPlayerManager].player.currentItem.duration.value / [LZPlayerManager lzPlayerManager].player.currentItem.duration.timescale;
    NSString *str = [NSString stringWithFormat:@"%lld",totalTime];
    //存储歌曲总时间
    LZUserDefaultsSET(str, TOTALTIME);
    LZUserDefaultsSynchronize;
    self.progressSlider.maximumValue = totalTime;
    self.progressSlider.minimumValue = 0;
    self.progressSlider.value = currentTime;//当前播放进度
    
    if (self.progressSlider.value == totalTime) {//如果progressSlider的值=总时长 就直接下一首(或者单曲循环)
        [self autoNext];
    }
    if ([LZPlayerManager lzPlayerManager].isPlay) {//正在播放歌曲时头像转动
        [UIView beginAnimations:@"rzoration" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.headerIV.transform = CGAffineTransformRotate(self.headerIV.transform, 0.02);
        [UIView commitAnimations];
    }
}

#pragma mark 自动下一首或者是单曲循环
-(void)autoNext{
    
    if ([LZPlayerBottomView lzPlayerBottomView].isSinglecycle) {//单曲循环
        [self reloadDataWithIndex:[LZPlayerManager lzPlayerManager].index];
    }else{
        [[LZPlayerManager lzPlayerManager] playNext];
        [self reloadDataWithIndex:[LZPlayerManager lzPlayerManager].index];
    }
   
}

#pragma mark 播放时调用
- (void)reloadDataWithIndex:(NSInteger)index
{
    //读取歌曲的总时间
    NSString *time = [NSString stringWithFormat:@"%@",LZUserDefaultsGET(TOTALTIME)];
    [LZPlayerManager lzPlayerManager].isFristPlayerPauseBtn = YES;
    // 寻找model
    LZPlayerModel *model = [LZPlayerManager lzPlayerManager].musicArray[index];
    [LZSignSongIdSimple lzSignSongIdSimple].songID = [NSString stringWithFormat:@"%@",model.trackId];
    if (self.reloadBlock) {
        self.reloadBlock();
    }
    if ([LZSignSongIdSimple lzSignSongIdSimple].isFirstClickedListPlayer==0) {//第一次点击列表播放
        if ([LZPlayerManager lzPlayerManager].isStartPlayer) {
            [LZPlayerManager lzPlayerManager].isStartPlayer(0);
        }
    }
    [LZSignSongIdSimple lzSignSongIdSimple].isFirstClickedListPlayer = 1;
    // 改变图片 标题 音频
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:model.coverLarge] placeholderImage:[UIImage imageNamed:@"musicicon"]];
    NSString *nick = [NSString stringWithFormat:@"%@",model.nickname];
    self.songerLB.text = [HealpClass isNullOrNilWithObject:nick] ? @"" : nick;
    NSString *title = [NSString stringWithFormat:@"%@",model.title];
    self.songNameLB.text = [HealpClass isNullOrNilWithObject:title] ? @"" : title;
    // 修改播放歌曲
    [[LZPlayerManager lzPlayerManager] replaceItemWithUrlString:model.playUrl32];
    [self lockScreen:time];
    //修改进度
    self.progressSlider.minimumValue = 0;
}

#pragma mark 锁屏传值
-(void)lockScreen:(NSString *)totalTime{
    NSNumber *time = [NSNumber numberWithDouble:[totalTime doubleValue]];
    if ([LZPlayerManager lzPlayerManager].musicArray.count) {
        LZPlayerModel *model = [LZPlayerManager lzPlayerManager].musicArray[[LZPlayerManager lzPlayerManager].index];
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        //设置歌曲时长
        [info setObject:time forKey:MPMediaItemPropertyPlaybackDuration];
        [info setObject:[NSNumber numberWithDouble:0] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        //设置歌曲名
        info[MPMediaItemPropertyTitle] = model.title;
        //演唱者
        [info setObject:model.nickname forKey:MPMediaItemPropertyArtist];
        //设置歌手头像
        NSString *str=[NSString stringWithFormat:@"%@",model.coverLarge];
        NSString *url=[str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        //设置歌手头像
        if ([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]]) {
            MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]]];
            info[MPMediaItemPropertyArtwork] = artwork;
        }
         [info setObject:[NSNumber numberWithFloat:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];//进度光标的速度 （这个随 自己的播放速率调整，我默认是原速播放）
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo =  info;
        //更新字典
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:info];
    }
}

@end
