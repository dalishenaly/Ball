//
//  THRegisterVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/10.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import QMUIKit
import SwiftyRSA

class THRegisterVC: THBaseVC {
    
    var second = 11
    
    var timer: Timer?

    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var sendCodeBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerBtn.setCorner(cornerRadius: 4) 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    @IBAction func clickSendCodeEvent(_ sender: UIButton) {
        sender.isEnabled = false
        guard let phone = phoneField.text else {
            QMUITips.show(withText: "请输入手机号")
            return
        }
        if !(phone.count == 11 && phone.first == "1") {
            QMUITips.show(withText: "请输入正确手机号")
            return
        }
        
        let param = ["type": "0", "phone": phone]
        THLoginRequestManager.requestSendVcode(param: param, successBlock: { (result) in
            sender.isEnabled = false
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimerInterval), userInfo: nil, repeats: true)
            self.timer?.fire()
            
        }) { (error) in
            QMUITips.show(withText: "验证码发送失败")
            sender.isEnabled = true
        }
    }
    
    @IBAction func clickResigetrEvent(_ sender: Any) {
        guard let phone = phoneField.text else {
            QMUITips.show(withText: "请输入手机号")
            return
        }
        guard let code = codeField.text else {
            QMUITips.show(withText: "请输入验证码")
            return
        }
        guard let password = passwordField.text else {
            QMUITips.show(withText: "请输入密码")
            return
        }
        if !(phone.count == 11 && phone.first == "1") {
            QMUITips.show(withText: "请输入正确手机号")
            return
        }
        
        let param = ["phone": phone, "code": code, "password": password]
        QMUITips.showLoading(in: view)
        THLoginRequestManager.requestRegisterData(param: param, successBlock: { (result) in
            QMUITips.hideAllTips()
            QMUITips.show(withText: "注册成功")
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            QMUITips.hideAllTips()
            QMUITips.show(withText: error.localizedDescription)
        }
    }
   

    @objc func onTimerInterval() {
        second -= 1
        sendCodeBtn.titleLabel?.text = "\(second)s后重试"
        sendCodeBtn.setTitle("\(second)s后重试", for: .normal)

        if second <= 0{
            timer?.invalidate()
            second = 60
            sendCodeBtn.titleLabel?.text = "发送验证码"
            sendCodeBtn.setTitle("发送验证码", for: .normal)
            sendCodeBtn.isEnabled = true
        }
    }
}
