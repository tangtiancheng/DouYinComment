//
//  ceshiBundle.swift
//  ceshi
//
//  Created by 唐天成 on 2023/6/25.
//

import WidgetKit
import SwiftUI

//@main：代表着Widget的主入口，系统从这里加载
@main
struct DDWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        
        RecommendWidget()
        ScrolPicWidget()
        ClockWidget()
        FanWidget()
        FrameAniWidget()
    }
}
