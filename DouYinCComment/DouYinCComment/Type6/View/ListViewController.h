//
//  ListViewController.h
//  DouYinCComment
//
//  Created by 唐天成 on 2020/12/24.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
