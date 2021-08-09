//
//  CommentInputView.m
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2017/7/5.
//  Copyright © 2017年 www.ShoujiDuoduo.com. All rights reserved.
//

#import "CommentInputView.h"
#import "Masonry.h"
#import "TTCCom.h"

@interface CommentInputView ()

@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property(nonatomic, strong) UIButton *sendButton;

@end

@implementation CommentInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
//        @weakify(self);
        UIView *commentWhiteView = [[UIView alloc]init];
        commentWhiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:commentWhiteView];
        [commentWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.with.offset(14   );
            make.top.with.offset(7   );
            make.bottom.with.offset(-7   );
            make.right.with.offset(-53   );
        }];
        
        UIImageView *penImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"writeComment"]];
        [commentWhiteView addSubview:penImageView];
        [penImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.with.offset(10   );
            make.top.with.offset(7   );
            make.width.height.mas_equalTo(24   );
        }];
        
        _placeHolderLabel = [[UILabel alloc] init];
        [commentWhiteView addSubview:_placeHolderLabel];
        _placeHolderLabel.font = [UIFont systemFontOfSize:15.0   ];
        _placeHolderLabel.text = @"说点什么...";
        _placeHolderLabel.textColor = RGBA(173, 178, 187, 1);
        _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
        [_placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.with.offset(10   );
            make.left.with.offset(34   );
            make.right.with.offset(-11   );
            make.height.mas_equalTo(16   );
        }];
        
        
        _commentTextView = [[UITextView alloc] init];
        _commentTextView.textContainerInset = UIEdgeInsetsMake(10   , 0, 10   , 0);
        _commentTextView.backgroundColor = [UIColor clearColor];
        _commentTextView.returnKeyType = UIReturnKeySend;
        _commentTextView.font = [UIFont systemFontOfSize:15.0   ];
        //    _commentTextView.delegate = self;
        [commentWhiteView addSubview:_commentTextView];
        [_commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.with.offset(0);
            make.left.with.offset(30   );
            make.right.with.offset(-11   );
            //        make.height.mas_equalTo(11);
            make.bottom.with.offset(0);
        }];
        
        UIButton *sendButton = [[UIButton alloc]init];
        self.sendButton = sendButton;
        [self addSubview:sendButton];
        sendButton.titleLabel.font = [UIFont systemFontOfSize:15   ];
        [sendButton setTitleColor:RGBA(61, 204, 121, 1) forState:UIControlStateNormal];
        [sendButton setTitleColor:RGBA(173, 178, 187, 1) forState:UIControlStateDisabled];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.with.offset(0);
            make.left.equalTo(commentWhiteView.mas_right).with.offset(0);
            make.height.mas_equalTo(50   );
        }];

    }
    return self;
}



@end
