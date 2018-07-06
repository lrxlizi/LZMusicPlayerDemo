//
//  LZNetWorking.h
//  LZMusicPlayerDemo
//
//  Created by 栗子 on 2017/12/20.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/.     https://github.com/lrxlizi/. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id data);
typedef void(^FailureBlock)(NSString *error);

typedef void(^filePath)(NSString  *data);

@interface LZNetWorking : NSObject
/**
get
 */
+ (void)sendGetNetWorkWithUrl:(NSString *)url parameters:(NSDictionary *)dict  successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 post
 */
+(void)sendPostNetWorkWithUrl:(NSString *)url parameters:(NSDictionary *)dict successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;


+(void)downLoadUrlString:(NSString *)urlStr returnStr:(filePath)str;



@end
