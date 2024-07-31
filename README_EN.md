# DouYinComment

- [中文](https://github.com/tangtiancheng/DouYinComment/blob/master/README.md)

支持pod导入:  
pod 'TTCTool  
或者只导入单个功能  
抖音评论效果: pod 'TTCTool/TCCommentsPopView'  
抖音转场动画: pod 'TTCTool/TTCTransition'  
抖音左滑进入个人主页: pod 'TTCTool/TTCPanPush'  
分页: pod 'TTCTool/TCViewPage'  
标签管理: pod 'TTCTool/TagChannelManager'  




这些功能大部分都是我在 "铃声多多"APP里已经用了,iOS端日活有70万左右, 常年保持AppStore 排行榜100多名, 不是让你们当小白鼠哈，仅仅为了自己记录(装逼)一下, 外加能帮别人一点是一点吧,有需要就拿去用!
这个Demo主要功 能:

## 1.iOS播放gif视频小组件,小组件帧动画,摇摇乐小组件,动态Widget, 网易云iOS可编辑小组件, 风扇小组件, 时钟小组件, 滚动照片小组件, 自己去跑起来看吧!

![image](https://github.com/tangtiancheng/ttcgif/blob/master/gif/小组件动画.gif)
![image](https://github.com/tangtiancheng/ttcgif/blob/master/gif/小组件添加.gif)
![image](https://github.com/tangtiancheng/ttcgif/blob/master/gif/小组件编辑.gif)



## 2.这个Demo有仿照抖音的小视频评论手势拖拽效果 (直接将TCCommentsPopView这个类拖入您的项目即可使用,很简单)
可以说完全和抖音的效果一模一样,该功能我已经在"铃声多多"项目中使用. 我在github,cocoachina,coco4app等网址上找了很久,都没有一个demo是能完全和抖音的一致的.如果觉得好用希望给一个star

![image](https://github.com/tangtiancheng/ttcgif/blob/master/gif/comment.gif)

## 3.一行代码实现仿抖音左滑Push进个人主页功能
  一行代码实现仿抖音 左滑 push进入个人主页,  
    1.把TTCPanPushTransition文件夹拖入你的项目中,  
    2.在需要push的控制器类中  #import "UIViewController+TTCPanPush.h"  
    3.然后在videDidLoad方法中调用getpanPushToViewController:方法, block返回你的个人主页控制器类  
     不会侵入你自己的原有代码,详细看demo 
     
     
    [self getpanPushToViewController:^UIViewController * _Nonnull{
        //这个应该是你的个人主页控制器
        Type4ViewControllerThird *vc = [[Type4ViewControllerThird alloc] init];
        return vc;
    }];
    

![image](https://github.com/tangtiancheng/ttcgif/blob/master/gif/panPush.gif)

## 4.抖音视频播放转场动画(github上其它demo并未做到和抖音一样,或者耦合度太高需要侵入你的代码,让你改很多东西才能实现,我自己封装了一个,只需将TTCTransition文件夹拖入你的项目,然后添加两行代码就行,完全不需要侵入修改你原有的代码. 希望大佬们多提意见)
一行或者两行代码实现抖音视频播放转场动画,支持push和present,两行代码脑残式操作,自己看下代码
首先将TTCTransition文件夹拖入你的项目中,
#import "TTCTransitionDelegate.h"

第一行:假设需要转场的控制器叫myVC,  那么调用myVC.ttcTransitionDelegate = [[TTCTransitionDelegate alloc] init];

第二行:抖音的转场动画效果是一个小窗口cell扩大到全屏播放界面,所以需要将小窗口cell传给我,不传也可以,默认就是从中心开始扩大,myVC.ttcTransitionDelegate.smalCurPlayCell = cell

![image](https://github.com/tangtiancheng/ttcgif/blob/master/gif/TTCTransition.gif)



## 5.模仿抖音播放小视频功能;(这个功能网上有很多其它更优秀的Demo,所以大家可能需求不大)
### (1).支持边下边播
### (2).支持视频预加载
![image](https://github.com/tangtiancheng/ttcgif/blob/master/gif/smallVideoImage.gif)

## 6.和铃声多多一样,支持上传音频到库乐队(GarageBand)直接设置手机铃声
鉴于之前有好几位iOS开发者通过简书找到我, 都是公司需要做这个功能但是不知道怎么实现, 这个小众功能我做的时候网上没有任何资料,当时我自己也是迷迷糊糊琢磨了一些时间才弄出来的. 今天把这个功能实现方法写出来把,希望能帮到大家.如果确实解决了您的燃眉之急,希望能点一个star,感谢.

![image](https://github.com/tangtiancheng/ttcgif/blob/master/gif/GarageBandImage.gif)


## 7.多列表嵌套分页滚动, header悬浮
### 该功能共有两个类:1.TCViewPager(用于处理列表分页)  2.TCNestScrollPageView(用于处理嵌套header滚动悬浮)
一开始铃声多多中只有分页功能，没有需要加入headerView悬浮嵌套的功能，所以就只写了TCViewPager，用于处理分页功能，后来个人主页需要做成headerView悬浮的效果，但是我又不想修改之前TCViewPager已经写好的代码，而且肯定有其他开发者已经有了自己的分页控件（改样式改代码肯定是改自己的代码比较熟悉比较快），只想添加一个headerView悬浮功能，不想用我的TCViewPager，所以我就索性写了TCNestScrollPageView用于处理嵌套headerView滚动悬浮，把TCNestScrollPageView和TCViewPager完全拆开。
如果你已经有了自己的分页控件,但是想在其基础上再添加header悬浮滚动的功能,那么你就只需要使用TCNestScrollPageView即可,不需要用到TCViewPager.用法非常非常简单,直接参照demo（github上有一些一两千star的项目我觉得无论是代码还是使用都有丢丢复杂，对新手不太友好，看起来一脸懵逼，想做一些改动都无从下手，TCNestScrollPageView和TCViewPager相对来说思想思路和代码都很简单，想做一些修改看看代码就能改，有需要的就用起来吧）
### (1).简单分页
![image](https://github.com/tangtiancheng/ttcgif/blob/master/gif/分页效果.gif)
### (2).headerView随时变动
![image](https://github.com/tangtiancheng/ttcgif/blob/master/gif/headerView随时变动.gif)
### (3).headerView吸顶
![image](https://github.com/tangtiancheng/ttcgif/blob/master/gif/headerView吸顶.gif)
### (4).改变headerView高度
![image](https://github.com/tangtiancheng/ttcgif/blob/master/gif/改变headerView高度.gif)
### (5).headerView不吸顶,下拉变大
![image](https://github.com/tangtiancheng/ttcgif/blob/master/gif/headerView不吸顶,下拉变大.gif)
### (6).Header滚动延续(实现方法和网上其它的不太一样,可以看看)
https://github.com/tangtiancheng/DouYinComment/archive/refs/tags/0.0.7.zip 新版没了,老版本有实现代码
![image](https://github.com/tangtiancheng/ttcgif/blob/master/gif/scrolContinue.gif)
### (7).标签编辑功能
![image](https://github.com/tangtiancheng/ttcgif/blob/master/gif/editTag.gif)
### (8).铃声多多音乐播放界面,(类似豆瓣电影主页)
![image](https://github.com/tangtiancheng/ttcgif/blob/master/gif/DDMusic.gif)

另外还有其他的效果自己去看demo,使用起来很简单, 我写这些东西都是尽力朝着让使用者一两行就能用, 不侵入使用者的代码,实现原理也不难,自己去看代码也肯定能看懂 (好用请给个star,谢谢)
