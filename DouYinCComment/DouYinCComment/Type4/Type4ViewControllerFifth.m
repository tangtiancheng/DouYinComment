//
//  Type4ViewControllerFifth.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/25.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "Type4ViewControllerFifth.h"
#import "TCNestScrollPageView.h"
#import "BaseTableViewController.h"
#import "BaseCollectionViewController.h"
#import "BaseWebViewController.h"
#import "BaseScrollViewController.h"
#import "BaseViewController.h"
#import "MyHeaderView.h"
#import "ZJScrollPageView.h"
#import "ZJPageTableViewController.h"
#import "TTCCom.h"
#import "ReactiveObjC.h"
#define imageScale (18.0/11)
#define headerHeight (floor(SCREEN_WIDTH/imageScale))
#define naviHederH (kDevice_Is_iPhoneX ? 88 : 64)
#define nestScrollPageYOffset  naviHederH


@interface Type4ViewControllerFifth ()<ZJScrollPageViewDelegate>

@property (nonatomic, strong) UIView *titleHeaderView;
@property (nonatomic, strong) MyHeaderView *nestPageScrollHeaderView;
@property(strong, nonatomic)NSArray<NSString *> *titles;


@end

@implementation Type4ViewControllerFifth

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    // 缩放标题
    style.scaleTitle = YES;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    // 设置附加按钮的背景图片
    
    self.titles = @[@"新闻头条",
                    @"国际要闻",
                    @"体育",
                    @"中国足球",
                    @"汽车",
                    @"囧途旅游",
                    @"幽默搞笑",
                    @"视频",
                    @"无厘头",
                    @"美女图片",
                    @"今日房价",
                    @"头像",
    ];
    // 初始化
    ZJScrollPageView *pageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - naviHederH) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    
    
   
    //2.创建你自己界面需要展示的嵌套headser
    self.nestPageScrollHeaderView = [self getHeader];
   
    //3.创建TCNestScrollPageView处理嵌套滚动
    TCNestScrollParam *nestScrollParam = [[TCNestScrollParam alloc] init];
    nestScrollParam.pageType = NestScrollPageViewHeadViewNoSuckTopType;
    nestScrollParam.yOffset = nestScrollPageYOffset;
    TCNestScrollPageView *scrollPageView = [[TCNestScrollPageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) headView:self.nestPageScrollHeaderView viewPageView:pageView nestScrollParam:nestScrollParam];
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


#pragma ZJScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
//    NSLog(@"%ld---------", index);

    if (!childVc) {
        childVc = [[ZJPageTableViewController alloc] init];
        childVc.title = self.titles[index];
    }
    
    return childVc;
}


- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    NSLog(@"%ld ---将要出现",index);
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    NSLog(@"%ld ---已经出现",index);
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    NSLog(@"%ld ---将要消失",index);

}


- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    NSLog(@"%ld ---已经消失",index);

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
