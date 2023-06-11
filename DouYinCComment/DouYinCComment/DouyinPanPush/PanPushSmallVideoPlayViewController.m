//
//  SmallVideoPlayViewController.m
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2019/1/5.
//  Copyright © 2019年 duoduo. All rights reserved.
//

#import "PanPushSmallVideoPlayViewController.h"
#import "SmallVideoPlayCell.h"
#import "SmallVideoModel.h"
#import "DDVideoPlayerManager.h"
#import "SDImageCache.h"
#import "CommentsPopView.h"
#import "TTCCom.h"
#import "TTCTransitionDelegate.h"
#import "UIViewController+TTCPanPush.h"
#import "Type4ViewControllerThird.h"


static NSString * const SmallVideoCellIdentifier = @"SmallVideoCellIdentifier";


@interface PanPushSmallVideoPlayViewController ()<UITableViewDataSource, UITableViewDelegate, ZFManagerPlayerDelegate, SmallVideoPlayCellDlegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *fatherView;
//这个是播放视频的管理器
@property (nonatomic, strong) DDVideoPlayerManager *videoPlayerManager;

@property (nonatomic, strong) NSMutableArray *modelArray;

@property (nonatomic, assign) NSInteger currentPlayIndex;


@end

@implementation PanPushSmallVideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.videoPlayerManager autoPause];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.videoPlayerManager autoPlay];
}


- (void)createUI {
    
    SmallVideoModel *model1 = [[SmallVideoModel alloc] init];
    model1.rid = 1;
    model1.name = @"push";
    model1.comment_num = 12;
    model1.score = 11;
    model1.artist = @"作者1";
    model1.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/46/user_head_30881645_20190423071746.jpg";
    model1.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/551/76097551.mp4";
    model1.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/551/76097551.jpg";
    model1.aspect = 1.778;
    
    SmallVideoModel *model2 = [[SmallVideoModel alloc] init];
    model2.rid = 2;
    model2.name = @"present";
    model2.comment_num = 12;
    model2.score = 21;
    model2.artist = @"作者2";
    model2.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/46/user_head_30881645_20190423071746.jpg";
    model2.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/479/76097479.mp4";
    model2.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/479/76097479.jpg";
    model2.aspect = 1.778;
    
    SmallVideoModel *model3 = [[SmallVideoModel alloc] init];
    model3.rid = 3;
    model3.name = @"push";
    model3.comment_num = 12;
    model3.score = 31;
    model3.artist = @"作者3";
    model3.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/31/user_head_34964288_20190212001831.jpg";
    model3.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/970/75779970.mp4";
    model3.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/970/75779970.jpg";
    model3.aspect = 1.778;
    
    SmallVideoModel *model4 = [[SmallVideoModel alloc] init];
    model4.rid = 4;
    model4.name = @"present";
    model4.comment_num = 12;
    model4.score = 41;
    model4.artist = @"作者4";
    model4.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/22/user_head_27430048_20190525064122.jpg";
    model4.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/204/76097204.mp4";
    model4.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/204/76097204.jpg";
    model4.aspect = 1.250;
    
    SmallVideoModel *model5 = [[SmallVideoModel alloc] init];
    model5.rid = 5;
    model5.name = @"push";
    model5.comment_num = 12;
    model5.score = 51;
    model5.artist = @"作者5";
    model5.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/13/user_head_15486360_20190426173413.jpg";
    model5.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/022/76097022.mp4";
    model5.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/022/76097022.jpg";
    model5.aspect = 1.799;
    
    SmallVideoModel *model6 = [[SmallVideoModel alloc] init];
    model6.rid = 6;
    model6.name = @"present";
    model6.comment_num = 12;
    model6.score = 61;
    model6.artist = @"作者6";
    model6.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/55/user_head_5925183_20190528092255.jpg";
    model6.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/550/76097550.mp4";
    model6.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/550/76097550.jpg";
    model6.aspect = 0.567;
    
    SmallVideoModel *model7 = [[SmallVideoModel alloc] init];
    model7.rid = 7;
    model7.name = @"push";
    model7.comment_num = 12;
    model7.score = 71;
    model7.artist = @"作者7";
    model7.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/43/user_head_123737_20190424101443.jpg";
    model7.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/488/75779488.mp4";
    model7.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/488/75779488.jpg";
    model7.aspect = 0.562;
    
    SmallVideoModel *model8 = [[SmallVideoModel alloc] init];
    model8.rid = 8;
    model8.name = @"present";
    model8.comment_num = 12;
    model8.score = 81;
    model8.artist = @"作者8";
    model8.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
    model8.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/809/76096809.mp4";
    model8.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/809/76096809.jpg";
    model8.aspect = 0.562;
    
    SmallVideoModel *model9 = [[SmallVideoModel alloc] init];
    model9.rid = 9;
    model9.name = @"push";
    model9.comment_num = 12;
    model9.score = 91;
    model9.artist = @"作者9";
    model9.head_url = @"http://thirdqq.qlogo.cn/g?b=oidb&amp;k=IXYXYnjFTRGWV18ibkgC6Kw&amp;s=100";
    model9.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/603/76096603.mp4";
    model9.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/603/76096603.jpg";
    model9.aspect = 1.000;
    
    SmallVideoModel *model10 = [[SmallVideoModel alloc] init];
    model10.rid = 10;
    model10.name = @"present";
    model10.comment_num = 12;
    model10.score = 101;
    model10.artist = @"作者10";
    model10.head_url = @"http://thirdqq.qlogo.cn/g?b=oidb&amp;k=lzQZzzcCgg8j4XvcyPBGOA&amp;s=100";
    model10.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/059/75778059.mp4";
    model10.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/059/75778059.jpg";
    model10.aspect = 1.778;
    
    SmallVideoModel *model11 = [[SmallVideoModel alloc] init];
    model11.rid = 11;
    model11.name = @"push";
    model11.comment_num = 12;
    model11.score = 111;
    model11.artist = @"作者11";
    model11.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/34/user_head_31365520_20190516093434.jpg";
    model11.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/037/76096037.mp4";
    model11.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/037/76096037.jpg";
    model11.aspect = 1.778;
    
    SmallVideoModel *model12 = [[SmallVideoModel alloc] init];
    model12.rid = 12;
    model12.name = @"present";
    model12.comment_num = 12;
    model12.score = 121;
    model12.artist = @"作者12";
    model12.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/34/user_head_31365520_20190516093434.jpg";
    model12.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/029/76096029.mp4";
    model12.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/029/76096029.jpg";
    model12.aspect = 1.778;
    self.modelArray = [NSMutableArray array];
    [self.modelArray addObjectsFromArray:@[model1,model2,model3,model4,model5,model6,model7,model8,model9,model10,model11,model12]];
    self.currentPlayIndex = 0;
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.pagingEnabled = YES;
    self.tableView.scrollsToTop = NO;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = self.view.frame.size.height;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.backgroundColor = [UIColor blackColor];
    [self.tableView registerClass:[SmallVideoPlayCell class] forCellReuseIdentifier:SmallVideoCellIdentifier];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.with.offset(0);
    }];
    if(@available(iOS 11.0, *)){
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentPlayIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    [self playIndex:self.currentPlayIndex];
    
  
    /*
     一行代码实现仿抖音 左滑 push进入个人主页,
    1.把TTCPanPushTransition文件夹拖入你的项目中,
    2.在需要push的控制器类中#import "UIViewController+TTCPanPush.h"
    3.然后在videDidLoad方法中调用getpanPushToViewController:方法, block返回你的主页控制器类
     不会侵入你自己的原有代码
     */
    [self getpanPushToViewController:^UIViewController * _Nonnull{
        //这个应该是你的个人主页控制器
        Type4ViewControllerThird *vc = [[Type4ViewControllerThird alloc] init];
        return vc;
    }];

}

#pragma mrak - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SmallVideoPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:SmallVideoCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = self.modelArray[indexPath.row];
    NSInteger rowIndex = indexPath.row;
    NSInteger index = self.modelArray.count - 2;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentIndex = round(self.tableView.contentOffset.y / self.tableView.frame.size.height);
    if(self.currentPlayIndex != currentIndex) {
        self.currentPlayIndex = currentIndex;
        [self playIndex:self.currentPlayIndex];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat currentIndex = self.tableView.contentOffset.y / self.tableView.frame.size.height;
    if(fabs(currentIndex - self.currentPlayIndex)>1) {
        [self.videoPlayerManager resetPlayer];
    }
}

- (void)playIndex:(NSInteger)currentIndex {
    SmallVideoPlayCell *currentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
    
    NSString *artist = nil;
    NSString *title = nil;
    NSString *cover_url = nil;
    NSURL *videoURL = nil;
    NSURL *originVideoURL = nil;
    BOOL useDownAndPlay = NO;
    AVLayerVideoGravity videoGravity = AVLayerVideoGravityResizeAspect;
    
    //关注,推荐
    SmallVideoModel *currentPlaySmallVideoModel = self.modelArray[currentIndex];
    
    artist = currentPlaySmallVideoModel.artist;
    title = currentPlaySmallVideoModel.name;
    cover_url = currentPlaySmallVideoModel.cover_url;
    videoURL = [NSURL URLWithString:currentPlaySmallVideoModel.video_url];
    originVideoURL = [NSURL URLWithString:currentPlaySmallVideoModel.video_url];
    useDownAndPlay = YES;
    if(currentPlaySmallVideoModel.aspect >= 1.4) {
        videoGravity = AVLayerVideoGravityResizeAspectFill;
    } else {
        videoGravity = AVLayerVideoGravityResizeAspect;
    }
    
    self.fatherView = currentCell.playerFatherView;
    self.videoPlayerManager.playerModel.videoGravity = videoGravity;
    self.videoPlayerManager.playerModel.fatherView       = self.fatherView;
    self.videoPlayerManager.playerModel.title            = title;
    self.videoPlayerManager.playerModel.artist = artist;
    self.videoPlayerManager.playerModel.placeholderImageURLString = cover_url;
    self.videoPlayerManager.playerModel.videoURL         = videoURL;
    self.videoPlayerManager.originVideoURL = originVideoURL;
    self.videoPlayerManager.playerModel.useDownAndPlay = YES;
    //如果设备存储空间不足200M,那么不要边下边播
    if([self deviceFreeMemorySize] < 200) {
        self.videoPlayerManager.playerModel.useDownAndPlay = NO;
    }
    [self.videoPlayerManager resetToPlayNewVideo];
   
    
}

- (CGFloat)deviceFreeMemorySize {
    /// 总大小
    float totalsize = 0.0;
    /// 剩余大小
    float freesize = 0.0;
    /// 是否登录
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary)
    {
        NSNumber *_free = [dictionary objectForKey:NSFileSystemFreeSize];
        freesize = [_free unsignedLongLongValue]*1.0/(1024);
        
        NSNumber *_total = [dictionary objectForKey:NSFileSystemSize];
        totalsize = [_total unsignedLongLongValue]*1.0/(1024);
    } else
    {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    return freesize/1024.0;
}




#pragma mark - LazyLoad

- (DDVideoPlayerManager *)videoPlayerManager {
    if(!_videoPlayerManager) {
        _videoPlayerManager = [[DDVideoPlayerManager alloc] init];
        _videoPlayerManager.managerDelegate = self;
    }
    return _videoPlayerManager;
}


#pragma mark - dealloc
- (void)dealloc {
    [self.videoPlayerManager resetPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
