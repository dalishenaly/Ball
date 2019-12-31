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
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        
        if phone.count == 11 && phone.first == "1" {
            
            
        } else {
            QMUITips.show(withText: "请输入正确手机号")
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
            
            navigationController?.popViewController(animated: true)
        } else if status == .cancel {
            
        } else if status == .fail {
                       
        }
    }
    
}
