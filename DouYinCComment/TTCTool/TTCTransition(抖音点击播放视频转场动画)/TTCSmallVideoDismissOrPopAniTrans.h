//
//  DDSmallVideoPopAniTrans.h
//  RingtoneDuoduo
//
//  Created by han on 2021/9/23.
//  Copyright © 2021 duoduo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTCSmallVideoDismissOrPopAniTrans : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, weak) UIView *smalCurPlayCell;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, weak) UIView *maskView;


//是否有tabbarPush干扰
@property (nonatomic, weak) UIImageView *tabbarCaptureImageV;


@end

NS_ASSUME_NONNULL_END
