//
//  TagModel.m
//  标签栏
//
//  Created by 唐天成 on 2020/8/8.
//  Copyright © 2020 xushuoa. All rights reserved.
//

#import "TagModel.h"
#import "TTCCom.h"
@implementation TagModel

- (instancetype)init {
    if(self = [super init]) {
        self.isCurrentPage = NO;
        self.isFix = NO;
        self.isEdit = NO;
        self.isAlreadyTag = NO;
        self.title = @"";
        self.data = nil;
    }
    return self;
}

@end
