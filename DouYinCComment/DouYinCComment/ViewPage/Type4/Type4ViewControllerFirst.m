//
//  Type4ViewControllerFirst.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/6.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "Type4ViewControllerFirst.h"
#import "TCNestScrollPageView.h"
#import "BaseTableViewController.h"
#import "BaseCollectionViewController.h"
#import "BaseWebViewController.h"
#import "BaseScrollViewController.h"
#import "BaseViewController.h"
#import "MyHeaderView.h"

#define imageScale (18.0/11)
#define headerHeight (floor(SCREEN_WIDTH/imageScale))
#define naviHederH (kDevice_Is_iPhoneX ? 88 : 64)
#define nestScrollPageYOffset  0

@interface Type4ViewControllerFirst ()

@end

@implementation Type4ViewControllerFirst

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    BaseTableViewController*vc1 = [[BaseTableViewController alloc] init];
    BaseCollectionViewController *vc2 = [[BaseCollectionViewController alloc] init];
    BaseWebViewController *vc3 = [[BaseWebViewController alloc] init];
    BaseScrollViewController *vc4 = [[BaseScrollViewController alloc] init];
    BaseViewController *vc5 = [[BaseViewController alloc] init];
    BaseViewController *vc6 = [[BaseViewController alloc] init];
    BaseViewController *vc7 = [[BaseViewController alloc] init];
    BaseViewController *vc8 = [[BaseViewController alloc] init];
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:@[vc1,vc2,vc3,vc4,vc5,vc6,vc7,vc8]];
    NSMutableArray *arry_seg_title = [NSMutableArray arrayWithArray:@[@"tableView",@"collectionView",@"webView",@"ScrollView",@"标题5",@"标题6",@"标题7",@"标题8"]];
    
    
    
    //分别创建 处理分页的  |  嵌套滚动的View  |  header头
    //1.创建TCViewPage处理分页(有些开发者可能之前已经写过分页的控件,只不过是没有实现嵌套滚动功能,那么你完全可以不需要用我的TCViewPager,你继续创建你项目里之前的分页控件,然后最后把你的分页控件传给TCNestScrollPageView就可以了)
    TCPageParam *pageParam = [self createPageParamWithTitleArr:arry_seg_title];
    TCViewPager *viewPager = [[TCViewPager alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - naviHederH) views:vcArray param:pageParam];
   
    //2.创建你自己界面需要展示的嵌套headser
    MyHeaderView *nestPageScrollHeaderView = [self getHeader];
   
    //3.创建TCNestScrollPageView处理嵌套滚动
    TCNestScrollParam *nestScrollParam = [[TCNestScrollParam alloc] init];
    nestScrollParam.pageType = NestScrollPageViewHeadViewNoSuckTopType;
    nestScrollParam.bounces = NO;
    TCNestScrollPageView *scrollPageView = [[TCNestScrollPageView alloc] initWithFrame:CGRectMake(0, naviHederH, SCREEN_WIDTH, SCREEN_HEIGHT - naviHederH) headView:nestPageScrollHeaderView viewPageView:viewPager nestScrollParam:nestScrollParam];
    [self.view addSubview:scrollPageView];
   
  
}

//创建header
- (MyHeaderView *)getHeader {
    MyHeaderView *headerView = [[MyHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerHeight)];
    return headerView;
}

- (TCPageParam *)createPageParamWithTitleArr:(NSMutableArray *)arry_seg_title {
    TCPageParam *pageParam = [[TCPageParam alloc] init];
    pageParam.titleArray = arry_seg_title;
    //当前选择的菜单索引
    pageParam.selectIndex = 1;
    //选中按钮下方横线背景颜色
    pageParam.tabSelectedArrowBgColor = [UIColor redColor];
    //选中按钮是否显示底部横线
    pageParam.showSelectedBottomLine = YES;
    //选中按钮底部横线与按钮的宽度比例
    pageParam.selectedBottomLineScale = 1.3;
    //菜单按钮的标题未选中颜色
    pageParam.tabTitleColor = [UIColor blackColor];
    //菜单按钮的标题选中颜色
    pageParam.tabSelectedTitleColor = [UIColor greenColor];
    //菜单按钮之前的间距
    pageParam.titlePageSpace = 40;
    //菜单按钮选中后与未选中前的比例
    pageParam.selectedLabelBigScale = 1.3;
    //菜单按钮的标题Font
    pageParam.labelFont = [UIFont systemFontOfSize:20];
    //顶部pageHeaderControl滚动条高度
    pageParam.pageHeaderHeight = 60;
    //顶部pageHeaderControl滚动条最左边按钮距离左边的间距 最右边按钮距离右边的间距
    pageParam.leftAndRightSpace = 20;
    return pageParam;
}

@end
