//
//  SmallVideoPlayViewController.h
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2019/1/5.
//  Copyright © 2019年 duoduo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TransitionSmallVideoPlayViewController;
@class SmallVideoModel;




@protocol SmallVideoPlayControllerDelegate<NSObject>

- (UIView *)smallVideoPlayIndex:(NSInteger)index ;


@end


NS_ASSUME_NONNULL_BEGIN

@interface TransitionSmallVideoPlayViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, assign) NSInteger currentPlayIndex;

@property (nonatomic, weak) id<SmallVideoPlayControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
