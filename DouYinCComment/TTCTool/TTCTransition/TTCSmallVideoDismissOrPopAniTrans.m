//
//  DDSmallVideoPopAniTrans.m
//  RingtoneDuoduo
//
//  Created by han on 2021/9/23.
//  Copyright © 2021 duoduo. All rights reserved.
//

#import "TTCSmallVideoDismissOrPopAniTrans.h"
#import "TTCCom.h"

@implementation TTCSmallVideoDismissOrPopAniTrans

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return self.duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    
    UITabBar *tabBar;
    if(self.tabbarCaptureImageV) {
        [toVC.view addSubview:self.tabbarCaptureImageV];
        tabBar = fromVC.tabBarController.tabBar;
        tabBar.hidden = YES;
    }
    
    
    UIView *containerView = [transitionContext containerView];
    CGRect finalFrame;
    CGRect initialFrame;
    initialFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    finalFrame = CGRectMake(initialFrame.size.width/2, initialFrame.size.height/2, 1, 1);
    if(!self.maskView.superview) {
        self.maskView.alpha = 1;
    }
    NSLog(@"%@",containerView.subviews);
    [containerView insertSubview:self.maskView belowSubview:fromVC.view];
    [containerView insertSubview:toVC.view belowSubview:self.maskView];
    if(self.smalCurPlayCell && self.smalCurPlayCell.superview) {
        finalFrame = [self.smalCurPlayCell.superview convertRect:self.smalCurPlayCell.frame toView:[UIApplication sharedApplication].delegate.window];
    }
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    fromVC.view.alpha = 1;
    self.smalCurPlayCell.alpha = 0.0;
    [UIView animateWithDuration:duration
                     animations:^{
        fromVC.view.transform = CGAffineTransformMakeScale(finalFrame.size.width/ initialFrame.size.width,  finalFrame.size.height/initialFrame.size.height);
        fromVC.view.center = CGPointMake(finalFrame.origin.x + finalFrame.size.width/2, finalFrame.origin.y + finalFrame.size.height/2);
        fromVC.view.alpha = 0.0;
        self.maskView.alpha = 0;
        self.smalCurPlayCell.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        if(self.tabbarCaptureImageV) {
            [self.tabbarCaptureImageV removeFromSuperview];
            tabBar.hidden = NO;
        }
        BOOL iscancel = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!iscancel];
    }];
}

- (void)dealloc {
    NSLog(@"%@销毁了",self);
}

@end
