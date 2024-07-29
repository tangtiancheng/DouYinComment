//
//  Fan.swift
//  DouYinCComment
//
//  Created by 唐天成 on 2024/2/7.
//  Copyright © 2024 唐天成. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct SmallWidgetFanView: View {
    var body: some View {
        // 通过GeometryReader获取view的尺寸
        GeometryReader { geo in
            ZStack() {
                Image("Fan_S_NingMeng_lamina")
                    .resizable()//自适应填满
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clockHandRotationEffect(period: .custom(0.5))
                Image("Fan_S_NingMeng_shell")
                    .resizable()//自适应填满
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
            }
        }.background(Color.black)
    }
}
