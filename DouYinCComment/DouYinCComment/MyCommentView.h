//
//  MyCommnetView.h
//  DouYinCComment
//
//  Created by 唐天成 on 2019/4/10.
//  Copyright © 2019 唐天成. All rights reserved.
//  这个应该是你给我提供的你自己写的评论View,里面正常应该包括评论列表,还有评论textView,这种简单的如果可以自行实现,本demo只提供TCCommentsPopView一个类来实现仿照抖音的评论手势(在我负责的项目"铃声多多"的小视频评论里已经实现了和抖音评论手势一模一样的功能) 如果觉得好用希望给一个star

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyCommentViewDelegate <NSObject>

- (void)closeComment;

@end

@interface MyCommentView : UIView

@property (nonatomic, weak) id<MyCommentViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
