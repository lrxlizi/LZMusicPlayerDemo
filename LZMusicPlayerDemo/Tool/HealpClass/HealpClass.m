//
//  HealpClass.m
//  LZMusicPlayerDemo
//
//  Created by 栗子 on 2017/12/22.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/.     https://github.com/lrxlizi/. All rights reserved.
//

#import "HealpClass.h"

@implementation HealpClass

//设置毛玻璃效果
+(void)blurEffrct:(UIView *)view{
    UIBlurEffect* effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView* effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame =view.bounds;
    [view addSubview:effectView];
    
}
//清空子视图(毛玻璃图片和头像图片)
+(void)cleaSubView:(UIView *)view{
    for (UIView *sub in view.subviews) {
        [sub removeFromSuperview];
    }
}

//计算文本的宽度
+ (float)getStringWidth:(NSString *)text andFont:(float)font{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    CGSize size = [text boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.width+1;
}
//判断是否为空
+ (BOOL)isNullOrNilWithObject:(id)object
{
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]||[object isEqualToString:@"(null)"]) {
            return YES;
        } else {
            return NO;
        }
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}


@end
