//
//  CommentsPopView.h
//  Douyin
//
//  Created by Tang TianCheng 
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//  

#import <UIKit/UIKit.h>


@interface TCCommentsPopView:UIView

+ (instancetype)commentsPopViewWithFrame:(CGRect)frame commentBackView:(UIView *)commentBackView;
- (void)showToView:(UIView *)view;
- (void)dismiss;

@end






