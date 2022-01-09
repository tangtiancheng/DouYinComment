//
//  ChargingAudioViewController.m
//  DouYinCComment
//
//  Created by han on 2022/1/8.
//  Copyright © 2022 唐天成. All rights reserved.
//


//iOS开发结合快捷指令和APP扩展一键设置充电音:https://www.jianshu.com/p/b4a706dc66ef

/*
 1.应该下载音频并存到APPGroup共享文件夹中,而且需要是mp3格式,如果下载下来的是aac之类的,需要转码为mp3,代码如果
 假设我的AppGroupID为 @"group.com.ChargingAudio"(这个要你自己去苹果开发者后台配置)
 
 在共享目录中创建一个文件夹(chargingAudioDirectory)用于存放充电音
 NSURL *url = [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.RingtoneIntentShare"] URLByAppendingPathComponent:@"chargingAudioDirectory"];
 [[NSFileManager defaultManager] createDirectoryAtPath:url.path withIntermediateDirectories:YES attributes:nil error:&error];
 
 //如果需要转码的话,代码如下
 #import "ExtAudioConverter.h"
 #import "lame.h"

 NSString *inputFile = @"XXXXXXXXXXXXXXXXXXXXXXXXXXXX";//这里应该是你下载下来的非MP3音频文件路径
 NSString *outFilePath = [NSString stringWithFormat:@"%@/chargingFullAudioRing.mp3",url.path];
 //2.然后将其转码为mp3
 ExtAudioConverter* converter = [[ExtAudioConverter alloc] init];
 converter.inputFile = inputFile;
 converter.outputFile = outFilePath;
  converter.outputFileType = kAudioFileMP3Type;
 converter.outputFormatID = kAudioFormatMPEGLayer3;
 [converter convert];

 //3.充电音文件已经准备好了,接下来就是给传出去, 我demo为了方便所以直接吧MP3音频放在bundle里了,但是你的肯定要放在APPgroup共享文件夹中
 在IntentHandler.m中实现如下代码
 //
 //  IntentHandler.m
 //  Shortcuts
 //
 //  Created by han on 2022/1/8.
 //  Copyright © 2022 唐天成. All rights reserved.
 //

 #import "IntentHandler.h"
 #import "ChargingAudioIntent.h"

 @interface IntentHandler ()<ChargingAudioIntentHandling>

 @end

 @implementation IntentHandler

 - (id)handlerForIntent:(INIntent *)intent {

     return self;
 }
 - (void)handleChargingAudio:(ChargingAudioIntent *)intent completion:(void (^)(ChargingAudioIntentResponse *response))completion NS_SWIFT_NAME(handle(intent:completion:))
 {
     NSURL *url = [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.ChargingAudio"] URLByAppendingPathComponent:@"chargingAudioDirectory"];
     NSString *audioPath = [NSString stringWithFormat:@"%@/chargingAudioRing.mp3",url.path];
     if([[NSFileManager defaultManager] fileExistsAtPath:audioPath]) {
         NSData *data = [NSData dataWithContentsOfFile:audioPath];
         INFile *infile = [INFile fileWithData:data filename:@"chargingAudio.mp3" typeIdentifier:nil];
         completion([ChargingAudioIntentResponse successIntentResponseWithAudioFile:infile]);
     } else {
         completion([[ChargingAudioIntentResponse alloc] initWithCode:(ChargingAudioIntentResponseCodeFailure) userActivity:nil]);
     }
 }
 @end
 
 */






#import "ChargingAudioViewController.h"
#import <WebKit/WebKit.h>




@interface ChargingAudioViewController ()

@property (nonatomic, strong) WKWebView* webView;


@end

@implementation ChargingAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    //开启手势触摸
    _webView.allowsBackForwardNavigationGestures = YES;
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    [self.view addSubview: _webView];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.jianshu.com/p/b4a706dc66ef"]
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:60.0];
    [self.webView loadRequest:request];
}



@end
