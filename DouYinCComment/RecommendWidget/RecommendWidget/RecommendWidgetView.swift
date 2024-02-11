//
//  RecommendWidgetView.swift
//  RecommendWidgetExtension
//
//  Created by han on 2022/10/10.
//  Copyright © 2022 duoduo. All rights reserved.
//

//很重要 !! 很重要 !! 很重要 !!
//这个RTDDDataModel.swift文件,记得Target Membership要勾选 RecommendWidgetExtension 和 WidgetIntentHandler 这两
//然后RecommendWidget.intentdefinition 这个 ,记得Target Membership要勾选DouYinCComment(就是你的主工程) 和 RecommendWidgetExtension 和 WidgetIntentHandler 这三
//然后  WidgetIntentHandler文件夹里的info.plist, 属性IntentsSupported数组 ,要添加ConfigurationIntent
//上面是容易犯错的地方,一些博客细节讲的不清不楚的,估计都是复制粘贴
//好用请点star

import SwiftUI
import Intents
import WidgetKit

//小的
struct RTDDWidgetViewSystemSmall: View {
    let list: [RTDDData]
    var body: some View {
        // 通过GeometryReader获取view的尺寸
        GeometryReader { geo in
            
            ZStack() {
                RTDDWidgetBigView(data: list[0])
            }.widgetURL(URL(string: "RingToneDD://Widget/"+list[0].id)!)//跳转方式其实就是普通的scheme
            
        }.background(
            Color.init(CGColor(red: 61.0/255, green: 204.0/255, blue: 121.0/255, alpha: 1))
        )
    }
}

//中的
struct RTDDWidgetViewSystemMedium: View {
    let list: [RTDDData]
    var body: some View {
        // 通过GeometryReader获取view的尺寸
        GeometryReader { geo in
            let itemWH = geo.size.height - 20
            //            let data = list[0]
            ZStack() {
                HStack(alignment: .center, spacing: 10) {
                    Link(destination: URL(string: "RingToneDD://Widget/"+list[0].id)!) {
                        RTDDWidgetBigView(data: list[0])
                            .frame(width: itemWH, height: itemWH)
                    }
                    VStack(spacing: 10) {
                        Link(destination: URL(string: "RingToneDD://Widget/"+list[1].id)!) {
                            RTDDWidgetSmallView(data: list[1])
                        }
                        Link(destination: URL(string: "RingToneDD://Widget/"+list[2].id)!) {
                            RTDDWidgetSmallView(data: list[2])
                        }
                    }
                }
            }
            .padding(10)//距离top left right bottom的距离
        }.background(
            Color.init(CGColor(red: 61.0/255, green: 204.0/255, blue: 121.0/255, alpha: 1))
        )
    }
}


//大的你自己写吧,我swiftUI实在不熟,问就是不会.
struct RTDDWidgetViewSystemLarge: View {
    let list: [RTDDData]
    var body: some View {
        // 通过GeometryReader获取view的尺寸
        GeometryReader { geo in
            let itemWH = geo.size.height - 20
            //            let data = list[0]
            ZStack() {
                HStack(alignment: .center, spacing: 10) {
                    Link(destination: URL(string: "RingToneDD://Widget/"+list[0].id)!) {
                        RTDDWidgetBigView(data: list[0])
                            .frame(width: itemWH, height: itemWH)
                    }
                    VStack(spacing: 10) {
                        Link(destination: URL(string: "RingToneDD://Widget/"+list[1].id)!) {
                            RTDDWidgetSmallView(data: list[1])
                        }
                        Link(destination: URL(string: "RingToneDD://Widget/"+list[2].id)!) {
                            RTDDWidgetSmallView(data: list[2])
                        }
                    }
                }
            }
            .padding(10)//距离top left right bottom的距离
        }.background(
            Color.init(CGColor(red: 61.0/255, green: 204.0/255, blue: 121.0/255, alpha: 1))
        )
    }
}







struct RTDDWidgetBigView: View {
    
    let data: RTDDData
    
    // 底部遮罩的占比为整体高度的 40%
    var contianerRatio : CGFloat = 0.4
    let gradientTopColor = Color.init(CGColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0))
    let gradientBottomColor = Color.init(CGColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.35))
    func gradientView() -> LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [gradientTopColor, gradientBottomColor]), startPoint: .top, endPoint: .bottom)
    }
    
    var body: some View {
        // 通过GeometryReader获取view的尺寸
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                
                // 添加背景图
                Image(data.bg)
                    .resizable()
                // 添加logo
                Image("icon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
                    .position(x: geo.size.width - (20/2) - 10, y: (20/2) + 10)
                    .ignoresSafeArea(.all)
                // 添加左下角的图标及文字
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 3) {
                        Image(data.icon)
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(data.title)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 16, alignment: .leading)//只支持一行
                        
                    }
                    
                    Text(data.desc)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 14, alignment: .leading)//只支持一行
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                
            }
        }
        .cornerRadius(15)
        
    }
}


struct RTDDWidgetSmallView: View {
    
    let data: RTDDData
    
    var body: some View {
        // 通过GeometryReader获取view的尺寸
        GeometryReader { geo in
            ZStack() {
                // 添加左下角的图标及文字
                HStack() {
                    Image(data.icon)
                        .resizable()
                        .frame(width: 25, height: 25)
                    Text(data.title)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 16, alignment: .leading)//只支持一行
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(10)
        }
        .background(
            Color.init(CGColor(red: 50.0/255, green: 50.0/255, blue: 50.0/255, alpha: 0.3))
        )
        .cornerRadius(15)
        
        
    }
}
