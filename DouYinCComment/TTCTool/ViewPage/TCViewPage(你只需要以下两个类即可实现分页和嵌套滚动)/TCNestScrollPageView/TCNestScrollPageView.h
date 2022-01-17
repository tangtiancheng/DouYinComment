//
//  ENestScrollPageView.h
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2020/6/9.
//  Copyright © 2020 duoduo. All rights reserved.
// 这个类是做嵌套滚动用的

#import <UIKit/UIKit.h>
#import "TCViewPager.h"

NS_ASSUME_NONNULL_BEGIN

//支持三种类型
typedef NS_ENUM(NSInteger, NestScrollPageViewType) {
    NestScrollPageViewHeadViewChageType = 0,//header随时变动
    NestScrollPageViewHeadViewSuckTopType = 1,//header吸顶不动
    NestScrollPageViewHeadViewNoSuckTopType = 2,//header不吸顶,可以一块往下拖
};



@interface TCNestScrollParam : NSObject

@property (nonatomic, assign) CGFloat yOffset;//往上滚动时头部的预留预期,默认为0;
@property (nonatomic, assign) NestScrollPageViewType pageType;
@property (nonatomic, assign) BOOL bounces;//是否保留TCMainScrollView的bounces,默认为YES

@end




/********************** 多个拖拽手势同时识别 ***************************/
@interface TCMainScrollView : UIScrollView

@property (nonatomic, assign) BOOL isScrolBySelf;
@property (nonatomic, weak) UIScrollView *currentSubScrolleView;
@property(nonatomic,strong)NSMutableArray *viewArray;     //自己和viewArray上的首饰

@end



@interface TCNestScrollPageView : UIView

@property (nonatomic, strong, readonly) TCMainScrollView *mainScrollView;
@property(nonatomic,copy)void(^didScrollBlock)(CGFloat dy);         //滚动回调

- (void)resetHeader:(UIView *)headerView;
- (void)resetViewPage:(UIView *)viewPage;
- (instancetype)initWithFrame:(CGRect)frame headView:(UIView *)headView viewPageView:(UIView *)viewPager nestScrollParam:(TCNestScrollParam *)param;

@property (nonatomic, strong, readonly) TCNestScrollParam *param;


//这个是给header滚动延续的时候用的
- (void)setObserveScrollView:(UIScrollView *)scrollView;

@end



NS_ASSUME_NONNULL_END
