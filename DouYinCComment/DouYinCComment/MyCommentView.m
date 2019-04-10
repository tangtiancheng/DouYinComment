//
//  MyCommnetView.m
//  DouYinCComment
//
//  Created by 唐天成 on 2019/4/10.
//  Copyright © 2019 唐天成. All rights reserved.
//

#import "MyCommentView.h"
#import "MyCommentCell.h"
#import "Masonry/Masonry.h"

static NSString *const commentCellIdentifier = @"commentCellIdentifier";

@interface MyCommentView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MyCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setupBaseView];
    }
    return self;
}

- (void)setupBaseView {
    self.backgroundColor = [UIColor whiteColor];
    UIButton *closeBtn = [[UIButton alloc] init];
    [self addSubview:closeBtn];
    [closeBtn setBackgroundColor:[UIColor redColor]];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeComment) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.with.offset(0);
        make.size.mas_equalTo(CGSizeMake(50, 40));
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.with.offset(0);
        make.top.with.offset(40);
    }];
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[MyCommentCell class] forCellReuseIdentifier:commentCellIdentifier];
}

- (void)closeComment {
    if([self.delegate respondsToSelector:@selector(closeComment)]) {
        [self.delegate closeComment];
    }
}

#pragma mark - UITableViewDataSource && UITableVideDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier forIndexPath:indexPath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

@end
