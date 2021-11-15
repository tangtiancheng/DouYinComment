//
//  ZFSliderView.m
//  ZFPlayer
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFSliderView.h"
#import "UIView+CommonFunction.h"
#import "UIView+EasyFrame.h"
/** 滑块的大小 */
static const CGFloat kSliderBtnWH = 18.0;
/** 间距 */
static const CGFloat kProgressMargin = 2.0;
/** 进度的高度 */
static const CGFloat kProgressH = 1.0;
/** 拖动slider动画的时间*/
static const CGFloat kAnimate = 0.3;

@interface ZFSliderButton ()

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation ZFSliderButton



//- (instancetype)initWithFrame:(CGRect)frame {
//    if(self = [super initWithFrame:frame]) {
//        self.timeLabel = [[UILabel alloc] init];
//        [self addSubview:self.timeLabel];
//        self.timeLabel.textAlignment = NSTextAlignmentCenter;
//        self.timeLabel.textColor = [UIColor whiteColor];
//        self.timeLabel.font = [UIFont systemFontOfSize:10];
//        self.timeLabel.text = @"00:00/00:00";
//        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.bottom.with.offset(0);
//        }];
//    }
//    return self;
//}
//
- (void)setPlayTime:(NSString *)playTime {
    self.timeLabel.text = playTime;
}

@end

@interface ZFSliderView ()<UIGestureRecognizerDelegate>

/** 进度背景 */
@property (nonatomic, strong) UIImageView *bgProgressView;
/** 缓存进度 */
@property (nonatomic, strong) UIImageView *bufferProgressView;
/** 滑动进度 */
@property (nonatomic, strong) UIImageView *sliderProgressView;
/** 滑块 */
@property (nonatomic, strong) ZFSliderButton *sliderBtn;

//@property (nonatomic, strong) UIView *loadingBarView;

//@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation ZFSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.allowTapped = YES;
        self.animate = YES;
        [self addSubViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.allowTapped = YES;
    self.animate = YES;
    [self addSubViews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    
    min_x = 0;
    min_w = min_view_w;
    min_y = 0;
    min_h = self.sliderHeight;
    self.bgProgressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = 0;
    min_w = self.thumbSize.width;
    min_h = self.thumbSize.height;
    self.sliderBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.sliderBtn.left = (self.width - self.thumbSize.width)  * self.value;
    
    min_x = 0;
    min_y = 0;
    if (self.sliderBtn.hidden) {
        min_w = (self.width- self.thumbSize.width) * self.value;
    } else {
        min_w = self.sliderBtn.left;
    }
    min_h = self.sliderHeight;
    self.sliderProgressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = 0;
    min_w = self.bgProgressView.width * self.bufferValue;
    min_h = self.sliderHeight;
    self.bufferProgressView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    self.bgProgressView.centerY     = min_view_h * 0.5;
    self.bufferProgressView.centerY = min_view_h * 0.5;
    self.sliderProgressView.centerY = min_view_h * 0.5;
    self.sliderBtn.centerY          = min_view_h * 0.5;
}

/**
 添加子视图
 */
- (void)addSubViews {
    self.thumbSize = CGSizeMake(kSliderBtnWH, kSliderBtnWH);
    self.sliderHeight = kProgressH;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgProgressView];
    [self addSubview:self.bufferProgressView];
    [self addSubview:self.sliderProgressView];
    [self addSubview:self.sliderBtn];
    
//    [self.bgProgressView createBordersWithColor:[UIColor clearColor] withCornerRadius:1 andWidth:0];
//    self.bgProgressView.layer.masksToBounds = YES;
//    
//    [self.bufferProgressView createBordersWithColor:[UIColor clearColor] withCornerRadius:1 andWidth:0];
//    self.bufferProgressView.layer.masksToBounds = YES;
//    [self.sliderProgressView createBordersWithColor:[UIColor clearColor] withCornerRadius:1 andWidth:0];
//    self.sliderProgressView.layer.masksToBounds = YES;

//    [self addSubview:self.loadingBarView];
    
    // 添加点击手势
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:self.tapGesture];
    
    // 添加滑动手势
    UIPanGestureRecognizer *sliderGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderGesture:)];
//    sliderGesture.delegate = self;
    [self addGestureRecognizer:sliderGesture];
}

#pragma mark - Setter

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor {
    _maximumTrackTintColor = maximumTrackTintColor;
    self.bgProgressView.backgroundColor = maximumTrackTintColor;
}

- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor {
    _minimumTrackTintColor = minimumTrackTintColor;
    self.sliderProgressView.backgroundColor = minimumTrackTintColor;
}

- (void)setBufferTrackTintColor:(UIColor *)bufferTrackTintColor {
    _bufferTrackTintColor = bufferTrackTintColor;
    self.bufferProgressView.backgroundColor = bufferTrackTintColor;
}


- (void)setMaximumTrackImage:(UIImage *)maximumTrackImage {
    _maximumTrackImage = maximumTrackImage;
    self.bgProgressView.image = maximumTrackImage;
    self.maximumTrackTintColor = [UIColor clearColor];
}

- (void)setMinimumTrackImage:(UIImage *)minimumTrackImage {
    _minimumTrackImage = minimumTrackImage;
    self.sliderProgressView.image = minimumTrackImage;
    self.minimumTrackTintColor = [UIColor clearColor];
}


- (void)setThumbBackGroundColor:(UIColor *)color {
    [self.sliderBtn setBackgroundColor:color];
}

- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state {
//    [self.sliderBtn setImage:image forState:state];
}

- (void)setValue:(float)value {
    if (isnan(value)) return;
    value = MIN(1.0, value);
    _value = value;
    if (self.sliderBtn.hidden) {
        self.sliderProgressView.width = (self.width - self.thumbSize.width)  * value;
    } else {
        self.sliderBtn.left = (self.width - self.thumbSize.width)  * value;
        self.sliderProgressView.width = self.sliderBtn.left;
    }
    int n_current_time = self.totleTime * value;
    int n_duration = self.totleTime;
    [self.sliderBtn setPlayTime:[NSString stringWithFormat:@"%02d:%02d|%02d:%02d", n_current_time / 60, n_current_time % 60, n_duration / 60, n_duration % 60]];
}

- (void)setBufferValue:(float)bufferValue {
    if (isnan(bufferValue)) return;
    bufferValue = MIN(1.0, bufferValue);
    _bufferValue = bufferValue;
    self.bufferProgressView.width = self.bgProgressView.width * bufferValue;
}

- (void)setAllowTapped:(BOOL)allowTapped {
    _allowTapped = allowTapped;
    if (!allowTapped) {
        [self removeGestureRecognizer:self.tapGesture];
    }
}

- (void)setSliderHeight:(CGFloat)sliderHeight {
    if (isnan(sliderHeight)) return;
    _sliderHeight = sliderHeight;
    self.bgProgressView.height     = sliderHeight;
    self.sliderProgressView.height = sliderHeight;
    self.bufferProgressView.height = sliderHeight;
}

//- (void)setIsHideSliderBlock:(BOOL)isHideSliderBlock {
//    _isHideSliderBlock = isHideSliderBlock;
//    // 隐藏滑块，滑杆不可点击
//    if (isHideSliderBlock) {
//        self.sliderBtn.hidden = YES;
//        self.bufferProgressView.left = 0;
//        self.bgProgressView.left     = 0;
//        self.sliderProgressView.left = 0;
//        self.allowTapped = NO;
//    }
//}

#pragma mark - UIGestureRecognizerDelegate
////1
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    NSLog(@"myVIew2shouldReceiveTouch");
//    return YES;
//}
//
////2.
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    NSLog(@"myVIew2gestureRecognizerShouldBegin");
//    return YES;
//}
//
////3. 是否与其他手势共存，一般使用默认值(默认返回NO：不与任何手势共存)
//- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if(otherGestureRecognizer == GetAppDelegate().globalNaviatrionController.interactivePopGestureRecognizer) {
//        otherGestureRecognizer.enabled = NO;
//        otherGestureRecognizer.enabled = YES;
//        return YES;
//    }
//    UIGestureRecognizer *g = GetAppDelegate().globalNaviatrionController.interactivePopGestureRecognizer;
////    NSLog(@"myVIew2shouldRecognizeSimultaneouslyWithGestureRecognizer");
////    if(gestureRecognizer == self.pan && [otherGestureRecognizer isKindOfClass:[UIGestureRecognizer class]]) {
////        return YES;
////    }
//    return NO;
//}

#pragma mark - User Action

- (void)sliderGesture:(UIGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            [self sliderBtnTouchBegin:self.sliderBtn];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            [self sliderBtnDragMoving:self.sliderBtn point:[gesture locationInView:self.bgProgressView] gestureRecognizer:gesture];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            [self sliderBtnTouchEnded:self.sliderBtn];
        }
            break;
        default:
            break;
    }
}

- (void)sliderBtnTouchBegin:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(sliderTouchBegan:)]) {
        [self.delegate sliderTouchBegan:self.value];
    }

}

- (void)sliderBtnTouchEnded:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(sliderTouchEnded:)]) {
        [self.delegate sliderTouchEnded:self.value];
    }

}

- (void)sliderBtnDragMoving:(UIButton *)btn point:(CGPoint)touchPoint gestureRecognizer:(UIPanGestureRecognizer *)pan{
    
    CGPoint transP = [pan translationInView:self];
    CGFloat left = btn.left + transP.x;
    if(left <=0) {
        left = 0;
    } else if(left >= (self.width- self.thumbSize.width)) {
        left = self.width- self.thumbSize.width;
    }
    btn.left = left;
    
    // 获取进度值 由于btn是从 0-(self.width - btn.width)
    CGFloat value = left  / (self.width- self.thumbSize.width);
    // value的值需在0-1之间
    value = value >= 1.0 ? 1.0 : value <= 0.0 ? 0.0 : value;
    if (self.value == value) return;
    self.isForward = self.value < value;
    self.value = value;
    if ([self.delegate respondsToSelector:@selector(sliderValueChanged:)]) {
        [self.delegate sliderValueChanged:value];
    }
    [pan setTranslation:CGPointZero inView:self];
}

- (void)tapped:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self.bgProgressView];
    CGFloat value = 0.0;
    value = (point.x) * 1.0 / self.bgProgressView.width;
    // 获取进度
    value = value >= 1.0 ? 1.0 : value <= 0 ? 0 : value;
    self.value = value;
    if ([self.delegate respondsToSelector:@selector(sliderTapped:)]) {
        [self.delegate sliderTapped:value];
    }
}

#pragma mark - getter

- (UIView *)bgProgressView {
    if (!_bgProgressView) {
        _bgProgressView = [UIImageView new];
        _bgProgressView.backgroundColor = [UIColor grayColor];
        _bgProgressView.contentMode = UIViewContentModeScaleAspectFill;
        _bgProgressView.clipsToBounds = YES;
    }
    return _bgProgressView;
}

- (UIView *)bufferProgressView {
    if (!_bufferProgressView) {
        _bufferProgressView = [UIImageView new];
        _bufferProgressView.backgroundColor = [UIColor whiteColor];
        _bufferProgressView.contentMode = UIViewContentModeScaleAspectFill;
        _bufferProgressView.clipsToBounds = YES;
    }
    return _bufferProgressView;
}

- (UIView *)sliderProgressView {
    if (!_sliderProgressView) {
        _sliderProgressView = [UIImageView new];
        _sliderProgressView.backgroundColor = [UIColor redColor];
        _sliderProgressView.contentMode = UIViewContentModeScaleAspectFill;
        _sliderProgressView.clipsToBounds = YES;
    }
    return _sliderProgressView;
}

- (ZFSliderButton *)sliderBtn {
    if (!_sliderBtn) {
        _sliderBtn = [[ZFSliderButton alloc] init];
    }
    return _sliderBtn;
}

@end
