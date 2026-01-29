//
//  hhhjj.swift
//  hhhjj
//
//  Created by 唐天成 on 2024/2/3.
//

import WidgetKit
import SwiftUI


struct ClockWidget: Widget {
    let kind: String = "ClockWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EntryView(entry: entry)
                .ddwidgetBackground(Color.black)
            
        }
        .configurationDisplayName("表情时钟")
        .description("时钟小组件,有需要代码自拿")
        .supportedFamilies([.systemSmall])
        .ddcontentMarginsDisabled()
    }
}
