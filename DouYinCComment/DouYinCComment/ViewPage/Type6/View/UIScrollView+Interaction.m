//
//  UIScrollView+Interaction.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/12/24.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "UIScrollView+Interaction.h"
#import<objc/runtime.h>

@implementation UIScrollView (Interaction)

- (void)setRingcanInteraction:(BOOL)ringcanInteraction
{
    // 让这个字符串与当前对象产生联系
    //    _name = name;
    // object:给哪个对象添加属性
    // key:属性名称
    // value:属性值
    // policy:保存策略
    objc_setAssociatedObject(self, @selector(ringcanInteraction), @(ringcanInteraction), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)ringcanInteraction
{
    return [objc_getAssociatedObject(self, @selector(ringcanInteraction)) boolValue];
}

@end
