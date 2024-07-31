//
//  File.swift
//  DouYinCComment
//
//  Created by 唐天成 on 2024/7/30.
//  Copyright © 2024 唐天成. All rights reserved.
//

import SwiftUI



@available(iOS 14.0, *)

struct SmallShakeView: View {
    //    var entry: DynamicWidgetProvider.Entry
    
    var body: some View {
        
        GeometryReader { proxy in
           
            
            let allAngle = 15.0
            //一次摇摆多少帧
            let imageFrameNum = 7
            //每帧距离多少度
            let transFAngele = allAngle / Double(imageFrameNum - 1)
            
            let width = proxy.size.width
            let height = proxy.size.height
            let duration = 1.4
            
            //https://max2d.com/archives/897   计算原理.   如果要方便,那就是lineWidth设置为imageWH.然后arcRadius设置为一个非常非常大的数即可不用做以下运算. 下面的只是为了说清楚算法
            //多少度
            let angle = 360.0 / (Double(2 * imageFrameNum) - 2)
            //正方形宽高
            let imageWH = max(width, height)
            //一半宽高
            let halfWH = (imageWH / 2)
            //一半弧度
            let halfRadian = (angle / 2)/180.0 * M_PI
            let tanHalf = tan(halfRadian)
            //半径
            let radiu = sqrt((5 * halfWH * halfWH) + (halfWH * halfWH) / (tanHalf * tanHalf) + (4 * halfWH * halfWH / tanHalf))
            let b = halfWH / tanHalf
            let t = radiu - imageWH - b
            let lineWidth = radiu - b;
            let arcRadius = (radiu - (lineWidth / 2)) * 400//这里其实不乘以300才是完完全全正确的结果,每个大小都是刚刚好的.但是这样转起来之后重叠部分会留阴影, 所以加以放大后.半径变大了,但是重叠部分还是那么大.相应的周长绝对速度就变大了. 这样阴影就会快速略过,肉眼便无法感知了.越放大效果越好.应该是这个理
            let offsetY = arcRadius - t / 2
            
            
            
            
            ZStack {
                ForEach(1...(2 * imageFrameNum - 2), id: \.self) { index in
                    ZStack {
                        ShakeView()
                            .rotationEffect(.degrees( getAngle(index: index, imageFrameNum: imageFrameNum, transFAngele: transFAngele) ), anchor: UnitPoint(x: 0.5, y: 1))
                            .frame(width: width * 0.85, height: height * 0.85)
                    }
                    .frame(width: width, height: height, alignment: .center)
                    .mask(
                        ArcView(arcStartAngle: angle * Double(index - 1),
                                arcEndAngle: angle * Double(index),
                                arcRadius: arcRadius)
                        .stroke(style: .init(lineWidth: lineWidth, lineCap: .square, lineJoin: .miter))
                        .frame(width: width, height: height)
                        .clockHandRotationEffect(period: .custom(duration))
                        .offset(y: arcRadius)
                    )
                }
            }
            .frame(width: width, height: height)
        }.background(Color.black)
        
    }
    
    
    func getAngle(index:NSInteger, imageFrameNum:NSInteger, transFAngele:CGFloat) -> CGFloat {
        if index < imageFrameNum {
            let result1 = Double(index) * transFAngele - Double(imageFrameNum - 1) * transFAngele / 2
            return result1
        } else {
            let result1 = Double(imageFrameNum - 1) * transFAngele / 2 - Double(index + 1 - imageFrameNum) * transFAngele
            return result1
        }
    }
}



@available(iOS 14.0, *)
struct ShakeView: View {
    //    var entry: DynamicWidgetProvider.Entry
    
    var body: some View {
        
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            
            Image("shake")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Image("shakeMan")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 258.0/411 * width , height: 222.0 / 411 * width)
                .position(CGPoint(x: width / 2, y: 177.0 / 411.0 * height))
            
        }
        
    }
    
    
}
