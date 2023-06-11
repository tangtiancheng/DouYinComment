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

//Present或Push转场动画代理
@property (nonatomic, weak) TTCSmallVideoPresentOrPushAniTrans *presentOrPushAniTrans;
//dismiss或Pop转场动画代理
@property (nonatomic, weak) TTCSmallVideoDismissOrPopAniTrans *dismissOrPopAniTrans;


@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, weak) UIViewController *fromVC;
@property (nonatomic, weak) UIViewController *toVC;


//黑色遮罩,拖拽的时候后面黑色半透遮罩
@property (nonatomic, strong) UIView *maskView;

//这两是拖拽的时候View变大变小要用的计算参数
@property (nonatomic, assign) CGRect viewFrame;
@property (nonatomic, assign) CGPoint startTapPoint;

//动画时长
@property (nonatomic, assign) CGFloat duration;


//push的时候如果需要hidesBottomBarWhenPushed,tabbar自己的push动画会对咱们得自定义转场照成很难看的干扰, 所以这时候咱们获取tabbar截图,把tabbar图片放到fromVC上,假装tabbar还在, 其实真的tabbar会hidden = YES隐藏掉,等转场动画完毕再把它显示出来
@property (nonatomic, strong) UIImageView *tabbarCaptureImageV;


@end

@implementation TTCTransitionDelegate

- (instancetype)init {
    if(self = [super init]) {
        self.duration = 0.25;
    }
    return self;
}


#pragma mark - 这个是push的
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  API_AVAILABLE(ios(7.0)) {

    self.navigationController = navigationController;
    if(operation == UINavigationControllerOperationPush) {
        //push
        self.tabbarCaptureImageV = [self getTabbarCaptureImageVFromViewController:fromVC toViewController:toVC];
        TTCSmallVideoPresentOrPushAniTrans *presentOrPushAniTrans = [[TTCSmallVideoPresentOrPushAniTrans alloc] init];
        presentOrPushAniTrans.duration = self.duration;
        self.presentOrPushAniTrans = presentOrPushAniTrans;
        presentOrPushAniTrans.smalCurPlayCell = self.smalCurPlayCell;
        presentOrPushAniTrans.maskView = self.maskView;
        [self prepareGestureRecognizerInView:toVC.view];
        presentOrPushAniTrans.fromVC = fromVC;
        presentOrPushAniTrans.toVC = toVC;
        presentOrPushAniTrans.tabbarCaptureImageV = self.tabbarCaptureImageV;
        self.fromVC = fromVC;
        self.toVC = toVC;
        return presentOrPushAniTrans;
        
    } else if(operation == UINavigationControllerOperationPop) {
        //pop
        TTCSmallVideoDismissOrPopAniTrans *dismissOrPopAniTrans = [[TTCSmallVideoDismissOrPopAniTrans alloc] init];
        dismissOrPopAniTrans.duration = self.duration;
        self.dismissOrPopAniTrans = dismissOrPopAniTrans;
        dismissOrPopAniTrans.smalCurPlayCell = self.smalCurPlayCell;
        dismissOrPopAniTrans.maskView = self.maskView;
        dismissOrPopAniTrans.tabbarCaptureImageV = self.tabbarCaptureImageV;
        return dismissOrPopAniTrans;
        
    } else {
        return nil;
    }
}







#pragma mark - 这个是present的
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



#pragma mark - PanGesture
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
//    self.panGesView = view;
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    gesture.delegate = self;
    [view addGestureRecognizer:gesture];
    self.viewFrame = view.frame;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            [gestureRecognizer.view.superview insertSubview:self.maskView belowSubview:gestureRecognizer.view];
            self.maskView.alpha = 1;
            
            if(self.tabbarCaptureImageV) {
                [self.fromVC.view addSubview:self.tabbarCaptureImageV];
            }
            
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat progressX = fabs(translation.x / SCREEN_WIDTH);
            CGFloat progressY = fabs(translation.y / SCREEN_HEIGHT);
            CGFloat progress = MAX(progressX, progressY);
            CGFloat ratio = 1.0f - progress*0.5f;
            gestureRecognizer.view.transform = CGAffineTransformMakeScale(ratio, ratio);
            gestureRecognizer.view.frame = CGRectMake(self.startTapPoint.x + translation.x - ratio * self.startTapPoint.x, self.startTapPoint.y + translation.y - ratio * self.startTapPoint.y, self.viewFrame.size.width * ratio, self.viewFrame.size.height * ratio);
            self.maskView.alpha = 1 - progress;
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            CGFloat progress = translation.x / SCREEN_WIDTH;
            //速度
            CGFloat velocity = [gestureRecognizer velocityInView:gestureRecognizer.view.superview].x;
            if(velocity < -300) {
                //往左轻扫
                [self viewResetToIdentifier];
            } else if(velocity > 300) {
                //往右轻扫
                [self popVC];
            } else {
                if (progress <= 0.25) {
                    [self viewResetToIdentifier];
                } else {
                    [self popVC];
                }
            }
            break;
        }
        default:
            break;
    }
}

- (void)viewResetToIdentifier {
    
    [UIView animateWithDuration:self.duration
                     animations:^{
        [self.toVC.view setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
        self.toVC.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.maskView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        if(self.tabbarCaptureImageV) {
            [self.tabbarCaptureImageV removeFromSuperview];
        }
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
    //一开始就往左滑动直接忽略本次手势
    self.startTapPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    CGPoint translationLog = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    if(translationLog.x < 0) {
        return NO;
    }
    return YES;
}


//push的时候如果需要hidesBottomBarWhenPushed,tabbar自己的push动画会对咱们得自定义转场照成很难看的干扰, 所以这时候咱们获取tabbar截图,把tabbar图片放到fromVC上,假装tabbar还在, 其实真的tabbar会hidden = YES隐藏掉,等转场动画完毕再把hidden = NO
- (UIImageView *)getTabbarCaptureImageVFromViewController:(UIViewController *)fromVC
                                         toViewController:(UIViewController *)toVC {
    //以下是判断是否需要隐藏tabbar
    BOOL isHideTabBar = NO;
    UIImageView *tabbarCaptureImageV = nil;
    isHideTabBar = fromVC.tabBarController && toVC.hidesBottomBarWhenPushed;
    UITabBar *tabBar = fromVC.tabBarController.tabBar;
    // tabBar位置不对或隐藏
    if (tabBar.frame.origin.x != 0 || tabBar.isHidden) {
        isHideTabBar = NO;
    }
    if([fromVC.navigationController.childViewControllers containsObject:fromVC.tabBarController]) {
        isHideTabBar = NO;
    }
    if(isHideTabBar) {
        
        UIGraphicsBeginImageContextWithOptions(tabBar.bounds.size, NO, UIScreen.mainScreen.scale);
        [tabBar drawViewHierarchyInRect:tabBar.bounds afterScreenUpdates:NO];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        tabbarCaptureImageV = [[UIImageView alloc] initWithImage:image];
        [fromVC.view addSubview:tabbarCaptureImageV];
        CGRect frame = tabBar.frame;
        frame.origin.x = 0;
        tabbarCaptureImageV.frame = frame;
        return tabbarCaptureImageV;
    }
    return nil;
}



- (UIView *)maskView {
    if(!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = RGBA(0, 0, 0, 0.9);
    }
    return _maskView;
}


- (void)dealloc {
    NSLog(@"%@销毁了",self);
}

@end
