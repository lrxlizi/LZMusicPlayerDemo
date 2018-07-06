//
//  LZPlayerModel.h
//  LZMusicPlayerDemo
//
//  Created by 栗子 on 2017/12/20.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/.     https://github.com/lrxlizi/. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZPlayerModel : NSObject
// 图片
@property (nonatomic, copy) NSString *coverLarge;
// 音乐地址
@property (nonatomic, copy) NSString *playUrl32;
// 标题
@property (nonatomic, strong) NSString *title;
//歌手名字
@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *trackId;

@end
