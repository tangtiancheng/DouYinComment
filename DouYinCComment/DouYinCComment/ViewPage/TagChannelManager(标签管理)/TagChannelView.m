//
//  TagChannelView.m
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2020/8/10.
//  Copyright © 2020 duoduo. All rights reserved.
//

#import "TagChannelView.h"
#import "TagBtn.h"
#import "TagModel.h"
#import "UIButton+CommonFunction.h"


#define TopHeadHeight  50
#define TagTipHeight   55
#define SpaceLR        14
#define TagSpaceH      12
#define TagSpaceV      12
#define TAGBtnW        ((SCREEN_WIDTH - 2 * SpaceLR - 3 * TagSpaceH) / 4)
#define TAGBtnH        (TAGBtnW * 20.0/38.0)
#define TAGBtnScaleLongPress  1.2

@interface TagChannelView ()<UIScrollViewDelegate, UIGestureRecognizerDelegate, LongPressDelegate>

@property (nonatomic, strong) TAGChannelParam *param;
@property (nonatomic, copy) TAGMgerBlock mgerBlock;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIView *topHeaderView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *tipTagLabel;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UILabel *recommendTagLabel;
@property (nonatomic, strong) UILabel *tipTagLabel2;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) NSMutableArray *upBtnArr;
@property (nonatomic, strong) NSMutableArray *belowBtnArr;

@property (nonatomic, strong) NSMutableArray <NSValue*>*upFranmeArr;
@property (nonatomic, strong) NSMutableArray <NSValue*>*belowFranmeArr;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
//当前正在拖拽的是否是tableView
@property (nonatomic, assign) BOOL isDragTableView;
//向下拖拽最后时刻的位移
@property (nonatomic, assign) CGFloat lastDrapDistance;

@end

@implementation TagChannelView

- (instancetype)initWithParam:(TAGChannelParam *)param mgerSuccess:(TAGMgerBlock)block {
    if(self = [super init]) {
        self.isEdit = NO;
        self.param = param;
        self.mgerBlock = block;
        self.upBtnArr = [NSMutableArray array];
        self.belowBtnArr = [NSMutableArray array];
        self.upFranmeArr = [NSMutableArray array];
        self.belowFranmeArr = [NSMutableArray array];
           
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        self.container = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationHeight)];
        self.container.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.container];
        
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:_container.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20.0f , 20.0f )];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        _container.layer.mask = shape;
        [_container addSubview:self.topHeaderView];
        [self.topHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.with.offset(0);
            make.height.mas_equalTo(TopHeadHeight);
        }];
        
        NSLog(@"%lf  %lf",TAGBtnH,TagSpaceV);
        CGFloat upBtnAllHeight = (self.param.upBtnDataArr.count/4 + (self.param.upBtnDataArr.count%4 ? 1 : 0)) * TAGBtnH + ((self.param.upBtnDataArr.count/4 + (self.param.upBtnDataArr.count%4 ? 1 : 0))-1) * TagSpaceV;
        upBtnAllHeight = (upBtnAllHeight > 0 ? upBtnAllHeight : 0);
        CGFloat belowBtnAllHeight = (self.param.belowBtnDataArr.count/4 + (self.param.belowBtnDataArr.count%4 ? 1 : 0)) * TAGBtnH + ((self.param.belowBtnDataArr.count/4 + (self.param.belowBtnDataArr.count%4 ? 1 : 0))-1) * TagSpaceV;
        belowBtnAllHeight = (belowBtnAllHeight > 0 ? belowBtnAllHeight : 0);

        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TopHeadHeight, SCREEN_WIDTH, SCREEN_HEIGHT - TopHeadHeight - NavigationHeight)];
        self.scrollView.delegate = self;
        [self.container addSubview:self.scrollView];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.contentSize = CGSizeMake(0, TagTipHeight * 2 + upBtnAllHeight + belowBtnAllHeight + 60 );
        
        UILabel *myTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceLR, 0, [@"我的标签" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:[UIFont boldSystemFontOfSize:15 ]} context:nil].size.width+1, TagTipHeight)];
        myTagLabel.text = @"我的标签";
        myTagLabel.font = [UIFont boldSystemFontOfSize:15 ];
        myTagLabel.textColor = RGBCOLORVALUE(0x4a4a4a);
        [self.scrollView addSubview:myTagLabel];
        
        self.tipTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(myTagLabel.right+6 , 0, 150, TagTipHeight)];
        self.tipTagLabel.text = @"点击进入列表";
        self.tipTagLabel.font = [UIFont systemFontOfSize:13.5 ];
        self.tipTagLabel.textColor = RGBCOLORVALUE(0x6a6a6a);
        [self.scrollView addSubview:self.tipTagLabel];
        
        self.editBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30 -14 , 0, 30 , TagTipHeight)];
        [self.scrollView addSubview:self.editBtn];
        [self.editBtn setEnlargeEdgeWithTop:0 right:10 bottom:0 left:10];
        [self.editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.editBtn setTitle:@"完成" forState:UIControlStateSelected];
        [self.editBtn setTitleColor:RGBCOLORVALUE(0x3dcc79) forState:UIControlStateNormal];
        self.editBtn.titleLabel.font = [UIFont systemFontOfSize:14 ];
        

        for(NSInteger i = 0;i<self.param.upBtnDataArr.count;i++) {
            int row = i / 4;
            int column = i % 4;
            TagBtn *btn  = [[TagBtn alloc] initWithFrame:CGRectMake(SpaceLR + column * (TAGBtnW + TagSpaceH), TagTipHeight + row * (TAGBtnH + TagSpaceV), TAGBtnW, TAGBtnH)];
            btn.delegate = self;
            btn.model = self.param.upBtnDataArr[i];
            [btn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:btn];
            [self.upFranmeArr addObject:[NSValue valueWithCGRect:btn.frame]];
            [self.upBtnArr addObject:btn];
        }
        
        UILabel *recommendTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceLR, TagTipHeight + upBtnAllHeight, [@"为你推荐" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:[UIFont boldSystemFontOfSize:15 ]} context:nil].size.width+1, TagTipHeight)];
        self.recommendTagLabel = recommendTagLabel;
        recommendTagLabel.text = @"为你推荐";
        recommendTagLabel.font = [UIFont boldSystemFontOfSize:15 ];
        recommendTagLabel.textColor = RGBCOLORVALUE(0x4a4a4a);
        [self.scrollView addSubview:recommendTagLabel];
        
        
        UILabel *tipTagLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(recommendTagLabel.right+6 , recommendTagLabel.top, 300, TagTipHeight)];
        self.tipTagLabel2 = tipTagLabel2;
        tipTagLabel2.text = @"点击进入列表";
        tipTagLabel2.font = [UIFont systemFontOfSize:13.5 ];
        tipTagLabel2.textColor = RGBCOLORVALUE(0x6a6a6a);
        [self.scrollView addSubview:tipTagLabel2];
        
        for(NSInteger i = 0;i<self.param.belowBtnDataArr.count;i++) {
            int row = i / 4;
            int column = i % 4;
            TagBtn *btn  = [[TagBtn alloc] initWithFrame:CGRectMake(SpaceLR + column * (TAGBtnW + TagSpaceH), TagTipHeight + upBtnAllHeight + TagTipHeight + row * (TAGBtnH + TagSpaceV), TAGBtnW, TAGBtnH)];
            btn.delegate = self;
            btn.model = self.param.belowBtnDataArr[i];
            [btn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:btn];
            [self.belowFranmeArr addObject:[NSValue valueWithCGRect:btn.frame]];
            [self.belowBtnArr addObject:btn];
        }
        
        //添加拖拽手势
        self.isDragTableView = NO;
        self.lastDrapDistance = 0.0;
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self.container addGestureRecognizer:self.panGestureRecognizer];
        self.panGestureRecognizer.delegate = self;
        
    }
    return self;
}

- (void)closeBtnCLick {
    [self show:NO];
}

- (void)editBtnClick {
    self.isEdit = !self.isEdit;
    [self.tipTagLabel setText:self.isEdit ? @"按住拖拽可以排序" : @"点击进入列表"];
    self.editBtn.selected = self.isEdit;
    for(TagBtn *btn in self.upBtnArr) {
        btn.model.isEdit = self.isEdit;
    }
    for(TagBtn *btn in self.belowBtnArr) {
        btn.model.isEdit = self.isEdit;
    }
}

- (void)tagBtnClick:(TagBtn *)btn {
    if([self.upBtnArr containsObject:btn]) {
        [self clickUpBtn:btn];
    } else {
        [self clickBelowBtn:btn];
    }
}

//点击上btn
-(void)clickUpBtn:(TagBtn *)btn {
    if(!self.isEdit) {
        for(TagModel *model in self.param.upBtnDataArr) {
            model.isCurrentPage = NO;
        }
        btn.model.isCurrentPage = YES;
        [self show:NO];
        return;
    }
    TagModel *model = btn.model;
    if (model.isFix) {
        return;
    }
    model.isAlreadyTag = NO;
    [self.param.upBtnDataArr removeObject:btn.model];
    [self.upBtnArr removeObject:btn];
    [self.upFranmeArr removeObjectAtIndex:self.upFranmeArr.count-1];
    [self.param.belowBtnDataArr insertObject:btn.model atIndex:0];
    [self.belowBtnArr insertObject:btn atIndex:0];
    [UIView animateWithDuration:0.3 animations:^{
        [self.upBtnArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = self.upFranmeArr[idx].CGRectValue;
        }];
    }];
    [self.belowFranmeArr removeAllObjects];
    CGFloat upBtnAllHeight = (self.param.upBtnDataArr.count/4 + (self.param.upBtnDataArr.count%4 ? 1 : 0)) * TAGBtnH + ((self.param.upBtnDataArr.count/4 + (self.param.upBtnDataArr.count%4 ? 1 : 0))-1) * TagSpaceV;
    upBtnAllHeight = (upBtnAllHeight > 0 ? upBtnAllHeight : 0);
    [UIView animateWithDuration:0.3 animations:^{
        self.recommendTagLabel.frame = CGRectMake(SpaceLR, TagTipHeight + upBtnAllHeight, [@"为你推荐" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:[UIFont boldSystemFontOfSize:15 ]} context:nil].size.width+1, TagTipHeight);
        self.tipTagLabel2.frame = CGRectMake(self.recommendTagLabel.right+6 , self.recommendTagLabel.top, 300, TagTipHeight);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.belowBtnArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger i, BOOL * _Nonnull stop) {
            int row = i / 4;
            int column = i % 4;
            obj.frame = CGRectMake(SpaceLR + column * (TAGBtnW + TagSpaceH), TagTipHeight + upBtnAllHeight + TagTipHeight + row * (TAGBtnH + TagSpaceV), TAGBtnW, TAGBtnH);
            [self.belowFranmeArr addObject:[NSValue valueWithCGRect:obj.frame]];
        }];
    }];
}

//点击下Btn
-(void)clickBelowBtn:(TagBtn *)btn{
    TagModel *model = btn.model;
    model.isAlreadyTag = YES;
    [self.param.belowBtnDataArr removeObject:btn.model];
    [self.belowBtnArr removeObject:btn];
    [self.param.upBtnDataArr addObject:btn.model];
    [self.upBtnArr addObject:btn];
    
    int i = (int)self.upBtnArr.count-1;
    int row = i / 4;
    int column = i % 4;
    CGFloat upBtnAllHeight = (self.param.upBtnDataArr.count/4 + (self.param.upBtnDataArr.count%4 ? 1 : 0)) * TAGBtnH + ((self.param.upBtnDataArr.count/4 + (self.param.upBtnDataArr.count%4 ? 1 : 0))-1) * TagSpaceV;
    upBtnAllHeight = (upBtnAllHeight > 0 ? upBtnAllHeight : 0);
    [UIView animateWithDuration:0.3 animations:^{
        btn.frame =  CGRectMake(SpaceLR + column * (TAGBtnW + TagSpaceH), TagTipHeight + row * (TAGBtnH + TagSpaceV), TAGBtnW, TAGBtnH);
        [self.upFranmeArr addObject:[NSValue valueWithCGRect:btn.frame]];
        self.recommendTagLabel.frame = CGRectMake(SpaceLR, TagTipHeight + upBtnAllHeight, [@"为你推荐" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:[UIFont boldSystemFontOfSize:15 ]} context:nil].size.width+1, TagTipHeight);
        self.tipTagLabel2.frame = CGRectMake(self.recommendTagLabel.right+6 , self.recommendTagLabel.top, 300, TagTipHeight);
    }];
    [self.belowFranmeArr removeAllObjects];
    [UIView animateWithDuration:0.3 animations:^{
        [self.belowBtnArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            int row = idx / 4;
            int column = idx % 4;
            obj.frame = CGRectMake(SpaceLR + column * (TAGBtnW + TagSpaceH), TagTipHeight + upBtnAllHeight + TagTipHeight + row * (TAGBtnH + TagSpaceV), TAGBtnW, TAGBtnH);
            [self.belowFranmeArr addObject:[NSValue valueWithCGRect:obj.frame]];
        }];
    }];
}


- (void)show:(BOOL)show {
    if(show) {
        [[UIApplication sharedApplication].delegate.window addSubview:self];
        [UIView animateWithDuration:0.15f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            CGRect frame = self.container.frame;
            frame.origin.y = frame.origin.y - frame.size.height;
            self.container.frame = frame;
        }
                         completion:^(BOOL finished) {
        }];
    } else {
        [UIView animateWithDuration:0.15f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
            CGRect frame = self.container.frame;
            frame.origin.y = frame.origin.y + frame.size.height;
            self.container.frame = frame;
        }
                         completion:^(BOOL finished) {
            [self removeFromSuperview];
            NSInteger index = 0;
            for(NSInteger i =0;i<self.param.upBtnDataArr.count;i++) {
                TagModel *model = self.param.upBtnDataArr[i];
                if(model.isCurrentPage) {
                    index = i;
                    break;
                }
            }
            
            if(self.mgerBlock) {
                self.mgerBlock(self.param.upBtnDataArr, self.param.belowBtnDataArr, index);
            }
        }];
    }
}

#pragma mark - LongPressDelegate

static CGPoint locationInBtn;
- (void) handleLongPressGestures:(UILongPressGestureRecognizer *)paramSender {
    TagBtn *tagBtn = (TagBtn *)paramSender.view;
    if(!self.isEdit) {
        [self editBtnClick];
    }
    if([self.belowBtnArr containsObject:tagBtn]) {
        return;
    }
    if(tagBtn.model.isFix) {
        return;
    }
    static  CGRect viewFrame;
    if (paramSender.state == UIGestureRecognizerStateBegan){
        [self.scrollView insertSubview:tagBtn atIndex:self.scrollView.subviews.count-1];
        viewFrame = tagBtn.frame;
        
        tagBtn.frame = CGRectMake(tagBtn.left - tagBtn.width*(TAGBtnScaleLongPress-1)/2, tagBtn.top - tagBtn.height*(TAGBtnScaleLongPress-1)/2, tagBtn.width * TAGBtnScaleLongPress, tagBtn.height * TAGBtnScaleLongPress);
        locationInBtn = [paramSender locationInView:tagBtn];
    }
    if (paramSender.state == UIGestureRecognizerStateChanged) {
        CGPoint locationInSup = [paramSender locationInView:tagBtn.superview];
        tagBtn.center = CGPointMake(locationInSup.x + tagBtn.width/2 - locationInBtn.x, locationInSup.y + tagBtn.height/2 - locationInBtn.y) ;
        for (int i = 0; i < self.upBtnArr.count; i ++) {
            TagBtn *btn = self.upBtnArr[i];
            if (btn == tagBtn || btn.model.isFix)continue;
            if (CGRectContainsPoint(btn.frame,tagBtn.center)) {
                [self.param.upBtnDataArr removeObject:tagBtn.model];
                [self.upBtnArr removeObject:tagBtn];
                [self.param.upBtnDataArr insertObject:tagBtn.model atIndex:i];
                [self.upBtnArr insertObject:tagBtn atIndex:i];
                [UIView animateWithDuration:0.3 animations:^{
                    [self.upBtnArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj != tagBtn) {
                            obj.frame = [self.upFranmeArr[idx] CGRectValue];
                        }else{
                            viewFrame = [self.upFranmeArr[idx] CGRectValue];
                        }
                    }];
                }];
                break;
            }
        }
    }
    if (paramSender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.3 animations:^{
            tagBtn.frame = viewFrame;
        }];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(self.scrollView.contentOffset.y <= 0) {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
}

#pragma mark - UIGestureRecognizerDelegate
//1
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(gestureRecognizer == self.panGestureRecognizer) {
        if(self.isEdit) {
            return NO;
        }
        UIView *touchView = touch.view;
        while (touchView != nil) {
            if(touchView == self.scrollView) {
                self.isDragTableView = YES;
                break;
            } else if(touchView == self.container) {
                self.isDragTableView = NO;
                break;
            }
            touchView = [touchView nextResponder];
        }
        NSLog(@"shouldReceiveTouch");
    }
    return YES;
}

//2.
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if(gestureRecognizer == self.panGestureRecognizer){
        //如果是自己加的拖拽手势
        NSLog(@"gestureRecognizerShouldBegin");
    }
    return YES;
}

//3. 是否与其他手势共存，一般使用默认值(默认返回NO：不与任何手势共存)
- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    NSLog(@"shouldRecognizeSimultaneouslyWithGestureRecognizer :\n%@  \n%@  \n%@",self.panGestureRecognizer,gestureRecognizer,otherGestureRecognizer);
    if(gestureRecognizer == self.panGestureRecognizer) {
        if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] || [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIPanGestureRecognizer")] ) {
            if(otherGestureRecognizer.view == self.scrollView) {
                return YES;
            }
        }
    }
    return NO;
}

//拖拽手势
- (void)pan:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 获取手指的偏移量
    CGPoint transP = [panGestureRecognizer translationInView:self.container];
    NSLog(@"transP : %@",NSStringFromCGPoint(transP));
    CGPoint transP2 = [panGestureRecognizer translationInView:self.scrollView];
    NSLog(@"transP2 : %@",NSStringFromCGPoint(transP2));
    if(self.isDragTableView) {
        //如果当前拖拽的是tableView
        if(self.scrollView.contentOffset.y <= 0) {
            //如果tableView置于顶端
            if(transP.y > 0) {
                //如果向下拖拽
                self.scrollView.contentOffset = CGPointMake(0, 0 );
                self.scrollView.panGestureRecognizer.enabled = NO;
                self.scrollView.panGestureRecognizer.enabled = YES;
                self.isDragTableView = NO;
                //向下拖
                self.container.frame = CGRectMake(self.container.left, self.container.top + transP.y, self.container.width, self.container.height);
            } else {
                //如果向上拖拽
            }
        }
    } else {
        if(transP.y > 0) {
            //向下拖
            self.container.frame = CGRectMake(self.container.left, self.container.top + transP.y, self.container.width, self.container.height);
        } else if(transP.y < 0 && self.container.top > (SCREEN_HEIGHT - self.container.height)){
            //向上拖
            self.container.frame = CGRectMake(self.container.left, (self.container.top + transP.y) > (SCREEN_HEIGHT - self.container.height) ? (self.container.top + transP.y) : (SCREEN_HEIGHT - self.container.height), self.container.width, self.container.height);
        } else {
            
        }
    }
    
    [panGestureRecognizer setTranslation:CGPointZero inView:self.container];
    if(panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"transP : %@",NSStringFromCGPoint(transP));
        NSLog(@"transP2 : %@",NSStringFromCGPoint(transP2));
        if(self.lastDrapDistance > 10 && self.isDragTableView == NO) {
            //如果是类似轻扫的那种
            [self show:NO];
        } else {
            //如果是普通拖拽
            if(self.container.top >= SCREEN_HEIGHT - self.container.height/2) {
                [self show:NO];
            } else {
                [UIView animateWithDuration:0.15f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     self.container.top = SCREEN_HEIGHT - self.container.height;
                                 }
                                 completion:^(BOOL finished) {
                                     NSLog(@"结束");
                                 }];
                
            }
        }
    }
    self.lastDrapDistance = transP.y;
    
}


#pragma mark - LazyLoad

- (UIView *)topHeaderView {
    if(!_topHeaderView) {
        _topHeaderView = [[UIView alloc] init];
        UILabel *textLabel = [[UILabel alloc] init];
        [_topHeaderView addSubview:textLabel];
        textLabel.text = @"标签管理";
        textLabel.textColor = RGBCOLORVALUE(0x4a4a4a);
        textLabel.font = [UIFont boldSystemFontOfSize:18 ];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.with.offset(14 );
            make.bottom.with.offset(-10 );
        }];
        
        UIButton *closeBtn = [[UIButton alloc] init];
        [closeBtn setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
        [_topHeaderView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeBtnCLick) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"TAG_Mger_Close"] forState:UIControlStateNormal];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.with.offset(-20 );
            make.width.height.mas_equalTo(22 );
            make.centerY.equalTo(textLabel);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        [_topHeaderView addSubview:lineView];
        lineView.hidden = YES;
        lineView.backgroundColor = RGBA(248, 247, 248,1);
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.with.offset(0);
            make.height.mas_equalTo(0.5);
        }];
        @weakify(self);
        [RACObserve(self, scrollView.contentOffset) subscribeNext:^(id x) {
            lineView.hidden = self.scrollView.contentOffset.y > 0 ? NO : YES;
            
        }];
    }
    return _topHeaderView;
}

- (void)dealloc {
    NSLog(@"销毁了");
}

@end
