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

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    UIButton *combtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 150, 100)];
    [self.view addSubview:combtn];
    [combtn setBackgroundColor:[UIColor redColor]];
    [combtn setTitle:@"评论功能" forState:UIControlStateNormal];
    [combtn addTarget:self action:@selector(commentMethod) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *douyinPlaybtn = [[UIButton alloc] initWithFrame:CGRectMake(210, 100, 150, 100)];
    [self.view addSubview:douyinPlaybtn];
    [douyinPlaybtn setBackgroundColor:[UIColor redColor]];
    [douyinPlaybtn setTitle:@"播放小视频" forState:UIControlStateNormal];
    [douyinPlaybtn addTarget:self action:@selector(douyinPlay) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *uploadbtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 250, 150, 100)];
    [self.view addSubview:uploadbtn];
    [uploadbtn setBackgroundColor:[UIColor redColor]];
    [uploadbtn setTitle:@"上传音频到库乐队" forState:UIControlStateNormal];
    [uploadbtn addTarget:self action:@selector(uploadGarageBand) forControlEvents:UIControlEventTouchUpInside];
   
    UIButton *viewPagebtn = [[UIButton alloc] initWithFrame:CGRectMake(210, 250, 150, 100)];
    [self.view addSubview:viewPagebtn];
    [viewPagebtn setBackgroundColor:[UIColor redColor]];
    [viewPagebtn setTitle:@"多页面嵌套" forState:UIControlStateNormal];
    [viewPagebtn addTarget:self action:@selector(showViewPage) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *transitionbtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 400, 150, 100)];
    [self.view addSubview:transitionbtn];
    [transitionbtn setBackgroundColor:[UIColor redColor]];
    [transitionbtn setTitle:@"视频播放转场动画" forState:UIControlStateNormal];
    [transitionbtn addTarget:self action:@selector(transition) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *panPushbtn = [[UIButton alloc] initWithFrame:CGRectMake(210, 400, 150, 100)];
    [self.view addSubview:panPushbtn];
    panPushbtn.titleLabel.numberOfLines = 0;
    [panPushbtn setBackgroundColor:[UIColor redColor]];
    [panPushbtn setTitle:@"抖音首页左滑进入个人主页" forState:UIControlStateNormal];
    [panPushbtn addTarget:self action:@selector(panPush) forControlEvents:UIControlEventTouchUpInside];
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

@end
