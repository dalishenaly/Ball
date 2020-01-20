//
//  DefineUtil.swift
//  fq
//
//  Created by 买超 on 2019/9/24.
//  Copyright © 2019 natloc. All rights reserved.
//

import UIKit


let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let SCREEN_WIDTH_SCALE = (SCREEN_WIDTH / 375)
let SCREEN_HEIGHT_SCALE = (SCREEN_HEIGHT / 812)

let STATUS_BAR_HEIGHT = UIApplication.shared.statusBarFrame.height
let TABBAR_HEIGHT = (isiPhoneX() ? CGFloat(83)  : CGFloat(49))
let NAVIGATIONBAR_HEIGHT = (isiPhoneX() ? CGFloat(88) : CGFloat(64))
let BOTTOM_SAFEAREA_HEIGHT = (isiPhoneX() ? CGFloat(34)  : CGFloat(0))

let infoDic: [String : Any]? = Bundle.main.infoDictionary
// 获取App的版本
let appVersion: String = infoDic?["CFBundleShortVersionString"] as? String ?? ""
let appBundleId: String = infoDic?["CFBundleIdentifier"] as? String ?? "" // 获取App的bundleId
let appBuildVersion: String = infoDic?["CFBundleVersion"] as? String ?? "" // 获取App的build版本
let appName: String = infoDic?["CFBundleDisplayName"] as? String ?? "" // 获取App的名称

func isiPhoneX() ->Bool {
    return STATUS_BAR_HEIGHT > 20 ? true : false
}

func windowEndEditing() {
    if let window = UIApplication.shared.delegate?.window {
        window?.endEditing(true)
    }
}

func SYSTEM_MEDIUM_FONT(_ font: CGFloat) -> (UIFont) {
    return UIFont(name: ".PingFangSC-Medium", size: (font))!
}

/// docement路径
var documentPath: String {
    let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    let documentPath = documentPaths.first
    return documentPath ?? ""
}

/// library路径
var libraryPath: String {
    let libraryPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    let libraryPath = libraryPaths.first
    return libraryPath ?? ""
}

/// cache路径
var cachesPath: String {
    let cachesPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    let cachesPath = cachesPaths.first
    return cachesPath ?? ""
}

class DefineUtil: NSObject {

}
