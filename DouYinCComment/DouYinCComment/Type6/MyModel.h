//
//  MyModel.h
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/21.
//  Copyright © 2020 唐天成. All rights reserved.
//  你应该自己代码会有类似这样的标签模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyModel : NSObject

@property (nonatomic, strong) NSString *tagID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isFix;

+ (instancetype)modelWithTagID:(NSString *)tagID title:(NSString *)title isFix:(BOOL)isFix;

@end

NS_ASSUME_NONNULL_END
