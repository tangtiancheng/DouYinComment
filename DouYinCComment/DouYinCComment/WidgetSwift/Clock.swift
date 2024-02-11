//
//  Clock.swift
//  DouYinCComment
//
//  Created by 唐天成 on 2024/2/7.
//  Copyright © 2024 唐天成. All rights reserved.
//

import SwiftUI

//表情时钟
@available(iOS 14.0, *)
struct SmallWidgetClockView: View {
    var body: some View {
        // 通过GeometryReader获取view的尺寸
        GeometryReader { geo in
//            var fanModel : WidgetTypeFanModel = entry.myWidgetModel?.widgetTypeModel as! WidgetTypeFanModel
            ZStack() {
//                Color.white
                Image("Clock_S_Dilate_Back")
                    .resizable()//自适应填满
                    .aspectRatio(contentMode: .fit)
//                    .scaledToFill()//image的mode
                    .frame(width: geo.size.width, height: geo.size.height)
                Image("Clock_S_Dilate_Eyes")
                    .resizable()//自适应填满
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 140.0/474 * geo.size.width, height: 140.0/474 * geo.size.width)
                    .offset(y:-30.0 / 474*geo.size.width)
                    .clockHandRotationEffect(period: .secondHand)
                    .position(x:140.0/474 * geo.size.height, y:188.0/474 * geo.size.height)
                Image("Clock_S_Dilate_Eyes")
                    .resizable()//自适应填满
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 110.0/474 * geo.size.width, height: 110.0/474 * geo.size.width)
                    .offset(y:-30.0 / 474*geo.size.width)
                    .clockHandRotationEffect(period: .secondHand)
                    .position(x:354.0/474 * geo.size.height, y:203.0/474 * geo.size.height)
                Image("Clock_S_Dilate_Sec")
                    .resizable()//自适应填满
                    .aspectRatio(contentMode: .fit)
//                    .scaledToFill()//image的mode
                    .frame(height: geo.size.height * 0.9)
                    .clockHandRotationEffect(period: .secondHand)
                    .position(x:geo.size.width * 0.52, y:245.0/474 * geo.size.height)
                Image("Clock_S_Dilate_Min")
                    .resizable()//自适应填满
                    .aspectRatio(contentMode: .fit)
                    .frame(height: geo.size.height * 0.64)
//                    .scaledToFill()//image的mode
//                    .frame(width: geo.size.width, height: geo.size.height)
                    .clockHandRotationEffect(period: .minuteHand)
                    .position(x:geo.size.width * 0.52, y:245.0/474 * geo.size.height)
                Image("Clock_S_Dilate_Hour")
                    .resizable()//自适应填满
                    .aspectRatio(contentMode: .fit)
//                    .scaledToFill()//image的mode
                    .frame(height: geo.size.height * 0.52)
                    .clockHandRotationEffect(period: .hourHand)
//                    .background(Color.red)
                    .position(x:geo.size.width * 0.52, y:245.0/474 * geo.size.height)

            }
        }
    }
}
