//
//  ENestScrollPageView.m
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2020/6/9.
//  Copyright © 2020 duoduo. All rights reserved.
//

#import "TCNestScrollPageView.h"



#pragma mark - TCNestScrollParam
@implementation TCNestScrollParam

- (instancetype)init {
    if(self = [super init]) {
        self.pageType = NestScrollPageViewHeadViewChageType;
        self.yOffset = 0;
        self.bounces = YES;
    }
    return self;
}

@end




#pragma mark - TCMainScrollView

@interface TCMainScrollView ()

@property (nonatomic, strong) UIView *viewPager;

//这个是header滚动延续的时候才会用到
//scrolContinuePanGestureRecognizer表示当前取到的最新的滚动延续的PanGestureRecognizer拖拽手势
@property (nonatomic, weak) UIPanGestureRecognizer *scrolContinuePanGestureRecognizer;

@end

@implementation TCMainScrollView
/********************** 多手势同时识别 ***************************/
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    UIView *otherGestureRecognizerView = otherGestureRecognizer.view;
    //header滚动延续的情况下
    if(otherGestureRecognizerView == self && gestureRecognizer == self.panGestureRecognizer && otherGestureRecognizer == self.scrolContinuePanGestureRecognizer && ((TCNestScrollPageView *)self.superview).param.scrolContinue) {
            return YES;
    }
    //header滚动不延续的情况下
    if( [otherGestureRecognizerView isKindOfClass:[UIScrollView class]] && otherGestureRecognizerView != self && gestureRecognizer == self.panGestureRecognizer && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {

        if([self.viewArray containsObject:(UIScrollView *)otherGestureRecognizerView]) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

//1
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(((TCNestScrollPageView *)self.superview).param.scrolContinue && self.scrolContinuePanGestureRecognizer) {
        //如果是header滚动延续的话就不需要后面那么多代码了
        return YES;
    }
    if(gestureRecognizer == self.panGestureRecognizer) {
        self.isScrolBySelf = YES;
        self.currentSubScrolleView = nil;
        UIView *touchView = touch.view;
        BOOL isContain = NO;
        while (touchView != nil) {
            if(touchView == self.viewPager) {
                isContain = YES;
                break;
            }
            touchView = [touchView nextResponder];
        }
        if(isContain) {
            touchView = touch.view;
            while (touchView != nil) {
                
                if([touchView isKindOfClass:[UIScrollView class]] && touchView != self) {
                    BOOL canContain = NO;
                    NSInteger scrollCount = 0;
                    UIView *tempView = touchView;
                    while (tempView != self.viewPager) {
                        if([tempView isKindOfClass:[UIScrollView class]]) {
                            scrollCount++;
                        }
                        tempView = [tempView nextResponder];
                    }
                    if(scrollCount == 2 && ((UIScrollView *)touchView).contentSize.width <= touchView.frame.size.width) {
                        canContain = YES;
                    }
                    if(canContain) {
                        self.isScrolBySelf = NO;
                        self.currentSubScrolleView = (UIScrollView *)touchView;
                        if(![self.viewArray containsObject:self.currentSubScrolleView]) {
                            [self.viewArray addObject:self.currentSubScrolleView];
                            [self.currentSubScrolleView addObserver:self.superview forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
                        }
                        [self addObserveScrollView:self.currentSubScrolleView];
                        break;
                    }
                }
                if(touchView == self.viewPager) {
                    break;
                }
                touchView = [touchView nextResponder];
            }
        }
        
    }
    return YES;
}


//这个方法给header滚动延续用的
- (void)addObserveScrollView:(UIScrollView *)scrollView {
    if(!((TCNestScrollPageView *)self.superview).param.scrolContinue) {
        return;
    }
    self.isScrolBySelf = NO;
    if(![self.viewArray containsObject:scrollView] && scrollView) {
        [self.viewArray addObject:scrollView];
        [scrollView addObserver:self.superview forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    if(self.currentSubScrolleView != scrollView) {
        if(self.scrolContinuePanGestureRecognizer && self.scrolContinuePanGestureRecognizer.view != self.currentSubScrolleView) {
            [self.currentSubScrolleView addGestureRecognizer:self.scrolContinuePanGestureRecognizer];
        }
        self.currentSubScrolleView = scrollView;
        self.scrolContinuePanGestureRecognizer = scrollView.panGestureRecognizer;
        if(self.scrolContinuePanGestureRecognizer) {
            [self addGestureRecognizer:self.scrolContinuePanGestureRecognizer];
        }
    }
}

- (NSMutableArray *)viewArray {
    if(!_viewArray) {
        _viewArray = [NSMutableArray array];
    }
    return _viewArray;
}

- (void)dealloc {
}

@end





#pragma mark - TCNestScrollPageView

@interface TCNestScrollPageView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) TCNestScrollParam *param;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) TCMainScrollView *mainScrollView;
@property (nonatomic, strong) UIView *viewPager;
@property (nonatomic, assign) CGFloat lastDy;//mainScrollView最后停留位置
@property(nonatomic,assign)BOOL nextReturn;//这个用于记录是否是咱们通过代码手动给subScrollView的conteentOffSet赋值,是的话就不用做监听处理
@property(nonatomic,assign)CGFloat stayHeight;//头部允许向上滚动的距离
@property (nonatomic, assign) CGFloat mainTabExchangeDy;//mainScrollView最后变化距离

@end

@implementation TCNestScrollPageView


- (instancetype)initWithFrame:(CGRect)frame headView:(UIView *)headView viewPageView:(UIView *)viewPager nestScrollParam:(TCNestScrollParam *)param {
    if(self = [super initWithFrame:frame]) {
        self.param = param;
        self.lastDy = 0.0;
        self.mainScrollView = [[TCMainScrollView alloc] initWithFrame:self.bounds];
        self.mainScrollView.delegate = self;
        if(@available(iOS 11.0, *)){
            self.mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        } else {
            self.viewController.automaticallyAdjustsScrollViewInsets = NO;
        }
        self.mainScrollView.bounces = self.param.bounces;
        self.mainScrollView.showsVerticalScrollIndicator = NO;
        [self insertSubview:self.mainScrollView atIndex:0];

        [self resetHeader:headView];
        [self resetViewPage:viewPager];
        
    }
    return self;
}


- (void)setHeaderView:(UIView *)headerView {
    _headerView = headerView;
    self.stayHeight =  ((CGFloat)ceil(headerView.frame.size.height - self.param.yOffset));
    
}

- (void)resetHeader:(UIView *)headerView {
    [self.headerView removeFromSuperview];
    self.headerView = headerView;
    [self.mainScrollView addSubview:self.headerView];
    self.viewPager.frame = CGRectMake(0, self.headerView.frame.size.height, self.frame.size.width, self.frame.size.height - self.param.yOffset);
    self.mainScrollView.contentSize = CGSizeMake(0, self.headerView.frame.size.height + self.frame.size.height - self.param.yOffset);
}

- (void)resetViewPage:(UIView *)viewPage {
    
    [self.viewPager removeFromSuperview];
    self.viewPager = viewPage;
    self.viewPager.frame = CGRectMake(0, self.headerView.frame.size.height, self.frame.size.width, self.frame.size.height - self.param.yOffset);
    [self.mainScrollView addSubview:self.viewPager];
    self.mainScrollView.viewPager = self.viewPager;
    self.mainScrollView.contentSize = CGSizeMake(0, self.headerView.frame.size.height + self.frame.size.height - self.param.yOffset);
}


//这个是给header滚动延续的时候用的
- (void)setObserveScrollView:(UIScrollView *)scrollView {
    [self.mainScrollView addObserveScrollView:scrollView];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview == nil) {
        for (UIScrollView *sc in self.mainScrollView.viewArray) {
            [sc removeObserver:self forKeyPath:@"contentOffset"];
        }
    }
}

#pragma mark - ScrollVieeScroll

//mainScrollView的滚动监听(三种效果都分开写,全写一起我自己都晕了,也不方便其他人阅读)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.param.pageType == NestScrollPageViewHeadViewChageType) {
        //header随时变动
        [self headViewChageTypeScrollViewDidScroll:scrollView];
    } else if(self.param.pageType == NestScrollPageViewHeadViewSuckTopType) {
        //header吸顶不动
        [self headViewSuckTopTypeScrollViewDidScroll:scrollView];
    } else if(self.param.pageType == NestScrollPageViewHeadViewNoSuckTopType) {
        //header不吸顶,可以一块往下拖
        [self headViewNoSuckTopTypeScrollViewDidScroll:scrollView];
    }
    if (self.didScrollBlock) {
        self.didScrollBlock(scrollView.contentOffset.y);
    }
}

//subScrollView的滚动监听(三种效果都分开写,全写一起我自己都晕了,也不方便其他人阅读)
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]){
        if(self.param.pageType == NestScrollPageViewHeadViewChageType) {
            //header随时变动
            [self headViewChageTypeObserveValueForKeyPath:keyPath ofObject:object change:change context:context];
        } else if(self.param.pageType == NestScrollPageViewHeadViewSuckTopType) {
            //header吸顶不动
            [self headViewSuckTopTypeObserveValueForKeyPath:keyPath ofObject:object change:change context:context];
        } else if(self.param.pageType == NestScrollPageViewHeadViewNoSuckTopType) {
            //header不吸顶,可以一块往下拖
            [self headViewNoSuckTopTypeObserveValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark headViewChageType header随时变动

- (void)headViewChageTypeScrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat dh = scrollView.contentOffset.y;
    _mainTabExchangeDy = dh - _lastDy;
    if (dh >= _stayHeight) {
        scrollView.contentOffset = CGPointMake(0, _stayHeight);
    } else if(dh<=0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    _lastDy = scrollView.contentOffset.y;
}
//subScrollView
- (void)headViewChageTypeObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    CGFloat new = [change[@"new"] CGPointValue].y;
    CGFloat old = [change[@"old"] CGPointValue].y;
    if (_nextReturn) {
        _nextReturn = false;
        return;
    }

    if (new == old) {
        NSLog(@"相等");
        return;
    }
    CGFloat dh = new - old;
    if (dh < 0) {
        //向下
        
        if(self.mainScrollView.contentOffset.y > 0 && ((UIScrollView *)object).contentOffset.y < (((UIScrollView *)object).contentSize.height-((UIScrollView *)object).frame.size.height) && self.mainScrollView.dragging == YES) {
            _nextReturn = true;
            ((UIScrollView *)object).contentOffset = CGPointMake(0, old);
        }
    } else if(dh > 0) {
        //向上
        if(self.mainScrollView.contentOffset.y < _stayHeight && ((UIScrollView *)object).contentOffset.y > 0 && self.mainScrollView.dragging == YES) {
            //加一下这个if判断是因为在tableView的情况下,如果只选reloadData之后,不知道为什么会导致contentOffSet莫名其妙加上40,也就是会造成dh>0.然后当执行((UIScrollView *)object).contentOffset = CGPointMake(0, old)后并不管用,tableView会反复让contentOffSet莫名其妙加上40,最后赵成崩溃,所以想法:当mainScrollView的contentoffset变化没有subScrollView的contentOffset变化那么大时,就表示出现了上述行为,那么就不做强制修改contentoffset
            if(dh > (_mainTabExchangeDy)) {
                return;
            }
            _nextReturn = true;
            ((UIScrollView *)object).contentOffset = CGPointMake(0, old);
        }
    }
}

#pragma mark headViewSuckTopType  //header吸顶不动

- (void)headViewSuckTopTypeScrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat dh = scrollView.contentOffset.y;
    if (dh >= _stayHeight) {
        scrollView.contentOffset = CGPointMake(0, _stayHeight);
        _lastDy = scrollView.contentOffset.y;
    } else if(dh<=0) {
        scrollView.contentOffset = CGPointMake(0, 0);
        _lastDy = scrollView.contentOffset.y;
    } else {
        UIScrollView *currenSubScrollView = self.mainScrollView.currentSubScrolleView;//nil;
        if (currenSubScrollView == nil) {
            _lastDy = scrollView.contentOffset.y;
            return;
        }
        if(currenSubScrollView.contentOffset.y > 0 && (scrollView.contentOffset.y < _stayHeight) && (scrollView.contentOffset.y - _lastDy)<0  && self.mainScrollView.isScrolBySelf == NO) {
            //向下拖拽
            scrollView.contentOffset = CGPointMake(0, _lastDy);
        } else if((scrollView.contentOffset.y - _lastDy)>0 && currenSubScrollView.contentOffset.y<0) {
            //向上
            scrollView.contentOffset = CGPointMake(0, _lastDy);
        }
        _lastDy = scrollView.contentOffset.y;
    }
}

//subScrollView
- (void)headViewSuckTopTypeObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
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
            if (self.mainScrollView.contentOffset.y > 0) {
                _nextReturn = true;
                ((UIScrollView *)object).contentOffset = CGPointMake(0, 0);
            }
        }
    }else{
        //向上
        if (self.mainScrollView.contentOffset.y < _stayHeight) {
            if (((UIScrollView *)object).contentOffset.y > 0) {
                _nextReturn = true;
                if(old < 0) {
                    old = 0;
                }
                ((UIScrollView *)object).contentOffset = CGPointMake(0, old);
            }
        }else{
        }
    }
}

#pragma mark headViewNoSuckTopType   //header不吸顶,可以一块往下拖

- (void)headViewNoSuckTopTypeScrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat dh = scrollView.contentOffset.y;
    if(_lastDy == dh) {
        return;
    }
    if (dh >= _stayHeight) {
        scrollView.contentOffset = CGPointMake(0, _stayHeight);
        _lastDy = scrollView.contentOffset.y;
    } else {
        UIScrollView *currenSubScrollView = self.mainScrollView.currentSubScrolleView;
        if (currenSubScrollView == nil) {
            _lastDy = scrollView.contentOffset.y;
            return;
        }
        //向下拖拽
        if (currenSubScrollView.contentOffset.y > 0 && (self.mainScrollView.contentOffset.y < _stayHeight) && (self.mainScrollView.contentOffset.y - _lastDy)<0  && self.mainScrollView.isScrolBySelf == NO) {
            scrollView.contentOffset = CGPointMake(0, _lastDy);
        }
        _lastDy = scrollView.contentOffset.y;
    }
}
//subScrollView
- (void)headViewNoSuckTopTypeObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
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
        if (self.mainScrollView.contentOffset.y < _stayHeight) {
            _nextReturn = true;
            ((UIScrollView *)object).contentOffset = CGPointMake(0, old);
        }else{
        }
    }
}


- (void)dealloc {
    NSLog(@"%@销毁了",self);
}

-(UIViewController*)viewController
{
    UIResponder *nextResponder =  self;
    do
    {
        nextResponder = [nextResponder nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;
    } while (nextResponder != nil);
    return nil;
}


@end



