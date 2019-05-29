//
//  SmallVideoModel.h
//  DouYinCComment
//
//  Created by 唐天成 on 2019/5/28.
//  Copyright © 2019 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SmallVideoModel : NSObject

@property (nonatomic)        UInt64      rid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger comment_num;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *head_url;
@property (nonatomic, copy) NSString *video_url;
@property (nonatomic, copy) NSString *cover_url;
@property (nonatomic, assign) CGFloat aspect;

@end

NS_ASSUME_NONNULL_END
