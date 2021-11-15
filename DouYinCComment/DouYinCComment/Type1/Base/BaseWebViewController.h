//
//  BaseWebViewController.h
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/3.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseWebView : UIView

@property (nonatomic, strong, readonly) WKWebView* webView;

- (void)didAppeared;

@end


@interface BaseWebViewController : UIViewController

@property (nonatomic, strong, readonly) BaseWebView *baseWebView;

@end

NS_ASSUME_NONNULL_END
