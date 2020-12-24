//
//  ListViewController.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/12/24.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "ListViewController.h"
#import "Masonry.h"
#import "UIScrollView+Interaction.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    scrollView.ringcanInteraction = YES;
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.with.offset(0);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20];
    [self.scrollView addSubview:label];
    if(self.type == 1) {
        label.text = @"播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n播放列表\n";
    } else if(self. type == 2) {
        label.text = @"歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n歌词\n";
    } else {
        label.text = @"评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n评论\n";
    }
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.with.offset(0);
        make.width.equalTo(self.view);
    }];
}




@end
