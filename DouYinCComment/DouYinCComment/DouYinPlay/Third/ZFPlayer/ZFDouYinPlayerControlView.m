//
//  ZFDouYinPlayerControlView.m
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2019/1/5.
//  Copyright © 2019年 duoduo. All rights reserved.
//

#import "ZFDouYinPlayerControlView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+CustomControlView.h"
#import "MMMaterialDesignSpinner.h"
#import "TTCCom.h"
#import "UIImageView+WebCache.h"
static const CGFloat ZFPlayerAnimationTimeInterval             = 7.0f;
static const CGFloat ZFPlayerControlBarAutoFadeOutTimeInterval = 0.35f;

@interface ZFDouYinPlayerControlView () <UIGestureRecognizerDelegate>

@property(nonatomic, strong) NSString *totleTime;
@property(nonatomic, strong) NSString *currentTime;


@end

@implementation ZFDouYinPlayerControlView
- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self addSubview:self.placeholderImageView];

        [self addSubview:self.activity];
        [self addSubview:self.repeatBtn];
        [self addSubview:self.playeBtn];
        [self addSubview:self.pauseIcon];
        [self addSubview:self.failBtn];
        [self addSubview:self.nameLabel];
        [self addSubview:self.artistLabel];
        
        [self addSubview:self.bottomProgressView];
        
        // 添加子控件的约束
        [self makeSubViewsConstraints];
     
        // 初始化时重置controlView
        [self zf_playerResetControlView];
        //        // app退到后台
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        //        // app进入前台
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        [self listeningRotating];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)makeSubViewsConstraints {
    [self.placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    
    
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.playeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.center.equalTo(self);
    }];
    
    [self.pauseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(100);
    }];
    
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.with.height.mas_equalTo(45);
    }];
    
    [self.failBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(33);
    }];
    
    [self.bottomProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.offset(15);
        if(kDevice_Is_iPhoneX) {
            make.bottom.with.offset(-40);
        } else {
            make.bottom.with.offset(-25);
        }
        make.width.mas_equalTo(ScreenWidth * 2 / 3);
        
    }];
    [self.artistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.offset(15);
        make.bottom.equalTo(self.nameLabel.mas_top).with.offset(-3);
    }];
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//
////    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
//    if (!self.isFullScreen) {
//        [self setOrientationPortraitConstraint];
//    } else {
//        [self setOrientationLandscapeConstraint];
//    }
//}

#pragma mark - Action

- (void)backBtnClick:(UIButton *)sender {
    // 状态条的方向旋转的方向,来判断当前屏幕的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 在cell上并且是竖屏时候响应关闭事件
    if (self.isCellVideo && orientation == UIInterfaceOrientationPortrait) {
        if ([self.delegate respondsToSelector:@selector(zf_controlView:closeAction:)]) {
            [self.delegate zf_controlView:self closeAction:sender];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(zf_controlView:backAction:)]) {
            [self.delegate zf_controlView:self backAction:sender];
        }
    }
}

- (void)nextBtnClick:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(zf_controlView:playNextParterAction:)]) {
        [self.delegate zf_controlView:self playNextParterAction:sender];
    }
}

- (void)lockScrrenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.showing = NO;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:lockScreenAction:)]) {
        [self.delegate zf_controlView:self lockScreenAction:sender];
    }
}

- (void)playBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:playAction:)]) {
        [self.delegate zf_controlView:self playAction:sender];
    }
}

- (void)fullScreenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:fullScreenAction:)]) {
        [self.delegate zf_controlView:self fullScreenAction:sender];
    }
}

- (void)repeatBtnClick:(UIButton *)sender {
    // 重置控制层View
    [self zf_playerResetControlView];
//    [self zf_playerShowControlView];
    if ([self.delegate respondsToSelector:@selector(zf_controlView:repeatPlayAction:)]) {
        [self.delegate zf_controlView:self repeatPlayAction:sender];
    }
}

- (void)centerPlayBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_controlView:cneterPlayAction:)]) {
        [self.delegate zf_controlView:self cneterPlayAction:sender];
    }
}

- (void)failBtnClick:(UIButton *)sender {
    self.failBtn.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:failAction:)]) {
        [self.delegate zf_controlView:self failAction:sender];
    }
}

- (void)progressSliderTouchBegan:(ASValueTrackingSlider *)sender {
    [self zf_playerCancelAutoFadeOutControlView];
    if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderTouchBegan:)]) {
        [self.delegate zf_controlView:self progressSliderTouchBegan:sender];
    }
}

- (void)progressSliderValueChanged:(ASValueTrackingSlider *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderValueChanged:)]) {
        [self.delegate zf_controlView:self progressSliderValueChanged:sender];
    }
}

- (void)progressSliderTouchEnded:(ASValueTrackingSlider *)sender {
    self.showing = YES;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderTouchEnded:)]) {
        [self.delegate zf_controlView:self progressSliderTouchEnded:sender];
    }
}


- (void)playerPlayDidEnd {
    self.backgroundColor  = RGBA(0, 0, 0, .6);
    self.repeatBtn.hidden = NO;
    // 初始化显示controlView为YES
    self.showing = NO;
    // 延迟隐藏controlView
    [self zf_playerShowControlView];
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange {

}



#pragma mark - Private Method

- (void)showControlView {
    self.showing = YES;
    
    if (self.isCellVideo) {
        self.shrink                = NO;
    }
    self.bottomProgressView.alpha  = 1;
    ZFPlayerShared.isStatusBarHidden = NO;
}

- (void)hideControlView {
    self.showing = NO;
    self.backgroundColor          = RGBA(0, 0, 0, 0);
    self.bottomProgressView.alpha = 1;
    if (self.isFullScreen && !self.playeEnd && !self.isShrink) {
        ZFPlayerShared.isStatusBarHidden = YES;
    }
}


//暂停播放动画
- (void)showPauseViewAnim:(BOOL)play {
    if(play == YES) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             self.pauseIcon.alpha = 0.0f;
                         } completion:^(BOOL finished) {
                             [self.pauseIcon setHidden:YES];
                         }];
    }else {
        [self.pauseIcon setHidden:NO];
        self.pauseIcon.transform = CGAffineTransformMakeScale(1.8f, 1.8f);
        self.pauseIcon.alpha = 1.0f;
        [UIView animateWithDuration:0.25f delay:0
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.pauseIcon.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                            } completion:^(BOOL finished) {
                            }];
    }
}



/**
 *  监听设备旋转通知
 */
- (void)listeningRotating {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}


//- (void)autoFadeOutControlView {
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(zf_playerHideControlView) object:nil];
//    [self performSelector:@selector(zf_playerHideControlView) withObject:nil afterDelay:ZFPlayerAnimationTimeInterval];
//}



#pragma mark - setter

- (void)setShrink:(BOOL)shrink {
    _shrink = shrink;
    self.bottomProgressView.hidden = shrink;
}

- (void)setFullScreen:(BOOL)fullScreen {
    _fullScreen = fullScreen;
    if(fullScreen) {
        [self zf_playerHideControlView];
    } else {
        [self zf_playerShowControlView];
    }
    ZFPlayerShared.isLandscape = fullScreen;
}

#pragma mark - getter



- (MMMaterialDesignSpinner *)activity {
    if (!_activity) {
        _activity = [[MMMaterialDesignSpinner alloc] init];
        _activity.lineWidth = 1;
        _activity.duration  = 1;
        _activity.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    }
    return _activity;
}

- (UIButton *)repeatBtn {
    if (!_repeatBtn) {
//        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBtn setImage:ZFPlayerImage(@"ZFPlayer_repeat_video") forState:UIControlStateNormal];
        [_repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _repeatBtn;
}



- (UIButton *)playeBtn {
    if (!_playeBtn) {
        _playeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playeBtn setImage:ZFPlayerImage(@"ZFPlayer_play_btn") forState:UIControlStateNormal];
        [_playeBtn addTarget:self action:@selector(centerPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playeBtn;
}

- (UIImageView *)pauseIcon {
    if(!_pauseIcon) {
        _pauseIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"smallVideo_play_pause"]];
        _pauseIcon.contentMode = UIViewContentModeCenter;
        _pauseIcon.hidden = YES;
        _pauseIcon.alpha = 0;
    }
    return _pauseIcon;
}

- (UIButton *)failBtn {
    if (!_failBtn) {
        _failBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_failBtn setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
        [_failBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _failBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _failBtn.backgroundColor = RGBA(0, 0, 0, 0.7);
        [_failBtn addTarget:self action:@selector(failBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _failBtn;
}


- (UIImageView *)placeholderImageView {
    if (!_placeholderImageView) {
        _placeholderImageView = [[UIImageView alloc] init];
        _placeholderImageView.contentMode = UIViewContentModeScaleAspectFit;
        _placeholderImageView.userInteractionEnabled = YES;
    }
    return _placeholderImageView;
}

- (UIProgressView *)bottomProgressView {
    if (!_bottomProgressView) {
//        _bottomProgressView                   = [[UIProgressView alloc] init];
        _bottomProgressView.progressTintColor = RGBA(255, 255, 255, 0.7);//RGBA(255, 128, 49, 1);;
        _bottomProgressView.trackTintColor    = [UIColor clearColor];
    }
    return _bottomProgressView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textColor = RGBA(255, 255, 255, 1);;//RGBA(165, 165, 165, 1);
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
        _nameLabel.layer.shadowOpacity = 0.3;
        _nameLabel.layer.shadowOffset = CGSizeMake(0, 1);
    }
    return _nameLabel;
}

- (UILabel *)artistLabel {
    if(!_artistLabel) {
        _artistLabel = [[UILabel alloc] init];
        _artistLabel.textColor = RGBA(255, 255, 255, 1);
        _artistLabel.font = [UIFont systemFontOfSize:17];
        _artistLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
        _artistLabel.layer.shadowOpacity = 0.3;
        _artistLabel.layer.shadowOffset = CGSizeMake(0, 1);
    }
    return _artistLabel;
}


#pragma mark - Public method

/** 重置ControlView */
- (void)zf_playerResetControlView {
    [self.activity stopAnimating];
    self.bottomProgressView.progress = 0;
    //    self.currentTimeLabel.text       = @"00:00";
    //    self.totalTimeLabel.text         = @"00:00";
    self.currentTime = @"00:00";
    self.totleTime = @"00:00";
    self.repeatBtn.hidden            = YES;
    self.playeBtn.hidden             = YES;
    self.failBtn.hidden              = YES;
    self.backgroundColor             = [UIColor clearColor];
    self.shrink                      = NO;
    self.showing                     = NO;
    self.playeEnd                    = NO;
    self.failBtn.hidden              = YES;
//    self.placeholderImageView.alpha  = 1;
    if(self.fullScreen) {
        [self hideControlView];
    } else {
        [self showControlView];
    }
}


/**
 *  取消延时隐藏controlView的方法
 */
- (void)zf_playerCancelAutoFadeOutControlView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

/** 设置播放模型 */
- (void)zf_playerModel:(ZFPlayerModel *)playerModel {
    
  
    // 设置网络占位图片
    if (playerModel.placeholderImageURLString) {
        
        [self.placeholderImageView sd_setImageWithURL:[NSURL URLWithString:playerModel.placeholderImageURLString] placeholderImage:[UIImage imageNamed:@""]];
    } else {
        self.placeholderImageView.image = playerModel.placeholderImage;
    }
    if (playerModel.resolutionDic) {
        [self zf_playerResolutionArray:[playerModel.resolutionDic allKeys]];
    }
    
//    self.nameLabel.text = playerModel.title;
//    if(playerModel.artist.length) {
//        self.artistLabel.text = [NSString stringWithFormat:@"@%@",playerModel.artist];
//    } else {
//        self.artistLabel.text = @"";
//    }
    
}

/** 正在播放（隐藏placeholderImageView） */
- (void)zf_playerItemPlaying {
    if(self.placeholderImageView.alpha != 0) {
//        [UIView animateWithDuration:1.0 animations:^{
            self.placeholderImageView.alpha = 0;
//        }];
    }
}

- (void)zf_playerShowOrHideControlView {
    if (self.isShowing) {
        [self zf_playerHideControlView];
    } else {
        [self zf_playerShowControlView];
    }
}
/**
 *  显示控制层
 */
- (void)zf_playerShowControlView {
    if ([self.delegate respondsToSelector:@selector(zf_controlViewWillShow:isFullscreen:)]) {
        [self.delegate zf_controlViewWillShow:self isFullscreen:self.isFullScreen];
    }
    [self zf_playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:ZFPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self showControlView];
    } completion:^(BOOL finished) {
        self.showing = YES;
        //        [self autoFadeOutControlView];
    }];
}

/**
 *  隐藏控制层
 */
- (void)zf_playerHideControlView {
    if ([self.delegate respondsToSelector:@selector(zf_controlViewWillHidden:isFullscreen:)]) {
        [self.delegate zf_controlViewWillHidden:self isFullscreen:self.isFullScreen];
    }
    [self zf_playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:ZFPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self hideControlView];
    } completion:^(BOOL finished) {
        self.showing = NO;
    }];
}

/** 小屏播放 */
- (void)zf_playerBottomShrinkPlay {
    self.shrink = YES;
    [self hideControlView];
}

/** 在cell播放 */
- (void)zf_playerCellPlay {
    self.cellVideo = YES;
    self.shrink    = NO;
}

- (void)zf_playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value {
    // 当前时长进度progress
    NSInteger proMin = currentTime / 60;//当前秒
    NSInteger proSec = currentTime % 60;//当前分钟
    // duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    if (!self.isDragged) {
        // 更新slider
        self.bottomProgressView.progress = value;
        // 更新当前播放时间
        self.currentTime = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
        
    }
    // 更新总时间
    self.totleTime = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
}

- (void)zf_playerDraggedTime:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd hasPreview:(BOOL)preview {
    // 快进快退时候停止菊花
    [self.activity stopAnimating];
    // 拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分钟
    
    //duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    self.currentTime = currentTimeStr;
    NSString *totalTimeStr   = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    self.totleTime = totalTimeStr;
    CGFloat  draggedValue    = (CGFloat)draggedTime/(CGFloat)totalTime;
    NSString *timeStr        = [NSString stringWithFormat:@"%@ / %@", currentTimeStr, totalTimeStr];
    
    // 更新bottomProgressView的值
    self.bottomProgressView.progress  = draggedValue;
   
    // 正在拖动控制播放进度
    self.dragged = YES;
}

- (void)zf_playerDraggedEnd {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
    });
    self.dragged = NO;
   
    // 滑动结束延时隐藏controlView
    //    [self autoFadeOutControlView];
}

- (void)zf_playerDraggedTime:(NSInteger)draggedTime sliderImage:(UIImage *)image; {
    // 拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分钟
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
   
    
}

/** progress显示缓冲进度 */
- (void)zf_playerSetProgress:(CGFloat)progress {
}

/** 视频加载失败 */
- (void)zf_playerItemStatusFailed:(NSError *)error {
    self.failBtn.hidden = NO;
}

/** 加载的菊花 */
- (void)zf_playerActivity:(BOOL)animated {
    if (animated) {
        [self.activity startAnimating];
        
    } else {
        [self.activity stopAnimating];
    }
}

/** 播放完了 */
- (void)zf_playerPlayEnd {
    self.repeatBtn.hidden = NO;
    self.playeEnd         = YES;
    self.showing          = NO;
    // 隐藏controlView
    [self hideControlView];
    self.backgroundColor  = RGBA(0, 0, 0, .3);
    ZFPlayerShared.isStatusBarHidden = NO;
    self.bottomProgressView.alpha = 0;
    [self repeatBtnClick:nil];
}

///**
// * 播放或者暂停
// */
//- (void)zf_playerPlayOrPause:(BOOL)state {
//    [self showPauseViewAnim:state];
//}



/** 播放按钮状态 */
- (void)zf_playerPlayBtnState:(BOOL)state {
    [self showPauseViewAnim:state];
}

/** 锁定屏幕方向按钮状态 */
- (void)zf_playerLockBtnState:(BOOL)state {
}


@end
