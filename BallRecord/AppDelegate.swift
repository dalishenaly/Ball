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
        
        
        THReachability.INSTANCE.startListening()
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        THLocationManager.instance.getLocation()
        
        configMobShare()
        
        THLoginController.instance.refreshToken()
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kAppEnterBackGroundNotificationName), object: nil)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kAppEnterForegroundNotificationName), object: nil)
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .all
    }
}

// MARK:- 公开常用属性
extension AppDelegate{
    
    /// 当前 应用层 的窗口
    static var WINDOW: UIWindow?{ return (UIApplication.shared.delegate as? AppDelegate)?.window }
    
    /// 当前显示的 tabBar VC
    static var CURRENT_TAB_VC: THMainTabbarVC?{ return WINDOW?.rootViewController as? THMainTabbarVC }
    
    /// 当前显示的导航 VC
    static var CURRENT_NAV_VC: THBaseNavVC?{ return CURRENT_TAB_VC?.selectedViewController as? THBaseNavVC }
    
    /// 当前显示的 VC
    static var CURRENT_VC: UIViewController?{ return CURRENT_NAV_VC?.topViewController }
    
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
            platformsRegister?.setupSinaWeibo(withAppkey: sinaAPPKey, appSecret: sinaAPPSecret, redirectUrl: "http://www.sharesdk.cn")
        }
    }
}

let SPEQQAPPKey = "1110222860"
let SPEQQAPPSecret = "v7v6ogAwDnwmuGIb"

let SPEWechatKey = "wx21b92785c963b82f"
let SPEWechatSecret = "21dd594f79d3343595ff1989d9d680c6"

let sinaAPPKey = "2209030890"
let sinaAPPSecret = "86bd05eb3bfd1821ecccb4e2c9a304c1"





