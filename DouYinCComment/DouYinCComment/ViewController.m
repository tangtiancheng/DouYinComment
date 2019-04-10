//
//  ViewController.m
//  DouYinCComment
//
//  Created by 唐天成 on 2019/4/10.
//  Copyright © 2019 唐天成. All rights reserved.
//

#import "ViewController.h"
#import "TCCommentsPopView.h"
#import "MyCommentView.h"

@interface ViewController ()<MyCommentViewDelegate>

@property (nonatomic, strong) TCCommentsPopView *popView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:btn];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"打开评论" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)open {
    MyCommentView *commentView = [[MyCommentView alloc]init];
    commentView.delegate = self;
    self.popView = [TCCommentsPopView commentsPopViewWithFrame:[UIScreen mainScreen].bounds commentBackView:commentView];
    [self.popView showToView:self.view];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

#pragma mark - MyCommentViewDelegate
- (void)closeComment {
    [self.popView dismiss];
}

@end
