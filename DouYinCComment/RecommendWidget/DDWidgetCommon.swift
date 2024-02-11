//
//  DDWidgetCommon.swift
//  DDWidgetExtension
//
//  Created by 唐天成 on 2023/8/14.
//  Copyright © 2023 duoduo. All rights reserved.
//

import Foundation
import SwiftUI



@available(iOS 14.0, *)
extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
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
extension WidgetConfiguration {
    func ddcontentMarginsDisabled() -> some WidgetConfiguration {
//        if #available(iOSApplicationExtension 15.0, *) {
        if #available(iOS 15.0, *) {

            return contentMarginsDisabled()
        } else {
            return self
        }
    }
}
