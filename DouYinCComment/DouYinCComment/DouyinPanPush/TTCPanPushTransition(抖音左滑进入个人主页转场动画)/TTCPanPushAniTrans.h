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
//是否有tabbarPush干扰
@property (nonatomic, weak) UIImageView *tabbarCaptureImageV;

@end

NS_ASSUME_NONNULL_END
