//
//  LZPlyerTableViewCell.h
//  LZMusicPlayerDemo
//
//  Created by 栗子 on 2017/12/20.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/.     https://github.com/lrxlizi/. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZPlayerModel.h"

@interface LZPlyerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UILabel *songLB;
@property (weak, nonatomic) IBOutlet UILabel *songerLB;
@property (strong,nonatomic)LZPlayerModel *model;

@end
