//
//  Type5ViewControllerFirst.m
//  DouYinCComment
//
//  Created by 唐天成 on 2020/8/21.
//  Copyright © 2020 唐天成. All rights reserved.
//

#import "Type5ViewControllerFirst.h"
#import "TCNestScrollPageView.h"
#import "BaseTableViewController.h"
#import "BaseCollectionViewController.h"
#import "BaseWebViewController.h"
#import "BaseScrollViewController.h"
#import "BaseViewController.h"
#import "MyHeaderView.h"
#import "MyModel.h"
#import "TagModel.h"
#import "TagChannelView.h"

#define imageScale (18.0/11)
#define headerHeight (floor(SCREEN_WIDTH/imageScale))
#define naviHederH (kDevice_Is_iPhoneX ? 88 : 64)
#define nestScrollPageYOffset  naviHederH


@interface Type5ViewControllerFirst ()

@property (nonatomic, strong) UIView *titleHeaderView;
@property (nonatomic, strong) MyHeaderView *nestPageScrollHeaderView;
@property (nonatomic, strong) NSMutableArray<MyModel *> *homeShowModelArray;//用于首页展示的标签模型
@property (nonatomic, strong) NSMutableArray<MyModel *> *waitEditModelArray;//下方等待编辑的标签模型
@property (nonatomic, strong) NSMutableArray<UIViewController *>* subVC;
@property (nonatomic, strong) TCViewPager *viewPager;
@property (nonatomic, strong) TCNestScrollPageView *scrollPageView;

@end

@implementation Type5ViewControllerFirst

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false animated:animated];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    self.view.backgroundColor = [UIColor whiteColor];
    [self getData];
    
    NSMutableArray *arry_seg_titles = [NSMutableArray array];
    for(MyModel *model in self.homeShowModelArray) {
        UIViewController *vc = nil;
        if([model.tagID isEqualToString:@"1"]) {
            vc = [[BaseTableViewController alloc] init];
        } else if([model.tagID isEqualToString:@"2"]) {
            vc = [[BaseCollectionViewController alloc] init];
        } else if([model.tagID isEqualToString:@"3"]) {
            vc = [[BaseWebViewController alloc] init];
        } else if([model.tagID isEqualToString:@"4"]) {
            vc = [[BaseScrollViewController alloc] init];
        } else {
            vc = [[BaseViewController alloc] init];
        }
        [self.subVC addObject:vc];
        [arry_seg_titles addObject:model.title];
    }
    //分别创建 处理分页的  |  嵌套滚动的View  |  header头
    //1.创建TCViewPage处理分页(有些开发者可能之前已经写过分页的控件,只不过是没有实现嵌套滚动功能,那么你完全可以不需要用我的TCViewPager,你继续创建你项目里之前的分页控件,然后最后把你的分页控件传给TCNestScrollPageView就可以了)
    TCPageParam *pageParam = [[TCPageParam alloc] init];
    pageParam.canEdit = YES;
    pageParam.titleArray = arry_seg_titles;
    self.viewPager = [[TCViewPager alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - naviHederH) views:self.subVC param:pageParam];
    [self.viewPager editTagBtnClickBlock:^{
       @strongify(self);
       [self editTagItemArr];
   }];
    
    //2.创建你自己界面需要展示的嵌套headser
    self.nestPageScrollHeaderView = [self getHeader];
   
    //3.创建TCNestScrollPageView处理嵌套滚动
    TCNestScrollParam *nestScrollParam = [[TCNestScrollParam alloc] init];
    nestScrollParam.pageType = NestScrollPageViewHeadViewNoSuckTopType;
    nestScrollParam.yOffset = nestScrollPageYOffset;
    TCNestScrollPageView *scrollPageView = [[TCNestScrollPageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) headView:self.nestPageScrollHeaderView viewPageView:self.viewPager nestScrollParam:nestScrollParam];
    self.scrollPageView = scrollPageView;
    [self.view addSubview:scrollPageView];
    scrollPageView.didScrollBlock = ^(CGFloat dy) {
        @strongify(self);
        //滚动过程中你需要的界面UI变化
        [self nestScrollPageViewDidScroll:dy];
    };
    
    [self createtitleHeaderView];
}

//创建header
- (MyHeaderView *)getHeader {
    MyHeaderView *headerView = [[MyHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerHeight)];
    return headerView;
}

- (void)createtitleHeaderView {
    UIView *titleHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, naviHederH)];
    self.titleHeaderView = titleHeaderView;
    titleHeaderView.alpha = 0.0;
    [self.view addSubview:titleHeaderView];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerImage"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = titleHeaderView.bounds;
    imageView.clipsToBounds = YES;
    [titleHeaderView addSubview:imageView];

    //设置UIVisualEffectView
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualView.backgroundColor = RGBA(0, 0, 0, 0.3);
    visualView.frame = imageView.bounds;
    [imageView addSubview:visualView];
   
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.frame = CGRectMake(0, kDevice_Is_iPhoneX ? 44 : 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backBtn.tintColor = [UIColor whiteColor];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)nestScrollPageViewDidScroll:(CGFloat)dy {
    NSLog(@"%lf  %lf",dy,headerHeight - nestScrollPageYOffset);
    if(dy >= headerHeight - nestScrollPageYOffset) {
        self.titleHeaderView.alpha = 1;
    } else {
        self.titleHeaderView.alpha = dy / (headerHeight - nestScrollPageYOffset);
    }
    if(dy<0) {
        self.nestPageScrollHeaderView.imageView.frame = CGRectMake(0, dy, SCREEN_WIDTH, headerHeight-dy);
    } else {
        self.nestPageScrollHeaderView.imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, headerHeight);
    }
}

//编辑标签
- (void)editTagItemArr {
    NSMutableArray *homeShowTagModelArray = [NSMutableArray array];
    for (NSInteger i =0;i<self.homeShowModelArray.count;i++)
    {
        MyModel* myModel = self.homeShowModelArray[i];
        TagModel *tagModel = [[TagModel alloc] init];
        tagModel.title = myModel.title;
        tagModel.isFix = myModel.isFix;
        tagModel.isCurrentPage = (i == self.viewPager.currentIndex);
        tagModel.data = myModel;
        tagModel.isAlreadyTag = YES;
        [homeShowTagModelArray addObject:tagModel];
    }
    NSMutableArray *addTagModelArray = [NSMutableArray array];
    for (NSInteger i =0;i<self.waitEditModelArray.count;i++)
    {
       MyModel* myModel = self.waitEditModelArray[i];
       TagModel *tagModel = [[TagModel alloc] init];
       tagModel.title = myModel.title;
       tagModel.isFix = myModel.isFix;
       tagModel.isCurrentPage = NO;
       tagModel.data = myModel;
       tagModel.isAlreadyTag = NO;
       [addTagModelArray addObject:tagModel];
    }
    TAGChannelParam *param = [[TAGChannelParam alloc] init];
    param.upBtnDataArr = homeShowTagModelArray;
    param.belowBtnDataArr = addTagModelArray;
    @weakify(self);
    TagChannelView *tagChannelView = [[TagChannelView alloc] initWithParam:param mgerSuccess:^(NSMutableArray<TagModel *> * _Nonnull upDataArr, NSMutableArray<TagModel *> * _Nonnull belowDataArr, NSInteger currentIndex) {
        //如果发生了编辑操作
        @strongify(self);
        [self.waitEditModelArray removeAllObjects];
        for(TagModel *tagModel in belowDataArr) {
            [self.waitEditModelArray addObject:tagModel.data];
        }
        NSMutableArray *dataDictArr = [NSMutableArray array];
        for(TagModel *model in upDataArr) {
            [dataDictArr addObject:model.data];
        }
        [self updateViewPageWithHomeShowModelArray:dataDictArr seledtedIndex:currentIndex];
    }];
    [tagChannelView show:YES];
}

- (void)updateViewPageWithHomeShowModelArray:(NSMutableArray<MyModel *> *)newHomeShowModelArray seledtedIndex:(NSInteger)index {
    if(!newHomeShowModelArray.count) {
        return;
    }
    if(self.homeShowModelArray.count == newHomeShowModelArray.count) {
        BOOL isChange = NO;
        for(NSInteger i =0;i<self.homeShowModelArray.count;i++) {
            MyModel *oldModel = self.homeShowModelArray[i];
            MyModel *newModel = newHomeShowModelArray[i];
            isChange = ![oldModel.tagID isEqualToString:newModel.tagID];
            if(isChange) {
                break;
            }
        }
        if(!isChange) {
            if(self.viewPager) {
                [self.viewPager changeSelectedIndex:index];
                return;
            }
        }
    }
    //如果发生了改变
    [self.viewPager removeFromSuperview];
    self.viewPager = nil;
    [self createViewPagerWithArryHomeTabItems:newHomeShowModelArray seledtedIndex:index];
}

//标签发生修改
- (void)createViewPagerWithArryHomeTabItems:(NSArray<MyModel *> *)tabItems seledtedIndex:(NSInteger)index {
    //数据量少就暂且不用NSSet了,直接两层for,
    NSMutableArray<UIViewController *> *vcArr = [NSMutableArray array];
    NSMutableArray<NSString *> *arry_seg_titles = [NSMutableArray array];
    for(MyModel *newModel in tabItems) {
        [arry_seg_titles addObject:newModel.title];
        BOOL isContain = NO;
        for(NSInteger j = 0;j<self.homeShowModelArray.count;j++) {
            MyModel *oldModel = self.homeShowModelArray[j];
            isContain = [newModel isEqual:oldModel];
            if(isContain) {
                //之前的控制器还能用就不要创建新的了
                [vcArr addObject:self.subVC[j]];
                break;;
            }
        }
        if(!isContain) {
            UIViewController *vc = nil;
            if([newModel.tagID isEqualToString:@"1"]) {
                vc = [[BaseTableViewController alloc] init];
            } else if([newModel.tagID isEqualToString:@"2"]) {
                vc = [[BaseCollectionViewController alloc] init];
            } else if([newModel.tagID isEqualToString:@"3"]) {
                vc = [[BaseWebViewController alloc] init];
            } else if([newModel.tagID isEqualToString:@"4"]) {
                vc = [[BaseScrollViewController alloc] init];
            } else {
                vc = [[BaseViewController alloc] init];
            }
            [vcArr addObject:vc];
        }
    }
    self.subVC = vcArr;
     TCPageParam *pageParam = [[TCPageParam alloc] init];
     pageParam.canEdit = YES;
     pageParam.titleArray = arry_seg_titles;
    pageParam.selectIndex = index;
     self.viewPager = [[TCViewPager alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - naviHederH) views:self.subVC param:pageParam];
    @weakify(self);
     [self.viewPager editTagBtnClickBlock:^{
        @strongify(self);
        [self editTagItemArr];
    }];
    [self.scrollPageView resetViewPage:self.viewPager];
}


//返回
- (void)backClick{
    [self.navigationController popViewControllerAnimated:true];
}


- (void)getData {
    MyModel *model1 = [MyModel modelWithTagID:@"1" title:@"最热" isFix:1];
    MyModel *model2 = [MyModel modelWithTagID:@"2" title:@"彩铃" isFix:1];
    MyModel *model3 = [MyModel modelWithTagID:@"3" title:@"最新" isFix:1];
    MyModel *model4 = [MyModel modelWithTagID:@"4" title:@"DJ榜" isFix:0];
    MyModel *model5 = [MyModel modelWithTagID:@"5" title:@"睡前" isFix:0];
    MyModel *model6 = [MyModel modelWithTagID:@"6" title:@"短信" isFix:0];
    MyModel *model7 = [MyModel modelWithTagID:@"7" title:@"语录" isFix:0];
    MyModel *model8 = [MyModel modelWithTagID:@"8" title:@"动漫" isFix:0];
    MyModel *model9 = [MyModel modelWithTagID:@"9" title:@"闹铃" isFix:0];
    MyModel *model10 = [MyModel modelWithTagID:@"10" title:@"分享" isFix:0];
    [self.homeShowModelArray addObjectsFromArray:@[model1,model2,model3,model4,model5,model6,model7,model8,model9,model10]];
    MyModel *model11 = [MyModel modelWithTagID:@"11" title:@"古风" isFix:0];
    MyModel *model12 = [MyModel modelWithTagID:@"12" title:@"80后" isFix:0];
    MyModel *model13 = [MyModel modelWithTagID:@"13" title:@"欧美馆" isFix:0];
    MyModel *model14 = [MyModel modelWithTagID:@"14" title:@"90后" isFix:0];
    MyModel *model15 = [MyModel modelWithTagID:@"15" title:@"粤语" isFix:0];
    MyModel *model16 = [MyModel modelWithTagID:@"16" title:@"小视频" isFix:0];
    MyModel *model17 = [MyModel modelWithTagID:@"17" title:@"搞笑" isFix:0];
    MyModel *model18 = [MyModel modelWithTagID:@"18" title:@"孤独" isFix:0];
    MyModel *model19 = [MyModel modelWithTagID:@"19" title:@"说唱" isFix:0];
    MyModel *model20 = [MyModel modelWithTagID:@"20" title:@"甜蜜" isFix:0];
    MyModel *model21 = [MyModel modelWithTagID:@"21" title:@"民谣" isFix:0];
    MyModel *model22 = [MyModel modelWithTagID:@"22" title:@"00后" isFix:0];
    MyModel *model23 = [MyModel modelWithTagID:@"23" title:@"沙雕" isFix:0];
    MyModel *model24 = [MyModel modelWithTagID:@"24" title:@"卡点" isFix:0];
    MyModel *model25 = [MyModel modelWithTagID:@"25" title:@"二次元" isFix:0];
    [self.waitEditModelArray addObjectsFromArray:@[model11,model12,model13,model14,model15,model16,model17,model18,model19,model20,model21,model22,model23,model24,model25]];
}

#pragma mark - LazyLoad
- (NSMutableArray *)homeShowModelArray {
    if(!_homeShowModelArray) {
        _homeShowModelArray = [NSMutableArray array];
    }
    return _homeShowModelArray;
}

- (NSMutableArray *)waitEditModelArray {
    if(!_waitEditModelArray) {
        _waitEditModelArray = [NSMutableArray array];
    }
    return _waitEditModelArray;
}

- (NSMutableArray *)subVC {
    if(!_subVC) {
        _subVC  = [NSMutableArray array];
    }
    return _subVC;
}

@end
