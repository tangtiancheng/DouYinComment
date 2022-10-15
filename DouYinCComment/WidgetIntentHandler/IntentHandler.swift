//
//  IntentHandler.swift
//  GKWYIntent
//
//  Created by han on 2022/10/11.
//  Copyright © 2022 唐天成. All rights reserved.
//

import Intents


class IntentHandler: INExtension, ConfigurationIntentHandling {
    func provideModeArrOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping (INObjectCollection<RTDDWidgetMode>?, Error?) -> Void) {
        var list = [RTDDWidgetMode]()
        for data in RTDDData.getList() {
            if intent.modeArr != nil {
                var exist = false
                for mode in intent.modeArr! {
                    if mode.identifier == data.id {
                        exist = true
                    }
                }
                // 没有才去添加
                if !exist {
                    list.append( .init(identifier: data.id, display: data.title, subtitle: data.desc, image: nil))
                }
            }else {
                list.append(.init(identifier: data.id, display: data.title, subtitle: data.desc, image: nil))
            }
        }
        completion(.init(items: list), nil)
    }

    func defaultModeArr(for intent: ConfigurationIntent) -> [RTDDWidgetMode]? {
        return RTDDData.getModeList()
    }

    override func handler(for intent: INIntent) -> Any {
        return self
    }
}
