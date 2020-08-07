//
//  UIView+EasyFrame.h
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/7.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (EasyFrame)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@end

NS_ASSUME_NONNULL_END
