//
//  ZFSuspendPlayerControlView.h
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2019/3/16.
//  Copyright © 2019 duoduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMMaterialDesignSpinner.h"
#import "ASValueTrackingSlider.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZFSuspendPlayerControlView : UIView

/** 系统菊花 */
@property (nonatomic, strong) MMMaterialDesignSpinner *activity;



/** 占位图 */
@property (nonatomic, strong) UIImageView             *placeholderImageView;
/** 控制层消失时候在底部显示的播放进度progress */
@property (nonatomic, strong) UIProgressView          *bottomProgressView;

/** 用户名 */
@property (nonatomic, strong) UILabel *artistLabel;
/** 视频名 */
@property (nonatomic, strong) UILabel *nameLabel;

/** 显示控制层 */
@property (nonatomic, assign, getter=isShowing) BOOL  showing;
/** 小屏播放 */
@property (nonatomic, assign, getter=isShrink ) BOOL  shrink;
/** 在cell上播放 */
@property (nonatomic, assign, getter=isCellVideo)BOOL cellVideo;
/** 是否拖拽slider控制播放进度 */
@property (nonatomic, assign, getter=isDragged) BOOL  dragged;
/** 是否播放结束 */
@property (nonatomic, assign, getter=isPlayEnd) BOOL  playeEnd;
/** 是否全屏播放 */
@property (nonatomic, assign,getter=isFullScreen)BOOL fullScreen;



@end

NS_ASSUME_NONNULL_END
