//
//  HealpClass.h
//  LZMusicPlayerDemo
//
//  Created by 栗子 on 2017/12/22.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/.     https://github.com/lrxlizi/. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealpClass : NSObject
/*
 设置毛玻璃效果
 */
+(void)blurEffrct:(UIView *)view;
//清空子视图(毛玻璃图片和头像图片)
+(void)cleaSubView:(UIView *)view;
//计算文本的宽度
+ (float)getStringWidth:(NSString *)text andFont:(float)font;
//判断是否为空
+ (BOOL)isNullOrNilWithObject:(id)object;
@end
