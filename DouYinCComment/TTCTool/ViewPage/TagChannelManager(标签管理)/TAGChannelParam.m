//
//  TAGChannelParam.m
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2020/8/10.
//  Copyright © 2020 duoduo. All rights reserved.
//

#import "TAGChannelParam.h"
#import "TTCCom.h"
@implementation TAGChannelParam

- (instancetype)init {
    if(self = [super init]) {
    }
    return self;
}

- (void)setUpBtnDataArr:(NSMutableArray<TagModel *> *)upBtnDataArr {
    _upBtnDataArr = [NSMutableArray arrayWithArray:upBtnDataArr];
}

- (void)setBelowBtnDataArr:(NSMutableArray<TagModel *> *)belowBtnDataArr {
    _belowBtnDataArr = [NSMutableArray arrayWithArray:belowBtnDataArr];
}

@end
