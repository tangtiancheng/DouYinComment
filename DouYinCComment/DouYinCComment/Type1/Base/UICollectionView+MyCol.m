//
//  UICollectionView+MyCol.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/25.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "UICollectionView+MyCol.h"
#import <objc/runtime.h>

@implementation UICollectionView (MyCol)

- (BOOL)canScrolWhenMAX {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setCanScrolWhenMAX:(BOOL)canScrolWhenMAX {
    objc_setAssociatedObject(self, @selector(canScrolWhenMAX), @(canScrolWhenMAX), OBJC_ASSOCIATION_ASSIGN);
}




- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if(self.canScrolWhenMAX) {
        CGPoint beginningLocation = [gestureRecognizer locationInView:self];
            CGPoint translationLog = [gestureRecognizer translationInView:self];
            NSLog(@"gestureRecognizer.view = %@ location.x = %lf ,translation.x = %lf",gestureRecognizer.view,beginningLocation.x,translationLog.x);
            if(self.contentOffset.x == 0 && translationLog.x>0) {
                return NO;
            }
        //    if((self.contentOffset.x == (self.contentSize.width-self.width)) && translationLog.x<0) {
        //        return NO;
        //    }
            if(ceil(self.contentOffset.x) == ceil(self.contentSize.width-self.frame.size.width) && translationLog.x<0) {
                return NO;
            }
    }
    return YES;
}

@end
