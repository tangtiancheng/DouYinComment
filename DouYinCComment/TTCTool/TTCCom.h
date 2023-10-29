//
//  TTCCom.h
//  tttt
//
//  Created by 唐天成 on 2021/8/9.
//  1

#ifndef TTCCom_h
#define TTCCom_h


#define SCREEN_WIDTH            ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT           ([UIScreen mainScreen].bounds.size.height)
// 颜色值RGB
#define RGBA(r,g,b,a)                       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGBCOLORVALUE(rgb)      ([UIColor colorWithRed:(float)((rgb & 0xFF0000) >> 16)/255.0 green:(float)((rgb & 0x00FF00) >> 8)/255.0 blue:(float)((rgb & 0x0000FF))/255.0 alpha:1.0])
//是否是iPhoneX
#define kDevice_Is_iPhoneX (@available(iOS 11.0, *) ? ([UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom ? YES : NO) : NO)

//导航条的高度
#define NavigationHeight    (kDevice_Is_iPhoneX ? 88 :  64)

#define SafeAreaBottomHeight (@available(iOS 11.0, *) ? [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom : 0)
#define SafeAreaTopHeight (@available(iOS 11.0, *) ? [UIApplication sharedApplication].keyWindow.safeAreaInsets.top : 0)
#define SafeAreaLeftHeight (@available(iOS 11.0, *) ? [UIApplication sharedApplication].keyWindow.safeAreaInsets.left : 0)
#define SafeAreaRightHeight (@available(iOS 11.0, *) ? [UIApplication sharedApplication].keyWindow.safeAreaInsets.right : 0)

#endif /* TTCCom_h */
