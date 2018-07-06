//
//  AppDelegate.m
//  LZMusicPlayerDemo
//
//  Created by 栗子 on 2017/12/20.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/.     https://github.com/lrxlizi/. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LZMusicNavViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window.rootViewController = [[LZMusicNavViewController alloc]initWithRootViewController:[[ViewController alloc]init]];
    //后台播放
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session  setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    [application beginReceivingRemoteControlEvents];//开启接收远程事件
    
    return YES;
}
#pragma mark - 接收远程事件
-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause://暂停
            {
                [[LZPlayerManager lzPlayerManager] playAndPause];
                [LZPlayerBottomView lzPlayerBottomView].isSongPlayer = NO;
                break;
            }case UIEventSubtypeRemoteControlPlay://播放
            {
                [[LZPlayerManager lzPlayerManager] playAndPause];
                [LZPlayerBottomView lzPlayerBottomView].isSongPlayer = YES;
                break;
            }case UIEventSubtypeRemoteControlPreviousTrack://前一首
            {
                 [[LZPlayerManager lzPlayerManager]playPrevious];
                 [[LZPlayerBottomView lzPlayerBottomView] reloadDataWithIndex: [LZPlayerManager lzPlayerManager].index];
                break;
            }case UIEventSubtypeRemoteControlNextTrack://下一首
            {
                [[LZPlayerManager lzPlayerManager]playNext];
                [[LZPlayerBottomView lzPlayerBottomView] reloadDataWithIndex: [LZPlayerManager lzPlayerManager].index];
                break;
            }
            default:
                break;
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
