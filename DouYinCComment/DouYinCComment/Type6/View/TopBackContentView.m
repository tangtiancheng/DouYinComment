//
//  TopBackContentView.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/12/22.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "TopBackContentView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UIButton+CommonFunction.h"
#import "TTCCom.h"
#import "UIImageView+WebCache.h"
#import "ReactiveObjC.h"
#import "UIView+CommonFunction.h"
@interface TopBackContentView ()

//@property (nonatomic, strong) UIView *previousFatherView;
//退出按钮
@property (nonatomic, strong) UIButton *popBtn;
//个人头像按钮
@property (nonatomic, strong) UIButton *userIconBtn;
//背景图
@property (nonatomic, strong) UIImageView *backImageView;
//@property (nonatomic, strong) UIImageView *topBackImageView;

//铃声名字Label
@property (nonatomic, strong) UILabel *ringNameLabel;
@property (nonatomic, strong) UIView *topContentView;
@property (nonatomic, strong) UIButton *topNextBtn;
@property (nonatomic, strong) UIButton *topPlayBtn;
@property (nonatomic, strong) UILabel *topRingNameLabel;
@property (nonatomic, strong) UILabel *topArtistLabel;

//铃声名字Label的高度
@property (nonatomic, assign) CGFloat ringNameLabelHeight;
//背景图片距离屏幕上方距离Y值
@property (nonatomic, assign) CGFloat backImageVSpaceWithTop;
//背景图片距离左边距离X值
@property (nonatomic, assign) CGFloat backImageVSpaceWithLeft;
//背景图片距离下方距离
@property (nonatomic, assign) CGFloat backImageVSpaceWithBottom;
//背景图片宽高
@property (nonatomic, assign) CGFloat backImageVWH;
//aX^2  rate为a系数
@property (nonatomic, assign) CGFloat backImageVLeftRate;
@property (nonatomic, assign) CGFloat backImageVTopRate;
@property (nonatomic, assign) CGFloat backImageVWRate;
@property (nonatomic, assign) CGFloat backImageVHRate;


@end

@implementation TopBackContentView

- (void)createBaseView {
    @weakify(self);
    self.ringNameLabelHeight = [UIFont systemFontOfSize:16].lineHeight * 3;
    self.backImageVSpaceWithTop = (kDevice_Is_iPhoneX ? 44 : 20) + 9  + 32  + 23 ;
    self.backImageVSpaceWithBottom = 23 ;
    self.backImageVSpaceWithLeft = 40;
    self.backImageVWH = (SCREEN_WIDTH - 40 * 2);
    
    CGFloat smallBackImageVWH = 49 ;
    CGFloat smallBackImageVSpaceWithTop = (kDevice_Is_iPhoneX ? 24 : 0) + 20 + (70  - smallBackImageVWH)/2;
    CGFloat smallBackImageVSpaceWithLeft = 14.0 ;
    
    CGFloat x = self.maxXHeight;
    self.backImageVTopRate = (self.backImageVSpaceWithTop - smallBackImageVSpaceWithTop) / (x * x);
    self.backImageVLeftRate = (self.backImageVSpaceWithLeft - smallBackImageVSpaceWithLeft) / (x * x);
    self.backImageVWRate = (self.backImageVWH - smallBackImageVWH) / (x * x);
    self.backImageVHRate = (self.backImageVWH - smallBackImageVWH) / (x * x);
    
    self.topContentView = [[UIView alloc] init];
    [self addSubview:self.topContentView];
    self.topContentView.backgroundColor = [UIColor clearColor];
    [self.topContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.with.offset(0);
        make.top.with.offset((kDevice_Is_iPhoneX ? 44 : 20));
        make.height.mas_equalTo(self.topHeaderVHeight - (kDevice_Is_iPhoneX ? 44 : 20));
    }];
    [self.topContentView whenTapped:^{
        @strongify(self);
        if(self.delegate && [self.delegate respondsToSelector:@selector(dismissListVCBtnCLick)]) {
            [self.delegate dismissListVCBtnCLick];
        }
    }];
    self.topNextBtn = [[UIButton alloc] init];
    [self.topNextBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    [self.topNextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topContentView addSubview:self.topNextBtn];
    [self.topNextBtn setBackgroundImage:[UIImage imageNamed:@"NewRT_Top_Next"] forState:UIControlStateNormal];
    [self.topNextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topContentView);
        make.right.with.offset(-16 );
        make.width.height.mas_equalTo(18 );
    }];
    self.topPlayBtn = [[UIButton alloc] init];
    [self.topPlayBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topPlayBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    [self.topContentView addSubview:self.topPlayBtn];
    [self.topPlayBtn setBackgroundImage:[UIImage imageNamed:@"NewRT_Top_Play"] forState:UIControlStateNormal];
    [self.topPlayBtn setBackgroundImage:[UIImage imageNamed:@"NewRT_Top_Pause"] forState:UIControlStateSelected];
    [self.topPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topContentView);
        make.right.equalTo(self.topNextBtn.mas_left).with.offset(-30 );
        make.width.height.mas_equalTo(27 );
    }];
    
//    self.topBackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NewRT_PlaceHolder"]];
//    [self.topContentView addSubview:self.topBackImageView];
//    [self.topBackImageView createBordersWithColor:[UIColor clearColor] withCornerRadius:6  andWidth:0];
//    self.topBackImageView.layer.masksToBounds = YES;
//    self.topBackImageView.frame = CGRectMake(smallBackImageVSpaceWithLeft, (70  - smallBackImageVWH)/2, smallBackImageVWH, smallBackImageVWH);
    
    self.topRingNameLabel = [[UILabel alloc] init];
    self.topRingNameLabel.text = @"铃声名字";
    [self.topContentView addSubview:self.topRingNameLabel];
    self.topRingNameLabel.font = [UIFont systemFontOfSize:13 ];
    self.topRingNameLabel.textColor = [UIColor whiteColor];
    [self.topRingNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.offset(49  + 14.0  + 11 );
        make.right.equalTo(self.topPlayBtn.mas_left).with.offset(-24 );
        make.bottom.equalTo(self.topContentView.mas_centerY).with.offset(-3 );
    }];
    self.topArtistLabel = [[UILabel alloc] init];
    self.topArtistLabel.text = @"作者名字";
    [self.topContentView addSubview:self.topArtistLabel];
    self.topArtistLabel.font = [UIFont systemFontOfSize:11 ];
    self.topArtistLabel.textColor = RGBA(255, 255, 255, 0.7); 
    [self.topArtistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.offset(49  + 14.0  + 11 );
        make.right.equalTo(self.topPlayBtn.mas_left).with.offset(-24 );
        make.top.equalTo(self.topContentView.mas_centerY).with.offset(4 );
    }];
    
    self.userIconBtn = [[UIButton alloc] init];
    [self.userIconBtn addTarget:self action:@selector(userIconBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.userIconBtn];
    [self.userIconBtn setBackgroundImage:[UIImage imageNamed:@"comment_icon_placeholder"] forState:UIControlStateNormal];
    [self.userIconBtn createBordersWithColor:[UIColor clearColor] withCornerRadius:16  andWidth:0];
    self.userIconBtn.layer.masksToBounds = YES;
    self.popBtn = [[UIButton alloc] init];
    [self.popBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [self addSubview:self.popBtn];
    [self.popBtn setBackgroundImage:[UIImage imageNamed:@"NewRT_Pop"] forState:UIControlStateNormal];
    [self.popBtn addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
            self.ringNameLabel = [[UILabel alloc] init];
    self.ringNameLabel.numberOfLines = 3;
    [self addSubview:self.ringNameLabel];
    self.ringNameLabel.text = @"铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述铃声描述";
    self.ringNameLabel.textColor = RGBA(255, 255, 255, 1);
    self.ringNameLabel.font = [UIFont systemFontOfSize:16 ];
    self.backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NewRT_PlaceHolder"]];
    [self addSubview:self.backImageView];
    [self.backImageView createBordersWithColor:[UIColor clearColor] withCornerRadius:6  andWidth:0];
    self.backImageView.layer.masksToBounds = YES;
    self.backImageView.frame = CGRectMake((SCREEN_WIDTH - self.backImageVWH)/2, self.backImageVSpaceWithTop, self.backImageVWH, self.backImageVWH);

    [self.ringNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.offset( 33);
        make.right.with.offset( -33);
        make.top.with.offset(self.backImageVWH + self.backImageVSpaceWithTop + self.backImageVSpaceWithBottom);
    }];
    [self.userIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset((kDevice_Is_iPhoneX ? 24 : 0) + 29 );
        make.right.with.offset(-15);
        make.width.height.mas_equalTo(32 );
    }];
    [self.popBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.offset(14 );
        make.centerY.equalTo(self.userIconBtn);
        make.width.height.mas_equalTo(22 );
    }];
}




- (void)setIsPlay:(BOOL)isPlay {
    _isPlay = isPlay;
    if(isPlay) {
        self.topPlayBtn.selected = YES;
    } else {
        self.topPlayBtn.selected = NO;
    }
}

-(void)playBtnClick {
    self.topPlayBtn.selected = !self.topPlayBtn.selected;
}

- (void)nextBtnClick {
}

- (void)userIconBtnClick {
    //跳转到用户主页
}

- (void)exchangeByListVDrapLength:(CGFloat)length {
    self.ringNameLabel.alpha = 1 - (length) / 200.0;
    self.popBtn.alpha = 1 - (length) / 200.0;
    self.userIconBtn.alpha = 1 - (length) / 200.0;
    self.topContentView.alpha = (length - (self.maxXHeight - 200))/200.0;
    CGFloat x = length;
    self.backImageView.frame = CGRectMake(self.backImageVSpaceWithLeft - self.backImageVLeftRate * x * x, self.backImageVSpaceWithTop - self.backImageVTopRate * x * x , self.backImageVWH - self.backImageVWRate * x * x, self.backImageVWH - self.backImageVHRate * x * x);
}

- (void)popVC {
    if(self.delegate && [self.delegate respondsToSelector:@selector(popBtnClick)]) {
        [self.delegate popBtnClick];
    }
}

- (void)dealloc {
}

@end
