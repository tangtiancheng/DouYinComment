//
//  WidgetSwiftView.swift
//  DouYinCComment
//
//  Created by 唐天成 on 2024/2/6.
//  Copyright © 2024 唐天成. All rights reserved.
//

//iOS小组件不支持动画, 所以滚动相册,风扇.时钟都是用到了一个私有旋转方法:_clockHandRotationEffect, 将其打包成xcframework动态库使用:ClockHandRotationKit.xcframework, 源码项目搜索:ClockHandRotationKit.swift.   网上提供的动态库最低都是要求iOS14.0, 在iOS12,13上一运行项目就崩溃,但是我们老项目iOS12,13用户还占比将近2%, 所以我自己打了一个ClockHandRotationKit.xcframework.在iOS12,13系统上,你运行APP也不会崩溃(由于是动态库,多以要将Embed选项改成Embed & Sign)

import SwiftUI
import WidgetKit
//fe

@objcMembers class WidgetSwiftView : UIView {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        createWidgetView()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createWidgetView() {
        self.backgroundColor = .white
        if #available(iOS 14.0, *) {
            var scrolV = UIScrollView(frame:self.bounds)
            self.addSubview(scrolV)
            scrolV.contentSize = CGSizeMake(self.frame.size.width, 2000)
//            scrolV.contentInsetAdjustmentBehavior = .never;
            //滚动相册
            var vc = UIHostingController(rootView:SmallWidgetScrolPicView(lineNum: 1,sizeType: .WidgetSizeSmallType))
            vc.view.layer.cornerRadius = 22;
            vc.view.layer.masksToBounds = true;
            scrolV.addSubview(vc.view)
            vc.view.frame = CGRectMake(10, 0, 160, 160)
            
            var vc2 = UIHostingController(rootView:SmallWidgetScrolPicView(lineNum: 2,sizeType: .WidgetSizeSmallType))
            vc2.view.layer.cornerRadius = 22;
            vc2.view.layer.masksToBounds = true;
            scrolV.addSubview(vc2.view)
            vc2.view.frame = CGRectMake(180, 0, 160, 160)
            
//            var vc3 = UIHostingController(rootView:SmallWidgetScrolPicView(lineNum: 1,sizeType: .WidgetSizeMidType))
//            vc3.view.layer.cornerRadius = 22;
//            vc3.view.layer.masksToBounds = true;
//            scrolV.addSubview(vc3.view)
//            vc3.view.frame = CGRectMake(10, 170, 320, 160)
            
            var vc4 = UIHostingController(rootView:SmallWidgetScrolPicView(lineNum: 2,sizeType: .WidgetSizeMidType))
            vc4.view.layer.cornerRadius = 22;
            vc4.view.layer.masksToBounds = true;
            scrolV.addSubview(vc4.view)
            vc4.view.frame = CGRectMake(10, 170, 320, 160)
            
            //风扇
            var vc5 = UIHostingController(rootView:SmallWidgetFanView())
            vc5.view.layer.cornerRadius = 22;
            vc5.view.layer.masksToBounds = true;
            scrolV.addSubview(vc5.view)
            vc5.view.frame = CGRectMake(10, 340, 160, 160)
            
            //时钟
            var vc6 = UIHostingController(rootView:SmallWidgetClockView())
            vc6.view.layer.cornerRadius = 22;
            vc6.view.layer.masksToBounds = true;
            scrolV.addSubview(vc6.view)
            vc6.view.frame = CGRectMake(180, 340, 160, 160)
            
            //小组件模拟帧动画
            if #available(iOS 15.0, *) {
                var vc7 = UIHostingController(rootView:WidgetFrameAniView(frameImages: ["01","02","03","04","05","06","07","08","09","010"]))
                vc7.view.backgroundColor = UIColor.black
                vc7.view.layer.cornerRadius = 22;
                vc7.view.layer.masksToBounds = true;
                scrolV.addSubview(vc7.view)
                vc7.view.frame = CGRectMake(10, 530, 160, 160)
                
               
            }
            
            
            if #available(iOS 14.0, *) {
                var vc8 = UIHostingController(rootView:WidgetFrameAniView2(color: .white))
                vc8.view.backgroundColor = UIColor.black
                vc8.view.layer.cornerRadius = 22;
                vc8.view.layer.masksToBounds = true;
                scrolV.addSubview(vc8.view)
                vc8.view.frame = CGRectMake(180, 530, 80, 80)
                
                var vc9 = UIHostingController(rootView:WidgetFrameAniView2(color: .red))
                vc9.view.backgroundColor = UIColor.black
                vc9.view.layer.cornerRadius = 22;
                vc9.view.layer.masksToBounds = true;
                scrolV.addSubview(vc9.view)
                vc9.view.frame = CGRectMake(270, 530, 80, 80)
                
            }
            
            
            
            
           
            
        }
       
        
    }
    
//    static func createScroPic() -> FactorySwiftUIView {
//
//        if #available(iOS 14.0, *) {
//            
//            var view = self.init()
//            var vc = UIHostingController(rootView:WidgetSwiftView())
//            view.addSubview(vc.view)
//            vc.view.frame = CGRectMake(0, 0, 158, 158)
//            vc.view.backgroundColor = UIColor.white
//            return view
//        } else {
//            var view = self.init()
////            var vc = UIHostingController(rootView:Text("1r"))
////            view.addSubview(vc.view)
////            vc.view.frame = CGRectMake(0, 0, 158, 158)
//            view.backgroundColor = UIColor.green
//            return view
//        }
//    }
//    
    
}



