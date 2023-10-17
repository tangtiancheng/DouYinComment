//
//  UIViewController+TTCPanPush.h
//  DouYinCComment
//
//  Created by 唐天成 on 2023/6/9.
//  Copyright © 2023 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (TTCPanPush)

//block返回一个要Push的控制器即可
- (void)getpanPushToViewController:(UIViewController * (^ __nullable)(void))panPushBlock;



@end

NS_ASSUME_NONNULL_END
