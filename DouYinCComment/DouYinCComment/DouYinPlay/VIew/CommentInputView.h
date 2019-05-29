//
//  CommentInputView.h
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2017/7/5.
//  Copyright © 2017年 www.ShoujiDuoduo.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentInputView : UIView

@property (nonatomic, strong, readonly) UITextView *commentTextView;
@property (nonatomic, strong, readonly) UILabel *placeHolderLabel;
@property (nonatomic, strong, readonly) UIButton *sendButton;

@end
