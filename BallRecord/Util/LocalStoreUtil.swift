//
//  LocalStoreUtil.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/27.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class LocalStoreUtil: NSObject {
    
    static let INSTANCE = LocalStoreUtil()
    let userDefault: UserDefaults = UserDefaults.standard


    let WIFI_SWITCH_STATUS_KEY: String = "wifiSwithStatusKey"
    
    
    func saveWifiSwichStatus(value: Bool) {
        userDefault.set(value, forKey: WIFI_SWITCH_STATUS_KEY)
    }
    
    func getWifiSwichStatus() -> Bool{
        let turnOn = userDefault.bool(forKey: WIFI_SWITCH_STATUS_KEY)
        return turnOn
    }
}
