//
//  TOGradientView.h
//  TraditionalOperaDD
//
//  Created by Admin on 2019/6/6.
//  Copyright © 2019 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TOGradientView : UIView

@property(nonatomic, assign) CGPoint startPoint;

@property(nonatomic, assign) CGPoint endPoint;

@property (nonatomic, strong) NSArray *colors;

@end

NS_ASSUME_NONNULL_END
