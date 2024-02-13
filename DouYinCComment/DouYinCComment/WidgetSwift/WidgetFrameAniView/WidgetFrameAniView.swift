//
//  WidgetFrameAniView.swift
//  DouYinCComment
//
//  Created by 唐天成 on 2024/2/12.
//  Copyright © 2024 唐天成. All rights reserved.
//

import SwiftUI
@available(iOS 15.0, *)
struct WidgetFrameAniView: View {
    var frameImages:[String] = []
    var date: Date = Date()
    var body: some View {
        GeometryReader { geo in
            ZStack() {
                var minSize = geo.size.width > geo.size.height ? geo.size.height : geo.size.width
                ForEach(frameImages.indices, id: \.self) { index in
                    let imagePath = Bundle.main.path(forResource: frameImages[index], ofType: "png")
                    let image = UIImage(contentsOfFile: imagePath ?? "")
                    //                    let image = UIImage(named: frameImages[index])
                    let imageDate = Date(timeInterval: TimeInterval(index - frameImages.count), since: date)
                    Image(uiImage:image ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .mask(alignment: .trailing)
                    {
                        Text(imageDate, style: .timer)
                            .multilineTextAlignment(.trailing)
                            .font(.custom("TreeNewBee\(frameImages.count)", size: minSize))
                            .foregroundColor(Color.black)
                        //                            .offset(x: -minSize/2)
                            .frame(width: minSize * 5, height: minSize, alignment: .trailing)
                    }
                    //                    .frame(width: minSize,height: minSize)
                    //                        .contentTransition(.identity)
                    .clipped()
                }
            }
            .position(CGPoint(x: geo.size.width/2, y: geo.size.height/2))
            
        }
        
    }
}





@available(iOS 14.0, *)
struct WidgetFrameAniView2: View {
    var color : Color = .white
    var body: some View {
        GeometryReader { geo in
            var minSize = geo.size.width > geo.size.height ? geo.size.height : geo.size.width
            ZStack(alignment: .trailing) {
                Text(Date(), style: .timer)
                    .multilineTextAlignment(.trailing)
                    .font(.custom("spaceman_astronaut", size: minSize))
                    .foregroundColor(color)
//                    .background(Color.green)
                    .frame(width: minSize * 5, height: minSize, alignment: .trailing)
//                    .clipped()
            }
            .frame(width: minSize, height: minSize,alignment: .trailing)
            .clipped()
//            .background(Color.red)
            .position(CGPoint(x: geo.size.width/2, y: geo.size.height/2))
            
        }
    }
}



//@available(iOS 14.0, *)
//struct ContentView11: View {
//    var body: some View {
//        GeometryReader { geo in
//            ZStack(alignment: .trailing) {
//                Text(Date(), style: .timer)
//                    //.fixedSize() //  ,如果是普通Text文本,加上这个的作用就是文本过长不显示...,直接截断, 那么其实就没必要把宽度弄成2千,但是在倒计时上加上这次直接数字就不显示了.所以没法用
//                    .multilineTextAlignment(.trailing)
//                    .foregroundColor(Color.orange)
//                    .lineLimit(1)
//                    .font(.custom("spaceman_astronaut", size: geo.size.height))
//                    .frame(width: 2000, height: geo.size.height, alignment: .trailing)
//                    .background(Color.red)
//   
//            }
//            .frame(maxWidth: geo.size.width, maxHeight: geo.size.height,alignment: .trailing)
//            .background(Color.green)
//            .clipped()
//        }
//        .background(Color.purple)
//    }
//}
