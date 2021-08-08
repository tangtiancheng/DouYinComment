//
//  BaseScrollViewController.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/5.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "BaseScrollViewController.h"

#pragma mark - BaseScrollView

@interface BaseScrollView ()

@property (nonatomic, strong) UIScrollView *scrollView1;
@property (nonatomic, strong) UIScrollView *scrollView2;
@property (nonatomic, strong) UIScrollView *scrollView3;
@property (nonatomic, strong) UIScrollView *scrollView4;

@property (nonatomic, assign) BOOL isDidAppeared;

@end

@implementation BaseScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.isDidAppeared = NO;
    }
    return self;
}

- (void)didAppeared {
    if(!self.isDidAppeared) {
        [self setupBaseView];
        self.isDidAppeared = YES;
       
    }
}

- (void)setupBaseView {
    self.backgroundColor = [UIColor whiteColor];
    [self scrollView1];
    [self scrollView2];
    [self scrollView3];
    [self scrollView4];
}

- (UIScrollView *)scrollView1 {
    if(!_scrollView1) {
        _scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(100, 100, 250, 100)];
        _scrollView1.backgroundColor = [UIColor redColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 40, 20)];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor blackColor];
        label.text = @"111";
        [_scrollView1 addSubview:label];
        _scrollView1.contentSize = CGSizeMake(0, 0);
        [self addSubview:_scrollView1];
    }
    return _scrollView1;
}
- (UIScrollView *)scrollView2 {
    if(!_scrollView2) {
        _scrollView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(100, 250, 250, 100)];
        _scrollView2.backgroundColor = [UIColor redColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 40, 20)];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor blackColor];
        label.text = @"222";
        [_scrollView2 addSubview:label];
        [self addSubview:_scrollView2];
        _scrollView2.contentSize = CGSizeMake(500, 0);
    }
    return _scrollView2;
}
- (UIScrollView *)scrollView3 {
    if(!_scrollView3) {
        _scrollView3 = [[UIScrollView alloc] initWithFrame:CGRectMake(100, 400, 250, 100)];
        _scrollView3.backgroundColor = [UIColor redColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 40, 20)];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor blackColor];
        label.text = @"333";
        [_scrollView3 addSubview:label];
        [self addSubview:_scrollView3];
        _scrollView3.contentSize = CGSizeMake(0, 300);
    }
    return _scrollView3;
}
- (UIScrollView *)scrollView4 {
    if(!_scrollView4) {
        _scrollView4 = [[UIScrollView alloc] initWithFrame:CGRectMake(100, 550, 250, 100)];
        _scrollView4.backgroundColor = [UIColor redColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 40, 20)];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor blackColor];
        label.text = @"444";
        [_scrollView4 addSubview:label];
        [self addSubview:_scrollView4];
        _scrollView4.contentSize = CGSizeMake(500, 300);
    }
    return _scrollView4;
}
@end


#pragma mark - BaseScrollViewController

@interface BaseScrollViewController ()

@property (nonatomic, strong) BaseScrollView *baseScrollView;

@end

@implementation BaseScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseScrollView = [[BaseScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.baseScrollView];

    [self.baseScrollView didAppeared];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.baseScrollView.frame = self.view.bounds;
}

@end
