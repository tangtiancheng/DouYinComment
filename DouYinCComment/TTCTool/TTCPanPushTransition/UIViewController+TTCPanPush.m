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

