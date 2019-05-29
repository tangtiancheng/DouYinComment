//
//  global.h
//  TaoYing
//
//  Created by mistyzyq on 13-1-9.
//  Copyright (c) 2013年 HuaYing Co., Ltd. All rights reserved.
//  全局设置单粒类,主要提供了一个枚举,让其他类成为单粒

#ifndef _NX_GLOBAL_H__
#define _NX_GLOBAL_H__

#ifdef __OCJC__
    #import <Foundation/Foundation.h>
#endif

#endif // _NX_GLOBAL_H__

//禁止不必要的编译警告
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//// some code
//#pragma clang diagnostic pop

//已知的一些编译警告类型
//-Wincompatible-pointer-types      指针类型不匹配
//-Wincomplete-implementation       没有实现已声明的方法
//-Wprotocol                        没有实现协议的方法
//-Wimplicit-function-declaration   尚未声明的函数(通常指c函数)
//-Warc-performSelector-leaks       使用performSelector可能会出现泄漏(该警告在xcode4.3.1中没出现过,网上流传说4.2使用performselector:withObject: 就会得到该警告)
//-Wdeprecated-declarations         使用了不推荐使用的方法(如[UILabel setFont:(UIFont*)])
//-Wunused-variable                 含有没有被使用的变量
//-Wname-of-warning
//-Wunused-parameter
//-Wunused-function
//-Wformat-security

#ifdef __OBJC__

#define DECLARE_SINGLETON_FOR_CLASS(classname)  + (classname *)shared##classname;

//MRC
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname)           \
                                                            \
static classname *shared##classname = nil;                  \
+ (classname *)shared##classname {                          \
    @synchronized(self) {                                   \
        if (shared##classname == nil) {                     \
            shared##classname = [[self alloc] init];        \
        }                                                   \
    }                                                       \
    return shared##classname;                               \
}                                                           \
                                                            \
+ (id)allocWithZone:(NSZone *)zone {                        \
    @synchronized(self) {                                   \
        if (shared##classname == nil) {                     \
            shared##classname = [super allocWithZone:zone]; \
            return shared##classname;                       \
        }                                                   \
    }                                                       \
    return nil;                                             \
}                                                           \
                                                            \
- (id)copyWithZone:(NSZone *)zone {                         \
    return self;                                            \
}                                                           \
                                                            \
- (id)retain {                                              \
    return self;                                            \
}                                                           \
                                                            \
- (NSUInteger)retainCount {                                 \
    return NSUIntegerMax;                                   \
}                                                           \
                                                            \
- (oneway void)release {                                    \
}                                                           \
                                                            \
- (id)autorelease {                                         \
    return self;                                            \
}



//ARC
#define ARCSYNTHESIZE_SINGLETON_FOR_CLASS(classname)        \
                                                            \
static classname *shared##classname = nil;                  \
+ (classname *)shared##classname {                          \
@synchronized(self) {                                       \
if (shared##classname == nil) {                             \
shared##classname = [[self alloc] init];                    \
}                                                           \
}                                                           \
return shared##classname;                                   \
}                                                           \
\
+ (id)allocWithZone:(NSZone *)zone {                        \
@synchronized(self) {                                       \
if (shared##classname == nil) {                             \
shared##classname = [super allocWithZone:zone];             \
return shared##classname;                                   \
}                                                           \
}                                                           \
return nil;                                                 \
}                                                           \
                                                            \
- (id)copyWithZone:(NSZone *)zone {                         \
return self;                                                \
}                                                           \






#endif
