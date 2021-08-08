//
//  Type1ViewControllerFirst.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/3.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "Type1ViewControllerFirst.h"
#import "BaseTableViewController.h"
#import "BaseCollectionViewController.h"
#import "BaseWebViewController.h"
#import "BaseViewController.h"
#import "BaseScrollViewController.h"
#import "TCViewPager.h"

@interface Type1ViewControllerFirst ()


@end

@implementation Type1ViewControllerFirst

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
    
    //分页配置
    TCPageParam *pageParam = [self createPageParamWithTitleArr:arry_seg_title];
    //分页列表
    TCViewPager *viewPager = [[TCViewPager alloc] initWithFrame:CGRectMake(0, kDevice_Is_iPhoneX ? 88 : 64, SCREEN_WIDTH, SCREEN_HEIGHT - (kDevice_Is_iPhoneX ? 88 : 64)) views:vcArray param:pageParam];
    
    [self.view addSubview:viewPager];
}

- (TCPageParam *)createPageParamWithTitleArr:(NSMutableArray *)arry_seg_title {
    TCPageParam *pageParam = [[TCPageParam alloc] init];
    pageParam.titleArray = arry_seg_title;
    return pageParam;
}

@end
