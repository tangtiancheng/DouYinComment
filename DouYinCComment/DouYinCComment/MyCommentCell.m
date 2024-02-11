//
//  MyCommentCell.m
//  DouYinCComment
//
//  Created by 唐天成 on 2019/4/10.
//  Copyright © 2019 唐天成. All rights reserved.
//

#import "MyCommentCell.h"

@interface MyCommentCell ()

@property (nonatomic, strong) UILabel *commentLabel;

@end

@implementation MyCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.commentLabel = [[UILabel alloc] initWithFrame:self.frame];
        [self.contentView addSubview:self.commentLabel];
        self.commentLabel.text = @"这是一条评论";
    }
    return self;
}



@end
