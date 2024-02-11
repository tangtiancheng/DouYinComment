



//
//  SwingAnimationModifier.swift
//  SwingAnimation
//
//  Created by Octree on 2023/3/16.
//
//  Copyright (c) 2023 Octree <fouljz@gmail.me>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


import ClockHandRotationKit
import SwiftUI

/// A modifier that applies a swing animation to a view.
///
@available(iOS 14.0, *)
public struct SwingAnimationModifier: ViewModifier {
    /// The duration of the animation.
    public let duration: CGFloat

    /// The direction of the swing animation.
    public let direction: Direction

    /// The distance of the swing animation.
    public let distance: CGFloat

    /// Creates a swing animation modifier with the specified duration, direction, and distance.
    /// - Parameters:
    ///   - duration: The duration of the animation.
    ///   - direction: The direction of the swing animation.
    ///   - distance: The distance of the swing animation.
    public init(duration: CGFloat, direction: Direction, distance: CGFloat) {
        self.duration = duration
        self.direction = direction
        self.distance = distance
    }

    private var alignment: Alignment {
        if direction == .vertical {
            return distance > 0 ? .top : .bottom
        } else {
            return distance > 0 ? .leading : .trailing
        }
    }
    
//    func ff(size:CGSize) -> Bool {
//        print(size)
//        return true
//    }
    
    
    @ViewBuilder
    
    
    
//    private func overlayView(content: Content) -> some View {
    public func overlayView(content: Content) -> some View {

        let alignment = alignment
        
         GeometryReader {
            let size = $0.size
//            var b = ff(size: size)
             //偏移量  distance
             //主体宽度
            let extendLength = direction == .vertical ? size.height : size.width
             //最外层杠杆长度
            let length: CGFloat = abs(distance) + extendLength
             //第二根长度
            let innerDiameter = abs(distance) / 2 + extendLength
            
             //这个好像没啥用
             let outerAlignment: Alignment = {
                if direction == .vertical {
                    return distance > 0 ? .bottom : .top
                } else {
//                    return distance > 0 ? .trailing : .leading
                    return distance > 0 ? .leading : .trailing
                }
            }()

            ZStack(alignment: outerAlignment) {
//                Text("123")
//                    .background(Color.red)
                Color.clear
//                Color.yellow.opacity(0.3)
                ZStack(alignment: alignment) {
//                    Text("123")
//                        .background(Color.red)
                    Color.clear
//                    Color.orange.opacity(0.3)
                    ZStack(alignment: alignment) {
//                        Text("123")
//                            .background(Color.red)
                        Color.clear
//                        Color.green.opacity(0.3)
                        content
                            .clockHandRotationEffect(period: .custom(duration))//主体
                    }
//                    .background(Color.green.opacity(0.3))
                    .frame(width: innerDiameter, height: innerDiameter)
                    .clockHandRotationEffect(period: .custom(-duration / 2))//第二根 长度应该是偏移长度/2 + 主体宽度
                }
//                .background(Color.orange.opacity(0.3))
                .frame(width: length, height: length)
                .clockHandRotationEffect(period: .custom(duration))//最外层杠杆  最外层长度应该等于偏移量+主体宽度length = distance + extendLength
            }
//            .background(Color.yellow.opacity(0.3))
            .frame(width: size.width, height: size.height, alignment: alignment)
        }//.background(Color.purple)
        
        
//         ZStack() {
//            let size = CGSizeMake(56, 56)//$0.size
//            let extendLength = direction == .vertical ? size.height : size.width
//            let length: CGFloat = abs(distance) + extendLength
//            let innerDiameter = (length + extendLength) / 2
//            let outerAlignment: Alignment = {
//                if direction == .vertical {
//                    return distance > 0 ? .bottom : .top
//                } else {
//                    return distance > 0 ? .trailing : .leading
//                }
//            }()
//
//            ZStack(alignment: outerAlignment) {
//                Color.clear
////                Color.yellow
//                ZStack(alignment: alignment) {
//                    Color.clear
////                    Color.orange
//                    ZStack(alignment: alignment) {
////                        Color.clear
//                        Color.green
//                        content//.clockHandRotationEffect(period: .custom(duration))
//                    }
//                    .frame(width: innerDiameter, height: innerDiameter)
//                    .clockHandRotationEffect(period: .custom(-duration / 2))
//                }
//                .frame(width: length, height: length)
//                .clockHandRotationEffect(period: .custom(duration))
//            }
//            .frame(width: size.width, height: size.height, alignment: alignment)
//         }//.background(Color.purple)
//
    }

    public func body(content: Content) -> some View {
        
        content
            .hidden()
            .overlay(overlayView(content: content))
    }
}
















/*
 //
 //  Xcode13ClockHandRotationEffectModifier.swift
 //  Xcode13ClockHandRotationEffectModifier
 //
 //  Created by everettjf on 2022/12/14.
 //
 import SwiftUI
 import WidgetKit


 pubilc enum Xcode13ClockHandRotationEffectPeriod {
     case custom(TimeInterval)
     case secondHand, hourHand, miniuteHand
 }

 pubilc struct Xcode13ClockHandRotationEffectModifier: ViewModifier {

     let clockPeriod: WidgetKit._ClockHandRotationEffect.Period
     let clockTimezone: TimeZone
     let clockAnchor: UnitPoint
     
     pubilc init(period: Xcode13ClockHandRotationEffectPeriod, timezone: TimeZone, anchor: UnitPoint) {
         var clockPeriod: WidgetKit._ClockHandRotationEffect.Period = .secondHand
         switch period {
         case .custom(let timeInterval):
             clockPeriod = .custom(timeInterval)
         case .secondHand:
             clockPeriod = .secondHand
         case .hourHand:
             clockPeriod = .hourHand
         case .miniuteHand:
             clockPeriod = .minuteHand
         }
         self.clockPeriod = clockPeriod
         self.clockTimezone = timezone
         self.clockAnchor = anchor
     }

     pubilc func body(content: Content) -> some View {
         content
             ._clockHandRotationEffect(self.clockPeriod, in: self.clockTimezone, anchor: self.clockAnchor)
     }

 }
 
 */
