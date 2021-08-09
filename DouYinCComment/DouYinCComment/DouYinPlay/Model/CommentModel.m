//
//  CommentModel.m
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2017/7/6.
//  Copyright © 2017年 www.ShoujiDuoduo.com. All rights reserved.
//

#import "CommentModel.h"
#import "TTCCom.h"

@implementation CommentModel

- (CGFloat)height {
    if(!_height) {
//    if(self.tuid.length) {
//        //回复评论
//
//        _height =  ( 17 + 14 + 7 + 12.5 + 14 + [[NSString stringWithFormat:@"回复@%@:%@",self.tname,self.comment] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 14 -14 -14 -34, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height + 1 + [[NSString stringWithFormat:@"@%@:%@",self.tname,self.tcomment] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 14 -14 -14 -34 - 10 - 10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height + 1 + 5 + 17 + 14 + 14);// [self.comment sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 14 -14 -14 -34, MAXFLOAT) lineBreakMode:NSLineBreakByTruncatingTail].height);
//    } else {
        //评论
        _height = ( 17 + 14 + 7 + 12.5 + 14 + 17 + [self.comment boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 14 -14 -14 -34, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height);
//    }
    }
    return _height;
}

@end
