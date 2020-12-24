

//
//  TCViewPager.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/8/28.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "TCViewPager.h"
#import "TOGradientView.h"

#define MYRGBACOLOR(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define DefultLeftAndRightSpace  22
#define DefultTitlePageSpace     22
#define EditBtnW   30

@interface TCPageParam ()

@property (nonatomic, assign) CGFloat width;



@end


@implementation TCPageParam

- (instancetype)init {
    if(self = [super init]) {
        [self setupDefaultValue];
    }
    return self;
}

//设置默认值
- (void)setupDefaultValue {
    self.selectIndex = 0;
    self.titleArray = [NSMutableArray array];
    self.tabSelectedBottomLineColor = [UIColor blackColor];
    self.showSelectedBottomLine = NO;
    self.selectedBottomLineScale = 1.0;
    
    self.tabTitleColor = [UIColor blackColor];
    self.tabSelectedTitleColor = [UIColor redColor];
    self.selectedLabelBigScale = 1.0;
    self.labelFont = [UIFont systemFontOfSize:15];
    self.pageHeaderHeight = 40;
    
    self.showBottomGradientLayer = YES;
    self.bottomGradientH = 6;
    self.bottomGradientColorArr = @[MYRGBACOLOR(239,242,241,1), MYRGBACOLOR(239,242,241,0.0)];
    
    self.pageHeaderControlBottomLineColor = [UIColor clearColor];
    self.pageHeaderControlBottomLineHeight = 1.0;
    self.viewPagerBgColor = [UIColor whiteColor];
    self.titlePageSpace = DefultTitlePageSpace;
    self.leftAndRightSpace = DefultLeftAndRightSpace;
    self.animateScroll = YES;
}


- (void)setTitleArray:(NSMutableArray *)titleArray {
    _titleArray = [NSMutableArray arrayWithArray:titleArray];
}

//这个方法是当用户没有传入leftAndRightSpace或者titlePageSpace,那么就按照默认的逻辑来做,
/*
 1.leftAndRightSpace和titlePageSpace都没有传入,那么就默认leftAndRightSpace为22,titlePageSpace为22,然后如果加上titleWidth后还是小于一屏,那么久重新计算leftAndRightSpace和titlePageSpace,使其刚好一屏
 2.如果leftAndRightSpace有值,titlePageSpace无值,那么让titlePageSpace默认为22,然后如果加上titleWidth后还是小于一屏,那么久重新计算titlePageSpace,使其刚好一屏
 3.如果leftAndRightSpace无值,titlePageSpace有值,那么leftAndRightSpace默认为22
 4.如果leftAndRightSpace和titlePageSpace都有值,那就照着你设置的值来
 */
- (void)calculate {
    CGFloat titleAllLength = 0;
    if(!self.titleArrayLength.count) {
        NSMutableArray *titleWidths = [NSMutableArray array];
        for(NSString *title in _titleArray) {
            CGFloat width = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:self.labelFont} context:nil].size.width +1;
            [titleWidths addObject:@(width)];
            titleAllLength = titleAllLength + width;
        }
        self.titleArrayLength = titleWidths;
    }
    for(NSNumber *width in self.titleArrayLength) {
        titleAllLength = titleAllLength + width.floatValue;
    }
    if(self.leftAndRightSpace >= 0) {
        if(self.titlePageSpace >= 0) {
        } else {
            self.titlePageSpace = DefultTitlePageSpace;
            if((titleAllLength + self.leftAndRightSpace * 2 + (self.titleArray.count -1) * self.titlePageSpace) < self.width && self.titleArray.count>1) {
                self.titlePageSpace = (self.width - titleAllLength - self.leftAndRightSpace * 2) / (self.titleArray.count - 1);
            }
        }
    } else {
        if(self.titlePageSpace >= 0) {
            self.leftAndRightSpace = DefultLeftAndRightSpace;
        } else {
            self.leftAndRightSpace = DefultLeftAndRightSpace;
            self.titlePageSpace = DefultTitlePageSpace;
            if((titleAllLength + self.leftAndRightSpace * 2 + (self.titleArray.count -1) * self.titlePageSpace) < self.width) {
                self.leftAndRightSpace = self.titlePageSpace = (self.width - titleAllLength) / (self.titleArray.count + 1);
            }
        }
    }
}

@end



@interface TCViewPager ()

//分页列表
@property (nonatomic, strong) UIScrollView *scrollView;
//菜单标题按钮列表
@property (nonatomic, strong) UIScrollView *pageHeaderControl;
//菜单标题按钮数组
@property (nonatomic, strong)  NSMutableArray *titleBtnArray;
//视图
@property (nonatomic, strong)  NSArray *views;
@property (nonatomic, strong) UIButton *editTagBtn;
//底部选中下划线
@property (nonatomic, strong) UIView *selectedBottomLine;

//// 当前选择的ViewController或者View
//@property (nonatomic, strong) id currentSelectViewOrController;
//点击block
@property (nonatomic, copy) TC_VP_SelectedBlock block;
@property (nonatomic, copy) TC_VP_EditTagBlock editTagBlock;;
//配置
@property (nonatomic, strong) TCPageParam *param;

@property (nonatomic, assign) NSInteger currentIndex;

@end


@implementation TCViewPager

- (UIViewController *)selectController {
    if(_views.count > self.currentIndex && self.currentIndex >= 0) {
        _selectController = _views[self.currentIndex];
        return _selectController;
    }
    return nil;
}

//按钮的点击事件
- (void)tabBtnClicked:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    
    if(index == self.param.selectIndex) {
        if(self.block) {
            self.block(self, index,self.param.selectIndex, YES);
        }
        return;
    } else {
        [self setSelectIndex:index isClickBtn:YES];
    }
}

- (void)changeSelectedIndex:(NSInteger)selectIndex {
    if(selectIndex == self.param.selectIndex) {
        if(_block) {
            _block(self, selectIndex,self.param.selectIndex, NO);
        }
        return;
    } else {
        [self setSelectIndex:selectIndex isClickBtn:NO];
    }
}

//修改某一个标题的名字
- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSInteger)index {
    if(self.param.titleArray.count > index) {
        NSMutableArray *titleMutableArray = [NSMutableArray arrayWithArray:self.param.titleArray];
        titleMutableArray[index] = title;
        self.param.titleArray = titleMutableArray;
    }
    UIButton *btn = self.titleBtnArray[index];
    [btn setTitle:title forState:UIControlStateNormal];
}

/**
 设置选择的按钮索引 触发的方法(里面主要做的就是修改下面红色label的滑动距离,并且使得上面的按钮选中状态发生改变)
 
 @param index 选中第几个按钮
 */
- (void)setSelectIndex:(NSInteger)index isClickBtn:(BOOL)isClickBtn
{
    for(NSInteger i = 0; i < self.views.count; i++) {
        UIButton *btn = (UIButton *)[self.pageHeaderControl viewWithTag:i + 100];
        [btn setTitleColor:self.param.tabTitleColor forState:UIControlStateNormal];
        btn.selected = NO;
        btn.transform = CGAffineTransformIdentity;
    }
    UIButton *button = (UIButton *)[self.pageHeaderControl viewWithTag:index + 100];
    //    UIView *selectedLabel = (UIView *)[self.pageHeaderControl viewWithTag:300];
    button.selected = YES;
    button.transform = CGAffineTransformMakeScale(self.param.selectedLabelBigScale, self.param.selectedLabelBigScale);
    
    id childVc = self.views[index];
    if([childVc isKindOfClass:[UIViewController class]]) {
        //        if (![childVc isViewLoaded]) {
        [self.scrollView addSubview:((UIViewController *)childVc).view];
        ((UIViewController *)childVc).view.frame = CGRectMake(index * self.width, 0, self.scrollView.width, self.scrollView.height);
        //        }
      
    } else if([childVc isKindOfClass:[UIView class]]) {
        if(![self.scrollView.subviews containsObject:childVc]) {
            [self.scrollView addSubview:((UIView *)childVc)];
            ((UIView *)childVc).frame = CGRectMake(index * self.width, 0, self.scrollView.width, self.scrollView.height);
        }
    }
    
    if(floor(self.scrollView.contentOffset.x) == floor(index * self.width)) {
        self.selectedBottomLine.width = [self.param.titleArrayLength[index] floatValue] * self.param.selectedBottomLineScale;
        self.selectedBottomLine.centerX = button.centerX;
        self.scrollView.contentOffset = CGPointMake(index * self.width, 0);
        //让按钮居中
        [self setUpTitleCenter:button];
        if(self.block) {
            self.block(self, index,self.param.selectIndex,isClickBtn);
        }
        self.param.selectIndex = index;
    } else {
        CGFloat duration = 0.3;
        if(!self.param.animateScroll) {
            duration = 0;
        }
        [UIView animateWithDuration:duration animations:^{
            self.selectedBottomLine.width = [self.param.titleArrayLength[index] floatValue] * self.param.selectedBottomLineScale;
            self.selectedBottomLine.centerX = button.centerX;
            self.scrollView.contentOffset = CGPointMake(index * self.width, 0);
            //让按钮居中
            [self setUpTitleCenter:button];
        } completion:^(BOOL finished) {
            
        }];
        if(self.block) {
            self.block(self, index,self.param.selectIndex,isClickBtn);
        }
        self.param.selectIndex = index;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/self.width;
    [self setSelectIndex:index isClickBtn:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat curPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    // 左边label角标
    NSInteger leftIndex = curPage;
    // 右边的label角标
    NSInteger rightIndex = leftIndex + 1;
    if(self.titleBtnArray.count <= leftIndex) {
        return;
    }
    // 获取左边的Button
    UIButton *leftButton = self.titleBtnArray[leftIndex];
    // 获取右边的button
    UIButton *rightButton;
    if (rightIndex < self.titleBtnArray.count ) {
        rightButton = self.titleBtnArray[rightIndex];
    }
    // 计算下右边缩放比例
    CGFloat rightScale = curPage - leftIndex;
    // 计算下左边缩放比例
    CGFloat leftScale = 1 - rightScale;
    leftButton.transform = CGAffineTransformMakeScale(leftScale * (self.param.selectedLabelBigScale - 1) + 1, leftScale * (self.param.selectedLabelBigScale - 1)+ 1);
    rightButton.transform = CGAffineTransformMakeScale(rightScale * (self.param.selectedLabelBigScale-1) + 1, rightScale * (self.param.selectedLabelBigScale - 1)+ 1);
    
    // 计算偏移量
    CGFloat offsetX = self.param.leftAndRightSpace  ;
    if(self.param.titleArrayLength.count >= 1) {
        offsetX = offsetX + [self.param.titleArrayLength[0] floatValue] * 0.5;
    }
    
    NSInteger indexInt = ((NSInteger)(scrollView.contentOffset.x/ scrollView.width));
    CGFloat indexFloat = scrollView.contentOffset.x / scrollView.width - indexInt;
    for(NSInteger i = 0; i<indexInt; i++) {
        offsetX = offsetX + [self.param.titleArrayLength[i] floatValue]/2 + self.param.titlePageSpace +( self.param.titleArrayLength.count > (i+1) ? [self.param.titleArrayLength[i+1] floatValue]/2 : 0);
    }
    if(self.param.titleArrayLength.count > indexInt ) {
        offsetX = offsetX + ([self.param.titleArrayLength[indexInt] floatValue]/2 + self.param.titlePageSpace +( self.param.titleArrayLength.count > (indexInt+1) ? [self.param.titleArrayLength[indexInt+1] floatValue]/2 : 0)) * indexFloat;
    }
    
    if(rightIndex <  _titleBtnArray.count) {
        self.selectedBottomLine.width = [self.param.titleArrayLength[leftIndex] floatValue] * self.param.selectedBottomLineScale * leftScale + [self.param.titleArrayLength[rightIndex] floatValue] * self.param.selectedBottomLineScale * rightScale;
    } else {
        self.selectedBottomLine.width = [self.param.titleArrayLength[leftIndex] floatValue] * self.param.selectedBottomLineScale * leftScale;
    }
    self.selectedBottomLine.centerX = offsetX;
    
    offsetX = offsetX - self.width * 0.5;
    if (offsetX < 0) offsetX = 0;
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.pageHeaderControl.contentSize.width - self.pageHeaderControl.width;
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    // 滚动标题滚动条
    [self.pageHeaderControl setContentOffset:CGPointMake(offsetX, 0) animated:NO];
    
    CGFloat NormalTitleB, NormalTitleG, NormalTitleR, SelectedTitleB, SelectedTitleG, SelectedTitleR;
    [self.param.tabTitleColor getRed:&NormalTitleR green:&NormalTitleG blue:&NormalTitleB alpha:nil];
    [self.param.tabSelectedTitleColor getRed:&SelectedTitleR green:&SelectedTitleG blue:&SelectedTitleB alpha:nil];
    NormalTitleB = NormalTitleB * 255;
    NormalTitleG = NormalTitleG * 255;
    NormalTitleR = NormalTitleR * 255;
    SelectedTitleB = SelectedTitleB * 255;
    SelectedTitleG = SelectedTitleG * 255;
    SelectedTitleR = SelectedTitleR * 255;
    [leftButton setTitleColor:MYRGBACOLOR(SelectedTitleR+(NormalTitleR-SelectedTitleR) * rightScale, SelectedTitleG+(NormalTitleG-SelectedTitleG) * rightScale, SelectedTitleB+(NormalTitleB-SelectedTitleB) * rightScale, 1) forState:UIControlStateNormal];
    [leftButton setTitleColor:MYRGBACOLOR(SelectedTitleR+(NormalTitleR-SelectedTitleR) * rightScale, SelectedTitleG+(NormalTitleG-SelectedTitleG) * rightScale, SelectedTitleB+(NormalTitleB-SelectedTitleB) * rightScale, 1) forState:UIControlStateSelected];
    
    [rightButton setTitleColor:MYRGBACOLOR(SelectedTitleR+(NormalTitleR-SelectedTitleR) * leftScale, SelectedTitleG+(NormalTitleG-SelectedTitleG) * leftScale, SelectedTitleB+(NormalTitleB-SelectedTitleB) * leftScale, 1) forState:UIControlStateNormal];
    [rightButton setTitleColor:MYRGBACOLOR(SelectedTitleR+(NormalTitleR-SelectedTitleR) * leftScale, SelectedTitleG+(NormalTitleG-SelectedTitleG) * leftScale, SelectedTitleB+(NormalTitleB-SelectedTitleB) * leftScale, 1) forState:UIControlStateSelected];
    NSLog(@"%f",curPage);
}

// 设置标题居中
- (void)setUpTitleCenter:(UIButton *)centerButton
{
    // 计算偏移量
    CGFloat offsetX = centerButton.center.x - self.width * 0.5;
    if (offsetX < 0) offsetX = 0;
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.pageHeaderControl.contentSize.width - self.pageHeaderControl.width;
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    // 滚动标题滚动条
    self.pageHeaderControl.contentOffset = CGPointMake(offsetX, 0);
}

- (void)didSelectedBlock:(TC_VP_SelectedBlock)block
{
    self.block = block;
}

- (void)editTagBtnClickBlock:(TC_VP_EditTagBlock)block {
    _editTagBlock = block;
}

- (void)editTagBtnClick {
    if(_editTagBlock) {
        _editTagBlock();
    }
}

- (NSInteger)currentIndex {
    return self.param.selectIndex;
}

- (id)initWithFrame:(CGRect)frame
              views:(NSArray *)views
              param:(TCPageParam *)param
{
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        self.views = views;
        self.param = param;
        self.param.width = frame.size.width;
        if(self.views.count != self.param.titleArray.count) {
            if(self.views.count > self.param.titleArray.count) {
                for(NSInteger i =0;i<self.param.titleArray.count-self.views.count;i++) {
                    [self.param.titleArray addObject:@""];
                }
            } else {
                [self.param.titleArray removeObjectsInRange:NSMakeRange(self.views.count, self.param.titleArray.count-self.views.count)];
            }
        }
        [self.param calculate];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    if(self.scrollView) return;
    CGRect rect = self.bounds;
    self.backgroundColor = self.param.viewPagerBgColor;
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.param.pageHeaderHeight, self.width, self.height - self.param.pageHeaderHeight)];
    if(@available(iOS 11.0, *)){
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    } else {
        self.viewController.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.backgroundColor = self.param.viewPagerBgColor;
    self.pageHeaderControl = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.param.canEdit ? self.width - EditBtnW : self.width, self.param.pageHeaderHeight)];
    self.pageHeaderControl.backgroundColor = self.param.viewPagerBgColor;
    self.pageHeaderControl.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    [self addSubview:self.pageHeaderControl];
    
    if(self.param.canEdit) {
        self.editTagBtn = [[UIButton alloc] init];
        self.editTagBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        self.editTagBtn.backgroundColor = [UIColor clearColor];
        [self.editTagBtn addTarget:self action:@selector(editTagBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.editTagBtn];
        [self.editTagBtn setImage:[UIImage imageNamed:@"TAG_Mger_Edit"] forState:UIControlStateNormal];
        [self.editTagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.with.offset(0);
            make.right.with.offset(0);
            make.height.mas_equalTo(self.param.pageHeaderHeight);
            make.width.mas_equalTo(EditBtnW);
        }];
    }
    
    if(self.param.showBottomGradientLayer) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        NSMutableArray *colorArr = [NSMutableArray array];
        for(UIColor *c in self.param.bottomGradientColorArr) {
            [colorArr addObject:(__bridge id)c.CGColor];
        }
        gradientLayer.colors = colorArr;
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1.0);
        gradientLayer.frame = CGRectMake(0, self.param.pageHeaderHeight, rect.size.width, self.param.bottomGradientH);
        [self.layer addSublayer:gradientLayer];
    }
    for(NSInteger i = 0; i < self.views.count; i++) {
        
        CGRect pageframe = self.pageHeaderControl.frame;
        pageframe.size.width = [self.param.titleArrayLength[i] floatValue];
        pageframe.origin.x = pageframe.origin.x + self.param.leftAndRightSpace;
        for(NSInteger j = 0; j < i; j++) {
            pageframe.origin.x = pageframe.origin.x + self.param.titlePageSpace + [self.param.titleArrayLength[j] floatValue];
        }
        
        //创建菜单按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [button setFrame:pageframe];
        button.tag = 100 + i;
        [button setTitleColor:self.param.tabTitleColor forState:UIControlStateNormal];
        [button setTitleColor:self.param.tabSelectedTitleColor forState:UIControlStateSelected];
        [button setBackgroundColor:[UIColor clearColor]];
        id currentTitle = self.param.titleArray[i];
        if([currentTitle isKindOfClass:[NSString class]]) {
            [button setTitle:self.param.titleArray[i] forState:UIControlStateNormal];
        } else if([currentTitle isKindOfClass:[UIImage class]]){
            [button setImage:currentTitle forState:UIControlStateNormal];
        }
        
        if(!self.titleBtnArray) {
            self.titleBtnArray = [NSMutableArray array];
        }
        [self.titleBtnArray addObject:button];
        
        button.titleLabel.font = self.param.labelFont;
        
        [button addTarget:self action:@selector(tabBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if(!i) {
            button.selected = YES;
            self.selectedBottomLine.centerX = button.centerX;
        }

        [self.pageHeaderControl addSubview:button];
    }
    
    //创建菜单标题scrollView下方的横线
    if(self.param.pageHeaderControlBottomLineWidth == 0) {
        self.param.pageHeaderControlBottomLineWidth = self.width;
    }
    UIView *pageHeaderControlBottomLine = [[UIView alloc] initWithFrame:CGRectMake((self.width - self.param.pageHeaderControlBottomLineWidth)/2, self.param.pageHeaderHeight - self.param.pageHeaderControlBottomLineHeight, self.param.pageHeaderControlBottomLineWidth, self.param.pageHeaderControlBottomLineHeight)];
    pageHeaderControlBottomLine.backgroundColor = self.param.pageHeaderControlBottomLineColor;
    [self.pageHeaderControl addSubview:pageHeaderControlBottomLine];
    
    if(self.param.showSelectedBottomLine) {
        //创建菜单按钮下划线
        self.selectedBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.pageHeaderControl.height -3, self.param.titlePageSpace * self.param.selectedBottomLineScale, 3)];
        self.selectedBottomLine.backgroundColor = self.param.tabSelectedBottomLineColor;
        [self.pageHeaderControl addSubview:self.selectedBottomLine];
    }
    
    
    
    CGFloat pageContentSizeWidth = 2 * self.param.leftAndRightSpace + (self.param.titleArrayLength.count - 1)*self.param.titlePageSpace;
    for(NSInteger i = 0; i < self.param.titleArrayLength.count; i++) {
        pageContentSizeWidth = pageContentSizeWidth + [self.param.titleArrayLength[i] floatValue];
    }
    self.pageHeaderControl.contentSize = CGSizeMake(pageContentSizeWidth >= self.pageHeaderControl.width ? pageContentSizeWidth : self.pageHeaderControl.width, 0);
    [self.scrollView setContentSize:CGSizeMake(rect.size.width * self.views.count + 1, 0)];
    self.scrollView.delegate = self;
    self.scrollView.contentOffset = CGPointMake(self.width*self.param.selectIndex, 0);
    if(self.views.count) {
        [self setSelectIndex:self.param.selectIndex isClickBtn:NO];
    }
}

- (void)dealloc {
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
