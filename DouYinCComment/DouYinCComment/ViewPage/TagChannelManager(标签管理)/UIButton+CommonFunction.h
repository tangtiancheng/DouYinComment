//
//  UIButton+CommonFunction.h
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/21.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (CommonFunction)

/**
 *  增加button的可点击范围
 */
- (void) setEnlargeEdgeWithTop:(CGFloat) top
                         right:(CGFloat) right
                        bottom:(CGFloat) bottom
                          left:(CGFloat) left;

@end

NS_ASSUME_NONNULL_END
