//
//  CommentTextView.m
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2019/1/14.
//  Copyright © 2019年 duoduo. All rights reserved.
//

#import "CommentTextView.h"
#import "TTCCom.h"
#import "UIView+EasyFrame.h"
#import "ReactiveObjC.h"
@interface CommentTextView ()<UITextViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat            textHeight;
@property (nonatomic, assign) CGFloat            keyboardHeight;

@property (nonatomic, strong) UIView *textBackView;

@property (nonatomic, strong) UIButton *sendButton;
//@property (nonatomic, strong) UIVisualEffectView *visualEffectView;

@property (nonatomic, strong) UIView *lineView;

@end


@implementation CommentTextView
- (instancetype)init {
    self = [super init];
    if(self) {
        self.frame = [UIScreen mainScreen].bounds;//ScreenFrame;
        self.backgroundColor = [UIColor clearColor];//ColorClear;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)]];
       
        UIFont *textViewFont = [UIFont systemFontOfSize:15  ];
        
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - (2 * kCommentTextViewTopBottomInset + ceilf(textViewFont.lineHeight) + kCommentTextViewTopSpace + kCommentTextViewBottomSpace) - SafeAreaBottomHeight, SCREEN_WIDTH, (2 * kCommentTextViewTopBottomInset + ceilf(textViewFont.lineHeight) + kCommentTextViewTopSpace + kCommentTextViewBottomSpace) + SafeAreaBottomHeight)];
        _container.backgroundColor = RGBA(244, 245, 246, 1);
        [self addSubview:_container];
        
        _textBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (2 * kCommentTextViewTopBottomInset + ceilf(textViewFont.lineHeight) + kCommentTextViewTopSpace + kCommentTextViewBottomSpace))];
        _textBackView.backgroundColor = RGBA(244, 245, 246, 1);
        [_container addSubview:_textBackView];
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(kCommentTextViewLeftSpace, kCommentTextViewTopSpace, SCREEN_WIDTH - kCommentTextViewLeftSpace - kCommentTextViewRightSpace, ceilf(textViewFont.lineHeight) + 2 * kCommentTextViewTopBottomInset)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.clipsToBounds = NO;
        _textView.textColor = [UIColor blackColor];
        _textView.font = textViewFont;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.scrollEnabled = NO;
        _textView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
        _textView.textContainerInset = UIEdgeInsetsMake(kCommentTextViewTopBottomInset, kCommentTextViewLeftInset, kCommentTextViewTopBottomInset, kCommentTextViewRightInset);
        _textView.textContainer.lineFragmentPadding = 0;
        _textHeight = ceilf(textViewFont.lineHeight);
        [_textBackView addSubview:_textView];
        _textView.delegate = self;
        
        
        _placeholderLabel = [[UILabel alloc]init];
        _placeholderLabel.text = @"说点什么...";
        _placeholderLabel.textColor = RGBA(173, 178, 187, 1);//ColorGray;
        _placeholderLabel.font = _textView.font;//BigFont;
        _placeholderLabel.frame = CGRectMake(kCommentTextViewLeftInset, 0, _textView.width, _textView.height);
        [_textView addSubview:_placeholderLabel];
        
        
        UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake(_textView.right, 0, SCREEN_WIDTH - _textView.right, _textBackView.height)];
        self.sendButton = sendButton;
        self.sendButton.enabled = NO;
        [self.sendButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
        sendButton.titleLabel.font = [UIFont systemFontOfSize:15  ];
        [sendButton setTitleColor:RGBA(61, 204, 121, 1) forState:UIControlStateNormal];
        [sendButton setTitleColor:RGBA(173, 178, 187, 1) forState:UIControlStateDisabled];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_textBackView addSubview:sendButton];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        self.lineView.backgroundColor = RGBA(244, 245, 246, 1);
        [self.container addSubview:self.lineView];
//        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.with.offset(0);
//            make.height.mas_equalTo(0.5);
//        }];
        _keyboardHeight = SafeAreaBottomHeight;
        @weakify(self);

        [RACObserve(self.textView, text)subscribeNext:^(NSString *text) {
            @strongify(self);
            if (text.length) {
                self.sendButton.enabled = YES;
                [_placeholderLabel setHidden:YES];
            } else {
                self.sendButton.enabled = NO;
                [_placeholderLabel setHidden:NO];
            }
        }];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
//    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0f, 10.0f)];
//    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
//    [shape setPath:rounded.CGPath];
//    _container.layer.mask = shape;
    
    [self updateTextViewFrame];
}


- (void)updateTextViewFrame {

    CGFloat textViewHeight = 0.0;
    if(_keyboardHeight > SafeAreaBottomHeight) {
        textViewHeight = _textHeight + 2 * kCommentTextViewTopBottomInset ;
    } else {
        textViewHeight = ceilf(_textView.font.lineHeight) + 2 * kCommentTextViewTopBottomInset ;
    }
    _textBackView.frame = CGRectMake(0, 0, SCREEN_WIDTH, textViewHeight + kCommentTextViewTopSpace + kCommentTextViewBottomSpace);
    _textView.frame = CGRectMake(kCommentTextViewLeftSpace, kCommentTextViewTopSpace, SCREEN_WIDTH - kCommentTextViewLeftSpace - kCommentTextViewRightSpace, textViewHeight);
    _container.frame = CGRectMake(0, SCREEN_HEIGHT - _keyboardHeight - textViewHeight - kCommentTextViewTopSpace - kCommentTextViewBottomSpace, SCREEN_WIDTH, textViewHeight + _keyboardHeight + kCommentTextViewTopSpace + kCommentTextViewBottomSpace);
}

#pragma mark - Action
- (void)sendComment {
    [self textView:self.textView shouldChangeTextInRange:NSMakeRange(0, 0) replacementText:@"\n"];
}


#pragma mark - keyboard notification
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;//[self userInfo];
    CGSize size = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat keyBoardHeight = UIInterfaceOrientationIsLandscape(orientation) ? size.width : size.height;
    
    
    _keyboardHeight = keyBoardHeight;
    [self updateTextViewFrame];
//    _textView.textColor = [UIColor blackColor];
    self.backgroundColor = RGBA(0, 0, 0, 0.6);//ColorBlackAlpha60;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _keyboardHeight = SafeAreaBottomHeight;
    [self updateTextViewFrame];
//    _textView.textColor = [UIColor whiteColor];//ColorWhite;
    self.backgroundColor = [UIColor clearColor];//ColorClear;
}

#pragma mark -  UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
    
    if(!textView.hasText) {
        [_placeholderLabel setHidden:NO];
        self.sendButton.enabled = NO;
        _textHeight = ceilf(_textView.font.lineHeight);
    }else {
        [_placeholderLabel setHidden:YES];
        self.sendButton.enabled = YES;
        CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - kCommentTextViewLeftInset - kCommentTextViewRightInset - kCommentTextViewLeftSpace - kCommentTextViewRightSpace, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        _textHeight = CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height)).height;
    }
    [self updateTextViewFrame];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {//判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        if(textView.text.length == 0) {
            return NO;
        }
        if([self.delegate respondsToSelector:@selector(onSendText:)]) {
            [self.delegate onSendText:textView.text];
//            [_placeholderLabel setHidden:NO];
//            self.sendButton.enabled = NO;
//            textView.text = @"";
            _textHeight = ceilf(textView.font.lineHeight);
            [textView resignFirstResponder];
        }
        return NO;
    }
    return YES;
}

#pragma mark - handle guesture tap
- (void)handleGuesture:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:_container];
    if(![_container.layer containsPoint:point]) {
        [_textView resignFirstResponder];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        if(hitView.backgroundColor == [UIColor clearColor]) {
            return nil;
        }
    }
    return hitView;
}

#pragma mark - update method
- (void)showToView:(UIView *)view {
   // UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [view addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
