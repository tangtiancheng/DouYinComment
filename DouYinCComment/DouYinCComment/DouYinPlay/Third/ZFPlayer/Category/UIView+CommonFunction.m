//
//  UIView+CommonFunction.m
//  Speech
//
//  Created by lwb on 2017/4/18.
//  Copyright © 2017年 Attackt. All rights reserved.
//

#import "UIView+CommonFunction.h"
#import <objc/runtime.h>
#import "TTCCom.h"


typedef void (^XP_WhenTappedBlock)();
static char kWhenTappedBlockKey;

@implementation UIView (CommonFunction)





- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

- (NSString *)frameStr {
    return NSStringFromCGRect(self.frame);
}








- (UIViewController *)viewController {
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}


//获得当前窗口的控制器
+ (UIViewController *)currentViewController {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIViewController *topController = [window rootViewController];
    //  Getting topMost ViewController
    while ([topController presentedViewController])    {
        topController = [topController presentedViewController];
    }
    
    while (([topController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topController topViewController]) || ([topController isKindOfClass:[UITabBarController class]] && [(UITabBarController *)topController viewControllers])) {
        if(([topController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topController topViewController])) {
            topController = [(UINavigationController*)topController topViewController];
        } else if(([topController isKindOfClass:[UITabBarController class]] && [(UITabBarController *)topController viewControllers])) {
            topController = [(UITabBarController*)topController selectedViewController];
        }
    }
    return topController;
}


- (UIImage *)lz_screenshot{
    UIImage *image = [self lz_screenshotWithSize:self.bounds.size];
    return image;
}

- (UIImage *)lz_screenshotWithSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    if( [self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }
    else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}


- (void)addCustomShadow {
    self.layer.shadowColor = RGBA(0, 0, 0, 0.3).CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 4);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 4.0;
    self.layer.masksToBounds = NO;
    self.clipsToBounds = NO;
}


// Borders
- (void)createBordersWithColor:(UIColor *)color withCornerRadius:(CGFloat)radius andWidth:(CGFloat)width {
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radius;
    self.layer.shouldRasterize = NO;
    self.layer.rasterizationScale = 2;
    //    self.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
    //    self.clipsToBounds = YES;
    //    self.layer.masksToBounds = YES;
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGColorRef cgColor = [color CGColor];
    self.layer.borderColor = cgColor;
    CGColorSpaceRelease(space);
}




- (void)setBlock:(XP_WhenTappedBlock)block forKey:(void *)blockKey {
    self.userInteractionEnabled = YES;
    objc_setAssociatedObject(self, blockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)addRequiredToDoubleTapsRecognizer:(UIGestureRecognizer *)recognizer {
    for (UIGestureRecognizer *gesture in[self gestureRecognizers]) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)gesture;
            
            if (tapGesture.numberOfTouchesRequired == 2 && tapGesture.numberOfTapsRequired == 1) {
                [recognizer requireGestureRecognizerToFail:tapGesture];
            }
        }
    }
}

- (UITapGestureRecognizer *)addTapGestureRecognizerWithTaps:(NSUInteger)taps touches:(NSUInteger)touches selector:(SEL)selector {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = taps;
    tapGesture.numberOfTouchesRequired = touches;
    [self addGestureRecognizer:tapGesture];
    return tapGesture;
}
- (void)viewWasTapped {
    [self runBlockForKey:&kWhenTappedBlockKey];
}
- (void)runBlockForKey:(void *)blockKey {
    XP_WhenTappedBlock block = objc_getAssociatedObject(self, blockKey);
    
    if (block) block();
}
/**
 *  whe single tapped
 *
 *  @param block block
 */
- (void)whenTapped:(void (^)())block {
    
    UITapGestureRecognizer *gesture = [self addTapGestureRecognizerWithTaps:1 touches:1 selector:@selector(viewWasTapped)];
    
    [self addRequiredToDoubleTapsRecognizer:gesture];
    [self setBlock:block forKey:&kWhenTappedBlockKey];
}






@end
