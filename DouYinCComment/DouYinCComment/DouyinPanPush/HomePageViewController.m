//
//  HomePageViewController.m
//  DouYinCComment
//
//  Created by 唐天成 on 2023/6/11.
//  Copyright © 2023 唐天成. All rights reserved.
//

#import "HomePageViewController.h"
#import "BaseTableViewController.h"
#import "BaseCollectionViewController.h"
#import "BaseWebViewController.h"
#import "BaseViewController.h"
#import "BaseScrollViewController.h"
#import "TCViewPager.h"
#import "TTCCom.h"
#import "PanPushSmallVideoPlayViewController.h"

#define NavigationBarHeight 44
//电磁条高度
#define StatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height ? [[UIApplication sharedApplication] statusBarFrame].size.height : ([UIApplication sharedApplication].delegate.window.safeAreaInsets.top ? [UIApplication sharedApplication].delegate.window.safeAreaInsets.top : 20 ))
//导航条的高度
#define NavigationHeight (StatusBarHeight+NavigationBarHeight)

@interface HomePageViewController ()


@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BaseViewController*vc1 = [[BaseViewController alloc] init];
    vc1.view.backgroundColor = [UIColor purpleColor];
    
    BaseViewController *vc2 = [[BaseViewController alloc] init];
    vc2.view.backgroundColor = [UIColor blueColor];
    
    BaseViewController *vc3 = [[BaseViewController alloc] init];
    vc3.view.backgroundColor = [UIColor greenColor];
    
    BaseViewController *vc4 = [[BaseViewController alloc] init];
    vc4.view.backgroundColor = [UIColor yellowColor];
    
    PanPushSmallVideoPlayViewController *smallVideoPlayViewController = [[PanPushSmallVideoPlayViewController alloc] init];
    
   
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:@[vc1,vc2,vc3,vc4,smallVideoPlayViewController]];
    NSMutableArray *arry_seg_title = [NSMutableArray arrayWithArray:@[@"关注",@"热点",@"商城",@"经验",@"推荐"]];
    
    //分页配置
    TCPageParam *pageParam = [self createPageParamWithTitleArr:arry_seg_title];
    //分页列表
    TCViewPager *viewPager = [[TCViewPager alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.tabBarController.tabBar.frame.size.height) views:vcArray param:pageParam];
    [self.view addSubview:viewPager];
    
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.backgroundColor = [UIColor redColor];
    backBtn.frame = CGRectMake(0, kDevice_Is_iPhoneX ? 44 : 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backBtn.tintColor = [UIColor whiteColor];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    
   


}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    self.navigationController.navigationBar.hidden = NO;

}


- (TCPageParam *)createPageParamWithTitleArr:(NSMutableArray *)arry_seg_title {
    TCPageParam *pageParam = [[TCPageParam alloc] init];
    pageParam.titleArray = arry_seg_title;
    //当前选择的菜单索引
    pageParam.selectIndex = 4;
    //选中按钮下方横线背景颜色
    pageParam.tabSelectedBottomLineColor = [UIColor whiteColor];
    //选中按钮是否显示底部横线
    pageParam.showSelectedBottomLine = YES;
    //选中按钮底部横线与按钮的宽度比例
    pageParam.selectedBottomLineScale = 1.0;
    //菜单按钮的标题未选中颜色
    pageParam.tabTitleColor = RGBA(255, 255, 255, 0.5);
    //菜单按钮的标题选中颜色
    pageParam.tabSelectedTitleColor = RGBA(255, 255, 255, 1);
    //菜单按钮之前的间距
    pageParam.titlePageSpace = 30;
    //菜单按钮选中后与未选中前的比例
    pageParam.selectedLabelBigScale = 1.0;
    //菜单按钮的标题Font
    pageParam.labelFont = [UIFont systemFontOfSize:16];
    //顶部pageHeaderControl滚动条高度
    pageParam.pageHeaderHeight = NavigationBarHeight;
    //顶部pageHeaderControl滚动条最左边按钮距离左边的间距 最右边按钮距离右边的间距
    pageParam.leftAndRightSpace = 50;
    pageParam.viewPagerBgColor = [UIColor clearColor];
    pageParam.showBottomGradientLayer = NO;
    pageParam.pageHeaderControlStayInTop = NO;
    pageParam.pageHeaderControlStaySpaceWithTop = StatusBarHeight;
    return pageParam;;
}

//返回
- (void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
