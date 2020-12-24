//
//  ContentListVBackView.h
//  DouYinCComment
//
//  Created by 唐天成 on 2020/12/22.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContentListVBackViewDelegate <NSObject>

- (void)topYChange:(CGFloat)topY dropEnd:(BOOL)drop animationDuration:(CGFloat)duration;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ContentListVBackView : UIView

//ListView顶部的预留高度
@property (nonatomic, assign) CGFloat topListVTopHeight;
//IPhoneXBotttomSafeHeihgt
@property (nonatomic, assign) CGFloat iPhoneXBotttomSafeHeihgt;
//顶部的高度
@property (nonatomic, assign) CGFloat topHeaderVHeight;
//TCViewPager的头部高度
@property (nonatomic, assign) CGFloat pageVHeaderH;


@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, assign, readonly) BOOL isShow;

@property (nonatomic, weak) id<ContentListVBackViewDelegate> delegate;

- (void)createBaseView;
- (void)showListV:(BOOL)animation;
- (void)dismissListV;



@end

NS_ASSUME_NONNULL_END
