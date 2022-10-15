//
//  RecommendWidget.swift
//  RecommendWidget
//
//  Created by han on 2022/10/10.
//  Copyright © 2022 duoduo. All rights reserved.
//

//很重要 !! 很重要 !! 很重要 !!
//这个RTDDDataModel.swift文件,记得Target Membership要勾选 RecommendWidgetExtension 和 WidgetIntentHandler 这两
//然后RecommendWidget.intentdefinition 这个 ,记得Target Membership要勾选DouYinCComment(就是你的主工程) 和 RecommendWidgetExtension 和 WidgetIntentHandler 这三
//然后  WidgetIntentHandler文件夹里的info.plist, 属性IntentsSupported数组 ,要添加ConfigurationIntent
//上面是容易犯错的地方,一些博客细节讲的不清不楚的,估计都是复制粘贴
//好用请点star

import WidgetKit
import SwiftUI
import Intents


struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), configuration: ConfigurationIntent(), list: RTDDData.getList())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, list: RTDDData.getList())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let updateDate = Calendar.current.date(byAdding: .second, value: 300, to: currentDate)
        
        var list = [RTDDData]();
        
        if let modeArr = configuration.modeArr {
            for mode in configuration.modeArr! {
                list.append(RTDDData.dataWith(mode: mode))
            }
        } else {
            list = RTDDData.getList();
        }
        
        let entry = SimpleEntry(date: currentDate, configuration: configuration, list: list)
            let timeline = Timeline(entries: [entry], policy: .after(updateDate!))
            completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let list: [RTDDData]

}

struct RecommendWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    var body: some View {
        switch family {
        case .systemSmall: RTDDWidgetViewSystemSmall(list: entry.list)
        case .systemMedium: RTDDWidgetViewSystemMedium(list: entry.list)
        case .systemLarge: RTDDWidgetViewSystemMedium(list: entry.list)
        default: RTDDWidgetViewSystemMedium(list: entry.list)
        }
    }
}

@main
struct RecommendWidget: Widget {
    let kind: String = "RecommendWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            RecommendWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("铃声多多推荐")
        .description("快捷音乐播放入口,并可自定义精选功能")
        .supportedFamilies([.systemSmall,.systemMedium])//只支持小号和中号组件.大号的组件UI懒得写了,都一样,你自己去写吧
    }
}

