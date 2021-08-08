//
//  TagBtn.h
//  标签栏
//
//  Created by 唐天成 on 2020/8/8.
//  Copyright © 2020 xushuoa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LongPressDelegate <NSObject>

- (void) handleLongPressGestures:(UILongPressGestureRecognizer *)paramSender;

@end


@interface TagBtn : UIButton

@property (nonatomic, strong) TagModel *model;

@property (nonatomic, weak) id<LongPressDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
