//
//  BaseCollectionViewController.h
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/3.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface BaseCollectionView : UIView

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

- (void)didAppeared;

@end


@interface BaseCollectionViewController : UIViewController

@property (nonatomic, strong, readonly) BaseCollectionView *baseCollectionView;

@end

NS_ASSUME_NONNULL_END
