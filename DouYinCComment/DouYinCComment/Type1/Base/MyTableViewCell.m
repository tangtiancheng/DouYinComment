//
//  MyTableViewCell.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/24.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "MyTableViewCell.h"
#import "Masonry.h"
#import "UICollectionView+MyCol.h"

#pragma mark - MyCollectionViewCell

@interface MyCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *label;

@end

@implementation MyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor yellowColor];
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.label];
    }
    return self;
}

@end


#pragma mark - MyTableViewCell

static NSString *collIdentifier = @"collIdentifier";

@interface MyTableViewCell ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation MyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        self.collectionView.canScrolWhenMAX = YES;
        self.collectionView.backgroundColor = [UIColor grayColor];
        [self.collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:collIdentifier];
        [self.contentView addSubview:self.collectionView];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.with.offset(0);
        }];
    }
    return self;
}

- (void)setNum:(NSInteger)num {
    _num = num;
    [self.collectionView reloadData];
}

#pragma mark UICollectionViewDataSource || UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.num;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collIdentifier forIndexPath:indexPath];
    cell.label.text = @(indexPath.item).stringValue;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = 100;
    CGFloat h = self.height;
    return CGSizeMake(w, h);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}







@end
