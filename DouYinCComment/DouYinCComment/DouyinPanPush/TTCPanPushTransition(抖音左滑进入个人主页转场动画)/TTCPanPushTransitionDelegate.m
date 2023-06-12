//
//  TTCPanPushTransitionDelegate.m
//  DouYinCComment
//
//  Created by 唐天成 on 2023/6/9.
//  Copyright © 2023 唐天成. All rights reserved.
//

#import "TTCPanPushTransitionDelegate.h"
#import "TTCPanPushAniTrans.h"
#import "UIViewController+TTCPanPush.h"

@interface TTCPanPushTransitionDelegate ()<UIGestureRecognizerDelegate>

//添加拖拽手势的控制器
@property (nonatomic, weak) UIViewController *panPushVC;
//获取要push到哪个控制器
@property (nonatomic, copy) UIViewController *(^panPushBlock) (void);
//手势
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
//可交互代理
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;
//动画时长
@property (nonatomic, assign) CGFloat duration;

//push的时候如果需要hidesBottomBarWhenPushed,tabbar自己的push动画会对咱们得自定义转场照成很难看的干扰, 所以这时候咱们获取tabbar截图,把tabbar图片放到fromVC上,假装tabbar还在, 其实真的tabbar会hidden = YES隐藏掉,等转场动画完毕再把它显示出来
@property (nonatomic, strong) UIImageView *tabbarCaptureImageV;

@end

@implementation TTCPanPushTransitionDelegate

- (instancetype)initWithPushPanVC:(UIViewController *)panPushVC panPushToViewController:(UIViewController * (^ __nullable)(void))panPushBlock {
    if(self = [super init]) {
        self.panPushVC = panPushVC;
        self.panPushBlock = panPushBlock;
        [self setupPanGes];
    }
    return self;
}


- (void)setupPanGes {
    self.duration = 0.5;
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlepanPushGesture:)];
    self.panGestureRecognizer.delegate = self;
    [self.panPushVC.view addGestureRecognizer:self.panGestureRecognizer];
}



#pragma mark - 这个是push的
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  API_AVAILABLE(ios(7.0)) {
    if(operation == UINavigationControllerOperationPush) {
        self.tabbarCaptureImageV = [self getTabbarCaptureImageVFromViewController:fromVC toViewController:toVC];
        //push
        TTCPanPushAniTrans *panPushAniTrans = [[TTCPanPushAniTrans alloc] init];
        panPushAniTrans.duration = self.duration;
        panPushAniTrans.tabbarCaptureImageV = self.tabbarCaptureImageV;
        return panPushAniTrans;
    } else if(operation == UINavigationControllerOperationPop) {
        //pop
        return nil;
    } else {
        return nil;
    }
}

//交互
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(nonnull id<UIViewControllerAnimatedTransitioning>)animationController{
    
    self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
    return self.interactiveTransition;
}



#pragma mark - PanGesture
- (void)handlepanPushGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    CGFloat scale = -translation.x / [UIScreen mainScreen].bounds.size.width;
//    CGFloat velocity = [gestureRecognizer velocityInView:gestureRecognizer.view.superview].x;
//    NSLog(@"132 %lf %ld %lf",translation.x,gestureRecognizer.state,velocity);

    scale = scale < 0 ? 0 : scale;
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            
            NSLog(@"%@", self.panPushVC.view.nextResponder);
            UINavigationController *navigationController = [self getNavigationVC:self.panPushVC];
            UIViewController *toVC = self.panPushBlock();
            if(navigationController && [toVC isKindOfClass:[UIViewController class]]) {
                navigationController.delegate = self;
                [navigationController pushViewController:toVC animated:YES];
                NSLog(@"132");
            } else {
                //你这都没导航控制器,那还做啥push,直接取消手势,功能不给你用
                gestureRecognizer.enabled = NO;
                gestureRecognizer.enabled = YES;
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {          
            [self.interactiveTransition updateInteractiveTransition:scale];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            //速度
            CGFloat velocity = [gestureRecognizer velocityInView:gestureRecognizer.view.superview].x;
            
            if(velocity < -300) {
                //往左轻扫直接push
                [self.interactiveTransition finishInteractiveTransition];
            } else if(velocity > 300) {
                //往右轻扫取消push
                [self.interactiveTransition cancelInteractiveTransition];
            } else {
                if (scale <= 0.5) {
                    [self.interactiveTransition cancelInteractiveTransition];
                } else {
                    [self.interactiveTransition finishInteractiveTransition];
                }
            }
            break;
        }
        default: {
            [self.interactiveTransition cancelInteractiveTransition];
            break;
        }
    }
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


//获取navigationVC
- (UINavigationController *)getNavigationVC:(UIViewController *)vc {
    if(vc) {
        if(vc.navigationController) {
            return vc.navigationController;
        } else {
            UIView *supV = vc.view.superview;
            if(supV) {
                vc = [self getViewController:supV];
                return [self getNavigationVC:vc];
            } else {
                return nil;
            }
        }
    } else {
        return nil;
    }
}
- (UIViewController *)getViewController:(UIView *)view {
    UIResponder *next = view.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}


#pragma mark - UIGestureRecognizeDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    //一开始就往右滑动直接忽略本次手势
//    self.startTapPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    CGPoint translationLog = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    if(translationLog.x > 0) {
        return NO;
    }
    return YES;
}


@end
