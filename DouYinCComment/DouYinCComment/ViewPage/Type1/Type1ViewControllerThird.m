//
//  Type1ViewControllerThird.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/5.
//  Copyright © 2020 唐天成. All rights reserved.
//  不建议这种写法,列表为View的话,你就得自己再去写一个方法(比如demo里的didAppeared方法)来实现展示的时候才添加subView和加载数据

#import "Type1ViewControllerThird.h"
#import "BaseTableViewController.h"
#import "BaseCollectionViewController.h"
#import "BaseWebViewController.h"
#import "BaseViewController.h"
#import "BaseScrollViewController.h"
#import "TCViewPager.h"

@interface Type1ViewControllerThird ()

@property (nonatomic, strong) TCViewPager *viewPager;

@end

@implementation Type1ViewControllerThird

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    BaseTableView *v1 = [[BaseTableView alloc] init];
    BaseCollectionView *v2 = [[BaseCollectionView alloc] init];
    BaseWebView *v3 = [[BaseWebView alloc] init];
    BaseScrollView *v4 = [[BaseScrollView alloc] init];
    v4.backgroundColor = [UIColor greenColor];
    UIView *v5 = [[UIView alloc] init];
    v5.backgroundColor = [UIColor greenColor];
    UIView *v6 = [[UIView alloc] init];
    v6.backgroundColor = [UIColor greenColor];
    UIView *v7 = [[UIView alloc] init];
    v7.backgroundColor = [UIColor greenColor];
    UIView *v8 = [[UIView alloc] init];
    v8.backgroundColor = [UIColor greenColor];
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:@[v1,v2,v3,v4,v5,v6,v7,v8]];
    NSMutableArray *arry_seg_title = [NSMutableArray arrayWithArray:@[@"tableView",@"collectionView",@"webView",@"ScrollView",@"标题5",@"标题6",@"标题7",@"标题8"]];
    
    //分页配置
    TCPageParam *pageParam = [self createPageParamWithTitleArr:arry_seg_title];
    //分页列表
    TCViewPager *viewPager = [[TCViewPager alloc] initWithFrame:CGRectMake(0, kDevice_Is_iPhoneX ? 88 : 64, SCREEN_WIDTH, SCREEN_HEIGHT - (kDevice_Is_iPhoneX ? 88 : 64)) views:vcArray param:pageParam];
    
    @weakify(self);
    [viewPager didSelectedBlock:^(TCViewPager *viewPager, NSInteger currentIndex,NSInteger previousIndex, BOOL isClickBtn) {
        @strongify(self);
        id view = viewPager.views[currentIndex];
        if([view isKindOfClass:[BaseTableView class]]) {
            [((BaseTableView *)view) didAppeared];
        } else if([view isKindOfClass:[BaseCollectionView class]]) {
            [((BaseCollectionView *)view) didAppeared];
        } else if([view isKindOfClass:[BaseWebView class]]) {
            [((BaseWebView *)view) didAppeared];
        } else if([view isKindOfClass:[BaseScrollView class]]) {
            [((BaseScrollView *)view) didAppeared];
        }
    }];
    [self.view addSubview:viewPager];
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
