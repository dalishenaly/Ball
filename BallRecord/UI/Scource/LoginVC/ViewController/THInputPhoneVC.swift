//
//  THInputPhoneVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/2.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import QMUIKit

enum InputPhoneType {
    case codeLogin
    case findPwd
}

class THInputPhoneVC: THBaseVC {

    var type: InputPhoneType?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phoneTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let str = type == .codeLogin ? "验证码登录" : "找回密码"
        titleLabel.text = str
    }

    @IBAction func nextEvent(_ sender: Any) {
        guard let phone = phoneTextfield.text else {
            QMUITips.show(withText: "请输入手机号")
            return
        }
        if !(phone.count == 11 && phone.first == "1") {
            QMUITips.show(withText: "请输入正确手机号")
            return
        }
        
        let vc = THInputCodeVC()
        vc.phone = phone
        vc.type = self.type
        navigationPushVC(vc: vc)
    }
    
}
