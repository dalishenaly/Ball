//
//  THLoginController.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/17.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import SwiftyRSA
class THLoginController: NSObject {

    static let instance = THLoginController()
    
    let userInfoPath = documentPath + "/currentUser"
    
    
    var hasLogin: Bool?
    var hasBind: Bool?
}

extension THLoginController {
    
    
    /// 保存用户信息
    func saveUserInfo(userInfo: THUserModel) {
        //  归档保存输入信息
        NSKeyedArchiver.archiveRootObject(userInfo, toFile: userInfoPath)
    }
    
    
    /// 获取用户信息
    func getUserInfo() -> THUserModel {
        //  解档设置保存的信息
        guard let infoModel = NSKeyedUnarchiver.unarchiveObject(withFile: userInfoPath) as? THUserModel else { return THUserModel() }
        
        return infoModel
    }
    
    /// 删除用户信息
    func deleteUserInfo() {
        //  删除储存信息文件
        if FileManager.default.fileExists(atPath: userInfoPath) {
            try? FileManager.default.removeItem(atPath: userInfoPath) // 删除文件
        }
    }
}

