//
//  THInputCodeVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/2.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import IQKeyboardManager
import QMUIKit

class THInputCodeVC: THBaseVC {

    var type: InputPhoneType?
    var phone: String?
    var code: CodeView?
    var second = 60
    var timer: Timer?
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var fourthTextField: UITextField!
    
    var showlabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickSendCode))
        detailLabel.addGestureRecognizer(tap)
        detailLabel.isUserInteractionEnabled = false
        
        detailLabel.adjustsFontSizeToFitWidth = true
        let str = "已发送至手机 \(phone ?? "") 重新发送(\(second))"
        
        let mutableString = NSMutableAttributedString(string: str)
        mutableString.addAttributes([NSAttributedString.Key.foregroundColor : MAIN_COLOR], range: NSRange(location: 18, length: str.count - 18))
        detailLabel.attributedText = mutableString
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerInterval), userInfo: nil, repeats: true)
        timer?.fire()
        
        code = CodeView(frame: CGRect(x: 0, y: 0, width: 210, height: 50))
        //Change Basic Attributes
        /*
         code.Base.changeViewBasicAttributes(codeNum: 4, lineColor: UIColor.blue, lineInputColor: UIColor.black, cursorColor: UIColor.red, errorColor: UIColor.red, fontNum: UIFont.systemFont(ofSize: 20), textColor: UIColor.black)
         or
         code.Base.changeInputNum(num: 4)
         */
        
        //To obtain Input Text
        code?.callBacktext = { str in
            
            if str.count == 4 {
                windowEndEditing()
                QMUITips.showLoading(in: self.view)
                if self.type == .codeLogin {
                    
                    let param = ["phone": self.phone ?? "",
                                 "code": str]
                    THLoginRequestManager.requestVcodeLogin(param: param, successBlock: { (result) in
                        QMUITips.hideAllTips()
                        let model = THUserModel.yy_model(withJSON: result)
                        THLoginController.instance.saveTokenInfo(userInfo: model ?? THUserModel())
                        popLoginRelatedVC()
                    }) { (error) in
                        QMUITips.hideAllTips()
                        QMUITips.show(withText: error.localizedDescription)
                        self.code?.clearnText(error: "error")
                    }
                } else {
                    let vc = THResetPasswordVC()
                    vc.code = str
                    vc.phone = self.phone
                    self.navigationPushVC(vc: vc)
                }
            }
        }
        
        code?.top = detailLabel.bottom + 45
        code?.centerX = SCREEN_WIDTH/2
        
        view.addSubview(code!)
        
        configData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared().isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared().isEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        code?.textFiled.becomeFirstResponder()
    }
    
    
    func configUI() {

    }
    
    func configFrame() {
        
    }
    
    func configData() {
        
        let str = self.type == .codeLogin ? "1" : "2"
        let param = ["type": str, "phone": self.phone ?? ""]
        THLoginRequestManager.requestSendVcode(param: param, successBlock: { (result) in
        }) { (error) in
        }
        
    }
    
    @objc func clickSendCode() {
        detailLabel.isUserInteractionEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerInterval), userInfo: nil, repeats: true)
        timer?.fire()
        configData()
    }
    
    @objc func onTimerInterval() {
        second -= 1
        let str = "已发送至手机 \(phone ?? "") 重新发送(\(second))"
        let mutableString = NSMutableAttributedString(string: str)
        mutableString.addAttributes([NSAttributedString.Key.foregroundColor : MAIN_COLOR], range: NSRange(location: 18, length: str.count - 18))
        detailLabel.attributedText = mutableString
        
        if second <= 0{
            timer?.invalidate()
            second = 60

            let str = "已发送至手机 \(phone ?? "") 重新发送"
            let mutableString = NSMutableAttributedString(string: str)
            mutableString.addAttributes([NSAttributedString.Key.foregroundColor : MAIN_COLOR], range: NSRange(location: 18, length: str.count - 18))
            detailLabel.attributedText = mutableString
            detailLabel.isUserInteractionEnabled = true
        }
    }
}

extension THInputCodeVC: UITextFieldDelegate {
    
}

