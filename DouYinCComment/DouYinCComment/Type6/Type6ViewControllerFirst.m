//
//  Type6ViewControllerFirst.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/12/22.
//  Copyright © 2020 唐天成. All rights reserved.
// 支持侧拉返回,下来返回

#import "Type6ViewControllerFirst.h"
#import "TopBackContentView.h"
#import "PlayToolBackView.h"
#import "ContentListVBackView.h"

#import "UIView+EasyFrame.h"

//是否是iPhoneX
#define kDevice_Is_iPhoneX (@available(iOS 11.0, *) ? ([UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom ? YES : NO) : NO)

//showVC popVC的时间
#define ShowAndPopVCDuration   (0.3)

@interface Type6ViewControllerFirst ()<UIGestureRecognizerDelegate, TopBackContentViewDelegate, ContentListVBackViewDelegate>

//拖拽contentBottomBackView退出播放界面
@property (nonatomic, strong) UIPanGestureRecognizer *panPopVCGestureRecognizer;
//向下拖拽最后时刻的位移
@property (nonatomic, assign) CGFloat lastPopVCDrapDistance;

//最下层的View(添加拖拽手势下拉pop)
@property (nonatomic, strong) UIView *contentBottomBackView;

//顶部包含放大放小背景图,铃声名称,播放按钮等的contentView
@property (nonatomic, strong) TopBackContentView *topBackContentView;
//控制器工具View
@property (nonatomic, strong) PlayToolBackView *playToolBackView;
//拖拽 播放列表,歌词,评论的contentView(添加拖拽手势)
@property (nonatomic, strong) ContentListVBackView *contentListVBackView;


//顶部的高度
@property (nonatomic, assign) CGFloat topHeaderVHeight;
//ListView顶部的预留高度
@property (nonatomic, assign) CGFloat topListVTopHeight;
//IPhoneXBotttomSafeHeihgt
@property (nonatomic, assign) CGFloat iPhoneXBotttomSafeHeihgt;
//控制器全部工具View的高度
@property (nonatomic, assign) CGFloat playerToolViewHeight;

@end

@implementation Type6ViewControllerFirst

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if(self.navigationController.viewControllers.lastObject == self && self.navigationController.viewControllers.count>=2) {
        UIView *fromView = self.navigationController.viewControllers.lastObject.view;
        UIView *toView = ((UIViewController *)self.navigationController.viewControllers[self.navigationController.viewControllers.count-2]).view;
        UIView *superView = fromView.superview;
        [superView insertSubview:toView belowSubview:fromView];
    }
    [self showVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBaseView];
}

- (void)createBaseView {
    self.view.backgroundColor = [UIColor clearColor];
    self.lastPopVCDrapDistance = 0.0;
//    self.spaceUnit = (SCREEN_WIDTH - 23 * KWIDTH_IPAD_SCALE * 4 - 63 * KWIDTH_IPAD_SCALE) / ( 27 * 2 + 61 * 2 + 47 * 2);
    self.topHeaderVHeight = (70.0 + (kDevice_Is_iPhoneX ? 44 : 20));
    self.iPhoneXBotttomSafeHeihgt = (kDevice_Is_iPhoneX ? 34.0 : 0);
    self.topListVTopHeight = (74.0  + (kDevice_Is_iPhoneX ? self.iPhoneXBotttomSafeHeihgt : 0));
    self.playerToolViewHeight = 31  + 63  + 35  + 16  + 36  + 25  + 20 ;

    [self contentBottomBackView];
    [self topBackContentView];
    [self playToolBackView];
    [self contentListVBackView];
}

#pragma mark - Action


- (void)showVC {
    if(self.contentBottomBackView.top == 0) {
        return;
    }
    CGFloat time = self.contentBottomBackView.top / SCREEN_HEIGHT * ShowAndPopVCDuration;
    [UIView animateWithDuration:time animations:^{
        self.contentBottomBackView.top = 0;
    } completion:^(BOOL finished) {
    }];
}

- (void)popVC {
    if(self.contentBottomBackView.top == SCREEN_HEIGHT) {
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    CGFloat time = (SCREEN_HEIGHT - self.contentBottomBackView.top) / SCREEN_HEIGHT * ShowAndPopVCDuration;
    
    [UIView animateWithDuration:time animations:^{
        self.contentBottomBackView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
}


#pragma mark - RACObserve
- (void)viewChangeByListVTopWithAnimationDuration:(CGFloat)duraion {

    if(duraion>0) {
        [self.topBackContentView layoutIfNeeded];
        [UIView animateWithDuration:duraion animations:^{
            [self.playToolBackView exchangeByListVDrapLength:SCREEN_HEIGHT - self.topListVTopHeight - self.contentListVBackView.top];
            [self.topBackContentView exchangeByListVDrapLength:SCREEN_HEIGHT - self.topListVTopHeight - self.contentListVBackView.top];
        }];
        [UIView animateWithDuration:duraion animations:^{
            [self.topBackContentView layoutIfNeeded];
        }];
    } else {
        [self.playToolBackView exchangeByListVDrapLength:SCREEN_HEIGHT - self.topListVTopHeight - self.contentListVBackView.top];
        [self.topBackContentView exchangeByListVDrapLength:SCREEN_HEIGHT - self.topListVTopHeight - self.contentListVBackView.top];
    }
    
}




#pragma mark - TopBackContentViewDelegate | PlayToolBackViewDelegate | ContentListVBackViewDelegate
- (void)popBtnClick {
    [self popVC];
}

- (void)dismissListVCBtnCLick {
    [self.contentListVBackView dismissListV];
}

- (void)topYChange:(CGFloat)topY dropEnd:(BOOL)drop animationDuration:(CGFloat)duration{
    [self viewChangeByListVTopWithAnimationDuration:duration];
}


#pragma mark - GestureRecognizerAction
//拖拽Pop手势
- (void)panPopVC:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 获取手指的偏移量
    CGPoint transP = [panGestureRecognizer translationInView:self.contentBottomBackView];
    if(transP.y > 0) {
        //向下拖
        self.contentBottomBackView.frame = CGRectMake(self.contentBottomBackView.left, self.contentBottomBackView.top + transP.y, self.contentBottomBackView.width, self.contentBottomBackView.height);
    } else if(transP.y < 0 && self.contentBottomBackView.top > 0){
        //向上拖
        self.contentBottomBackView.frame = CGRectMake(self.contentBottomBackView.left, (self.contentBottomBackView.top + transP.y) > 0 ? (self.contentBottomBackView.top + transP.y) : 0, self.contentBottomBackView.width, self.contentBottomBackView.height);
    }
    [panGestureRecognizer setTranslation:CGPointZero inView:self.contentBottomBackView];
    if(panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if(self.lastPopVCDrapDistance > 10) {
            //如果是类似轻扫的那种
            [self popVC];
        } else {
            //如果是普通拖拽
            if(self.contentBottomBackView.top >= SCREEN_HEIGHT/2) {
                [self popVC];
            } else {
                [self showVC];
            }
        }
    }
    self.lastPopVCDrapDistance = transP.y;
}

#pragma mark - UIGestureRecognizerDelegate
//1
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(gestureRecognizer == self.panPopVCGestureRecognizer) {
        return [self panPopVCGestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
    }
    return YES;
}
- (BOOL)panPopVCGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}
//2.
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if(gestureRecognizer == self.panPopVCGestureRecognizer){
        //如果是自己加的拖拽手势
        return [self panPopVCGestureRecognizerShouldBegin:gestureRecognizer];
    }
    return YES;
}
- (BOOL)panPopVCGestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if(self.contentListVBackView.isShow) {
        return NO;
    }
    return YES;
}
//3. 是否与其他手势共存，一般使用默认值(默认返回NO：不与任何手势共存)
- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if(gestureRecognizer == self.panPopVCGestureRecognizer) {
        return [self panPopVCGestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    return NO;
}
- (BOOL)panPopVCGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

#pragma mark - LazyLoad

- (ContentListVBackView *)contentListVBackView {
    if(!_contentListVBackView) {
        _contentListVBackView = [[ContentListVBackView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - self.topListVTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - self.topHeaderVHeight)];
        _contentListVBackView.delegate = self;
        [self.contentBottomBackView addSubview:_contentListVBackView];
        _contentListVBackView.iPhoneXBotttomSafeHeihgt = self.iPhoneXBotttomSafeHeihgt;
        _contentListVBackView.topListVTopHeight = self.topListVTopHeight;
        _contentListVBackView.topHeaderVHeight = self.topHeaderVHeight;
        _contentListVBackView.pageVHeaderH = (60.0 );
        [_contentListVBackView createBaseView];
       
    }
    return _contentListVBackView;
}
- (TopBackContentView *)topBackContentView {
    if(!_topBackContentView) {
        _topBackContentView = [[TopBackContentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _topBackContentView.delegate = self;
        _topBackContentView.heightTopUntilRingName = SCREEN_HEIGHT - self.topListVTopHeight - self.playerToolViewHeight;
        _topBackContentView.topHeaderVHeight = self.topHeaderVHeight;
        _topBackContentView.maxXHeight = SCREEN_HEIGHT - self.topHeaderVHeight - self.topListVTopHeight;
        [_topBackContentView createBaseView];
        [self.contentBottomBackView addSubview:_topBackContentView];
        
        
        
    }
    return _topBackContentView;
}
- (PlayToolBackView *)playToolBackView {
    if(!_playToolBackView) {
        _playToolBackView = [[PlayToolBackView alloc] initWithFrame:CGRectMake(0, self.topHeaderVHeight, SCREEN_WIDTH, SCREEN_HEIGHT - self.topHeaderVHeight - self.topListVTopHeight)];
        [self.contentBottomBackView addSubview:_playToolBackView];
        [_playToolBackView createBaseView];
    }
    return _playToolBackView;
}

- (UIView *)contentBottomBackView {
    if(!_contentBottomBackView) {
        _contentBottomBackView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:_contentBottomBackView];
        _contentBottomBackView.backgroundColor = [UIColor blackColor];//[UIColor clearColor];
        self.panPopVCGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPopVC:)];
        [_contentBottomBackView addGestureRecognizer:self.panPopVCGestureRecognizer];
        self.panPopVCGestureRecognizer.delegate = self;

        UIView *backAlphaColorView = [[UIView alloc] initWithFrame:_contentBottomBackView.bounds];
        [_contentBottomBackView addSubview:backAlphaColorView];
        backAlphaColorView.backgroundColor = RGBA(0, 0, 0, 0.75);
    }
    return _contentBottomBackView;
}

@end
