//
//  ENestScrollPageView.m
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2020/6/9.
//  Copyright © 2020 duoduo. All rights reserved.
//

#import "TCNestScrollPageView.h"

#pragma mark - TCMainScrollView


@implementation TCMainScrollView
/********************** 多手势同时识别 ***************************/
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    UIView *otherGestureRecognizerView = otherGestureRecognizer.view;
    if(([otherGestureRecognizerView isKindOfClass:[UITableView class]] || [otherGestureRecognizerView isKindOfClass:[UICollectionView class]] || [otherGestureRecognizerView isKindOfClass:NSClassFromString(@"WKScrollView")] || [otherGestureRecognizerView isKindOfClass:[UIScrollView class]]) && otherGestureRecognizerView != self && gestureRecognizer == self.panGestureRecognizer && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if(floor(((UIScrollView *)otherGestureRecognizerView).contentSize.width) > floor(otherGestureRecognizerView.frame.size.width) && ((UIScrollView *)otherGestureRecognizerView).contentSize.height <= otherGestureRecognizerView.frame.size.height) {
            return NO;
        } else {
            return YES;
        }
    }
    return NO;
}

//1
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    if(gestureRecognizer == self.panGestureRecognizer) {
        self.isScrolBySelf = YES;
        self.currentSubScrolleView = nil;
        UIView *touchView = touch.view;
        while (touchView != nil) {
            if(([touchView isKindOfClass:[UITableView class]] || [touchView isKindOfClass:[UICollectionView class]] || [touchView isKindOfClass:[UIScrollView class]] || [touchView isKindOfClass:NSClassFromString(@"WKScrollView")]) && touchView != self) {


                if(floor(((UIScrollView *)touchView).contentSize.width) > floor(touchView.frame.size.width) && ((UIScrollView *)touchView).contentSize.height <= touchView.frame.size.height) {
                } else {
                    self.isScrolBySelf = NO;
                    self.currentSubScrolleView = (UIScrollView *)touchView;
                    if(![self.viewArray containsObject:self.currentSubScrolleView]) {
                        [self.viewArray addObject:self.currentSubScrolleView];
                        [self.currentSubScrolleView addObserver:self.superview forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
                    }
                    break;
                }
            }
            if(touchView == self) {
                break;
            }
            touchView = [touchView nextResponder];
        }
    }
    return YES;
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


#pragma mark - TCNestScrollPageView

@interface TCNestScrollPageView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) TCNestScrollParam *param;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) TCMainScrollView *mainTabelView;
@property (nonatomic, strong) UITableViewCell *cell;
@property (nonatomic, strong) UIView *viewPager;
@property (nonatomic, assign) CGFloat lastDy;//mainTableView最后停留位置
@property(nonatomic,assign)BOOL nextReturn;//这个用于记录是否是手动改变contentOffset的conteentOffSet,是的话就不用做监听处理
@property(nonatomic,assign)CGFloat stayHeight;//头部允许向上滚动的距离
@property (nonatomic, assign) CGFloat mainTabExchangeDy;//mainTableView最后变化距离

@end

@implementation TCNestScrollPageView


- (instancetype)initWithFrame:(CGRect)frame headView:(UIView *)headView viewPageView:(UIView *)viewPager nestScrollParam:(TCNestScrollParam *)param {
    if(self = [super initWithFrame:frame]) {
        self.param = param;
        self.lastDy = 0.0;
        self.viewPager = viewPager;
        [self setupBaseView];
        self.headerView = headView;
    }
    return self;
}

- (void)setupBaseView {
    self.mainTabelView = [[TCMainScrollView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    if(@available(iOS 11.0, *)){
        self.mainTabelView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    } else {
        self.viewController.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.mainTabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    self.mainTabelView.dataSource = self;
    self.mainTabelView.delegate = self;
    self.mainTabelView.bounces = self.param.bounces;
    self.mainTabelView.showsVerticalScrollIndicator = NO;
    [self insertSubview:self.mainTabelView atIndex:0];
}

- (void)setHeaderView:(UIView *)headerView {
    _headerView = headerView;
    self.stayHeight =  ((CGFloat)ceil(headerView.frame.size.height - self.param.yOffset));
    self.mainTabelView.tableHeaderView = self.headerView;
}

- (void)resetHeader:(UIView *)headerView {
    self.headerView = headerView;
}

- (void)resetViewPage {
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview == nil) {
        for (UIScrollView *sc in self.mainTabelView.viewArray) {
            [sc removeObserver:self forKeyPath:@"contentOffset"];
        }
    }
}

#pragma mark - ScrollVieeScroll

//mainScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.param.pageType == NestScrollPageViewHeadViewChageType) {
        [self headViewChageTypeScrollViewDidScroll:scrollView];
    } else if(self.param.pageType == NestScrollPageViewHeadViewSuckTopType) {
        [self headViewSuckTopTypeScrollViewDidScroll:scrollView];
    } else if(self.param.pageType == NestScrollPageViewHeadViewNoSuckTopType) {
        [self headViewNoSuckTopTypeScrollViewDidScroll:scrollView];
    }
    if (self.didScrollBlock) {
        self.didScrollBlock(scrollView.contentOffset.y);
    }
}



//subScrollView
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]){
        if(self.param.pageType == NestScrollPageViewHeadViewChageType) {
            [self headViewChageTypeObserveValueForKeyPath:keyPath ofObject:object change:change context:context];
        } else if(self.param.pageType == NestScrollPageViewHeadViewSuckTopType) {
            [self headViewSuckTopTypeObserveValueForKeyPath:keyPath ofObject:object change:change context:context];
        } else if(self.param.pageType == NestScrollPageViewHeadViewNoSuckTopType) {
            [self headViewNoSuckTopTypeObserveValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark headViewChageType

- (void)headViewChageTypeScrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat dh = scrollView.contentOffset.y;
    _mainTabExchangeDy = dh - _lastDy;
    if (dh >= _stayHeight) {
        scrollView.contentOffset = CGPointMake(0, _stayHeight);
//        _lastDy = scrollView.contentOffset.y;
    } else if(dh<=0) {
        scrollView.contentOffset = CGPointMake(0, 0);
//        _lastDy = scrollView.contentOffset.y;
    }
    _lastDy = scrollView.contentOffset.y;
}
//subScrollView
- (void)headViewChageTypeObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    CGFloat new = [change[@"new"] CGPointValue].y;
    CGFloat old = [change[@"old"] CGPointValue].y;
    NSLog(@"%p %lf  %lf  %lf  %lf   %p  %d  %d  %d    %@",object,self.mainTabelView.contentOffset.y, ((UIScrollView *)object).contentOffset.y, old, new, object, ((UIScrollView *)object).tracking, ((UIScrollView *)object).dragging,((UIScrollView *)object).decelerating,NSStringFromUIEdgeInsets(((UIScrollView *)object).contentInset));
    if (_nextReturn) {
        _nextReturn = false;
        return;
    }
//    CGFloat new = [change[@"new"] CGPointValue].y;
//    CGFloat old = [change[@"old"] CGPointValue].y;
    if (new == old) {
        NSLog(@"相等");
        return;
    }
    CGFloat dh = new - old;
    if (dh < 0) {
        //向下
        NSLog(@"向下old : %lf   new : %lf    %lf   %lf",old,new,((UIScrollView *)object).contentSize.height,((UIScrollView *)object).frame.size.height);
        
        if(self.mainTabelView.contentOffset.y > 0 && ((UIScrollView *)object).contentOffset.y < (((UIScrollView *)object).contentSize.height-((UIScrollView *)object).frame.size.height) && self.mainTabelView.dragging == YES) {
            _nextReturn = true;
            NSLog(@"向下--old : %lf",old);
            ((UIScrollView *)object).contentOffset = CGPointMake(0, old);
        }
    } else if(dh > 0) {
        //向上
        NSLog(@"向上old : %lf",old);
        if (self.mainTabelView.contentOffset.y < _stayHeight && ((UIScrollView *)object).contentOffset.y > 0 && self.mainTabelView.dragging == YES) {
            //加一下这个if判断是因为在tableView的情况下,如果只选reloadData之后,不知道为什么会导致contentOffSet莫名其妙加上40,也就是会照成dh>0.然后当执行((UIScrollView *)object).contentOffset = CGPointMake(0, old)后并不管用,tableView会反复让contentOffSet莫名其妙加上40,最后照成崩溃,所以想法:当maintableView的contentoffset变化没有subScrollView的contentOffset变化那么大时,就表示出现了上述行为,那么就不做强制修改contentoffset
            NSLog(@"uiuiuiu%lf  %lf  %lf  %lf",_mainTabExchangeDy,self.mainTabelView.contentOffset.y,old,new);
            if(dh > _mainTabExchangeDy) {
                return;
            }
            _nextReturn = true;
            NSLog(@"向上--old : %lf",old);
            ((UIScrollView *)object).contentOffset = CGPointMake(0, old);
        }
    }
}

#pragma mark headViewSuckTopType

- (void)headViewSuckTopTypeScrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat dh = scrollView.contentOffset.y;
    if (dh >= _stayHeight) {
        scrollView.contentOffset = CGPointMake(0, _stayHeight);
        _lastDy = scrollView.contentOffset.y;
    } else if(dh<=0) {
        scrollView.contentOffset = CGPointMake(0, 0);
        _lastDy = scrollView.contentOffset.y;
    } else {
        UIScrollView *currenSubScrollView = self.mainTabelView.currentSubScrolleView;//nil;
        if (currenSubScrollView == nil) {
            _lastDy = scrollView.contentOffset.y;
            return;
        }
        //向下拖拽
        NSLog(@"%lf %lf %lf  %lf %lf",currenSubScrollView.contentOffset.y,scrollView.contentOffset.y,_stayHeight,scrollView.contentOffset.y,_lastDy);
        if (currenSubScrollView.contentOffset.y > 0 && (scrollView.contentOffset.y < _stayHeight) && (scrollView.contentOffset.y - _lastDy)<0  && self.mainTabelView.isScrolBySelf == NO) {
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
            if (self.mainTabelView.contentOffset.y > 0) {
                _nextReturn = true;
                ((UIScrollView *)object).contentOffset = CGPointMake(0, 0);
            }
        }
    }else{
        //向上
        if (self.mainTabelView.contentOffset.y < _stayHeight) {
            if (((UIScrollView *)object).contentOffset.y > 0) {
                _nextReturn = true;
                //                                    self.scrollTag = true;
                ((UIScrollView *)object).contentOffset = CGPointMake(0, old);
            }
        }else{
        }
    }
}

#pragma mark headViewNoSuckTopType

- (void)headViewNoSuckTopTypeScrollViewDidScroll:(UIScrollView *)scrollView{
     NSLog(@" %lf %lf  %lf %lf",scrollView.contentOffset.y,_stayHeight,scrollView.contentOffset.y,_lastDy);
    CGFloat dh = scrollView.contentOffset.y;
    if(_lastDy == dh) {
        return;
    }
    if (dh >= _stayHeight) {
        scrollView.contentOffset = CGPointMake(0, _stayHeight);
        _lastDy = scrollView.contentOffset.y;
    } else {
        UIScrollView *currenSubScrollView = self.mainTabelView.currentSubScrolleView;
        if (currenSubScrollView == nil) {
            _lastDy = scrollView.contentOffset.y;
            return;
        }
        //向下拖拽
       
        if (currenSubScrollView.contentOffset.y > 0 && (self.mainTabelView.contentOffset.y < _stayHeight) && (self.mainTabelView.contentOffset.y - _lastDy)<0  && self.mainTabelView.isScrolBySelf == NO) {
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
        if (self.mainTabelView.contentOffset.y < _stayHeight) {
            _nextReturn = true;
            ((UIScrollView *)object).contentOffset = CGPointMake(0, old);
        }else{
        }
    }
}

#pragma mark - UITableViewDataSource && UITableViewDlegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%lf",self.frame.size.height - self.param.yOffset);
    return self.frame.size.height - self.param.yOffset;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    self.cell = cell;
    if(![cell.contentView.subviews containsObject:self.viewPager]) {
        self.viewPager.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.param.yOffset);
        [cell.contentView addSubview:self.viewPager];
    }
    return cell;
}

- (void)resetViewPage:(UIView *)viewPage {
    
    [self.viewPager removeFromSuperview];
    self.viewPager = viewPage;
    self.viewPager.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.param.yOffset);
    [self.cell.contentView addSubview:self.viewPager];
    
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



