//
//  hhhjj.swift
//  hhhjj
//
//  Created by 唐天成 on 2024/2/3.
//

import WidgetKit
import SwiftUI


struct GifVideoPlayWidget: Widget {
    let kind: String = "GifVideoPlayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EntryView(entry: entry)
                .ddwidgetBackground(Color.black)
            
        }
        .configurationDisplayName("播放gif视频")
        .description("gif视频小组件,有需要代码自拿")
        .supportedFamilies([.systemSmall])
        .ddcontentMarginsDisabled()
        
    }
}
