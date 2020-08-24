//
//  TagModel.h
//  标签栏
//
//  Created by 唐天成 on 2020/8/8.
//  Copyright © 2020 xushuoa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagModel : NSObject

@property (nonatomic, assign) BOOL isCurrentPage;//是否为当前展示页.
@property (nonatomic, assign) BOOL isFix;//是否固定
@property (nonatomic, assign) BOOL isEdit;//是否处于编辑状态
@property (nonatomic, assign) BOOL isAlreadyTag;//是否已经选为我的标签
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) id data;//这个传你的标签模型


@end

NS_ASSUME_NONNULL_END
