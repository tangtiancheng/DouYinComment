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

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *combtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 150, 100)];
    [self.view addSubview:combtn];
    [combtn setBackgroundColor:[UIColor redColor]];
    [combtn setTitle:@"评论功能" forState:UIControlStateNormal];
    [combtn addTarget:self action:@selector(commentMethod) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *douyinPlaybtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 250, 150, 100)];
    [self.view addSubview:douyinPlaybtn];
    [douyinPlaybtn setBackgroundColor:[UIColor redColor]];
    [douyinPlaybtn setTitle:@"播放小视频" forState:UIControlStateNormal];
    [douyinPlaybtn addTarget:self action:@selector(douyinPlay) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *uploadbtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 150, 100)];
    [self.view addSubview:uploadbtn];
    [uploadbtn setBackgroundColor:[UIColor redColor]];
    [uploadbtn setTitle:@"上传音频到库乐队" forState:UIControlStateNormal];
    [uploadbtn addTarget:self action:@selector(uploadGarageBand) forControlEvents:UIControlEventTouchUpInside];
   
    UIButton *viewPagebtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 550, 150, 100)];
    [self.view addSubview:viewPagebtn];
    [viewPagebtn setBackgroundColor:[UIColor redColor]];
    [viewPagebtn setTitle:@"多页面嵌套" forState:UIControlStateNormal];
    [viewPagebtn addTarget:self action:@selector(showViewPage) forControlEvents:UIControlEventTouchUpInside];
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

@end
