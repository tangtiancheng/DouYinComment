


//
//  TCViewPager.h
//
//  Created by 唐天成 on 16/8/28.
//  Copyright © 2016年 唐天成. All rights reserved.
//  这个类是做简单分页用的
//
#import <UIKit/UIKit.h>
@class TCViewPager;

typedef void (^TC_VP_SelectedBlock)(TCViewPager *viewPager, NSInteger currentIndex, NSInteger previousIndex, BOOL isClickBtn);


@interface TCPageParam : NSObject

//当前选择的菜单索引
@property (nonatomic, assign) NSInteger selectIndex;

//选中按钮下方横线背景颜色 默认为 blackColor
@property (nonatomic, strong) UIColor *tabSelectedArrowBgColor;
//选中按钮是否显示底部横线  默认NO
@property (nonatomic, assign) BOOL showSelectedBottomLine;
//选中按钮底部横线与按钮的宽度比例 //默认为1.0
@property (nonatomic, assign) CGFloat selectedBottomLineScale;

//菜单按钮的标题未选中颜色 //默认 blackColor
@property (nonatomic, strong) UIColor *tabTitleColor;
//菜单按钮的标题选中颜色 //默认 redColor
@property (nonatomic, strong) UIColor *tabSelectedTitleColor;
//菜单按钮之前的间距
@property (nonatomic, assign) CGFloat titlePageSpace;
//菜单按钮选中后与未选中前的比例 默认为1.0
@property (nonatomic, assign) CGFloat selectedLabelBigScale;
//菜单按钮的标题Font //默认为[UIFont systemFontOfSize:15];
@property (nonatomic, strong) UIFont *labelFont;
//顶部pageHeaderControl滚动条高度 //默认40
@property (nonatomic, assign)CGFloat pageHeaderHeight;
//顶部pageHeaderControl滚动条最左边按钮距离左边的间距 最右边按钮距离右边的间距
@property (nonatomic, assign)CGFloat leftAndRightSpace;

//菜单的文本label
@property (nonatomic, strong) NSMutableArray *titleArray;

@end


@interface TCViewPager : UIView<UIScrollViewDelegate>


//视图
@property (nonatomic, strong, readonly)  NSArray *views;
/**
 *  点击菜单按钮时 调用的block方法
 *
 *  @param block 返回YFViewPager本身和点击的按钮的索引值,从左到右一次是0,1,2,3...
 */
- (void)didSelectedBlock:(TC_VP_SelectedBlock)block;

/**
 *  初始化 TCViewPager的方法
 *
 *  @param frame  frame
 *  @param views  视图数组 可以是view，也可以是Viewcontroler,也可以混合有些传view有些传ViewController(我喜欢全用ViewController) 和标题数组一一对应
 *  @param param  配置param  这个如果设置为nil的话,那么就按照默认的配置来运行
 *  @return TCViewPager
 */
- (id)initWithFrame:(CGRect)frame
              views:(NSArray *)views
              param:(TCPageParam *)param;


@end





