//
//  DouyinTabBarController.m
//  DouYinCComment
//
//  Created by 唐天成 on 2023/6/11.
//  Copyright © 2023 唐天成. All rights reserved.
//

#import "DouyinTabBarController.h"
#import "HomePageViewController.h"

@interface DouyinTabBarController ()

@end

@implementation DouyinTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBar.translucent = NO;
    self.tabBar.backgroundColor = [UIColor orangeColor];
    // Do any additional setup after loading the view.
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:[[HomePageViewController alloc] init]];
    naviVC.navigationBar.hidden = YES;
    naviVC.interactivePopGestureRecognizer.enabled = YES;

    naviVC.title = @"首页";
    
    UIViewController *vc1 = [[UIViewController alloc] init];
    vc1.view.backgroundColor = [UIColor greenColor];
    vc1.title = @"朋友";
    
    UIViewController *vc2 = [[UIViewController alloc] init];
    vc2.view.backgroundColor = [UIColor yellowColor];
    vc2.title = @"消息";
    
    UIViewController *vc3 = [[UIViewController alloc] init];
    vc3.view.backgroundColor = [UIColor blueColor];
    vc3.title = @"我";
    
    self.viewControllers = @[naviVC,vc1,vc2,vc3];
    
    
    
}


@end
