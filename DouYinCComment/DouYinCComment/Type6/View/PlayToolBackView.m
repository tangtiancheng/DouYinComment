//
//  PlayToolBackView.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/12/22.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "PlayToolBackView.h"
#import "ZFSliderView.h"

@interface PlayToolBackView ()<ZFSliderViewDelegate>

//循环播放类型按钮
@property (nonatomic, strong) UIButton *playTypeBtn;
//上一曲按钮
@property (nonatomic, strong) UIButton *previousBtn;
//下一曲按钮
@property (nonatomic, strong) UIButton *nextBtn;
//播放按钮
@property (nonatomic, strong) UIButton *playBtn;
//定时播放按钮
@property (nonatomic, strong) UIButton *timerStopPlayBtn;

//进度条
@property (nonatomic, strong) ZFSliderView *slider;
//播放时间Label
@property (nonatomic, strong) UILabel *playTimeLabel;
//总时间Label
@property (nonatomic, strong) UILabel *totalTimeLabel;

//设铃声按钮
@property (nonatomic, strong) UIButton *setRingBtn;
//设彩铃按钮
@property (nonatomic, strong) UIButton *setColorRingBtn;
//收藏按钮
@property (nonatomic, strong) UIButton *collectBtn;
//分享按钮
@property (nonatomic, strong) UIButton *shareBtn;
//下载按钮
@property (nonatomic, strong) UIButton *downBtn;
//添加铃单按钮
@property (nonatomic, strong) UIButton *addToRingSheetBtn;



@end

@implementation PlayToolBackView

- (void)createBaseView {

    self.backgroundColor = [UIColor clearColor];
    self.playTypeBtn = [[UIButton alloc] init];
    [self.playTypeBtn addTarget:self action:@selector(playTypeChange) forControlEvents:UIControlEventTouchUpInside];
    [self.playTypeBtn setBackgroundImage:[UIImage imageNamed:@"NewRT_PlayOrder"] forState:UIControlStateNormal];
    [self addSubview:self.playTypeBtn];
    self.previousBtn = [[UIButton alloc] init];
    [self.previousBtn addTarget:self action:@selector(previousBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.previousBtn setBackgroundImage:[UIImage imageNamed:@"NewRT_Previous"] forState:UIControlStateNormal];
    [self addSubview:self.previousBtn];
    self.playBtn = [[UIButton alloc] init];
    self.playBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"NewRT_Play"] forState:UIControlStateNormal];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"NewRT_Pause"] forState:UIControlStateSelected];
    [self addSubview:self.playBtn];
    self.nextBtn = [[UIButton alloc] init];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"NewRT_Next"] forState:UIControlStateNormal];
    [self addSubview:self.nextBtn];
    self.timerStopPlayBtn = [[UIButton alloc] init];
    [self.timerStopPlayBtn addTarget:self action:@selector(closeAudioBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.timerStopPlayBtn setBackgroundImage:[UIImage imageNamed:@"NewRT_TimeClose"] forState:UIControlStateNormal];
    [self addSubview:self.timerStopPlayBtn];

    self.playTimeLabel = [[UILabel alloc] init];
    self.playTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.playTimeLabel.text = @"00:00";
    self.playTimeLabel.font = [UIFont systemFontOfSize:11 * 1];
    self.playTimeLabel.textColor = RGBCOLORVALUE(0xcccccc);
    [self addSubview:self.playTimeLabel];
    self.totalTimeLabel = [[UILabel alloc] init];
    self.totalTimeLabel.textAlignment = NSTextAlignmentRight;
    self.totalTimeLabel.text = @"00:00";
    self.totalTimeLabel.font = [UIFont systemFontOfSize:11 * 1];
    self.totalTimeLabel.textColor = RGBCOLORVALUE(0xcccccc);
    [self addSubview:self.totalTimeLabel];
    self.slider = [[ZFSliderView alloc] init];
//    [self.slider setEnlargeEdgeWithTop:0 right:50 bottom:0 left:50];
    self.slider.delegate = self;
    self.slider.maximumTrackTintColor = RGBA(255,255,255,0.5);
    self.slider.minimumTrackTintColor = RGBA(255, 255, 255, 0.7);
    self.slider.bufferTrackTintColor = RGBCOLORVALUE(0xcccccc);
    [self.slider setThumbBackGroundColor:[UIColor whiteColor]];
    self.slider.thumbSize = CGSizeMake(14 * 1, 14 * 1);
    [self.slider.sliderBtn createBordersWithColor:[UIColor clearColor] withCornerRadius:7 *1 andWidth:0];
    self.slider.sliderHeight = 2;
    self.slider.totleTime = 0;
//        self.slider.bufferValue = [AudioPlayerAdapter sharedPlayerAdapter].buffProgress;
    [self addSubview:self.slider];
    
    self.setRingBtn = [[UIButton alloc] init];
    [self.setRingBtn createBordersWithColor:RGBA(255, 255, 255, 0.5) withCornerRadius:12.5 * 1 andWidth:1];
    [self.setRingBtn addTarget:self action:@selector(setRingBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    [self.setRingBtn setTitle:@"设铃声" forState:UIControlStateNormal];
    [self.setRingBtn setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
    self.setRingBtn.titleLabel.font = [UIFont systemFontOfSize:11 * 1];
    [self addSubview:self.setRingBtn];
    self.setColorRingBtn = [[UIButton alloc] init];
    [self.setColorRingBtn addTarget:self action:@selector(setColorRingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.setColorRingBtn createBordersWithColor:RGBA(255, 255, 255, 0.5) withCornerRadius:12.5 * 1 andWidth:1];
    [self.setColorRingBtn setTitle:@"设彩铃" forState:UIControlStateNormal];
    [self.setColorRingBtn setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
    self.setColorRingBtn.titleLabel.font = [UIFont systemFontOfSize:11 * 1];
    [self addSubview:self.setColorRingBtn];
    self.collectBtn = [[UIButton alloc] init];
    [self.collectBtn addTarget:self action:@selector(collectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.collectBtn setBackgroundImage:[UIImage imageNamed:@"NewRT_AddCollect"] forState:UIControlStateNormal];
    [self.collectBtn setBackgroundImage:[UIImage imageNamed:@"NewRT_AlreadyCollect"] forState:UIControlStateSelected];
    [self addSubview:self.collectBtn];
    
    self.shareBtn = [[UIButton alloc] init];
    [self.shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"NewRT_Share"] forState:UIControlStateNormal];
    [self addSubview:self.shareBtn];
    
    self.downBtn = [[UIButton alloc] init];
    [self.downBtn addTarget:self action:@selector(downBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.downBtn setBackgroundImage:[UIImage imageNamed:@"NewRT_Down"] forState:UIControlStateNormal];
    [self addSubview:self.downBtn];
    
    self.addToRingSheetBtn = [[UIButton alloc] init];
    [self.addToRingSheetBtn addTarget:self action:@selector(addRingSheetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.addToRingSheetBtn setBackgroundImage:[UIImage imageNamed:@"NewRT_AddToSheet"] forState:UIControlStateNormal];
    [self addSubview:self.addToRingSheetBtn];

    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.with.offset(-31 * 1);
        make.centerX.with.offset(0);
        make.width.height.mas_equalTo(63 * 1);
    }];
    [self.playTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.offset(1 * 27);
        make.centerY.equalTo(self.playBtn);
        make.width.height.mas_equalTo(23 * 1);
    }];
    [self.previousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playTypeBtn.mas_right).with.offset(1 * 61);
        make.centerY.equalTo(self.playBtn);
        make.width.height.mas_equalTo(23 * 1);
    }];
    [self.timerStopPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.with.offset(-1 * 27);
        make.centerY.equalTo(self.playBtn);
        make.width.height.mas_equalTo(23 * 1);
    }];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timerStopPlayBtn.mas_left).with.offset(-1 * 61);
        make.centerY.equalTo(self.playBtn);
        make.width.height.mas_equalTo(23 * 1);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.playBtn.mas_top).with.offset(-35 * 1);
        make.left.with.offset(1 * 27);
        make.right.with.offset(1 * -27);
        make.height.mas_equalTo(16 * 1);
    }];
    
    [self.playTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.slider);
        make.width.mas_equalTo(39 * 1);
        make.top.equalTo(self.slider.mas_bottom).with.offset(9 * 1);
    }];
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.slider);
        make.width.mas_equalTo(39 * 1);
        make.top.equalTo(self.slider.mas_bottom).with.offset(9 * 1);
    }];
    
    [self.setRingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25 * 1);
        make.right.with.offset(-27 * 1);
        make.width.mas_equalTo(57 * 1);
        make.bottom.equalTo(self.slider.mas_top).with.offset(-36 * 1);
    }];
    [self.setColorRingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25 * 1);
        make.width.mas_equalTo(57 * 1);
        make.centerY.equalTo(self.setRingBtn);
        make.right.equalTo(self.setRingBtn.mas_left).with.offset(-1 * 12);
    }];
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.offset(1 * 27);
        make.centerY.equalTo(self.setRingBtn);
        make.width.height.mas_equalTo(23 * 1);
    }];
    [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.collectBtn.mas_right).with.offset(1 * 30);
        make.centerY.equalTo(self.setRingBtn);
        make.width.height.mas_equalTo(23 * 1);
    }];
    
    [self.addToRingSheetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.downBtn.mas_right).with.offset(1 * 30);
        make.centerY.equalTo(self.setRingBtn);
        make.width.height.mas_equalTo(23 * 1);
    }];
   
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addToRingSheetBtn.mas_right).with.offset(1 * 30);
        make.centerY.equalTo(self.setRingBtn);
        make.width.height.mas_equalTo(23 * 1);
    }];
}

- (void)playTypeChange {
}
- (void)previousBtnClick {
}

- (void)setRingBtnCLick {
}
- (void)setColorRingBtnClick {
}
- (void)setLiveBtnCLick {
  
}
- (void)shareBtnClick {
}

- (void)nextBtnClick {
}
- (void)closeAudioBtnClick {
}

-(void)playBtnClick {
}

- (void)addRingSheetBtnClick {
}

- (void)downBtnClick {
}

- (void)collectBtnClick {
}

- (void)exchangeByListVDrapLength:(CGFloat)length {
    self.alpha = 1 - (length) / 200.0;
}


@end
