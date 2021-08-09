//
//  Type2ViewControllerSecond.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/6.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "Type2ViewControllerSecond.h"
#import "TCNestScrollPageView.h"
#import "BaseTableViewController.h"
#import "BaseCollectionViewController.h"
#import "BaseWebViewController.h"
#import "BaseScrollViewController.h"
#import "BaseViewController.h"
#import "TTCCom.h"
#import "ReactiveObjC.h"
@interface Type2ViewControllerSecond ()

@end

@implementation Type2ViewControllerSecond

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

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
    
    
    //分别创建 处理分页的  |  嵌套滚动的View  |  header头
    //1.创建TCViewPage处理分页(有些开发者可能之前已经写过分页的控件,只不过是没有实现嵌套滚动功能,那么你完全可以不需要用我的TCViewPager,你继续创建你项目里之前的分页控件,然后最后把你的分页控件传给TCNestScrollPageView就可以了)
    TCPageParam *pageParam = [[TCPageParam alloc] init];
    pageParam.titleArray = arry_seg_title;
    TCViewPager *viewPager = [[TCViewPager alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (kDevice_Is_iPhoneX ? 44 : 20)) views:vcArray param:pageParam];
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
   
    //2.创建你自己界面需要展示的嵌套headser
    UIView *headerView = [self getHeader];
    
    //3.创建TCNestScrollPageView处理嵌套滚动
    TCNestScrollParam *nestScrollParam = [[TCNestScrollParam alloc] init];
    nestScrollParam.pageType = NestScrollPageViewHeadViewChageType;
    TCNestScrollPageView *scrollPageView = [[TCNestScrollPageView alloc] initWithFrame:CGRectMake(0, (kDevice_Is_iPhoneX ? 44 : 20), SCREEN_WIDTH, SCREEN_HEIGHT - (kDevice_Is_iPhoneX ? 44 : 20)) headView:headerView viewPageView:viewPager nestScrollParam:nestScrollParam];
    [self.view addSubview:scrollPageView];
    
}

//创建header
- (UIView *)getHeader {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    UISearchTextField *searchTextField = [[UISearchTextField alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH-100, 50)];
    [headerView addSubview:searchTextField];
    UIButton *back = [[UIButton alloc] init];
    back.frame = CGRectMake(0, 0, 50, 50);
    [back setImage:[UIImage imageNamed:@"button_back"] forState:UIControlStateNormal];
    back.tintColor = [UIColor whiteColor];
    [headerView addSubview:back];
    [back addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    return headerView;
}

//返回
- (void)backClick{
    [self.navigationController popViewControllerAnimated:true];
}

@end
