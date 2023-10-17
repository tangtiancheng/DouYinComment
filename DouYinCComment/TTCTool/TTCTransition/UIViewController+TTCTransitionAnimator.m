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
        [self ttcPushVCswizzled];
    });
}

+ (void)ttcPushVCswizzled {
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

@end






@implementation UINavigationController (TTCTransitionAnimator)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self ttcPushVCswizzled];
    });
}

+ (void)ttcPushVCswizzled {
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






