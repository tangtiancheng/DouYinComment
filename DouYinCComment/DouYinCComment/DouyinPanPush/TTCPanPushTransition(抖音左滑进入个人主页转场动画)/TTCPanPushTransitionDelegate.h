//
//  TTCPanPushTransitionDelegate.h
//  DouYinCComment
//
//  Created by 唐天成 on 2023/6/9.
//  Copyright © 2023 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTCPanPushTransitionDelegate : NSObject<UINavigationControllerDelegate>



- (instancetype)initWithPushPanVC:(UIViewController *)fromVC panPushToViewController:(UIViewController * (^ __nullable)(void))panPushBlock;

@property (nonatomic, copy, readonly) UIViewController *(^panPushBlock) (void);


@end

NS_ASSUME_NONNULL_END
