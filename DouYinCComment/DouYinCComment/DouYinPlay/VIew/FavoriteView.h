//
//  FavoriteView.h
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2019/1/7.
//  Copyright © 2019年 duoduo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(BOOL isSelected);

@interface FavoriteView : UIView

@property (nonatomic, strong) UIImageView      *favoriteBefore;
@property (nonatomic, strong) UIImageView      *favoriteAfter;

@property (nonatomic, copy) ClickBlock clickBlock;
@property (nonatomic, assign) BOOL isChoose;

- (void)resetView;

//-(void)startChoose:(BOOL)isChoose animation:(BOOL)animation;

@end

