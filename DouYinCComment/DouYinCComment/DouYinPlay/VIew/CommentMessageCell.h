//
//  CommentMessageCell.h
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2017/7/4.
//  Copyright © 2017年 www.ShoujiDuoduo.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@protocol CommentMessageCellDelegate <NSObject>

//点赞
- (void)zanTapWithCommentModel:(CommentModel *)model;


@end

@interface CommentMessageCell : UITableViewCell

@property(nonatomic, strong) CommentModel *commentModel;
@property(nonatomic, weak) id<CommentMessageCellDelegate> delegate;

@end
