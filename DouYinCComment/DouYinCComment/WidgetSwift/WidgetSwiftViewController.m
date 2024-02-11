//
//  WidgetSwiftViewController.m
//  DouYinCComment
//
//  Created by 唐天成 on 2024/2/6.
//  Copyright © 2024 唐天成. All rights reserved.
//

#import "WidgetSwiftViewController.h"
#import "DouYinCComment-Swift.h"

@interface WidgetSwiftViewController ()

@end

@implementation WidgetSwiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WidgetSwiftView *widgetSwiftView = [[WidgetSwiftView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:widgetSwiftView];
    
    // Do any additional setup after loading the view.
}



@end
