//
//  Type4ViewControllerThird.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/6.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "Type4ViewControllerThird.h"
#import "TCNestScrollPageView.h"
#import "BaseTableViewController.h"
#import "BaseCollectionViewController.h"
#import "BaseWebViewController.h"
#import "BaseScrollViewController.h"
#import "BaseViewController.h"
#import "MyHeaderView.h"
#import "TTCCom.h"
#import "ReactiveObjC.h"
#define imageScale (18.0/11)
#define headerHeight (floor(SCREEN_WIDTH/imageScale))
#define naviHederH (kDevice_Is_iPhoneX ? 88 : 64)
#define nestScrollPageYOffset  naviHederH

@interface Type4ViewControllerThird ()

@property (nonatomic, strong) UIView *titleHeaderView;
@property (nonatomic, strong) MyHeaderView *nestPageScrollHeaderView;

@end

@implementation Type4ViewControllerThird

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    TCViewPager *viewPager = [[TCViewPager alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - naviHederH) views:vcArray param:pageParam];
   
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
