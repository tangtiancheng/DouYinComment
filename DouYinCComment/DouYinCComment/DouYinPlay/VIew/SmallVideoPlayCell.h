//
//  SmallVideoPlayCell.h
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2019/1/5.
//  Copyright © 2019年 duoduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmallVideoModel.h"

@protocol SmallVideoPlayCellDlegate <NSObject>
//关注
- (void)handleAddConcerWithVideoModel:(SmallVideoModel *)smallVideoModel;
//点击头像
- (void)handleClickPersonIcon:(SmallVideoModel *)smallVideoModel;
//收藏视频
- (void)handleFavoriteVdieoModel:(SmallVideoModel *)smallVdeoModel;
//取消收藏视频
- (void)handleDeleteFavoriteVdieoModel:(SmallVideoModel *)smallVdeoModel;
//评论
- (void)handleCommentVidieoModel:(SmallVideoModel *)smallVideoModel;
//分享
- (void)handleShareVideoModel:(SmallVideoModel *)smallVideoModel;
//设置铃声
- (void)handleSetRingVideoModel:(SmallVideoModel *)smallVideoMoodel;
//设置动态壁纸
- (void)handleSetLivePhoto:(SmallVideoModel *)smallVideoModel;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SmallVideoPlayCell : UITableViewCell

@property (nonatomic, strong) SmallVideoModel *model;
@property (nonatomic, strong) UIView *playerFatherView;

@property (nonatomic, weak) id<SmallVideoPlayCellDlegate> delegate;

@end

NS_ASSUME_NONNULL_END
