//
//  RTDDData.swift
//  RingtoneDuoduo
//
//  Created by han on 2022/10/16.
//  Copyright © 2022 duoduo. All rights reserved.
//

//很重要 !! 很重要 !! 很重要 !!
//这个RTDDDataModel.swift文件,记得Target Membership要勾选 RecommendWidgetExtension 和 WidgetIntentHandler 这两
//然后RecommendWidget.intentdefinition 这个 ,记得Target Membership要勾选DouYinCComment(就是你的主工程) 和 RecommendWidgetExtension 和 WidgetIntentHandler 这三
//然后  WidgetIntentHandler文件夹里的info.plist, 属性IntentsSupported数组 ,要添加ConfigurationIntent
//上面是容易犯错的地方,一些博客细节讲的不清不楚的,估计都是复制粘贴
//好用请点star


import Foundation


struct RTDDData {
    let id: String      // 唯一标识   //1最热铃声 2我的下载 3我的收藏
    let title: String   // 标题
    let desc: String    // 描述
    let icon: String    // 图标名称
    let bg: String      // 背景图片名称
//    var bgImage: UIImage? = UIImage(named: "RelationCardBack") // 背景图片对象
    
    static func getList() -> [RTDDData] {
        var list = [RTDDData]()
        list.append(.init(id:"1", title: "最热铃声", desc: "全网最火歌曲铃声", icon: "HotRing", bg: "hotRingBacImg"))
        list.append(.init(id:"2", title: "下载铃声", desc: "我的下载铃声", icon: "MyDown", bg: "hotRingBacImg"))
        list.append(.init(id:"3", title: "收藏铃声", desc: "我的收藏铃声", icon: "Mycollect", bg: "hotRingBacImg"))
        list.append(.init(id:"4", title: "最近播放", desc: "最近播放铃声", icon: "PlayHis", bg: "hotRingBacImg"))
        list.append(.init(id:"5", title: "一起听", desc: "我的一起听房间", icon: "yiqiting", bg: "hotRingBacImg"))

        return list
    }
    
    static func getModeList() -> [RTDDWidgetMode] {
        var list = [RTDDWidgetMode]()
        for data in getList() {
            list.append(RTDDWidgetMode(identifier: data.id, display: data.title))
        }
        return list;
    }
    
    static func dataWith(mode: RTDDWidgetMode) -> RTDDData {
        var data: RTDDData? = nil
        for m in getList() {
            if m.id == mode.identifier {
                data = m
            }
        }
        return data!
    }
    
}
