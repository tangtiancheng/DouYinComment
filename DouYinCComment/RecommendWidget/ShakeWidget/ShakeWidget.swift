//
//  hhhjj.swift
//  hhhjj
//
//  Created by 唐天成 on 2024/2/3.
//

import WidgetKit
import SwiftUI


struct ShakeWidget: Widget {
    let kind: String = "ShakeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EntryView(entry: entry)
                .widgetBackground(Color.black.opacity(0))
            
        }
        .configurationDisplayName("播放git视频")
        .description("git视频小组件,有需要代码自拿")
        .supportedFamilies([.systemSmall])
        .ddcontentMarginsDisabled()
        
    }
}
