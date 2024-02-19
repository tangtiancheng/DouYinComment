////
////  NSNull+Safe.m
////  pictureDDiOS
////
////  Created by Admin on 2020/7/14.
////  Copyright © 2020 shanyongjie. All rights reserved.
////
//
//#import "NSNull+Safe.h"
////#define NULLSAFE_ENABLED YES
//
//@implementation NSNull (Safe)
//
////#if NULLSAFE_ENABLED
////修改了下,消息转发到这
//- (void)methodDefa {
//    
//}
//
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
//{
//    //look up method signature
//    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
//    if (!signature)
//    {
//        BOOL ishave = NO;
//        for (Class someClass in @[
//            [NSMutableArray class],
//            [NSMutableDictionary class],
//            [NSMutableString class],
//            [NSNumber class],
//            [NSDate class],
//            [NSData class]
//        ])
//        {
//            @try
//            {
//                if ([someClass instancesRespondToSelector:selector])
//                {
//                    ishave = YES;
//                    signature = [someClass instanceMethodSignatureForSelector:selector];
//
//                    break;
//                }
//            }
//            @catch (__unused NSException *unused) {}
//        }
//        
//        if(!ishave) {
//            signature = [self.class instanceMethodSignatureForSelector:@selector(methodDefa)];
//        }
//    }
//    return signature;
//}
//
//- (void)forwardInvocation:(NSInvocation *)invocation
//{
//    invocation.target = nil;
//    [invocation invoke];
//}
//
////#endif
//
//@end
