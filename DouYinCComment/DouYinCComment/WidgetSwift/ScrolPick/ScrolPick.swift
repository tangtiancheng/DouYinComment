//
//  SmallWidgetGetWageView.swift
//  DDWidgetExtension
//
//  Created by 唐天成 on 2023/10/16.
//  Copyright © 2023 duoduo. All rights reserved.
//

import SwiftUI
import ClockHandRotationKit
import WidgetKit

enum ScrolDirection {
    case leftToRight
    case RightToLeft
}
enum WidgetSizeType {
    case WidgetSizeSmallType
    case WidgetSizeMidType
}

@available(iOS 14.0, *)
struct SmallWidgetScrolPicView: View {
    
    var lineNum : Int = 1
    var sizeType: WidgetSizeType = .WidgetSizeSmallType
    var body: some View {
        // 通过GeometryReader获取view的尺寸
        GeometryReader { geo in
            ZStack() {
                if lineNum == 1 {
                    SmallWidgetRow1ScrolPicView(sizeType: sizeType)
                } else {
                    SmallWidgetRow2ScrolPicView()
                }
            }
        }
        .background(
            Color.black
        )
    }
}


//单行滚动相册
@available(iOS 14.0, *)
struct SmallWidgetRow1ScrolPicView: View {
    var sizeType: WidgetSizeType = .WidgetSizeSmallType
    var body: some View {
        // 通过GeometryReader获取view的尺寸
        GeometryReader { geo in
            ZStack() {
                Image(sizeType == .WidgetSizeSmallType ? "ScrolPic_S_Back" : "ScrolPic_M_Back")
                    .resizable()//自适应填满
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height)
                SmallWidgetRowScrolPicView()
                    .frame(width: geo.size.width-10, height:sizeType == .WidgetSizeSmallType ? geo.size.height * 340/474 : geo.size.height * 320/474)
            }
        }
    }
}


//两行滚动相册
@available(iOS 14.0, *)
struct SmallWidgetRow2ScrolPicView: View {
//    @Environment(\.widgetFamily) var family: WidgetFamily
    var body: some View {
        // 通过GeometryReader获取view的尺寸
        GeometryReader { geo in
            ZStack() {
//                if isAddWidget {
                    VStack(spacing:5.0) {
                        SmallWidgetRowScrolPicView(scrolDirection: .leftToRight)
                        SmallWidgetRowScrolPicView(scrolDirection: .RightToLeft)
                    }
                    .frame(width: geo.size.width-10, height: geo.size.height-10)
                    .cornerRadius(17)
                    .clipped()
//                } else {
//                    VStack(spacing:5.0) {
//                        SmallWidgetRowScrolPicView(scrolDirection: .leftToRight)
//                        SmallWidgetRowScrolPicView(scrolDirection: .RightToLeft)
//                    }
//                    .frame(width: geo.size.width-10, height: geo.size.height-10)
//                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }

}






@available(iOS 14.0, *)
struct SmallWidgetRowScrolPicView: View {
    var scrolDirection : ScrolDirection = .leftToRight
//    var sizeScale = 1.0
    
    var body: some View {
        // 通过GeometryReader获取view的尺寸
         GeometryReader { geo in
             ZStack() {
                 //                Color.white
                 var space = 5.0 //* sizeScale//图片与图片之前距离
                 var padding = 0.0//5.0//总体左右间距
                 var imageW = geo.size.height * 3.7/3
                 var imageNum = 10
                 var imageNumF = CGFloat(imageNum)
                 var allW  = imageW * imageNumF + space * (imageNumF - 1) + padding * 2
                 var duration = 40.0
                 let directAndDistance = getDirectAndDistance(allW: allW, size: geo.size, scrolDirection: scrolDirection)
                 var scroDistance : CGFloat = directAndDistance.scroDistance
                 HStack(spacing: space) {
                     ForEach(0..<imageNum) { index in
                         var imageStr = String("ScrolPicDef\(index % 10)")
                         Image(imageStr)
                             .resizable()//自适应填满
                             .aspectRatio(contentMode: .fill)
                             .frame(width: imageW , height: geo.size.height )
                             .cornerRadius(3)
                             .clipped()
                         
                     }
                 }
                 .padding(.leading,padding)
                 .padding(.trailing,padding)
                 .frame(width: allW, height: geo.size.height)
                 .swingAnimation(duration: duration * 2, direction: .horizontal, distance: scroDistance)
                 .frame(width: geo.size.width, height: geo.size.height, alignment: directAndDistance.alignment)
             }
             .clipped()
        }
    }
    
    
    func getDirectAndDistance(allW : CGFloat, size:CGSize, scrolDirection:ScrolDirection) -> (scroDistance:CGFloat, alignment:Alignment) {
        var scroDistance : CGFloat
        var alignment : Alignment
        switch scrolDirection {
        case .leftToRight:
            scroDistance = allW - size.width
            alignment = .trailing
        case .RightToLeft:
            scroDistance = size.width - allW
            alignment = .leading
      
        }
        return (scroDistance, alignment)
    }
}



