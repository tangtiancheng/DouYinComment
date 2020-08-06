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


typedef NS_ENUM(NSInteger, NestScrollPageViewType) {
    NestScrollPageViewHeadViewChageType = 0,//header随时变动
    NestScrollPageViewHeadViewSuckTopType = 1,//header吸顶不动
    NestScrollPageViewHeadViewNoSuckTopType = 2,//header不吸顶,可以一块往下拖
};

/********************** 多手势同时识别 ***************************/
@interface TCMainScrollView : UITableView

@property (nonatomic, assign) BOOL isScrolBySelf;
@property (nonatomic, weak) UIScrollView *currentSubScrolleView;

@property(nonatomic,strong)NSMutableArray *viewArray;     //自己和viewArray上的首饰

@end

@interface TCNestScrollParam : NSObject

@property (nonatomic, assign) CGFloat yOffset;//往上滚动时头部的预留预期,默认为0;
@property (nonatomic, assign) NestScrollPageViewType pageType;
@property (nonatomic, assign) BOOL bounces;//是否保留TCMainScrollView的bounces,默认为YES

@end


@interface TCNestScrollPageView : UIView

@property (nonatomic, strong, readonly) TCMainScrollView *mainTabelView;
@property(nonatomic,copy)void(^didScrollBlock)(CGFloat dy);         //滚动回调

- (void)resetHeader:(UIView *)headerView;
- (instancetype)initWithFrame:(CGRect)frame headView:(UIView *)headView viewPageView:(UIView *)viewPager nestScrollParam:(TCNestScrollParam *)param;

@end



NS_ASSUME_NONNULL_END
