//
//  UIView+CommonFunction.h
//  Speech
//
//  Created by lwb on 2017/4/18.
//  Copyright © 2017年 Attackt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CommonFunction)






/**
 *  寻找View所在的当前控制器
 *
 *  @return UIViewController
 */
- (UIViewController *)viewController;

//获得当前窗口的控制器
+ (UIViewController *)currentViewController;

/**
 UIView 截图
 
 @return 截图的UIImage
 */
- (UIImage *)lz_screenshot;


/**
 UIView 截图
 
 @param size 控制截屏的大小
 @return 截图后的UIImage
 */
- (UIImage *)lz_screenshotWithSize:(CGSize)size;


/**
 添加普通阴影效果
 */
- (void)addCustomShadow;



/**
 *  Create UIview切圆角(4个角)
 *
 *  @param color  Border's color
 *  @param radius Border's radius
 *  @param width  Border's width
 */
- (void)createBordersWithColor:(UIColor *)color
              withCornerRadius:(CGFloat)radius
                      andWidth:(CGFloat)width;

/**
 *  whe single tapped
 *
 *  @param block block
 */

- (void)whenTapped:(void (^)())block;

@end
