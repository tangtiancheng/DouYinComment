//
//  Type2ViewControllerFirst.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/5.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "Type2ViewControllerFirst.h"
#import "TCNestScrollPageView.h"
#import "BaseTableViewController.h"
#import "BaseCollectionViewController.h"
#import "BaseWebViewController.h"
#import "BaseScrollViewController.h"
#import "BaseViewController.h"

@interface Type2ViewControllerFirst ()

@end

@implementation Type2ViewControllerFirst

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false animated:animated];
}

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
    NSMutableArray *arry_seg_title = [NSMutableArray arrayWithArray:@[@"标题1",@"标题2",@"标题3",@"标题4",@"标题5",@"标题6",@"标题7",@"标题8"]];
    
    
    
    //分别创建 处理分页的  |  嵌套滚动的View  |  header头
    //1.创建TCViewPage处理分页(有些开发者可能之前已经写过分页的控件,只不过是没有实现嵌套滚动功能,那么你完全可以不需要用我的TCViewPager,你继续创建你项目里之前的分页控件,然后最后把你的分页控件传给TCNestScrollPageView就可以了)
    TCPageParam *pageParam = [[TCPageParam alloc] init];
    pageParam.titleArray = arry_seg_title;
    TCViewPager *viewPager = [[TCViewPager alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (kDevice_Is_iPhoneX ? 44 : 20)) views:vcArray param:pageParam];
   
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
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH-100, 50)];
    [headerView addSubview:searchBar];
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
