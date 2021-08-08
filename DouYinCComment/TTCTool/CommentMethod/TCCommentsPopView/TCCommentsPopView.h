//
//  CommentsPopView.h
//  Douyin
//
//  Created by Tang TianCheng 
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//你只需要把 TCCommentsPopView 这个类拖入你的工程里就可以实现抖音评论拖拽效果,具体使用参照demo

#import <UIKit/UIKit.h>


@interface TCCommentsPopView:UIView

+ (instancetype)commentsPopViewWithFrame:(CGRect)frame commentBackView:(UIView *)commentBackView;
- (void)showToView:(UIView *)view;
- (void)dismiss;

@end






