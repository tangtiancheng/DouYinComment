//
//  UIViewController+TTCPanPush.m
//  DouYinCComment
//
//  Created by 唐天成 on 2023/6/9.
//  Copyright © 2023 唐天成. All rights reserved.
//

#import "UIViewController+TTCPanPush.h"
#import <objc/runtime.h>
#import "TTCPanPushTransitionDelegate.h"

@interface UIViewController ()

@property (nonatomic, strong) TTCPanPushTransitionDelegate *panPushTransitionDelegate;

//左右拖拽最后时刻的位移
@property (nonatomic, assign) CGFloat drapDistance;
//往左快速轻扫(回位) 和 往右快速轻扫(Pop Dismiss)
@property (nonatomic, assign) CGFloat lastDrapDistance;

@end

@implementation UIViewController (TTCPanPush)

//block返回一个要Push的控制器即可
- (void)getpanPushToViewController:(UIViewController * (^ __nullable)(void))panPushBlock {
    if(panPushBlock) {
        self.panPushTransitionDelegate = [[TTCPanPushTransitionDelegate alloc] initWithPushPanVC:self panPushToViewController:panPushBlock];
    }
}


- (void)setPanPushTransitionDelegate:(TTCPanPushTransitionDelegate *)panPushTransitionDelegate
{
    objc_setAssociatedObject(self, @selector(panPushTransitionDelegate), panPushTransitionDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (TTCPanPushTransitionDelegate *)panPushTransitionDelegate
{
    return objc_getAssociatedObject(self, @selector(panPushTransitionDelegate));
}


@end

