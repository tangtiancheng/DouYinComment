//
//  CommentTextView.h
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2019/1/14.
//  Copyright © 2019年 duoduo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CommentTextViewDelegate<NSObject>

-(void)onSendText:(NSString *)text;

@end

#define kCommentTextViewLeftSpace   10  
#define kCommentTextViewTopSpace    10  
#define kCommentTextViewRightSpace  55  
#define kCommentTextViewBottomSpace 10  


#define kCommentTextViewLeftInset   5  
#define kCommentTextViewRightInset  5  
#define kCommentTextViewTopBottomInset  5  

@interface CommentTextView : UIView

@property (nonatomic, strong) UIView                         *container;
@property (nonatomic, strong) UITextView                     *textView;
@property (nonatomic, strong) UILabel            *placeholderLabel;
@property (nonatomic, weak) id<CommentTextViewDelegate> delegate;


- (void)showToView:(UIView *)view;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
