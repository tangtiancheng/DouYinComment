//
//  TopBackContentView.h
//  DouYinCComment
//
//  Created by 唐天成 on 2020/12/22.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TopBackContentViewDelegate <NSObject>

- (void)popBtnClick;
- (void)dismissListVCBtnCLick;

@end

@interface TopBackContentView : UIView


//允许拖拽的最大长度
@property (nonatomic, assign) CGFloat maxXHeight;
//顶部的高度
@property (nonatomic, assign) CGFloat topHeaderVHeight;

//上部分的高度(包括歌名以上)
@property (nonatomic, assign) CGFloat heightTopUntilRingName;

@property (nonatomic, assign) BOOL isPlay;
//@property (nonatomic, strong, readonly) UIView *previousFatherView;

- (void)createBaseView;

- (void)exchangeByListVDrapLength:(CGFloat)length;

@property (nonatomic, weak) id<TopBackContentViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
