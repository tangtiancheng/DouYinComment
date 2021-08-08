//
//  MyHeaderView.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/6.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "MyHeaderView.h"

@interface MyHeaderView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIVisualEffectView *topBackVisualView;

@end

@implementation MyHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setupBaseView];
    }
    return self;
}

- (void)setupBaseView {
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerImage"]];
    self.imageView.frame = self.bounds;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.masksToBounds = YES;
    [self addSubview:self.imageView];

    //设置UIVisualEffectView
    UIVisualEffectView *topBackVisualView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.topBackVisualView = topBackVisualView;
    topBackVisualView.alpha = 0.2;
    topBackVisualView.backgroundColor = RGBA(0, 0, 0, 0.3);
    [self.imageView addSubview:topBackVisualView];
    topBackVisualView.frame = self.imageView.bounds;
    [topBackVisualView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.with.offset(0);
    }];
}


- (void)resetFrame:(CGRect)frame {
    self.frame = frame;
    self.imageView.frame = self.bounds;
    self.topBackVisualView.frame = self.imageView.bounds;

}

@end
