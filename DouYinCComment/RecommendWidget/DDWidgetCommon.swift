//
//  DDWidgetCommon.swift
//  DDWidgetExtension
//
//  Created by 唐天成 on 2023/8/14.
//  Copyright © 2023 duoduo. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit


@available(iOS 14.0, *)
extension View {
    //这是每个小组件都必须有的,他的颜色会随着色调模式颜色改变而改变, 然后background(backgroundView)在色调模式下统一会变为白色
    func ddwidgetBackground(_ backgroundView: some View) -> some View {
#if compiler(>=5.9)
        //        if #available(iOSApplicationExtension 17.0, *) {
        if #available(iOS 17.0, *) {
            //            return containerBackground(.fill.tertiary, for: .widget)
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
#else
        return background(backgroundView)
#endif
    }
}

@available(iOS 14.0, *)
extension Image {
    //小组件图片不加这个,在手机切换自定义色调时图片会显示成纯白色
    func ddwidgetAccentedRenderingMode() -> some View {
        //        if #available(iOSApplicationExtension 17.0, *) {
        if #available(iOS 18.0, *) {
            return widgetAccentedRenderingMode(WidgetAccentedRenderingMode.fullColor)
        } else {
            return self
        }
    }
}





@available(iOS 14.0, *)
extension WidgetConfiguration {
    //处理小组件默认边距,去掉
    func ddcontentMarginsDisabled() -> some WidgetConfiguration {
//        if #available(iOSApplicationExtension 15.0, *) {
        if #available(iOS 15.0, *) {

            return contentMarginsDisabled()
        } else {
            return self
        }
    }
}
