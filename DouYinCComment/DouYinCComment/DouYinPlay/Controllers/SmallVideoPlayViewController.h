//
//  SmallVideoPlayViewController.h
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2019/1/5.
//  Copyright © 2019年 duoduo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SmallVideoPlayViewController;
@class SmallVideoModel;






NS_ASSUME_NONNULL_BEGIN

@interface SmallVideoPlayViewController : UIViewController

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, assign) NSInteger currentPlayIndex;
@property (nonatomic) BOOL hasMore;

@property (nonatomic, assign) NSInteger rid;

@end

NS_ASSUME_NONNULL_END
