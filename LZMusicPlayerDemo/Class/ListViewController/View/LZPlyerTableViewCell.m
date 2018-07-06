//
//  LZPlyerTableViewCell.m
//  LZMusicPlayerDemo
//
//  Created by 栗子 on 2017/12/20.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/.     https://github.com/lrxlizi/. All rights reserved.
//

#import "LZPlyerTableViewCell.h"

@implementation LZPlyerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerIV.layer.cornerRadius = 30;
    self.headerIV.layer.masksToBounds = YES;
    
}


-(void)setModel:(LZPlayerModel *)model{
    _model = model;
    [self.headerIV  sd_setImageWithURL:[NSURL URLWithString:model.coverLarge] placeholderImage:[UIImage imageNamed:@"musicicon"]];
    self.songLB.text = [NSString stringWithFormat:@"%@",model.title];
    self.songerLB.text = [NSString stringWithFormat:@"%@",model.nickname];
    if ([[LZSignSongIdSimple lzSignSongIdSimple].songID isEqualToString:[NSString stringWithFormat:@"%@",model.trackId]]) {
        self.songLB.textColor = LZColor(255, 203, 42,1);//ffcb2a
        self.songerLB.textColor = LZColor(255, 203, 42,1);
    }else{
        self.songLB.textColor = LZColor(51,51, 51,1);
         self.songerLB.textColor = LZColor(163, 163, 163,1);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
