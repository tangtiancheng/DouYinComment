//
//  UIViewController+DDTransitionAnimator.h
//  RingtoneDuoduo
//
//  Created by han on 2021/9/23.
//  Copyright © 2021 duoduo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTCTransitionDelegate;
NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (TTCTransitionAnimator)

@property (nonatomic, strong) TTCTransitionDelegate *ttcTransitionDelegate;

@end

@interface UINavigationController (TTCTransitionAnimator)


@end




NS_ASSUME_NONNULL_END
