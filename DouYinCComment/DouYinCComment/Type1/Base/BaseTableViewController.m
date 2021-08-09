//
//  BaseTableViewController.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/3.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "BaseTableViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "ReactiveObjC.h"
#import "MyTableViewCell.h"

static NSString *const cellIdentifier = @"cellIdentifier";
static NSString *const MyTableViewCellIdentifier = @"MyTableViewCellIdentifier";

#pragma mark - BaseTableView

@interface BaseTableView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, assign) BOOL isDidAppeared;

@end

@implementation BaseTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.isDidAppeared = NO;
        
    }
    return self;
}

- (void)didAppeared {
    if(!self.isDidAppeared) {
        [self setupBaseView];
        for(NSInteger i =0; i<30; i++) {
            [self.arr addObject:@(i)];
        }
        [self.tableView reloadData];
        self.isDidAppeared = YES;
       
    }
}


- (void)setupBaseView {
    self.backgroundColor = [UIColor greenColor];
    [self tableView];
    @weakify(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.arr removeAllObjects];
            for(NSInteger i =0; i<30; i++) {
                [self.arr addObject:@(i)];
            }
            [self.tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];
        });
    }];
    

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for(NSInteger i =0;i<10;i++) {
                [self.arr addObject:@(i)];
            }

            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}

#pragma mark UITableViewDataSource || UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 5) {
        MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyTableViewCellIdentifier forIndexPath:indexPath];
        cell.num = 2;
        return cell;
    } else if(indexPath.row == 7) {
        MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyTableViewCellIdentifier forIndexPath:indexPath];
        cell.num = 20;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @(indexPath.row).stringValue;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 5 || indexPath.row == 7) {
        return 80;
    } else {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
        [_tableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:MyTableViewCellIdentifier];
        [self addSubview:_tableView];
        _tableView.tableFooterView = [UIView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;

    }
    return _tableView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (NSMutableArray *)arr {
    if(!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

@end


#pragma mark - BaseTableViewController

@interface BaseTableViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) BaseTableView *baseTableView;

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTableView = [[BaseTableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.baseTableView];
    [self.baseTableView didAppeared];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.baseTableView.frame = self.view.bounds;
}

@end
