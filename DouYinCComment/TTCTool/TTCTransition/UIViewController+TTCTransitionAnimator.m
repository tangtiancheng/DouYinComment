//
//  UIViewController+DDTransitionAnimator.m
//  RingtoneDuoduo
//
//  Created by han on 2021/9/23.
//  Copyright © 2021 duoduo. All rights reserved.
//

#import "UIViewController+TTCTransitionAnimator.h"
#import <objc/runtime.h>
#import "TTCTransitionDelegate.h"

@interface UIViewController ()


@end

@implementation UIViewController (TTCTransitionAnimator)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self pushVCswizzled];
    });
}

+ (void)pushVCswizzled {
    Class class = [self class];
    SEL originalSelector = @selector(viewDidAppear:);
    SEL swizzledSelector = @selector(TTCviewDidAppear:);
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if(!originalMethod) {
        return;
    }
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)TTCviewDidAppear:(BOOL)animated {
    if(self.navigationController.viewControllers.lastObject == self) {
        if(self.ttcTransitionDelegate && animated) {
            self.navigationController.delegate = self.ttcTransitionDelegate;
        } else if([self.navigationController.delegate isKindOfClass:[TTCTransitionDelegate class]]) {
            self.navigationController.delegate = nil;
        }
    } 
    [self TTCviewDidAppear:animated];
}


- (void)setTtcTransitionDelegate:(TTCTransitionDelegate *)ttcTransitionDelegate
{
    // 让这个字符串与当前对象产生联系
    //    _name = name;
    // object:给哪个对象添加属性
    // key:属性名称
    // value:属性值
    // policy:保存策略
    objc_setAssociatedObject(self, @selector(ttcTransitionDelegate), ttcTransitionDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.transitioningDelegate = ttcTransitionDelegate;
    
}
- (TTCTransitionDelegate *)ttcTransitionDelegate
{
    return objc_getAssociatedObject(self, @selector(ttcTransitionDelegate));
}


//- (void)setTabbarCaptureImageV:(UIImageView *)tabbarCaptureImageV
//{
//    // 让这个字符串与当前对象产生联系
//    //    _name = name;
//    // object:给哪个对象添加属性
//    // key:属性名称
//    // value:属性值
//    // policy:保存策略
//    objc_setAssociatedObject(self, @selector(tabbarCaptureImageV), tabbarCaptureImageV, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    self.tabbarCaptureImageV = tabbarCaptureImageV;
//    
//}
//- (UIImageView *)tabbarCaptureImageV
//{
//    return objc_getAssociatedObject(self, @selector(tabbarCaptureImageV));
//}



@end




@implementation UINavigationController (TTCTransitionAnimator)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self pushVCswizzled];
    });
}

+ (void)pushVCswizzled {
    Class class = [self class];
    SEL originalSelector = @selector(pushViewController:animated:);
    SEL swizzledSelector = @selector(TTCpushViewController:animated:);
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if(!originalMethod) {
        return;
    }
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)TTCpushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if(viewController.ttcTransitionDelegate && animated) {
        self.delegate = viewController.ttcTransitionDelegate;
    } else if([self.delegate isKindOfClass:[TTCTransitionDelegate class]]) {
        self.delegate = nil;
    }
    [self TTCpushViewController:viewController animated:animated];
}

@end




@implementation UIView (TTCTransitionAnimator)

- (UIImage *)getCaptureImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, UIScreen.mainScreen.scale);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


//push的时候如果需要hidesBottomBarWhenPushed,tabbar自己的push动画会对咱们得自定义转场照成很难看的干扰, 所以这时候咱们获取tabbar截图,把tabbar图片放到fromVC上,假装tabbar还在, 其实真的tabbar会hidden = YES隐藏掉,等转场动画完毕再把hidden = NO
+ (UIImageView *)getTabbarCaptureImageVFromViewController:(UIViewController *)fromVC
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
        tabbarCaptureImageV = [[UIImageView alloc] initWithImage:[tabBar getCaptureImage]];
        [fromVC.view addSubview:tabbarCaptureImageV];
        CGRect frame = tabBar.frame;
        frame.origin.x = 0;
        tabbarCaptureImageV.frame = frame;
        return tabbarCaptureImageV;
    }
    return nil;
}

@end
