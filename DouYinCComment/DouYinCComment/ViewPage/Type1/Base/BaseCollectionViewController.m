//
//  BaseCollectionViewController.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/3.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"

static NSString *collIdentifier = @"collIdentifier";

#pragma mark - BaseCell

@interface BaseCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *label;

@end

@implementation BaseCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.label];

    }
    return self;
}

@end


#pragma mark - BaseCollectionView

@interface BaseCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, assign) BOOL isDidAppeared;

@end

@implementation BaseCollectionView

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
        [self.collectionView reloadData];
        self.isDidAppeared = YES;
    }
}

- (void)setupBaseView {
    self.backgroundColor = [UIColor yellowColor];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor grayColor];
    [self.collectionView registerClass:[BaseCell class] forCellWithReuseIdentifier:collIdentifier];
    [self addSubview:self.collectionView];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    @weakify(self);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.arr removeAllObjects];
            for(NSInteger i =0; i<30; i++) {
                [self.arr addObject:@(i)];
            }
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
        });
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for(NSInteger i =0;i<10;i++) {
                [self.arr addObject:@(i)];
            }
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView reloadData];
        });
    }];
}

#pragma mark UICollectionViewDataSource || UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collIdentifier forIndexPath:indexPath];
    cell.label.text = @(indexPath.item).stringValue;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = (self.frame.size.width - 4 * 10) / 3-1;
    CGFloat h = w;
    return CGSizeMake(w, h);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

- (NSMutableArray *)arr {
    if(!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}


@end




#pragma mark - BaseCollectionViewController

@interface BaseCollectionViewController ()

@property (nonatomic, strong) BaseCollectionView *baseCollectionView;

@end

@implementation BaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseCollectionView = [[BaseCollectionView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.baseCollectionView];
    [self.baseCollectionView didAppeared];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.baseCollectionView.frame = self.view.bounds;
}


@end
