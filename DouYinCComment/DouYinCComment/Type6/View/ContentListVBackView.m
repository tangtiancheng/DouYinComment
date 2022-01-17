//
//  ContentListVBackView.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/12/22.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "ContentListVBackView.h"
#import "TCViewPager.h"
#import "UIScrollView+Interaction.h"
#import "ListViewController.h"
#import "TTCCom.h"
#import "Masonry.h"
#import "ReactiveObjC.h"
#import "UIView+EasyFrame.h"
#import "UIView+CommonFunction.h"
//showListV HideListV的时间
#define ShowAndHideListVDuration (0.3)

@interface ContentListVBackView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *iPhoneXBottommaskView;
@property (nonatomic, strong) UIView *backMainColorView;
@property (nonatomic, strong) UIView *backAlphaColorView;

@property (nonatomic, assign) BOOL isShow;


@property (nonatomic, strong) UIPanGestureRecognizer *panContentListVBackGestureRecognizer;
//向上或向下拖拽最后时刻的位移
@property (nonatomic, assign) CGFloat lastContentListVBackDrapDistance;
////当前正在拖拽的是否是能交互的scrollView
@property (nonatomic, assign) BOOL isPanContentListVBackDragScrollV;

@property (nonatomic, weak) UIScrollView *currentSubScrolleView;
@property(nonatomic,assign)BOOL nextReturn;//这个用于记录是否是手动改变contentOffset的conteentOffSet,是的话就不用做监听处理

@property (nonatomic, strong) TCViewPager *viewPager;

@property(nonatomic,strong)NSMutableArray *interactionScrollVArray;     //自己和interactionScrollVArray上的首饰

@property (nonatomic, strong) ListViewController *currentPlayListViewController;
@property (nonatomic, strong) ListViewController *currentPlayLyricViewController;
@property (nonatomic, strong) ListViewController *currentPlayCommentViewController;

@end

@implementation ContentListVBackView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.pageIndex = 0;
        self.isShow = NO;
    }
    return self;
}

- (void)createBaseView {
    @weakify(self);

    self.backMainColorView = [[UIView alloc] init];
    [self addSubview:self.backMainColorView];
    self.backMainColorView.backgroundColor = RGBA(90, 90, 90, 1);
    [self.backMainColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.with.offset(0);
    }];
    self.backAlphaColorView = [[UIView alloc] init];
    [self addSubview:self.backAlphaColorView];
    self.backAlphaColorView.backgroundColor = RGBA(0, 0, 0, 0.6);
    [self.backAlphaColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.with.offset(0);
    }];
    
    
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    lineView.backgroundColor = RGBA(255, 255, 255, 0.5);
    [lineView createBordersWithColor:[UIColor clearColor] withCornerRadius:2 * 1 andWidth:0];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(11 * 1);;
        make.centerX.with.offset(0);
        make.height.mas_equalTo(4 * 1);
        make.width.mas_equalTo(46 * 1);
    }];
    self.isPanContentListVBackDragScrollV = NO;
    [self viewPager];
    [self iPhoneXBottommaskView];
    
    UIView *toptapV = [[UIView alloc] init];
    toptapV.backgroundColor = [UIColor clearColor];
    [self addSubview:toptapV];
    [toptapV whenTapped:^{
        @strongify(self);
        [self showListV:YES];
    }];
    [toptapV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.with.offset(0);
        make.bottom.equalTo(self.viewPager.mas_top);
    }];
    
    self.backgroundColor = [UIColor blueColor];
    self.panContentListVBackGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panContentListVBack:)];
    [self addGestureRecognizer:self.panContentListVBackGestureRecognizer];
    self.panContentListVBackGestureRecognizer.delegate = self;
    [RACObserve(self, frame) subscribeNext:^(id x) {
        @strongify(self);
        [self viewChangeByListVTop];
    }];
    
    [self.delegate topYChange:self.top dropEnd:YES animationDuration:0];

}

- (void)viewChangeByListVTop {
    self.iPhoneXBottommaskView.top = SCREEN_HEIGHT  - ((self.top - self.topHeaderVHeight)/(self.height - self.topListVTopHeight) * self.iPhoneXBotttomSafeHeihgt);
}

#pragma mark - Action
- (void)showListV:(BOOL)animation {
    self.isShow = YES;
    if(self.top == self.topHeaderVHeight) {
        return;
    }
    CGFloat time = (self.top - self.topHeaderVHeight) / (self.height - self.topListVTopHeight) * ShowAndHideListVDuration;
    if(animation) {
        
        [UIView animateWithDuration:time animations:^{
            self.top = self.topHeaderVHeight;
        } completion:^(BOOL finished) {
            
        }];
        if(self.delegate && [self.delegate respondsToSelector:@selector(topYChange:dropEnd:animationDuration:)]) {
            [self.delegate topYChange:self.top dropEnd:YES animationDuration:time];
        }
    } else {
        self.top = self.topHeaderVHeight;
        if(self.delegate && [self.delegate respondsToSelector:@selector(topYChange:dropEnd:animationDuration:)]) {
            [self.delegate topYChange:self.top dropEnd:YES animationDuration:time];
        }
//        if([self.currentPlayListViewController isViewLoaded]) {
//            [self.currentPlayListViewController scrollToNowPlayingItem:NO];
//        }
       
    }
}

- (void)dismissListV {
    self.isShow = NO;
    if(self.top == (SCREEN_HEIGHT - self.topListVTopHeight)) {
        return;
    }
    CGFloat time = (SCREEN_HEIGHT - self.top - self.topListVTopHeight) / (self.height - self.topListVTopHeight) * ShowAndHideListVDuration;
    [UIView animateWithDuration:time animations:^{
        self.top = SCREEN_HEIGHT - self.topListVTopHeight;
    } completion:^(BOOL finished) {
    }];
    if(self.delegate && [self.delegate respondsToSelector:@selector(topYChange:dropEnd:animationDuration:)]) {
        [self.delegate topYChange:self.top dropEnd:YES animationDuration:time];
    }
}

#pragma mark - GestureRecognizerAction
//拖拽listV手势
- (void)panContentListVBack:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 获取手指的偏移量
    CGPoint transP = [panGestureRecognizer translationInView:self];
    
    if(self.isPanContentListVBackDragScrollV) {
        //如果当前拖拽的是tableView
        if(transP.y > 0 && self.top < (SCREEN_HEIGHT - self.topListVTopHeight) && self.currentSubScrolleView.contentOffset.y<=0) {
            //向下拖
            self.top =  (self.top + transP.y) < (SCREEN_HEIGHT - self.topListVTopHeight) ? (self.top + transP.y) : (SCREEN_HEIGHT - self.topListVTopHeight) ;
        } else if(transP.y < 0 && self.top > self.topHeaderVHeight) {
            //向上拖
            self.top = (self.top + transP.y) > self.topHeaderVHeight ? (self.top + transP.y) : self.topHeaderVHeight;
        }
        
    } else {
        if(transP.y > 0 && self.top < (SCREEN_HEIGHT - self.topListVTopHeight)) {
            //向下拖
            self.top = (self.top + transP.y) < (SCREEN_HEIGHT - self.topListVTopHeight) ? (self.top + transP.y) : (SCREEN_HEIGHT - self.topListVTopHeight) ;
        } else if(transP.y < 0 && self.top > self.topHeaderVHeight) {
            //向上拖
            self.top = (self.top + transP.y) > self.topHeaderVHeight ? (self.top + transP.y) : self.topHeaderVHeight;
            
        }
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(topYChange:dropEnd:animationDuration:)]) {
        [self.delegate topYChange:self.top dropEnd:NO animationDuration:0];
    }
    
    [panGestureRecognizer setTranslation:CGPointZero inView:self];
    if(panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
//        NSLog(@"transP : %@",NSStringFromCGPoint(transP));
        if(self.lastContentListVBackDrapDistance > 10) {
            if(self.isPanContentListVBackDragScrollV && self.currentSubScrolleView.contentOffset.y <= 0) {
                //如果是类似轻扫的那种
                [self dismissListV];
            } else if(!self.isPanContentListVBackDragScrollV){
                //如果是类似轻扫的那种
                [self dismissListV];
            }
            
        } else if(self.lastContentListVBackDrapDistance < -10) {
            //如果是类似轻扫的那种
            [self showListV:YES];
        } else {
            //如果是普通拖拽
            if(self.top >= (self.topHeaderVHeight + self.height/2)   ) {
                [self dismissListV];
            } else {
                [self showListV:YES];
            }
        }
        self.isPanContentListVBackDragScrollV = NO;
    }
    self.lastContentListVBackDrapDistance = transP.y;
}

#pragma mark - ScrollVieeScroll

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]){
        [self headViewNoSuckTopTypeObserveValueForKeyPath:keyPath ofObject:object change:change context:context];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
//subScrollView
- (void)headViewNoSuckTopTypeObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if(self.isPanContentListVBackDragScrollV) {
        if (_nextReturn) {
            _nextReturn = false;
            return;
        }
        CGFloat new = [change[@"new"] CGPointValue].y;
        CGFloat old = [change[@"old"] CGPointValue].y;

        if (new == old) {return;}
        CGFloat dh = new - old;
        if (dh < 0) {
            //向下
            if(((UIScrollView *)object).contentOffset.y < 0){
                _nextReturn = true;
                ((UIScrollView *)object).contentOffset = CGPointMake(0, 0);
            }
        }else{
            //向上
    //        if (self.mainTabelView.contentOffset.y < _stayHeight) {
            if (self.top > self.topHeaderVHeight) {
                _nextReturn = true;
                ((UIScrollView *)object).contentOffset = CGPointMake(0, old);
            }else{
            }
        }
    }
}



#pragma mark - UIGestureRecognizerDelegate
//1
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(gestureRecognizer == self.panContentListVBackGestureRecognizer) {
        return [self panContentListVBackGestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
    }
    return YES;
}


- (BOOL)panContentListVBackGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    self.isPanContentListVBackDragScrollV = NO;
    self.currentSubScrolleView = nil;
    UIView *touchView = touch.view;

        while (touchView != nil) {
            if([touchView isKindOfClass:[UIScrollView class]] && touchView != self) {
                BOOL canContain = NO;

                    if([touchView isKindOfClass:[UIScrollView class]] && ((UIScrollView *)touchView).ringcanInteraction == YES) {
                        canContain = YES;

                    }

                if(canContain) {
                    self.isPanContentListVBackDragScrollV = YES;
                    self.currentSubScrolleView = (UIScrollView *)touchView;
                    if(![self.interactionScrollVArray containsObject:self.currentSubScrolleView]) {
                        [self.interactionScrollVArray addObject:self.currentSubScrolleView];
                        [self.currentSubScrolleView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
                    }
                    break;
                }
            }
            if(touchView == self.viewPager) {
                break;
            }
            touchView = [touchView nextResponder];
        }
//    }
    
    return YES;
}


//2.
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if(gestureRecognizer == self.panContentListVBackGestureRecognizer) {
        return [self panContentListVBackGestureRecognizerShouldBegin:gestureRecognizer];
    }
    return YES;
}

- (BOOL)panContentListVBackGestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

//3. 是否与其他手势共存，一般使用默认值(默认返回NO：不与任何手势共存)
- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if(gestureRecognizer == self.panContentListVBackGestureRecognizer) {
        return [self panContentListVBackGestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    return NO;
}

- (BOOL)panContentListVBackGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    UIView *otherGestureRecognizerView = otherGestureRecognizer.view;
    if( [otherGestureRecognizerView isKindOfClass:[UIScrollView class]] && otherGestureRecognizerView != self && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        if([self.interactionScrollVArray containsObject:(UIScrollView *)otherGestureRecognizerView]) {
            return YES;
        } else {
            return NO;
        }

    }
    return NO;
}

#pragma mark - LazyLoad

- (TCViewPager *)viewPager {
    if(!_viewPager) {
        CGFloat fontSize = 16 ;
        CGFloat leftAndRightSpace = 14.0 ;
        CGFloat titlePageSpace = 0;
        CGFloat titleW = (SCREEN_WIDTH - 2 * leftAndRightSpace)/3;
        NSMutableArray *arry_seg_title = [NSMutableArray arrayWithArray:@[@"播放列表",@"歌词",[NSString stringWithFormat:@"评论"]]];
        ListViewController *currentPlayListViewController = [[ListViewController alloc] init];
        currentPlayListViewController.type = 1;
        self.currentPlayListViewController = currentPlayListViewController;
        [self.viewController addChildViewController:currentPlayListViewController];
       
        ListViewController* currentPlayLyricViewController = [[ListViewController alloc] init];
        currentPlayLyricViewController.type = 2;
        self.currentPlayLyricViewController = currentPlayLyricViewController;
        [self.viewController addChildViewController:currentPlayLyricViewController];

        
        ListViewController* currentPlayCommentViewController = [[ListViewController alloc] init];
        currentPlayCommentViewController.type = 3;
        self.currentPlayCommentViewController = currentPlayCommentViewController;
        [self.viewController addChildViewController:currentPlayCommentViewController];


        TCPageParam *pageParam = [[TCPageParam alloc] init];
        pageParam.animateScroll = NO;
        pageParam.titleArray = arry_seg_title;
        pageParam.titleArrayLength = @[@(titleW),@(titleW),@(titleW)];
        pageParam.leftAndRightSpace = leftAndRightSpace;
        pageParam.titlePageSpace = titlePageSpace;
        pageParam.selectedLabelBigScale = 1.0;
        pageParam.pageHeaderHeight = self.pageVHeaderH;
        pageParam.labelFont = [UIFont systemFontOfSize:fontSize];
        pageParam.tabTitleColor = [UIColor whiteColor];
        pageParam.tabSelectedTitleColor = [UIColor whiteColor];
        pageParam.showSelectedBottomLine = YES;
        pageParam.tabSelectedBottomLineColor = [UIColor whiteColor];
        pageParam.pageHeaderControlBottomLineColor = RGBA(255, 255, 255, 0.3);
        pageParam.pageHeaderControlBottomLineWidth = SCREEN_WIDTH - 2 * leftAndRightSpace;
        pageParam.pageHeaderControlBottomLineHeight = 0.5;
        pageParam.showBottomGradientLayer = NO;
        pageParam.selectIndex = self.pageIndex;
        pageParam.viewPagerBgColor = [UIColor clearColor];
        _viewPager = [[TCViewPager alloc] initWithFrame:CGRectZero views:@[self.currentPlayListViewController, self.currentPlayLyricViewController, self.currentPlayCommentViewController] param:pageParam];
        
        @weakify(self);
        [self addSubview:_viewPager];
        [_viewPager mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.with.offset(0);
            make.bottom.with.offset(0);
            make.top.with.offset(self.topListVTopHeight - self.pageVHeaderH - self.iPhoneXBotttomSafeHeihgt+3);
        }];
        [_viewPager didSelectedBlock:^(id viewPager, NSInteger currentIndex,NSInteger previousIndex, BOOL isClickBtn) {
            @strongify(self);
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self didSegmentControlSelectIndex:currentIndex previousIndex:previousIndex isClickBtn:isClickBtn];
//            });
        }];
    }
    return _viewPager;
}

-(void)didSegmentControlSelectIndex:(NSUInteger)currentIndex previousIndex:(NSUInteger)previousIndex isClickBtn:(BOOL)isClickBtn
{
    self.pageIndex = currentIndex;
    if(isClickBtn) {
        [self showListV:YES];
    }
}


- (NSMutableArray *)interactionScrollVArray {
    if(!_interactionScrollVArray) {
        _interactionScrollVArray = [NSMutableArray array];
    }
    return _interactionScrollVArray;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview == nil) {
        for (UIScrollView *sc in self.interactionScrollVArray) {
            [sc removeObserver:self forKeyPath:@"contentOffset"];
        }
    }
}

- (UIView *)iPhoneXBottommaskView {
    if(!_iPhoneXBottommaskView && kDevice_Is_iPhoneX) {
        _iPhoneXBottommaskView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - self.iPhoneXBotttomSafeHeihgt, SCREEN_WIDTH, self.iPhoneXBotttomSafeHeihgt)];
        [self.superview addSubview:_iPhoneXBottommaskView];
        _iPhoneXBottommaskView.backgroundColor = [UIColor blackColor];
    }
    return _iPhoneXBottommaskView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(10 * 1, 10 * 1)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
