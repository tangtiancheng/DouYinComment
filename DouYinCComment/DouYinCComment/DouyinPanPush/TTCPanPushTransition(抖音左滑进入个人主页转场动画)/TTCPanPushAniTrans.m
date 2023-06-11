//
//  TTCPanPushAniTrans.m
//  DouYinCComment
//
//  Created by 唐天成 on 2023/6/9.
//  Copyright © 2023 唐天成. All rights reserved.
//

#import "TTCPanPushAniTrans.h"

@implementation TTCPanPushAniTrans

//这个函数用来设置动画执行的时长
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
//这个函数用来处理具体的动画效果
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {

    
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    
    if(self.tabbarCaptureImageV) {
        [fromViewController.view addSubview:self.tabbarCaptureImageV];
        UITabBar *tabBar = fromViewController.tabBarController.tabBar;
        tabBar.hidden = YES;
    }
    
    
    CGFloat screenW = containerView.bounds.size.width;
    CGFloat screenH = containerView.bounds.size.height;


    // 设置toViewController
    toViewController.view.frame = CGRectMake(screenW, 0, screenW, screenH);
    [containerView addSubview:toViewController.view];
    
    [UIView animateWithDuration:self.duration animations:^{
        
        CGRect frame = fromViewController.view.frame;
        frame.origin.x = -0.3 * frame.size.width;
        fromViewController.view.frame = frame;
        
        toViewController.view.frame = CGRectMake(0, 0, screenW, screenH);
    } completion:^(BOOL finished) {
        if(self.tabbarCaptureImageV) {
            [self.tabbarCaptureImageV removeFromSuperview];
        }
        fromViewController.navigationController.delegate = nil;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    


}

- (void)dealloc {
    NSLog(@"%@销毁了",self);
}



@end
