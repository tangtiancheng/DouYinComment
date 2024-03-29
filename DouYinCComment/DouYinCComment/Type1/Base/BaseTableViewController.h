//
//  BaseTableViewController.h
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/3.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableView : UIView

@property (nonatomic, strong, readonly) UITableView *tableView;

- (void)didAppeared;

@end

@interface BaseTableViewController : UIViewController

@property (nonatomic, strong, readonly) BaseTableView *baseTableView;


@end

NS_ASSUME_NONNULL_END
