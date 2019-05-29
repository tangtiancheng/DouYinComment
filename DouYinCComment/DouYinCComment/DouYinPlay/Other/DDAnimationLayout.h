//
//  DDAnimationLayout.h
//  DuoDUoAnimateHouse
//
//  Created by 唐天成 on 2017/11/15.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DDAnimationLayout;

@protocol DDAnimationLayoutDelegate <NSObject>

// 动态获取 item 宽度
- (CGSize) DDAnimationLayout:(DDAnimationLayout *)layout atIndexPath:(NSIndexPath *) indexPath;

@end


@interface DDAnimationLayout : UICollectionViewLayout
//水平还是竖直
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic,weak) id <DDAnimationLayoutDelegate> delegate;

//距离4周的宽度
@property (nonatomic, assign) UIEdgeInsets sectionInset;
/** 每一列之间的间距 */
@property (nonatomic, assign) CGFloat columnMargin;
/** 每一行之间的间距 */
@property (nonatomic, assign) CGFloat rowMargin;
/** 显示多少行或多少列 */
@property (nonatomic, assign) int rowsOrColumnsCount;



@end
