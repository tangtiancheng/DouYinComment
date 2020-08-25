//
//  RootViewPageViewController.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/3.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "RootViewPageViewController.h"
#import "Masonry.h"
#import "BaseTableViewController.h"
#import "Type1ViewControllerFirst.h"
#import "Type1ViewControllerSecond.h"
#import "Type1ViewControllerThird.h"

#import "Type2ViewControllerFirst.h"
#import "Type2ViewControllerSecond.h"

#import "Type3ViewControllerFirst.h"
#import "Type3ViewControllerSecond.h"

#import "Type4ViewControllerFirst.h"
#import "Type4ViewControllerSecond.h"
#import "Type4ViewControllerThird.h"
#import "Type4ViewControllerFourth.h"
#import "Type4ViewControllerFifth.h"

#import "Type5ViewControllerFirst.h"

static NSString *const cellIdentifier = @"cellIdentifier";

@interface RootViewPageViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RootViewPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self tableView];
    
    NSLog(@"屏幕:%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
    
}

#pragma mark - UITableViewDataSource || UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 3;
    } else if(section == 1) {
        return 2;
    } else if(section == 2) {
        return 2;
    } else if(section == 3) {
        return 5;
    } else if(section == 4) {
        return 1;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    label.font = [UIFont systemFontOfSize:25];
    if(section == 0) {
        label.text = @"普通分页";
    } else if(section == 1) {
        label.text = @"嵌套滚动(header随时变动)";
    } else if(section == 2) {
        label.text = @"嵌套滚动(header吸顶不动)";
    } else if(section == 3) {
        label.text = @"嵌套滚动(header不吸顶)";
    } else if(section == 4) {
        label.text = @"编辑标签";
    }
    return label;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            cell.textLabel.text = @"默认param数据(列表为ViewControl)";
        } else if(indexPath.row == 1) {
            cell.textLabel.text = @"非默认param数据(列表为ViewControl)";
        } else if(indexPath.row == 2) {
            cell.textLabel.text = @"非默认param数据(列表为View,不推荐这种)";
        }
        
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            cell.textLabel.text = @"头部随时变动,适用滚动隐藏显示搜索框场景(列表为ViewControl)";
        } else if(indexPath.row == 1) {
            cell.textLabel.text = @"头部随时变动,适用滚动隐藏显示搜索框场景(列表为View)";
        }
    } else if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            cell.textLabel.text = @"头部吸顶不动,适用于有下拉刷新的个人主页(列表为ViewControl)";
        } else if(indexPath.row == 1) {
            cell.textLabel.text = @"头部吸顶不动(非默认param数据,列表为ViewControl)";
        }
    } else if(indexPath.section == 3) {
        if(indexPath.row == 0) {
            cell.textLabel.text = @"去除bounces(列表为ViewControl)";
        } else if(indexPath.row == 1) {
            cell.textLabel.text = @"添加下拉刷新,改变headerView高度(列表为ViewControl)";
        } else if(indexPath.row == 2) {
            cell.textLabel.text = @"适用于下拉的时候图片也拉升变大的个人主页(列表为ViewControl)";
        } else if(indexPath.row == 3) {
            cell.textLabel.text = @"类似铃声多多铃单页";
        } else if(indexPath.row == 4) {
            cell.textLabel.text = @"viewPager使用第三方的ZJScrollPageView(viewPager可以使用你自己的写好的分页控制视图)";
        }
    } else if(indexPath.section == 4) {
        if(indexPath.row == 0) {
            cell.textLabel.text = @"编辑标签";
        }
    }
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            Type1ViewControllerFirst *vc = [[Type1ViewControllerFirst alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if(indexPath.row == 1) {
            Type1ViewControllerSecond *vc = [[Type1ViewControllerSecond alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if(indexPath.row == 2) {
            Type1ViewControllerThird *vc = [[Type1ViewControllerThird alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            Type2ViewControllerFirst *vc = [[Type2ViewControllerFirst alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if(indexPath.row == 1) {
            Type2ViewControllerSecond *vc = [[Type2ViewControllerSecond alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            Type3ViewControllerFirst *vc = [[Type3ViewControllerFirst alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if(indexPath.row == 1) {
            Type3ViewControllerSecond *vc = [[Type3ViewControllerSecond alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if(indexPath.section == 3) {
        if(indexPath.row == 0) {
            Type4ViewControllerFirst *vc = [[Type4ViewControllerFirst alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if(indexPath.row == 1) {
            Type4ViewControllerSecond *vc = [[Type4ViewControllerSecond alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if(indexPath.row == 2) {
            Type4ViewControllerThird *vc = [[Type4ViewControllerThird alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if(indexPath.row == 3) {
            Type4ViewControllerFourth *vc = [[Type4ViewControllerFourth alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if(indexPath.row == 4) {
            Type4ViewControllerFifth *vc = [[Type4ViewControllerFifth alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if(indexPath.section == 4) {
        if(indexPath.row == 0) {
            Type5ViewControllerFirst *vc = [[Type5ViewControllerFirst alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
        [self.view addSubview:_tableView];
        _tableView.tableFooterView = [UIView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

@end
