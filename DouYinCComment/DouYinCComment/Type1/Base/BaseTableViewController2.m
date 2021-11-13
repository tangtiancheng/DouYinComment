//
//  BaseTableViewController2.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/6.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "BaseTableViewController2.h"

@interface BaseTableViewController2 ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) BaseTableView *baseTableView;

@end

@implementation BaseTableViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor purpleColor];
    
    self.baseTableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 50)];
    [self.view addSubview:self.baseTableView];
    [self.baseTableView didAppeared];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.baseTableView.frame = CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 50);
}
@end
