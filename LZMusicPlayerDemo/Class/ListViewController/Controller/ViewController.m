//
//  ViewController.m
//  LZMusicPlayerDemo
//
//  Created by 栗子 on 2017/12/20.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/.     https://github.com/lrxlizi/. All rights reserved.
//

#import "ViewController.h"
#import "LZPlyerTableViewCell.h"
#import "LZPlayerModel.h"

#define kMusicUrl @"http://mobile.ximalaya.com/mobile/others/ca/album/track/5541/true/1/15"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *musicTableVIew;
@property(nonatomic,strong) NSMutableArray *totalSongArr;
@property (nonatomic, strong)VTMagicController  *magicController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.totalSongArr         = [NSMutableArray array];
    self.navigationItem.title = @"LZMusicPlayerDemo";
    
    [LZSignSongIdSimple lzSignSongIdSimple].songID = @"";
    [LZPlayerBottomView lzPlayerBottomView].reloadBlock = ^{
        [self.musicTableVIew reloadData];//刷新当前播放歌曲songName和songerName字体的颜色
    };
    //添加UI
    [self createUI];
    NSArray *tempArr = LZUserDefaultsGET(SONGLIST);
    if (tempArr.count) {
        [self savedata:tempArr];
    }
    [self initdata];
}
-(void)createUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.musicTableVIew = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, LZSCREENW, LZSCREENH-65-64)];
    self.musicTableVIew.delegate = self;
    self.musicTableVIew.dataSource = self;
    self.musicTableVIew.tableFooterView = [UIView new];
    [self.view addSubview:self.musicTableVIew];
    [self.musicTableVIew registerNib:[UINib nibWithNibName:@"LZPlyerTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LZPLAYERCELL"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.totalSongArr.count) {
        return self.totalSongArr.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LZPlyerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZPLAYERCELL"];
    if (!cell) {
        cell = [[LZPlyerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LZPLAYERCELL"];
    }
    cell.model = self.totalSongArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    [LZPlayerManager lzPlayerManager].index = indexPath.row;
    [LZPlayerBottomView lzPlayerBottomView].isSongPlayer = YES;//修改按钮的图片
    [[LZPlayerBottomView lzPlayerBottomView] reloadDataWithIndex: [LZPlayerManager lzPlayerManager].index];
   

}
#pragma mark 数据请求
-(void)initdata{
    [LZNetWorking sendPostNetWorkWithUrl:kMusicUrl parameters:nil successBlock:^(id data) {
        NSArray *array = data[@"tracks"][@"list"];
        if (array.count) {
            LZUserDefaultsSET(array, SONGLIST);
            LZUserDefaultsSynchronize;
            [self savedata:array];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}
-(void)savedata:(NSArray *)array{
    [self.totalSongArr removeAllObjects];
    self.totalSongArr = [LZPlayerModel mj_objectArrayWithKeyValuesArray:array];
    [LZPlayerManager lzPlayerManager].musicArray = self.totalSongArr;
    [self.musicTableVIew reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
