//
//  Type4ViewControllerFourth.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/6.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "Type4ViewControllerFourth.h"
#import "TCNestScrollPageView.h"
#import "BaseTableViewController2.h"
#import "BaseCollectionViewController.h"
#import "BaseWebViewController.h"
#import "BaseScrollViewController.h"
#import "BaseViewController.h"
#import "MyHeaderView.h"

#define imageScale (18.0/11)
#define headerHeight (floor(SCREEN_WIDTH/imageScale))
#define naviHederH (kDevice_Is_iPhoneX ? 88 : 64)
#define nestScrollPageYOffset  naviHederH

@interface Type4ViewControllerFourth ()

@property (nonatomic, strong) UIView *titleHeaderView;
@property (nonatomic, strong) MyHeaderView *nestPageScrollHeaderView;

@end

@implementation Type4ViewControllerFourth

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false animated:animated];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    BaseTableViewController2*vc1 = [[BaseTableViewController2 alloc] init];
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:@[vc1]];
    NSMutableArray *arry_seg_title = [NSMutableArray arrayWithArray:@[@"标题1"]];
    
    //分别创建 处理分页的  |  嵌套滚动的View  |  header头
    //1.创建TCViewPage处理分页(有些开发者可能之前已经写过分页的控件,只不过是没有实现嵌套滚动功能,那么你完全可以不需要用我的TCViewPager,你继续创建你项目里之前的分页控件,然后最后把你的分页控件传给TCNestScrollPageView就可以了)
    TCPageParam *pageParam = [[TCPageParam alloc] init];
    pageParam.titleArray = arry_seg_title;
    pageParam.pageHeaderHeight = 0;
    pageParam.showBottomGradientLayer = NO;
    TCViewPager *viewPager = [[TCViewPager alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) views:vcArray param:pageParam];
   
    //2.创建你自己界面需要展示的嵌套headser
    self.nestPageScrollHeaderView = [self getHeader];
   
    //3.创建TCNestScrollPageView处理嵌套滚动
    TCNestScrollParam *nestScrollParam = [[TCNestScrollParam alloc] init];
    nestScrollParam.pageType = NestScrollPageViewHeadViewNoSuckTopType;
    nestScrollParam.yOffset = nestScrollPageYOffset;
    TCNestScrollPageView *scrollPageView = [[TCNestScrollPageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) headView:self.nestPageScrollHeaderView viewPageView:viewPager nestScrollParam:nestScrollParam];
    [self.view addSubview:scrollPageView];
    @weakify(self);
    scrollPageView.didScrollBlock = ^(CGFloat dy) {
        @strongify(self);
        //滚动过程中你需要的界面UI变化
        [self nestScrollPageViewDidScroll:dy];
    };
    
    [self createtitleHeaderView];
}

//创建header
- (MyHeaderView *)getHeader {
    MyHeaderView *headerView = [[MyHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerHeight)];
    return headerView;
}

- (void)createtitleHeaderView {
    UIView *titleHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, naviHederH)];
    self.titleHeaderView = titleHeaderView;
    titleHeaderView.alpha = 0.0;
    [self.view addSubview:titleHeaderView];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerImage"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = titleHeaderView.bounds;
    imageView.clipsToBounds = YES;
    [titleHeaderView addSubview:imageView];

    //设置UIVisualEffectView
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualView.backgroundColor = RGBA(0, 0, 0, 0.3);
    visualView.frame = imageView.bounds;
    [imageView addSubview:visualView];
   
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.frame = CGRectMake(0, kDevice_Is_iPhoneX ? 44 : 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backBtn.tintColor = [UIColor whiteColor];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)nestScrollPageViewDidScroll:(CGFloat)dy {
    NSLog(@"%lf  %lf",dy,headerHeight - nestScrollPageYOffset);
    if(dy >= headerHeight - nestScrollPageYOffset) {
        self.titleHeaderView.alpha = 1;
    } else {
        self.titleHeaderView.alpha = dy / (headerHeight - nestScrollPageYOffset);
    }
    if(dy<0) {
        self.nestPageScrollHeaderView.imageView.frame = CGRectMake(0, dy, SCREEN_WIDTH, headerHeight-dy);
    } else {
        self.nestPageScrollHeaderView.imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, headerHeight);
    }
    
}

//返回
- (void)backClick{
    [self.navigationController popViewControllerAnimated:true];
}

@end
