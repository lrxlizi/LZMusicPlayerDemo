//
//  LZSignSongIdSimple.h
//  LZMusicPlayerDemo
//
//  Created by 栗子 on 2017/12/20.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/.     https://github.com/lrxlizi/. All rights reserved.
//

/**
 标记歌曲id
 */
#import <Foundation/Foundation.h>

@interface LZSignSongIdSimple : NSObject

+(instancetype)lzSignSongIdSimple;
@property (nonatomic, copy) NSString *songID;
@property (nonatomic, assign) NSInteger isFirstClickedListPlayer;//第一次点击列表播放



@end
