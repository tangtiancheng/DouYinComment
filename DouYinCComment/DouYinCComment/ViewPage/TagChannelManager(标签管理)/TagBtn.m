//
//  TagBtn.m
//  标签栏
//
//  Created by 唐天成 on 2020/8/8.
//  Copyright © 2020 xushuoa. All rights reserved.
//

#import "TagBtn.h"
#import "UIView+CommonFunction.h"

@interface TagBtn ()

@property (nonatomic, strong) UIImageView *delImage;
@property (nonatomic, strong) UIImageView *addImage;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@end

@implementation TagBtn

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setTitleColor:RGBCOLORVALUE(0x4a4a4a) forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14 ];
        
        UIImageView *delImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TAG_Mger_Delt"]];
        self.delImage = delImage;
        delImage.hidden = YES;
        [self addSubview:delImage];
        [delImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.with.offset(3 );
            make.right.with.offset(-3 );
            make.width.height.mas_equalTo(13 );
        }];
        
        UIImageView *addImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TAG_Mger_Add"]];
        self.addImage = addImage;
        addImage.hidden = YES;
        [self addSubview:addImage];
        [addImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.with.offset(3 );
            make.right.with.offset(-3 );
            make.width.height.mas_equalTo(13 );
        }];
        [self addLongPress:self];
        @weakify(self);
        [RACObserve(self, model.title) subscribeNext:^(id x) {
            @strongify(self);
            [self setTitle:self.model.title forState:UIControlStateNormal];
        }];
        [RACObserve(self, model.isAlreadyTag) subscribeNext:^(id x) {
            @strongify(self);
            if(self.model.isAlreadyTag) {
                self.backgroundColor = RGBCOLORVALUE(0xf3f4f6);
                [self createBordersWithColor:[UIColor clearColor] withCornerRadius:4  andWidth:0];
                self.addImage.hidden = YES;
                if(self.model.isEdit && !self.model.isFix) {
                    self.delImage.hidden = NO;
                    [self commintAnimation:NO];
                } else {
                    self.delImage.hidden = YES;
                    [self commintAnimation:YES];
                }
            } else {
                self.backgroundColor = [UIColor whiteColor];
                [self createBordersWithColor:RGBA(190, 190, 190, 1) withCornerRadius:4  andWidth:1];
                self.addImage.hidden = NO;
                self.delImage.hidden = YES;
                [self commintAnimation:YES];
            }
        }];
        [RACObserve(self, model.isEdit) subscribeNext:^(id x) {
            @strongify(self);
            if(self.model.isEdit) {
                self.longPress.minimumPressDuration = 0.3;
            } else {
                self.longPress.minimumPressDuration = 1.0;
            }
            if(self.model.isAlreadyTag) {
                self.backgroundColor = RGBCOLORVALUE(0xf3f4f6);
                [self createBordersWithColor:[UIColor clearColor] withCornerRadius:4  andWidth:0];
                self.addImage.hidden = YES;
                if(self.model.isEdit && !self.model.isFix) {
                    self.delImage.hidden = NO;
                    [self commintAnimation:NO];
                } else {
                    self.delImage.hidden = YES;
                    [self commintAnimation:YES];
                }
            }
        }];
        [RACObserve(self, model.isFix) subscribeNext:^(id x) {
            @strongify(self);
            if(self.model.isCurrentPage) {
                [self setTitleColor:RGBCOLORVALUE(0x3dcc79) forState:UIControlStateNormal];
            } else {
                if(self.model.isFix) {
                    [self setTitleColor:RGBCOLORVALUE(0x969696) forState:UIControlStateNormal];
                } else {
                    [self setTitleColor:RGBCOLORVALUE(0x4a4a4a) forState:UIControlStateNormal];
                }
            }
            
        }];
        [RACObserve(self, model.isCurrentPage) subscribeNext:^(id x) {
            @strongify(self);
            if(self.model.isCurrentPage) {
                [self setTitleColor:RGBCOLORVALUE(0x3dcc79) forState:UIControlStateNormal];
            } else {
                if(self.model.isFix) {
                    [self setTitleColor:RGBCOLORVALUE(0x969696) forState:UIControlStateNormal];
                } else {
                    [self setTitleColor:RGBCOLORVALUE(0x4a4a4a) forState:UIControlStateNormal];
                }
            }
            
        }];
        
    }
    return self;
}

- (void)commintAnimation:(BOOL)hidden{
    if (hidden) {
        [self removeAnimation];
    }else{
        [self startShakeAnimation];
    }
}

- (void)removeAnimation{
    [self.layer removeAllAnimations];
}

- (void)startShakeAnimation{
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    shakeAnimation.values = @[@(-0.02),@0.02,@(-0.02)];
    
    CGFloat timeArc = (arc4random() % 9 + 1 ) * 0.01;
    shakeAnimation.timeOffset = [self.layer convertTime:CACurrentMediaTime()+timeArc
                                                toLayer:nil];
    
    shakeAnimation.duration = 0.4f;
    shakeAnimation.fillMode = kCAFillModeForwards;
    shakeAnimation.repeatCount = HUGE_VAL;
    shakeAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:shakeAnimation forKey:@"shake"];
}


//添加长按手势
-(void)addLongPress:(UIButton *)btn{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPressGestures:)];
    self.longPress = longPress;
    longPress.numberOfTouchesRequired = 1;
    longPress.allowableMovement = 100.0f;
    longPress.minimumPressDuration = 1.0;
    [btn addGestureRecognizer:longPress];
}

- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)paramSender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(handleLongPressGestures:)]) {
        [self.delegate handleLongPressGestures:paramSender];
    }
}




@end
