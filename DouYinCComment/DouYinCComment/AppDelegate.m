//
//  AppDelegate.m
//  DouYinCComment
//
//  Created by 唐天成 on 2019/4/10.
//  Copyright © 2019 唐天成. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


//点击小组件响应这里
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //都已经到跳转了,说明代码没问题了,好歹我把demo写出来助人为乐了,不去帮我点个star就是你的不对了
    UIViewController *vc = [[UIViewController alloc] init];
    if([url.absoluteString isEqualToString:@"RingToneDD://Widget/1"]) {
        //最热铃声
        vc.title = @"最火铃声";
        vc.view.backgroundColor = [UIColor redColor];
    } else if([url.absoluteString isEqualToString:@"RingToneDD://Widget/2"]) {
        //我的下载
        vc.title = @"我的下载";
        vc.view.backgroundColor = [UIColor yellowColor];
    } else if([url.absoluteString isEqualToString:@"RingToneDD://Widget/3"]) {
        //我的收藏
        vc.title = @"我的收藏";
        vc.view.backgroundColor = [UIColor purpleColor];
    } else if([url.absoluteString isEqualToString:@"RingToneDD://Widget/4"]) {
        //播放历史
        vc.title = @"播放历史";
        vc.view.backgroundColor = [UIColor blueColor];
    } else if([url.absoluteString isEqualToString:@"RingToneDD://Widget/5"]) {
        //进入我的一起听房间
        vc.title = @"一起听房间";
        vc.view.backgroundColor = [UIColor greenColor];
    }
        [(UINavigationController *)self.window.rootViewController pushViewController:vc animated:YES];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 0.0;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
