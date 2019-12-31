//
//  THRegisterVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/10.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import QMUIKit

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

    @IBAction func clickSendCodeEvent(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerInterval), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @IBAction func clickResigetrEvent(_ sender: Any) {
        guard let phone = phoneField.text else {
            QMUITips.show(withText: "请输入手机号")
            return
        }
        
        if phone.count == 11 && phone.first == "1" {
            
            
        } else {
            QMUITips.show(withText: "请输入正确手机号")
        }
    }
   

    @objc func onTimerInterval() {
        second -= 1
        sendCodeBtn.titleLabel?.text = "\(second)s后重试"
        sendCodeBtn.setTitle("\(second)s后重试", for: .normal)

        if second <= 0{
            timer?.invalidate()
            second = 61
            sendCodeBtn.titleLabel?.text = "发送验证码"
            sendCodeBtn.setTitle("发送验证码", for: .normal)
        }
    }
}
