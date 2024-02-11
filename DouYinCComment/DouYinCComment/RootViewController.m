//
//  RootViewController.m
//  DouYinCComment
//
//  Created by 唐天成 on 2019/5/28.
//  Copyright © 2019 唐天成. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"
#import "SmallVideoListViewController.h"
#import "GarageBandViewController.h"
#import "RootViewPageViewController.h"
#import "TransitionVideoListViewController.h"
#import "ReactiveObjC.h"
#import "DouyinTabBarController.h"
#import "WidgetSwiftViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationController.navigationBar.hidden = YES;
    //    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    UIButton *comBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 150, 100)];
    [self.view addSubview:comBtn];
    [comBtn setBackgroundColor:[UIColor redColor]];
    [comBtn setTitle:@"评论功能" forState:UIControlStateNormal];
    [comBtn addTarget:self action:@selector(commentMethod) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *douyinPlayBtn = [[UIButton alloc] initWithFrame:CGRectMake(210, 100, 150, 100)];
    [self.view addSubview:douyinPlayBtn];
    [douyinPlayBtn setBackgroundColor:[UIColor redColor]];
    [douyinPlayBtn setTitle:@"播放小视频" forState:UIControlStateNormal];
    [douyinPlayBtn addTarget:self action:@selector(douyinPlay) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 250, 150, 100)];
    [self.view addSubview:uploadBtn];
    [uploadBtn setBackgroundColor:[UIColor redColor]];
    [uploadBtn setTitle:@"上传音频到库乐队" forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(uploadGarageBand) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *viewPageBtn = [[UIButton alloc] initWithFrame:CGRectMake(210, 250, 150, 100)];
    [self.view addSubview:viewPageBtn];
    [viewPageBtn setBackgroundColor:[UIColor redColor]];
    [viewPageBtn setTitle:@"多页面嵌套" forState:UIControlStateNormal];
    [viewPageBtn addTarget:self action:@selector(showViewPage) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *transitionBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 400, 150, 100)];
    [self.view addSubview:transitionBtn];
    [transitionBtn setBackgroundColor:[UIColor redColor]];
    [transitionBtn setTitle:@"视频播放转场动画" forState:UIControlStateNormal];
    [transitionBtn addTarget:self action:@selector(transition) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *panPushBtn = [[UIButton alloc] initWithFrame:CGRectMake(210, 400, 150, 100)];
    [self.view addSubview:panPushBtn];
    panPushBtn.titleLabel.numberOfLines = 0;
    [panPushBtn setBackgroundColor:[UIColor redColor]];
    [panPushBtn setTitle:@"抖音首页左滑进入个人主页" forState:UIControlStateNormal];
    [panPushBtn addTarget:self action:@selector(panPush) forControlEvents:UIControlEventTouchUpInside];
    

    UIButton *widgetBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 550, 150, 100)];
    [self.view addSubview:widgetBtn];
    [widgetBtn setBackgroundColor:[UIColor redColor]];
    [widgetBtn setTitle:@"widget小组件" forState:UIControlStateNormal];
    [widgetBtn addTarget:self action:@selector(showWidget) forControlEvents:UIControlEventTouchUpInside];
}


- (void)commentMethod {
    ViewController *vc = [[ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)douyinPlay {
    
    SmallVideoListViewController *vc = [[SmallVideoListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)uploadGarageBand {
    GarageBandViewController *vc = [[GarageBandViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showViewPage {
    RootViewPageViewController *vc = [[RootViewPageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)transition {
    TransitionVideoListViewController *vc = [[TransitionVideoListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)panPush {
    DouyinTabBarController *vc = [[DouyinTabBarController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (void)showWidget {
    WidgetSwiftViewController *vc = [[WidgetSwiftViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
