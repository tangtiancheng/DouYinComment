//
//  NSDate+Helper.h
//  DouYinCComment
//
//  Created by 唐天成 on 2019/5/29.
//  Copyright © 2019 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Helper)

//传一个字符串日期 比如 2017-10-16 19:14:58,返回几分钟前这样的
+ (NSString *)intervalFromNoewDateWithString:(NSString *)date;

@end

NS_ASSUME_NONNULL_END
