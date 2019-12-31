//
//  AppConfigure.h
//  GaragebandTest
//
//  Created by 唐天成 on 2019/6/15.
//  Copyright © 2019 TT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppConfigure : NSObject

/**
 库乐队的一个基础文件
 */
@property (nonatomic, copy) NSString* bandfolder;

/**
 生成好的库乐队band文件所在文件夹
 */
@property (nonatomic, copy) NSString* bandfolderDirectory;


+ (AppConfigure *)sharedAppConfigure;

@end

NS_ASSUME_NONNULL_END
