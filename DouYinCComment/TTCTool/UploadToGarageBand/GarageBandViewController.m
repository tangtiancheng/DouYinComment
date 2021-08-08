//
//  GarageBandViewController.m
//  DouYinCComment
//
//  Created by 唐天成 on 2019/12/31.
//  Copyright © 2019 唐天成. All rights reserved.
//

#import "GarageBandViewController.h"
#import "ExtAudioConverter.h"
#import "AppConfigure.h"

@interface GarageBandViewController ()

@end

@implementation GarageBandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 300, 100)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"上传音频到库乐队" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(upload) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)upload {
    //这个是你的音频路径
    NSString *inputFile = nil;
    inputFile =  [[NSBundle mainBundle] pathForResource:@"牡丹亭外.m4a" ofType:nil];
    NSString *fileName=[[inputFile lastPathComponent] stringByDeletingPathExtension];
    
    
    //1.先拷贝一个bandFolder
    NSString *copyAtPath = [AppConfigure sharedAppConfigure].bandfolder;
    NSString *copyToPath = [[AppConfigure sharedAppConfigure].bandfolderDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.band",fileName]];
    [[NSFileManager defaultManager] copyItemAtPath:copyAtPath toPath:copyToPath error:NULL];
    //2.然后要把你自己的音频转码为aiff
    ExtAudioConverter* converter = [[ExtAudioConverter alloc] init];
    converter.inputFile = inputFile;
    converter.outputFile = [NSString stringWithFormat:@"%@/Media/ringtone.aiff",copyToPath];
    converter.outputFileType = kAudioFileAIFFType;
    [converter convert];
    
    BOOL b = [[NSFileManager defaultManager] fileExistsAtPath:copyToPath];
    
    //3.弹出分享框并进行分享
    NSArray *items = [NSArray arrayWithObjects:[NSURL fileURLWithPath:copyToPath],nil];
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
    
    // 分享之后的回调
    activityViewController.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
        } else  if(activityError){
        }
    };
    [self presentViewController:activityViewController animated:YES completion:^{
    }];
       
}


@end
