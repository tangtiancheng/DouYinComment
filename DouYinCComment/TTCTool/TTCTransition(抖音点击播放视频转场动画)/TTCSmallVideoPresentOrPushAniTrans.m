//
//  DDSmallVideoPushAniTrans.m
//  RingtoneDuoduo
//
//  Created by han on 2021/9/23.
//  Copyright © 2021 duoduo. All rights reserved.
//

#import "TTCSmallVideoPresentOrPushAniTrans.h"
#import "TTCCom.h"

@interface TTCSmallVideoPresentOrPushAniTrans ()


@end

@implementation TTCSmallVideoPresentOrPushAniTrans

//这个函数用来设置动画执行的时长
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
//这个函数用来处理具体的动画效果
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {

    if(self.tabbarCaptureImageV) {
        [self.fromVC.view addSubview:self.tabbarCaptureImageV];
        UITabBar *tabBar = self.fromVC.tabBarController.tabBar;
        tabBar.hidden = YES;
    }
    
    
    NSLog(@"%@",[transitionContext containerView].subviews);
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:self.maskView];
    [containerView addSubview:self.toVC.view];

    CGRect finalFrame = [transitionContext finalFrameForViewController:self.toVC];
    CGRect initialFrame = CGRectMake(finalFrame.size.width/2, finalFrame.size.height/2, 0, 0);
    if(self.smalCurPlayCell && self.smalCurPlayCell.superview) {
        initialFrame = [self.smalCurPlayCell.superview convertRect:self.smalCurPlayCell.frame toView:self.toVC.view];
    }
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    self.toVC.view.center = CGPointMake(initialFrame.origin.x + initialFrame.size.width/2, initialFrame.origin.y + initialFrame.size.height/2);
    self.toVC.view.transform = CGAffineTransformMakeScale(initialFrame.size.width/finalFrame.size.width, initialFrame.size.height/finalFrame.size.height);
    
    self.toVC.view.alpha = 0.0;
    self.smalCurPlayCell.alpha = 1.0;
    self.maskView.alpha = 0;
    [UIView animateWithDuration:duration
                     animations:^{
        self.toVC.view.center = CGPointMake(finalFrame.origin.x + finalFrame.size.width/2, finalFrame.origin.y + finalFrame.size.height/2);
        self.toVC.view.transform = CGAffineTransformMakeScale(1, 1);
        self.toVC.view.alpha = 1;
        self.maskView.alpha = 1;
        self.smalCurPlayCell.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.maskView removeFromSuperview];
            [containerView insertSubview:self.fromVC.view belowSubview:self.toVC.view];
        });
        if(self.tabbarCaptureImageV) {
            [self.tabbarCaptureImageV removeFromSuperview];
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];

    }];
    

}

- (void)dealloc {
    NSLog(@"%@销毁了",self);
}





@end
