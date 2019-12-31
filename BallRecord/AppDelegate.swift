//
//  AppDelegate.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/17.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init()
        window?.frame = UIScreen.main.bounds
        window?.makeKeyAndVisible()
        window?.rootViewController = THMainTabbarVC()
        
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        configMobShare()
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        NotificationCenter.default.post(name: NSNotification.Name(kAppEnterBackGroundNotificationName), object: nil)
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .all
    }
}

/// configVonder
extension AppDelegate {
    
    func configMobShare() {
        ShareSDK.registPlatforms { (platformsRegister: SSDKRegister?) in
            //QQ
            platformsRegister?.setupQQ(withAppId: SPEQQAPPKey, appkey: SPEQQAPPSecret)
            //微信
            platformsRegister?.setupWeChat(withAppId: SPEWechatKey, appSecret: SPEWechatSecret)
            //新浪
            platformsRegister?.setupSinaWeibo(withAppkey: "", appSecret: "", redirectUrl: "")
        }
    }
}

let SPEQQAPPKey = "1101961128"
let SPEQQAPPSecret = "BTnN5UnEtdN2uzfe"
let SPEWechatKey = "wx568ef5bd0ed2b572"
let SPEWechatSecret = "c774adc77c378a43b6fe2c1e0bb5b69d"





