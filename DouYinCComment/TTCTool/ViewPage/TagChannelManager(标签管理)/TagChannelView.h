//
//  TagChannelView.h
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2020/8/10.
//  Copyright © 2020 duoduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAGChannelParam.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^TAGMgerBlock)(NSMutableArray <TagModel *> *upDataArr, NSMutableArray <TagModel *> *belowDataArr, NSInteger currentIndex);

@interface TagChannelView : UIView

- (instancetype)initWithParam:(TAGChannelParam *)param mgerSuccess:(TAGMgerBlock)block;

- (void)show:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
