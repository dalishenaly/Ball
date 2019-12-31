//
//  THInputCodeVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/2.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import IQKeyboardManager

class THInputCodeVC: THBaseVC {

    var phone: String?
    
    var second = 10
    var timer: Timer?
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var fourthTextField: UITextField!
    
    var showlabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailLabel.text = "已发送至手机 \(phone ?? "") 重新发送(\(second))"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerInterval), userInfo: nil, repeats: true)
        timer?.fire()
        
        
        view.layoutIfNeeded()
        
        let code = CodeView(frame: CGRect(x: 0, y: 0, width: 210, height: 50))
        //Change Basic Attributes
        /*
         code.Base.changeViewBasicAttributes(codeNum: 4, lineColor: UIColor.blue, lineInputColor: UIColor.black, cursorColor: UIColor.red, errorColor: UIColor.red, fontNum: UIFont.systemFont(ofSize: 20), textColor: UIColor.black)
         or
         code.Base.changeInputNum(num: 4)
         */
        
        //To obtain Input Text
        code.callBacktext = { str in
            if str == "1234" {
                
            } else {
                code.clearnText(error: "error")
            }
        }
        
        code.top = detailLabel.bottom + 45
        code.centerX = view.centerX
        
        view.addSubview(code)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared().isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared().isEnabled = true
    }
    
    
    func configUI() {

    }
    
    func configFrame() {
        
    }
    
    func configData() {
        
    }
    
    @objc func onTimerInterval() {
        second -= 1
        detailLabel.text = "已发送至手机 \(phone ?? "") 重新发送(\(second))"

        if second <= 0{
            timer?.invalidate()
            second = 10
            detailLabel.text = "已发送至手机 \(phone ?? "") 重新发送"
        }
    }
    

}

extension THInputCodeVC: UITextFieldDelegate {
    
}

