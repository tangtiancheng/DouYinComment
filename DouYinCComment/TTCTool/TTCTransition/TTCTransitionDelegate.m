//
//  TTCPresentTransitionDelegate.m
//  DouYinCComment
//
//  Created by han on 2021/10/30.
//  Copyright © 2021 唐天成. All rights reserved.
//

#import "TTCTransitionDelegate.h"
#import "TTCSmallVideoPresentOrPushAniTrans.h"
#import "TTCSmallVideoDismissOrPopAniTrans.h"
#import "TTCCom.h"

@interface TTCTransitionDelegate ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) TTCSmallVideoPresentOrPushAniTrans *presentOrPushAniTrans;
@property (nonatomic, weak) TTCSmallVideoDismissOrPopAniTrans *dismissOrPopAniTrans;


@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, weak) UIViewController *fromVC;
@property (nonatomic, weak) UIViewController *toVC;


//黑色遮罩
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, weak) UIView *panGesView;

@property (nonatomic, assign) CGRect viewFrame;
@property (nonatomic, assign) CGPoint startTapPoint;
@property (nonatomic, assign) CGFloat duration;

//左右拖拽最后时刻的位移
@property (nonatomic, assign) CGFloat drapDistance;
@property (nonatomic, assign) CGFloat lastDrapDistance;


@end

@implementation TTCTransitionDelegate

- (instancetype)init {
    if(self = [super init]) {
        self.duration = 0.25;
        self.drapDistance = 0;
        self.lastDrapDistance = 0;
    }
    return self;
}


//这个是push的
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  API_AVAILABLE(ios(7.0)) {
    self.navigationController = navigationController;
    if(operation == UINavigationControllerOperationPush) {
        TTCSmallVideoPresentOrPushAniTrans *presentOrPushAniTrans = [[TTCSmallVideoPresentOrPushAniTrans alloc] init];
        presentOrPushAniTrans.duration = self.duration;
        self.presentOrPushAniTrans = presentOrPushAniTrans;
        presentOrPushAniTrans.smalCurPlayCell = self.smalCurPlayCell;
        presentOrPushAniTrans.maskView = self.maskView;
        [self prepareGestureRecognizerInView:toVC.view];
        presentOrPushAniTrans.fromVC = fromVC;
        presentOrPushAniTrans.toVC = toVC;
        self.fromVC = fromVC;
        self.toVC = toVC;
        return presentOrPushAniTrans;
    } else if(operation == UINavigationControllerOperationPop) {
        TTCSmallVideoDismissOrPopAniTrans *dismissOrPopAniTrans = [[TTCSmallVideoDismissOrPopAniTrans alloc] init];
        dismissOrPopAniTrans.duration = self.duration;
        self.dismissOrPopAniTrans = dismissOrPopAniTrans;
        dismissOrPopAniTrans.smalCurPlayCell = self.smalCurPlayCell;
        dismissOrPopAniTrans.maskView = self.maskView;
        return dismissOrPopAniTrans;
    } else {
        return nil;
    }
}



//这个是present
/// 这个函数用来设置当执行present方法时进行的转场动画
/// @param presented 要弹出的Controller
/// @param presenting 当前的Controller
/// @param source 源Controller,对于present动作,presenting与source是一样的
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    TTCSmallVideoPresentOrPushAniTrans *presentOrPushAniTrans = [[TTCSmallVideoPresentOrPushAniTrans alloc] init];
    presentOrPushAniTrans.duration = self.duration;
    self.presentOrPushAniTrans = presentOrPushAniTrans;
    presentOrPushAniTrans.smalCurPlayCell = self.smalCurPlayCell;
    presentOrPushAniTrans.maskView = self.maskView;
    [self prepareGestureRecognizerInView:presented.view];
    self.fromVC = source;
    self.toVC = presented;
    presentOrPushAniTrans.fromVC = source;
    presentOrPushAniTrans.toVC = presented;
    return presentOrPushAniTrans;
}
//这个是present
/// 这个函数用来设置当执行dismiss方法时进行的转场动画
/// @param dismissed
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    TTCSmallVideoDismissOrPopAniTrans *dismissOrPopAniTrans = [[TTCSmallVideoDismissOrPopAniTrans alloc] init];
    dismissOrPopAniTrans.duration = self.duration;
    self.dismissOrPopAniTrans = dismissOrPopAniTrans;
    dismissOrPopAniTrans.smalCurPlayCell = self.smalCurPlayCell;
    dismissOrPopAniTrans.maskView = self.maskView;
    return dismissOrPopAniTrans;
}



- (void)setSmalCurPlayCell:(UIView *)smalCurPlayCell {
    _smalCurPlayCell.alpha = 1;
    if(_smalCurPlayCell) {
        smalCurPlayCell.alpha = 0.0;
    }
    _smalCurPlayCell = smalCurPlayCell;
    self.presentOrPushAniTrans.smalCurPlayCell = smalCurPlayCell;
    self.dismissOrPopAniTrans.smalCurPlayCell = smalCurPlayCell;

}

- (void)prepareGestureRecognizerInView:(UIView*)view {
    self.panGesView = view;
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    gesture.delegate = self;
    [view addGestureRecognizer:gesture];
    self.viewFrame = view.frame;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:self.panGesView.superview];

    //    if(!_interacting && (translation.x < 0 || translation.y < 0 || translation.x < translation.y)) {
    //        return;
    //    }
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            //            _interacting = YES;
            
            [self.panGesView.superview insertSubview:self.maskView belowSubview:self.panGesView];
            self.maskView.alpha = 1;
            
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat progressX = fabs(translation.x / SCREEN_WIDTH);
            CGFloat progressY = fabs(translation.y / SCREEN_HEIGHT);
            CGFloat progress = MAX(progressX, progressY);
            
            CGFloat ratio = 1.0f - progress*0.5f;
            
            //            [self.panGesView setCenter:CGPointMake(self.viewCenter.x + translation.x * (1.0f - fabs(progressX)*0.5f), self.viewCenter.y + translation.y * (1.0f - fabs(progressY)*0.5f))];
            
            self.panGesView.transform = CGAffineTransformMakeScale(ratio, ratio);
            self.panGesView.frame = CGRectMake(self.startTapPoint.x + translation.x - ratio * self.startTapPoint.x, self.startTapPoint.y + translation.y - ratio * self.startTapPoint.y, self.viewFrame.size.width * ratio, self.viewFrame.size.height * ratio);
            self.maskView.alpha = 1 - progress;
            
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            CGFloat progress = translation.x / SCREEN_WIDTH;
            if(self.lastDrapDistance < -10) {
                [self viewResetToIdentifier];

            } else {
                if (progress <= 0.25) {
                    if(self.lastDrapDistance > 10) {
                        //如果是类似轻扫的那种
                        [self popVC];

                    } else {
                        [self viewResetToIdentifier];
                    }
                } else {
                    //                _interacting = NO;
                    //                [self finishInteractiveTransition];
                    //                [_presentingVC dismissViewControllerAnimated:YES completion:nil];
//                    [GetAppDelegate().globalNaviatrionController popViewControllerAnimated:YES];
                    [self popVC];
                }
            }
            
            
            break;
        }
        default:
            break;
    }
    self.lastDrapDistance = translation.x - self.drapDistance;
    self.drapDistance = translation.x;
}

- (void)viewResetToIdentifier {
    [UIView animateWithDuration:self.duration
                     animations:^{
        [self.panGesView setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
        self.panGesView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.maskView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
    }];
}
- (void)popVC {
    if(self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.toVC dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - UIGestureRecognizeDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    self.startTapPoint = [gestureRecognizer locationInView:self.panGesView.superview];
    CGPoint translationLog = [gestureRecognizer translationInView:self.panGesView.superview];
    if(translationLog.x < 0) {
        return NO;
    }
    return YES;
}

- (UIView *)maskView {
    if(!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = RGBA(0, 0, 0, 0.9);//[UIColor redColor];
    }
    return _maskView;
}


- (void)dealloc {
    NSLog(@"%@销毁了",self);
}

@end
