//
//  TOGradientView.m
//  TraditionalOperaDD
//
//  Created by Admin on 2019/6/6.
//  Copyright © 2019 Admin. All rights reserved.
//

#import "TOGradientView.h"

@interface TOGradientView ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation TOGradientView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareDefault];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        self.gradientLayer.frame = self.bounds;
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self prepareDefault];

}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
    
}

-(void)prepareDefault{
    _startPoint = CGPointMake(0, 1);
    _endPoint = CGPointMake(0, 0);
    _colors = @[(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor, (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6].CGColor];
}

-(void)setStartPoint:(CGPoint)startPoint{
    _startPoint = startPoint;
    self.gradientLayer.startPoint = startPoint;
}

-(void)setEndPoint:(CGPoint)endPoint{
    _endPoint = endPoint;
    self.gradientLayer.endPoint = endPoint;
}

-(void)setColors:(NSArray *)colors{
    _colors = colors;
    self.gradientLayer.colors = colors;
}

-(CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        [self.layer insertSublayer:gradientLayer atIndex:0];
        gradientLayer.startPoint = self.startPoint;
        gradientLayer.endPoint = self.endPoint;
        gradientLayer.colors = self.colors;
        _gradientLayer = gradientLayer;
    }
    return _gradientLayer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
