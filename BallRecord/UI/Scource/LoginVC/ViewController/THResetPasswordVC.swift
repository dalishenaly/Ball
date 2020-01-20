//
//  THResetPasswordVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/2.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import QMUIKit

class THResetPasswordVC: THBaseVC {

    var code: String?
    var phone: String?
    @IBOutlet weak var firstTextField: UITextField!
    
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var sureBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sureBtn.setCorner(cornerRadius: 4)
        
    }

    @IBAction func sureEvent(_ sender: Any) {
        
        if firstTextField.text?.isEmpty ?? true {
            QMUITips.show(withText: "请输入新密码")
            return
        }
        
        if secondTextField.text?.isEmpty ?? true {
            QMUITips.show(withText: "请再次输入新密码")
            return
        }
        
        if firstTextField.text! != secondTextField.text {
            QMUITips.show(withText: "两次密码输入不一样")
            return
        }
        
        let param = ["phone": phone ?? "" , "code": code ?? "", "newPassword": firstTextField.text!]
        QMUITips.showLoading(in: view)
        THLoginRequestManager.requestSetNewPwd(param: param, successBlock: { (response) in
            QMUITips.hideAllTips()
            
            let vc = THResetPwdResultVC()
            vc.resetReuslt = .success
            self.navigationPushVC(vc: vc)

            
        }) { (error) in
            QMUITips.hideAllTips()
            let vc = THResetPwdResultVC()
            vc.resetReuslt = .failure
            self.navigationPushVC(vc: vc)
        }
        
        
    }
}
