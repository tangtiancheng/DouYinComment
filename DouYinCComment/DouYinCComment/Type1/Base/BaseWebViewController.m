//
//  BaseWebViewController.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/3.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "BaseWebViewController.h"
#import <WebKit/WebKit.h>

#pragma mark - BaseWebView
@interface BaseWebView ()

@property (nonatomic, strong) WKWebView* webView;
@property (nonatomic, assign) BOOL isDidAppeared;

@end

@implementation BaseWebView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.isDidAppeared = NO;
        
    }
    return self;
}
- (void)didAppeared {
    if(!self.isDidAppeared) {
        [self setupBaseView];
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]
                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:60.0];
        [self.webView loadRequest:request];
        self.isDidAppeared = YES;
    }
}

- (void)setupBaseView {
    self.backgroundColor = [UIColor blueColor];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    //允许视频播放
    config.allowsAirPlayForMediaPlayback = YES;
    // 允许在线播放
    config.allowsInlineMediaPlayback = YES;
    //    // 允许可以与网页交互，选择视图
    config.selectionGranularity = WKSelectionGranularityCharacter;
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    if (@available(iOS 10.0, *)) {
        config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    } else {
        config.mediaPlaybackRequiresUserAction = false;
    }
    
    _webView = [[WKWebView alloc] initWithFrame:self.bounds configuration:config];
    //开启手势触摸
    _webView.allowsBackForwardNavigationGestures = YES;
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    [self addSubview: _webView];
   
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.webView.frame = self.bounds;
}

@end

#pragma mark - BaseWebViewController

@interface BaseWebViewController ()

@property (nonatomic, strong) BaseWebView *baseWebView;

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseWebView = [[BaseWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.baseWebView];
    [self.baseWebView didAppeared];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.baseWebView.frame = self.view.bounds;
}

@end
