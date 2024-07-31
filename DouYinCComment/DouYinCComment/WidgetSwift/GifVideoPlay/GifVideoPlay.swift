//
//  Fan.swift
//  DouYinCComment
//
//  Created by 唐天成 on 2024/2/7.
//  Copyright © 2024 唐天成. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct ArcView: Shape {
    var arcStartAngle: Double
    var arcEndAngle: Double
    var arcRadius: Double
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: arcRadius,
                    startAngle: .degrees(arcStartAngle),
                    endAngle: .degrees(arcEndAngle),
                    clockwise: false)
        return path
    }
}

@available(iOS 14.0, *)
//原理其实就是有N帧就放N张图片在原地不动,然后借助mask这个方法放一个遮罩.每个遮罩对应圆的一块角度区域.然后都旋转起来后,就会出现类似电影一样一帧一帧出现的视频效果.
struct SmallGifVideoPlayView: View {
    //    var entry: DynamicWidgetProvider.Entry
        var name: String
        var body: some View {
            if let gifPath = Bundle.main.path(forResource: name, ofType: "gif"),
               let gifData = NSData(contentsOfFile: gifPath),
               let gifImage = UIImage.sd_image(withGIFData: gifData as Data),
               let gifImages = gifImage.images, gifImages.count > 0 {
                GeometryReader { proxy in
                    let width = proxy.size.width
                    let height = proxy.size.height
                    let duration = gifImage.duration
                    
                    //https://max2d.com/archives/897   计算原理.   如果要方便,那就是lineWidth设置为imageWH.然后arcRadius设置为一个非常非常大的数即可不用做以下运算. 下面的只是为了说清楚算法
                    //多少度
                    let angle = 360.0 / Double(gifImages.count)
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
                    let arcRadius = (radiu - (lineWidth / 2)) * 300//这里其实不乘以300才是完完全全正确的结果,每个大小都是刚刚好的.但是这样转起来之后重叠部分会留阴影, 所以加以放大后.半径变大了,但是重叠部分还是那么大.相应的周长绝对速度就变大了. 这样阴影就会快速略过,肉眼便无法感知了.越放大效果越好.应该是这个理
                    let offsetY = arcRadius - t / 2
                    ZStack {
                        ForEach(1...gifImages.count, id: \.self) { index in
                            Image(uiImage: gifImages[gifImages.count-index])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width, height: height)
                                .mask(
                                    ArcView(arcStartAngle: angle * Double(index - 1),
                                            arcEndAngle: angle * Double(index),
                                            arcRadius: arcRadius)
                                    .stroke(style: .init(lineWidth: lineWidth, lineCap: .square, lineJoin: .miter))
                                    .frame(width: width, height: height)
                                    .clockHandRotationEffect(period: .custom(duration))
                                    .offset(y: offsetY)
                                )
                        }
                    }
                    .frame(width: width, height: height)
                }
            }
        }
}
