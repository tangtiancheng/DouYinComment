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
                        .mask(alignment: .center)
                    {
                        Text(imageDate, style: .timer)
                            .multilineTextAlignment(.center)
                            .font(.custom("TreeNewBee\(frameImages.count)", size: minSize))
                            .foregroundColor(Color.black)
                            .offset(x: -minSize/2)
                            .frame(width: minSize * 2, height: minSize, alignment: .center)
                    }
//                    .frame(width: minSize,height: minSize)
                    //                        .contentTransition(.identity)
                    .clipped()
                }
                
                
            }
        }
        
    }
}

