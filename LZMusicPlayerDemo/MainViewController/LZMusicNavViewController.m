//
//  LZMusicNavViewController.m
//  LZMusicPlayerDemo
//
//  Created by 栗子 on 2017/12/22.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/.     https://github.com/lrxlizi/. All rights reserved.
//

#import "LZMusicNavViewController.h"

#import "LZMusicDetailVIewController.h"

@interface LZMusicNavViewController ()

@end

@implementation LZMusicNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加底部菜单
    [self addBottomVIew];
}
#pragma mark 添加底部菜单
-(void)addBottomVIew{
    
    LZPlayerBottomView *bottomVIew = [LZPlayerBottomView lzPlayerBottomView];
    [self.view addSubview:bottomVIew];
    [bottomVIew.jumpBtn addTarget:self action:@selector(jumpBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)jumpBtnClicked{
    
    if (![HealpClass isNullOrNilWithObject:[LZSignSongIdSimple lzSignSongIdSimple].songID]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LZMusicDetailVIewController *detail = [storyBoard instantiateViewControllerWithIdentifier:@"LZMusicDetailVIewController"];
        [self presentViewController:detail animated:YES completion:nil];
    }
    
//    if ( [LZPlayerManager lzPlayerManager].isPlay) {
//
//    }
}
-(BOOL)shouldAutorotate{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
    
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

-(UIBarButtonItem*) createBackButton
{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 24, 24);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    return   [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}
-(void)popself{
    
    [self popViewControllerAnimated:YES];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    [super pushViewController:viewController animated:animated];
//    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1) {
//        viewController.navigationItem.leftBarButtonItem =[self createBackButton];
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
