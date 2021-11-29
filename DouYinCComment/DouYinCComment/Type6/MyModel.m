//
//  MyModel.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/21.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "MyModel.h"

@implementation MyModel

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        return [self.tagID isEqualToString:[other tagID]];
    }
}

+ (instancetype)modelWithTagID:(NSString *)tagID title:(NSString *)title isFix:(BOOL)isFix {
    MyModel *model = [[MyModel alloc] init];
    model.tagID = tagID;
    model.title = title;
    model.isFix = isFix;
    return model;
}
@end
