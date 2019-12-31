//
//  AppConfigure.m
//  GaragebandTest
//
//  Created by 唐天成 on 2019/6/15.
//  Copyright © 2019 TT. All rights reserved.
//

#import "AppConfigure.h"

@implementation AppConfigure


+ (AppConfigure *)sharedAppConfigure {
    
    static AppConfigure *configure;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configure = [[AppConfigure alloc] init];
    });
    return configure;
}


- (id) init
{
    self = [super init];
    if (self)
    {
        [self configFileDirectory];
        
    }
    return self;
}

- (void) configFileDirectory
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *dir = [array objectAtIndex:0];
    NSString *cacheDirectory = dir;
    
    self.bandfolder = [cacheDirectory stringByAppendingPathComponent:@"bandfolder"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:self.bandfolder]) {
        BOOL success = [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"bandfolder.band" ofType:nil] toPath:self.bandfolder error:NULL];
    }
    
    self.bandfolderDirectory = [cacheDirectory stringByAppendingPathComponent:@"bandfolderDirectory"];
   
    BOOL isDirectory = FALSE;
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:self.bandfolderDirectory isDirectory:&isDirectory])
    {
        [fileMgr createDirectoryAtPath:self.bandfolderDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
  
}

@end
