//
//  LZPlayerBottomView.h
//  LZMusicPlayerDemo
//
//  Created by 栗子 on 2017/12/20.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/.     https://github.com/lrxlizi/. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZPlayerModel.h"

typedef void(^reloadData)(void);//刷新页面用(当前播放的歌曲--->歌曲名字颜色改变)

@interface LZPlayerBottomView : UIView

+(instancetype)lzPlayerBottomView;

/*歌手头像*/
@property(nonatomic,strong)UIImageView *headerIV;
/*歌名*/
@property(nonatomic,strong)UILabel     *songNameLB;
/*歌手名*/
@property(nonatomic,strong)UILabel     *songerLB;
/*播放暂停按钮*/
@property(nonatomic,strong)UIButton    *playAndPauseBtn;
/*下一首按钮*/
@property(nonatomic,strong)UIButton    *nextBtn;
/*进度*/
@property(nonatomic,strong)UISlider    *progressSlider;
/*定时器*/
@property(nonatomic,strong)NSTimer     *timer;
/*跳转按钮*/
@property (nonatomic, strong) UIButton *jumpBtn;


- (void)reloadDataWithIndex:(NSInteger)index;
//点击下一首时刷新页面用(当前播放的歌曲--->歌曲名字颜色改变)
@property(nonatomic,copy)void(^reloadBlock)(void);
//是否在播放歌曲(主要作用是替换播放暂停按钮的图片)
@property (nonatomic, assign) BOOL isSongPlayer;
//自动下一首
-(void)autoNext;
//播放暂停
-(void)playAndPauseBtnClicekd:(UIButton *)btn;
//下一首按钮点击
-(void)nextBtnClicked:(UIButton *)btn;
//上一首
-(void)previousBtnClicked:(UIButton *)btn;
//标记是否在单曲循环 (如果是yes是当前这首播放完时自动还从新开始播放)当前播放的
@property (nonatomic, assign) BOOL isSinglecycle;


@end
