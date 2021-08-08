//
//  TAGChannelParam.h
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2020/8/10.
//  Copyright © 2020 duoduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TAGChannelParam : NSObject


/**
 *上按钮数组
 **/
@property (nonatomic, strong) NSMutableArray<TagModel *> *upBtnDataArr;

/**
 *下按钮数组
 **/
@property (nonatomic, strong) NSMutableArray<TagModel *> *belowBtnDataArr;



@end

NS_ASSUME_NONNULL_END
