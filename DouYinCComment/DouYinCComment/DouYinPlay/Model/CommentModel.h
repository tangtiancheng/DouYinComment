//
//  CommentModel.h
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2017/7/6.
//  Copyright © 2017年 www.ShoujiDuoduo.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
"ruid":"qq_A6B8CEFAB39EB910F6ADB8A55704FCD1",
"uid":"qq_784C9E405FCD74E73165B07CB720060A",
"tcomment":"歌名？",
"upvote":3,
"tname":"安稳🍂",
"createtime":"2017-07-03 00:19:58",
"rid":"23364500",
"comment":"远走高飞",
"thead_url":"http://cdnringbd.shoujiduoduo.com/ringres/userprofile/head_pic/49/user_head_20170628202949.jpg",
"cid":"59591d2e7f8b9a82448b4591",
"tuid":"phone_18362446031",
"ddid":"655029",
"tcid":"59591a107f8b9a240d8b456f",
"head_url":"http://q.qlogo.cn/qqapp/100382066/784C9E405FCD74E73165B07CB720060A/100",
"name":"ヅ一輩孓﹠_嘅諾訁呢ღ"
*/

@interface CommentModel : NSObject



//当前的评论ID
@property(nonatomic, copy) NSString *cid;
//当前评论内容
@property(nonatomic, copy) NSString *comment;
//当前评论日期
@property(nonatomic, copy) NSString *createtime;

//当前评论人名字
@property(nonatomic, copy) NSString *name;
//当前评论人头像地址
@property(nonatomic, copy) NSString *head_url;
@property(nonatomic, assign) CGFloat height;


@end
