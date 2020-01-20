//
//  THLoginController.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/17.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THLoginController: NSObject {

    static let instance = THLoginController()
    
    let userInfoPath = documentPath + "/currentUser"
    
    
    var hasLogin: Bool {
        return getTokenInfo().token != ""
    }
    var hasBind: Bool {
        return (userInfo?.openid ?? "") != ""
    }
    
    var userInfo: THUserInfoModel?
}

extension THLoginController {
    
    
    /// 保存用户信息
    func saveTokenInfo(userInfo: THUserModel) {
        //  归档保存输入信息
        NSKeyedArchiver.archiveRootObject(userInfo, toFile: userInfoPath)
    }
    
    
    /// 获取用户信息
    func getTokenInfo() -> THUserModel {
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
    
    func logout() {
        deleteUserInfo()
        userInfo = nil
        AppDelegate.CURRENT_NAV_VC?.popToRootViewController(animated: true)
    }
    
    func pushLoginVC(hasLogin: (()->Void)?) {
        if self.hasLogin {
            hasLogin?()
            return
        }
        
        let loginVC = THLoginVC()
        loginVC.hidesBottomBarWhenPushed = true
        AppDelegate.CURRENT_NAV_VC?.pushViewController(loginVC, animated: true)
    }
    
    func refreshToken() {
        let uid = getTokenInfo().uid
        if uid != "" {
            let param = ["uid": uid]
            THLoginRequestManager.requestRefreshToken(param: param, successBlock: { (result) in
                let model = THUserModel.yy_model(withJSON: result)
                THLoginController.instance.saveTokenInfo(userInfo: model ?? THUserModel())
            }) { (error) in
            }
        }
    }
}


