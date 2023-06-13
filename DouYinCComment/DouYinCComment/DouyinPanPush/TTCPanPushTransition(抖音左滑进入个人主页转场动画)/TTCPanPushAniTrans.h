//
//  TTCPanPushAniTrans.h
//  DouYinCComment
//
//  Created by 唐天成 on 2023/6/9.
//  Copyright © 2023 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTCPanPushAniTrans : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CGFloat duration;
//如果从tabbar页面跳进来的有值,否则为nil
@property (nonatomic, weak) UIImageView *tabbarCaptureImageV;

@property (nonatomic, weak) id<UINavigationControllerDelegate> previousNavDelegate;

@end

NS_ASSUME_NONNULL_END
