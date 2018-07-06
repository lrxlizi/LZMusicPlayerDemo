//
//  LZSignSongIdSimple.m
//  LZMusicPlayerDemo
//
//  Created by 栗子 on 2017/12/20.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/.     https://github.com/lrxlizi/. All rights reserved.
//

#import "LZSignSongIdSimple.h"

@implementation LZSignSongIdSimple

+(instancetype)lzSignSongIdSimple{
    static LZSignSongIdSimple *songID = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        songID = [[LZSignSongIdSimple alloc] init];
    });
    return songID;
}

@end
