//
//  THLoginVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/2.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import QMUIKit

class THLoginVC: THBaseVC {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userName: QMUITextField!
    @IBOutlet weak var password: QMUITextField!
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(clickItem))
        navigationItem.rightBarButtonItem = item
    }

    @objc func clickItem() {
        let vc = THRegisterVC()
        navigationPushVC(vc: vc)
    }
    
    @IBAction func codeLoginEvent(_ sender: Any) {
        let vc = THInputPhoneVC()
        vc.type = .codeLogin
        navigationPushVC(vc: vc)
    }
    
    @IBAction func forgetPasswordEvent(_ sender: Any) {
        let vc = THInputPhoneVC()
        vc.type = .findPwd
        navigationPushVC(vc: vc)
    }
    
    @IBAction func loginEvent(_ sender: Any) {
        
        guard let phone = userName.text else {
            QMUITips.show(withText: "请输入手机号")
            return
        }
        guard let password = password.text else {
            QMUITips.show(withText: "请输入密码")
            return
        }
        if !(phone.count == 11 && phone.first == "1") {
            QMUITips.show(withText: "请输入正确手机号")
            return
        }
        
        let param = ["username": phone, "password": password]
        QMUITips.showLoading(in: view)
        THLoginRequestManager.requestLogin(param: param, successBlock: { (result) in
            QMUITips.hideAllTips()
            let model = THUserModel.yy_model(withJSON: result)
            THLoginController.instance.saveTokenInfo(userInfo: model ?? THUserModel())
            
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            QMUITips.hideAllTips()
            QMUITips.show(withText: error.localizedDescription)
        }
        
        
    }
    
    @IBAction func weChatLoginEvent(_ sender: Any) {
        
        ShareSDK.authorize(SSDKPlatformType.typeWechat, settings: nil) { (status: SSDKResponseState, user: SSDKUser?, error: Error?) in
            self.authorizeHandle(status: status, user: user)
        }
    }
    
    @IBAction func qqLoginEvent(_ sender: Any) {
        
        ShareSDK.authorize(SSDKPlatformType.typeQQ, settings: nil) { (status: SSDKResponseState, user: SSDKUser?, error: Error?) in
            self.authorizeHandle(status: status, user: user)
        }
    }
    
    @IBAction func weiboLoginEvent(_ sender: Any) {
        
        ShareSDK.authorize(SSDKPlatformType.typeSinaWeibo, settings: nil) { (status: SSDKResponseState, user: SSDKUser?, error: Error?) in
            self.authorizeHandle(status: status, user: user)
        }
    }
    
    
    /// 授权登录处理
    func authorizeHandle(status: SSDKResponseState, user: SSDKUser?) {
        if status == .success {
            QMUITips.showLoading(in: self.view)
            var platform = ""
            if user?.platformType == SSDKPlatformType.typeWechat {
                platform = "wechat"
            } else if user?.platformType == SSDKPlatformType.typeQQ {
                platform = "qq"
            } else {
                platform = "weibo"
            }
            let param = ["type": platform, "openid": user?.uid, "nickname": user?.nickname, "imagePath": user?.icon]
            THLoginRequestManager.requestThirdLogin(param: param, successBlock: { (result) in
                QMUITips.hideAllTips()
                
                
                
                self.navigationController?.popViewController(animated: true)
            }) { (error) in
                QMUITips.hideAllTips()
            }
            
        } else if status == .cancel {
            
        } else if status == .fail {
                       
        }
    }
    
}

/// pop登录相关vc
func popLoginRelatedVC() {
    let vcArr = AppDelegate.CURRENT_NAV_VC?.viewControllers ?? []
    var vcArray = [UIViewController]()
    for vc in vcArr {
        if !(vc is THLoginVC || vc is THRegisterVC || vc is THInputPhoneVC || vc is THInputCodeVC || vc is THResetPasswordVC || vc is THResetPwdResultVC) {
            vcArray.append(vc)
        }
    }
    AppDelegate.CURRENT_NAV_VC?.setViewControllers(vcArray, animated: true)
}

/// pop到登录相关vc
func popToLoginVC() {
    let vcArr = AppDelegate.CURRENT_NAV_VC?.viewControllers ?? []
    var vcArray = [UIViewController]()
    for vc in vcArr {
        if !(vc is THLoginVC || vc is THRegisterVC || vc is THInputPhoneVC || vc is THInputCodeVC || vc is THResetPasswordVC || vc is THResetPwdResultVC) {
            vcArray.append(vc)
        }
    }
    let vc = THLoginVC()
    vc.hidesBottomBarWhenPushed = true
    vcArray.append(THLoginVC())
    AppDelegate.CURRENT_NAV_VC?.setViewControllers(vcArray, animated: true)
}
