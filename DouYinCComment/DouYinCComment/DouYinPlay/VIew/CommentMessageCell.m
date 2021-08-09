//
//  CommentMessageCell.m
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2017/7/4.
//  Copyright © 2017年 www.ShoujiDuoduo.com. All rights reserved.
//

#import "CommentMessageCell.h"
//#import "UIButton+CustomCategory.h"
//#import "TCCustomBtn.h"
//#import "UserHomeViewController.h"
#import "UIButton+WebCache.h"
#import "Masonry.h"
#import "TTCCom.h"
#import "UIView+CommonFunction.h"
#import "ReactiveObjC.h"
#import "NSDate+Helper.h"
@interface CommentMessageCell ()

//头像
@property(nonatomic, strong) UIButton *iconButton;
//姓名
@property(nonatomic, strong) UILabel *nameLabel;
//评论日期
@property(nonatomic, strong) UILabel *commentDateLabel;
//评论内容
@property(nonatomic, strong) UILabel *commentMessageLabel;


@end

@implementation CommentMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupBaseView];
    }
    return self;
}

- (void)setupBaseView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.iconButton = [[UIButton alloc]init];
    [self.contentView addSubview:self.iconButton];
    [self.iconButton setBackgroundImage:[UIImage imageNamed:@"comment_icon_placeholder"] forState:UIControlStateNormal];
    [self.iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(14   );
        make.left.with.offset(14   );
        make.width.height.mas_equalTo(34   );
    }];
    [self.iconButton createBordersWithColor:[UIColor clearColor] withCornerRadius:17    andWidth:0];
    self.iconButton.clipsToBounds = YES;
    
    
    //用户名
    self.nameLabel = [[UILabel alloc]init];
//    self.nameLabel.displaysAsynchronously = YES;
    self.nameLabel.text = @"用户名";
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.font = [UIFont systemFontOfSize:14   ];
    self.nameLabel.textColor = RGBA(74, 74, 74, 1);
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(15   );
        make.left.equalTo(self.iconButton.mas_right).with.offset(14   );
        make.right.lessThanOrEqualTo(self).with.offset(-5);
        make.height.mas_equalTo(14   );
    }];
    
    //回复日期
    self.commentDateLabel = [[UILabel alloc]init];
    self.commentDateLabel.text = @"刚刚";
    [self.contentView addSubview:self.commentDateLabel];
    self.commentDateLabel.font = [UIFont systemFontOfSize:12.5   ];
    self.commentDateLabel.textColor = RGBA(173, 178, 187, 1);//(0xadb2bb);
    [self.commentDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(7   );
        make.left.equalTo(self.iconButton.mas_right).with.offset(14   );
        make.right.lessThanOrEqualTo(self).with.offset(-5);
        make.height.mas_equalTo(12.5   );
    }];
    
    //回复内容
    self.commentMessageLabel = [[UILabel alloc]init];
//    self.commentMessageLabel.displaysAsynchronously = YES;
//    self.commentMessageLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 14    -14    -14    -34   ;

//    self.commentMessageLabel.adjustsFontSizeToFitWidth = YES;
    self.commentMessageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.commentMessageLabel.numberOfLines = 0;
    [self.contentView addSubview:self.commentMessageLabel];
    self.commentMessageLabel.font = [UIFont systemFontOfSize:14   ];
    self.commentMessageLabel.textColor = RGBA(74, 74, 74, 1);//(0x4a4a4a);
    [self.commentMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentDateLabel.mas_bottom).with.offset(14   );
        make.left.equalTo(self.iconButton.mas_right).with.offset(14   );
        make.right.with.offset(-14   );
        make.bottom.with.offset(-17   );
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = RGBA(238, 238, 238, 1);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentMessageLabel);
        make.height.mas_equalTo(1);
        make.right.bottom.with.offset(0);
    }];
    @weakify(self);
}

#pragma mark - Action


#pragma mark - Setter

- (void)setCommentModel:(CommentModel *)commentModel {
    _commentModel = commentModel;
    if([commentModel.head_url hasPrefix:@"https"]) {
        [self.iconButton sd_setImageWithURL:[NSURL URLWithString:commentModel.head_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"comment_icon_placeholder"] options:SDWebImageAllowInvalidSSLCertificates];
    } else {
        [self.iconButton sd_setImageWithURL:[NSURL URLWithString:commentModel.head_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"comment_icon_placeholder"]];
    }
    self.nameLabel.text = commentModel.name;
    self.commentDateLabel.text = [NSDate intervalFromNoewDateWithString:commentModel.createtime];
    self.commentMessageLabel.text = commentModel.comment;
}




- (void)layoutSubviews {
    [super layoutSubviews];
}


@end
