//
//  THBindAlert.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/6.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

typealias bindBlockType = (_ state: SSDKResponseState, _ user: SSDKUser?)->Void

class THBindAlert: UIView {
    
    var choiceBlock: bindBlockType?

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var weChatView: UIView!
    
    @IBOutlet weak var qqView: UIView!
    
    @IBOutlet weak var weiboView: UIView!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = UIScreen.main.bounds
        
        alertView.addRoundedOrShadow(radius: 8, shadowOpacity: 0.3, shadowColor: .black)
        weChatView.setCorner(cornerRadius: 8)
        weiboView.setCorner(cornerRadius: 8)
        cancelBtn.setCorner(cornerRadius: 8)

        addGesture()
    }
    
    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickWeChatView))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(clickQQView))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(clickWeiBoView))
        
        weChatView.addGestureRecognizer(tap)
        qqView.addGestureRecognizer(tap2)
        weiboView.addGestureRecognizer(tap3)
    }
    
    @IBAction func clickCancelBtn(_ sender: Any) {
        dismiss()
    }
    
    @objc func clickWeChatView() {
        ShareSDK.getUserInfo(.typeWechat) { (state: SSDKResponseState, user: SSDKUser?, error: Error?) in
            self.choiceBlock?(state, user)
            self.dismiss()
        }
    }
    
    @objc func clickQQView() {
        ShareSDK.getUserInfo(.typeQQ) { (state: SSDKResponseState, user: SSDKUser?, error: Error?) in
            self.choiceBlock?(state, user)
            self.dismiss()
        }
    }
    
    @objc func clickWeiBoView() {
        ShareSDK.getUserInfo(.typeSinaWeibo) { (state: SSDKResponseState, user: SSDKUser?, error: Error?) in
            self.choiceBlock?(state, user)
            self.dismiss()
        }
    }
    
    
    class func show(choiceBlock: bindBlockType?) {
        let alert = THBindAlert.loadNib()
        alert.choiceBlock = choiceBlock
        if let window = UIApplication.shared.delegate?.window {
            window?.addSubview(alert)
        }
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    
    override func draw(_ rect: CGRect) {
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
    }
}
