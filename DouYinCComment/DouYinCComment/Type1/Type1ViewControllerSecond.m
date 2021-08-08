//
//  Type1ViewControllerSecond.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/5.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "Type1ViewControllerSecond.h"
#import "BaseTableViewController.h"
#import "BaseCollectionViewController.h"
#import "BaseWebViewController.h"
#import "BaseViewController.h"
#import "BaseScrollViewController.h"
#import "TCViewPager.h"

@interface Type1ViewControllerSecond ()


@end

@implementation Type1ViewControllerSecond

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
    
    //分页配置
    TCPageParam *pageParam = [self createPageParamWithTitleArr:arry_seg_title];
    //分页列表
    TCViewPager *viewPager = [[TCViewPager alloc] initWithFrame:CGRectMake(0, kDevice_Is_iPhoneX ? 88 : 64, SCREEN_WIDTH, SCREEN_HEIGHT - (kDevice_Is_iPhoneX ? 88 : 64)) views:vcArray param:pageParam];
    [self.view addSubview:viewPager];
}

- (TCPageParam *)createPageParamWithTitleArr:(NSMutableArray *)arry_seg_title {
    TCPageParam *pageParam = [[TCPageParam alloc] init];
    pageParam.titleArray = arry_seg_title;
    //当前选择的菜单索引
    pageParam.selectIndex = 1;
    //选中按钮下方横线背景颜色
    pageParam.tabSelectedBottomLineColor = [UIColor redColor];
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
    return pageParam;;
}

@end
