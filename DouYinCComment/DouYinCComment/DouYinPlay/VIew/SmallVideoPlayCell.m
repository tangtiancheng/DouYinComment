//
//  SmallVideoPlayCell.m
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2019/1/5.
//  Copyright © 2019年 duoduo. All rights reserved.
//

#import "SmallVideoPlayCell.h"
#import "FavoriteView.h"
#import "Masonry.h"
#import "TTCCom.h"
#import "UIView+CommonFunction.h"
#import "ReactiveObjC.h"
#import "UIImageView+WebCache.h"
@interface SmallVideoPlayCell ()

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UIImageView *share;
@property (nonatomic, strong) UILabel *shareNum;

@property (nonatomic, strong) UIImageView *comment;
@property (nonatomic, strong) UILabel *commentNum;

@property (nonatomic, strong) FavoriteView *favorite;
@property (nonatomic, strong) UILabel *favoriteNum;

@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIImageView *focus;

@property (nonatomic, strong) UIImageView *setRingImage;
@property (nonatomic, strong) UILabel *setRingNameLabel;

@property (nonatomic, strong) UIImageView *setLivePhotoImage;
@property (nonatomic, strong) UILabel *setLivePhotoNameLabel;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *artistLabel;

@end

@implementation SmallVideoPlayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        UIView *bottomView = [[UIView alloc] init];
        [self.contentView addSubview:bottomView];
        bottomView.backgroundColor = [UIColor blackColor];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.with.offset(0);
            if(kDevice_Is_iPhoneX) {
                make.height.mas_equalTo(83);
            } else {
                make.height.mas_equalTo(0);
            }
        }];
        
        self.coverImageView = [[UIImageView alloc] init];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.coverImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.coverImageView];
        self.imageView.backgroundColor = [UIColor blackColor];
        self.contentView.backgroundColor = [UIColor blackColor];
        [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.with.offset(0);
            make.bottom.equalTo(bottomView.mas_top);
        }];
        self.playerFatherView = [[UIView alloc] init];
        [self.contentView addSubview:self.playerFatherView];
        [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.with.offset(0);
            make.bottom.equalTo(bottomView.mas_top);
        }];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CAGradientLayer *gradientLayer = [CAGradientLayer new];
        
        gradientLayer.frame = CGRectMake(SCREEN_WIDTH - 100 , 0, 100 , SCREEN_HEIGHT);
        //colors存放渐变的颜色的数组
        gradientLayer.colors=@[(__bridge id)RGBA(0, 0, 0, 0.5).CGColor,(__bridge id)RGBA(0, 0, 0, 0.0).CGColor];
//        gradientLayer.locations = @[@0.3, @0.5, @1.0];
        /**
         * 起点和终点表示的坐标系位置，(0,0)表示左上角，(1,1)表示右下角
         */
        gradientLayer.startPoint = CGPointMake(1, 0);
        gradientLayer.endPoint = CGPointMake(0, 0);
        //    layer.frame = self.messageLabel.bounds;
        [self.contentView.layer addSublayer:gradientLayer];
        
        
        
        _setRingImage = [[UIImageView alloc]init];
        _setRingImage.contentMode = UIViewContentModeScaleAspectFit;
        _setRingImage.image = [UIImage imageNamed:@"videoRing"];
        _setRingImage.userInteractionEnabled = YES;
        //        _share.tag = kAwemeListLikeShareTag;
        //        [_share addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
        [self.contentView addSubview:_setRingImage];
        
        _setRingNameLabel = [[UILabel alloc]init];
        _setRingNameLabel.text = @"设为铃声";
        _setRingNameLabel.textColor = [UIColor whiteColor];//ColorWhite;
        _setRingNameLabel.font = [UIFont systemFontOfSize:12 ];//SmallFont;
        [self.contentView addSubview:_setRingNameLabel];
        _setRingNameLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
        _setRingNameLabel.layer.shadowOpacity = 0.3;
        _setRingNameLabel.layer.shadowOffset = CGSizeMake(0, 1);
        
        _setLivePhotoImage = [[UIImageView alloc]init];
        _setLivePhotoImage.contentMode = UIViewContentModeScaleAspectFit;
        _setLivePhotoImage.image = [UIImage imageNamed:@"LivePhoto"];
        _setLivePhotoImage.userInteractionEnabled = YES;
        //        _share.tag = kAwemeListLikeShareTag;
        //        [_share addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
        [self.contentView addSubview:_setLivePhotoImage];
        
        _setLivePhotoNameLabel = [[UILabel alloc]init];
        _setLivePhotoNameLabel.text = @"动态壁纸";
        _setLivePhotoNameLabel.textColor = [UIColor whiteColor];//ColorWhite;
        _setLivePhotoNameLabel.font = [UIFont systemFontOfSize:12 ];//SmallFont;
        [self.contentView addSubview:_setLivePhotoNameLabel];
        _setLivePhotoNameLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
        _setLivePhotoNameLabel.layer.shadowOpacity = 0.3;
        _setLivePhotoNameLabel.layer.shadowOffset = CGSizeMake(0, 1);
        
        
        //init share、comment、like action view
        _share = [[UIImageView alloc]init];
        _share.contentMode = UIViewContentModeCenter;
        _share.image = [UIImage imageNamed: @"smallVideo_home_share"];
        _share.userInteractionEnabled = YES;
//        _share.tag = kAwemeListLikeShareTag;
//        [_share addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
        [self.contentView addSubview:_share];
        
        _shareNum = [[UILabel alloc]init];
        _shareNum.text = @"其他";
        _shareNum.textColor = [UIColor whiteColor];//ColorWhite;
        _shareNum.font = [UIFont systemFontOfSize:12 ];//SmallFont;
        [self.contentView addSubview:_shareNum];
        _shareNum.layer.shadowColor = [[UIColor blackColor] CGColor];
        _shareNum.layer.shadowOpacity = 0.3;
        _shareNum.layer.shadowOffset = CGSizeMake(0, 1);
        
        _comment = [[UIImageView alloc]init];
        _comment.contentMode = UIViewContentModeCenter;
        _comment.image = [UIImage imageNamed:@"smallVideo_home_comment"];
        _comment.userInteractionEnabled = YES;
//        _comment.tag = kAwemeListLikeCommentTag;
//        [_comment addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
        [self.contentView addSubview:_comment];
        
        _commentNum = [[UILabel alloc]init];
        _commentNum.text = @"0";
        _commentNum.textColor = [UIColor whiteColor];//ColorWhite;
        _commentNum.font = [UIFont systemFontOfSize:12 ];//SmallFont;
        [self.contentView addSubview:_commentNum];
        _commentNum.layer.shadowColor = [[UIColor blackColor] CGColor];
        _commentNum.layer.shadowOpacity = 0.3;
        _commentNum.layer.shadowOffset = CGSizeMake(0, 1);
//        _commentNum.backgroundColor = [UIColor redColor];
        
        _favorite = [FavoriteView new];
        [self.contentView addSubview:_favorite];
        
        _favoriteNum = [[UILabel alloc]init];
        _favoriteNum.text = @"0";
        _favoriteNum.textColor = [UIColor whiteColor];//ColorWhite;
        _favoriteNum.font = [UIFont systemFontOfSize:12 ];//SmallFont;
        [self.contentView addSubview:_favoriteNum];
        _favoriteNum.layer.shadowColor = [[UIColor blackColor] CGColor];
        _favoriteNum.layer.shadowOpacity = 0.3;
        _favoriteNum.layer.shadowOffset = CGSizeMake(0, 1);
        
        _avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        [_avatar createBordersWithColor:[UIColor whiteColor] withCornerRadius:25  andWidth:1];
        _avatar.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatar];
        
        _focus = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smallVideo_personal_add_little"]];
        _focus.backgroundColor = RGBA(222, 67, 88, 1);
        [_focus createBordersWithColor:[UIColor clearColor] withCornerRadius:12   andWidth:0];
        _focus.layer.masksToBounds = YES;
        _focus.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_focus];
        
        _artistLabel = [[UILabel alloc] init];
        _artistLabel.textColor = RGBA(255, 255, 255, 1);
        _artistLabel.font = [UIFont systemFontOfSize:17 ];
        _artistLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
        _artistLabel.layer.shadowOpacity = 0.3;
        _artistLabel.layer.shadowOffset = CGSizeMake(0, 1);
        [self.contentView addSubview:_artistLabel];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textColor = RGBA(255, 255, 255, 1);;//RGBA(165, 165, 165, 1);
        _nameLabel.font = [UIFont systemFontOfSize:12 ];
        _nameLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
        _nameLabel.layer.shadowOpacity = 0.3;
        _nameLabel.layer.shadowOffset = CGSizeMake(0, 1);
        [self.contentView addSubview:_nameLabel];
        
        @weakify(self);
        [_setRingImage whenTapped:^{
            @strongify(self);
            [self setRing];
        }];
        
        [_setLivePhotoImage whenTapped:^{
            @strongify(self);
            [self setLivePhoto];
        }];
        
        _favorite.clickBlock = ^(BOOL isChoose) {
            @strongify(self);
            [self favoriteOrDelVideo:isChoose];
        };
        [_avatar whenTapped:^{
            @strongify(self);
            [self pushToPersonalMessageVC];
        }];
        [_focus whenTapped:^{
            @strongify(self);
            [self addConcern];
        }];
        [_share whenTapped:^{
            @strongify(self);
            [self shareVideo];
        }];
        [_comment whenTapped:^{
            @strongify(self);
            [self commentVidieo];
        }];
        [_setRingImage mas_makeConstraints:^(MASConstraintMaker *make) {
            if(kDevice_Is_iPhoneX) {
                make.bottom.with.offset(-150);
            } else {
                make.bottom.with.offset(-135 );
            }
            make.right.with.offset(-10 );
            make.width.mas_equalTo(45 );
            make.height.mas_equalTo(45 );
        }];
        [_setRingNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.setRingImage.mas_bottom).with.offset(5 );
            make.centerX.equalTo(self.setRingImage);
        }];
        
        [_setLivePhotoImage mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.bottom.equalTo(_setRingImage.mas_top).with.offset(-40 );
            
            make.right.with.offset(-10 );
            make.width.mas_equalTo(50 );
            make.height.mas_equalTo(45 );
        }];
        [_setLivePhotoNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.setLivePhotoImage.mas_bottom).with.offset(5 );
            make.centerX.equalTo(self.setLivePhotoImage);
        }];
        
        
        [_share mas_makeConstraints:^(MASConstraintMaker *make) {
            if(kDevice_Is_iPhoneX) {
                make.bottom.equalTo(_setLivePhotoImage.mas_top).with.offset(-40 );
            } else {
                make.bottom.equalTo(_setLivePhotoImage.mas_top).with.offset(-40 );
            }
            make.right.with.offset(-10 );
            make.width.mas_equalTo(50 );
            make.height.mas_equalTo(45 );
        }];
        [_shareNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.share.mas_bottom);
            make.centerX.equalTo(self.share);
        }];
        [_comment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.share.mas_top).with.offset(-25 );
            make.right.equalTo(self).with.offset(-10 );
            make.width.mas_equalTo(50 );
            make.height.mas_equalTo(45 );
        }];
        [_commentNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.comment.mas_bottom);
            make.centerX.equalTo(self.comment);
        }];
        [_favorite mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.comment.mas_top).with.offset(-25 );
            make.right.equalTo(self).with.offset(-10 );
            make.width.mas_equalTo(50 );
            make.height.mas_equalTo(45 );
        }];
        [_favoriteNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.favorite.mas_bottom);
            make.centerX.equalTo(self.favorite);
        }];
        [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_favorite);
            make.bottom.equalTo(self.favorite.mas_top).with.offset(-35 );
            make.width.height.mas_equalTo(50 );
        }];
        [_focus mas_makeConstraints:^(MASConstraintMaker *make) {
             make.width.height.mas_equalTo(24 );
            make.centerX.equalTo(self.avatar);
            make.centerY.equalTo(_avatar.mas_bottom);
        }];
        [_artistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.with.offset(15 );
            if(kDevice_Is_iPhoneX) {
                make.top.equalTo(self.contentView.mas_bottom).with.offset(-(83  - 10 ));
            } else {
                make.top.equalTo(self.contentView.mas_bottom).with.offset(-83 );
            }
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.with.offset(15 );
            make.width.mas_equalTo(SCREEN_WIDTH * 2 / 3);
            make.top.equalTo(_artistLabel.mas_bottom).with.offset(3 );
        }];
        
       
    }
    return self;
}


- (void)setModel:(SmallVideoModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    if(model.artist.length) {
        self.artistLabel.text = [NSString stringWithFormat:@"@%@",model.artist];
    } else {
        self.artistLabel.text = @"";
    }
    self.commentNum.text = @(model.comment_num).stringValue;
    self.favoriteNum.text = @(model.score).stringValue;
    
    if(model.aspect >= 1.4) {
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    } else {
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString: model.cover_url]];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.head_url] placeholderImage:[UIImage imageNamed:@"comment_icon_placeholder"]];
  
    self.focus.hidden = NO;
    self.favorite.isChoose = NO;
    
    
}

#pragma mark - Action

//关注
- (void)addConcern {
    
    if([self.delegate respondsToSelector:@selector(handleAddConcerWithVideoModel:)]) {
        [self.delegate handleAddConcerWithVideoModel:self.model];
    }
}

//进入个人主页
- (void)pushToPersonalMessageVC {
//    NSArray *a = self.viewController.navigationController.childViewControllers;
//    if(a.count > 1) {
//        if([a[a.count-2] isMemberOfClass:[UserHomeViewController class]]) {
//            return;
//        }
//    }
//    if([self.delegate respondsToSelector:@selector(handleClickPersonIcon:)]) {
//        [self.delegate handleClickPersonIcon:self.model];
//    }
}

//收藏视频
- (void)favoriteOrDelVideo:(BOOL)choose {
    if([self.delegate respondsToSelector:@selector(handleFavoriteVdieoModel:)] && choose) {
        [self.delegate handleFavoriteVdieoModel:self.model ];
    } else if([self.delegate respondsToSelector:@selector(handleDeleteFavoriteVdieoModel:)] && !choose) {
        [self.delegate handleDeleteFavoriteVdieoModel:self.model];
    }
}

//评论
- (void)commentVidieo {
    if([self.delegate respondsToSelector:@selector(handleCommentVidieoModel:)]) {
        [self.delegate handleCommentVidieoModel:self.model];
    }
}

//分享
- (void)shareVideo {
    if([self.delegate respondsToSelector:@selector(handleShareVideoModel:)]) {
        [self.delegate handleShareVideoModel:self.model];
    }
}

//设置铃声
- (void)setRing {
    if([self.delegate respondsToSelector:@selector(handleSetRingVideoModel:)]) {
        [self.delegate handleSetRingVideoModel:self.model];
    }
}

//设置动态壁纸
- (void)setLivePhoto {
    if([self.delegate respondsToSelector:@selector(handleSetRingVideoModel:)]) {
        [self.delegate handleSetLivePhoto:self.model];
    }
}

- (void)dealloc {
}

@end
