
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
typedef void (^TC_VP_EditTagBlock)();

@interface TCPageParam : NSObject

//滑动是否动画
@property (nonatomic, assign) BOOL animateScroll;

//当前选择的菜单索引
@property (nonatomic, assign) NSInteger selectIndex;
//是否允许编辑标签列表
@property (nonatomic, assign) NSInteger canEdit;
//选中按钮下方横线背景颜色 默认为 blackColor
@property (nonatomic, strong) UIColor *tabSelectedBottomLineColor;
//选中按钮是否显示底部横线  默认NO
@property (nonatomic, assign) BOOL showSelectedBottomLine;
//选中按钮底部横线与按钮的宽度比例 //默认为1.0
@property (nonatomic, assign) CGFloat selectedBottomLineScale;


//菜单标题scrollView下方横线颜色
@property (nonatomic, strong) UIColor *pageHeaderControlBottomLineColor;
//菜单标题scrollView下方横线宽度
@property (nonatomic, assign) CGFloat pageHeaderControlBottomLineWidth;
//菜单标题scrollView下方横线高度
@property (nonatomic, assign) CGFloat pageHeaderControlBottomLineHeight;


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
//顶部pageHeaderControl滚动条是否置于scrollView顶上 //默认是YES
@property (nonatomic, assign) BOOL pageHeaderControlStayInTop;
//如果pageHeaderControl滚动条不是置于scrollView顶上,那么top与上方的距离
@property (nonatomic, assign) CGFloat pageHeaderControlStaySpaceWithTop;

//顶部pageHeaderControl底下的渐变层 //默认为YES
@property (nonatomic, assign)BOOL showBottomGradientLayer ;
//顶部pageHeaderControl底下的渐变层颜色 //默认@[MYRGBACOLOR(239,242,241,1), MYRGBACOLOR(239,242,241,0.0)];
@property (nonatomic, strong) NSArray *bottomGradientColorArr;
//顶部pageHeaderControl底下的渐变层大小 //默认6
@property (nonatomic, assign) CGFloat bottomGradientH;

//菜单的文本label
@property (nonatomic, strong) NSMutableArray *titleArray;
//菜单标题数组长度
@property (nonatomic, strong) NSArray *titleArrayLength;

//背景颜色
@property (nonatomic, strong) UIColor *viewPagerBgColor;

@end





@interface TCViewPager : UIView<UIScrollViewDelegate>


//视图
@property (nonatomic, strong, readonly) NSArray *views;
@property (nonatomic, assign, readonly) NSInteger currentIndex;
/**
 *  当前选择的控制器
 */
@property (nonatomic, strong) UIViewController *selectController;

/**
 *  点击菜单按钮时 调用的block方法
 *
 *  @param block 返回YFViewPager本身和点击的按钮的索引值,从左到右一次是0,1,2,3...
 */
- (void)didSelectedBlock:(TC_VP_SelectedBlock)block;
- (void)editTagBtnClickBlock:(TC_VP_EditTagBlock)block;
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


- (void)changeSelectedIndex:(NSInteger)selectIndex;

//修改某一个标题的名字
- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSInteger)index;



@end
