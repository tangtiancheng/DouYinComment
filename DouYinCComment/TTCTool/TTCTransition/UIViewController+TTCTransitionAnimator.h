//
//  UIViewController+DDTransitionAnimator.h
//  RingtoneDuoduo
//
//  Created by han on 2021/9/23.
//  Copyright © 2021 duoduo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTCTransitionDelegate;
NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (TTCTransitionAnimator)

@property (nonatomic, strong) TTCTransitionDelegate *ttcTransitionDelegate;

//@property (nonatomic, strong) UIImageView *tabbarCaptureImageV;

@end

@interface UINavigationController (TTCTransitionAnimator)


@end


@interface UIView (TTCTransitionAnimator)

- (UIImage *)getCaptureImage;

//push的时候如果需要hidesBottomBarWhenPushed,tabbar自己的push动画会对咱们得自定义转场照成很难看的干扰, 所以这时候咱们获取tabbar截图,把tabbar图片放到fromVC上,假装tabbar还在, 其实真的tabbar会hidden = YES隐藏掉,等转场动画完毕再把hidden = NO
+ (UIImageView *)getTabbarCaptureImageVFromViewController:(UIViewController *)fromVC
                                         toViewController:(UIViewController *)toVC;
@end

NS_ASSUME_NONNULL_END
