//
//  TTCTransitionDelegate.h
//  DouYinCComment
//
//  Created by han on 2021/10/30.
//  Copyright © 2021 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+TTCTransitionAnimator.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTCTransitionDelegate : NSObject<UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>


@property (nonatomic, weak) UIView *smalCurPlayCell;


@end

NS_ASSUME_NONNULL_END
