//
//  THInputView.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/12.
//  Copyright © 2019 maichao. All rights reserved.
//

import QMUIKit


@objc protocol THInputViewDelegate {
    func clickPublishEvent()
}

class THInputView: UIView {

    weak var delegate: THInputViewDelegate?
    var keyboardManager: QMUIKeyboardManager?
    
    lazy var textView: QMUITextView = {
        let textView = QMUITextView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 80, height: 80))
        textView.placeholder = "优质评论将会被优先展示"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = COLOR_F4F4F4
        textView.setCorner(cornerRadius: 8, masksToBounds: true, borderColor: COLOR_LINE, borderWidth: 0.5)
        textView.inputAccessoryView = UIView()
        return textView
    }()
    
    lazy var publishBtn: UIButton = {
        let button = UIButton()
        button.setTitle("发布", for: .normal)
        button.setTitleColor(UIColor.colorWithString("5E6D82"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickPublishBtnEvent), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 80))
        
        configUI()
        configFrame()
        configData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension THInputView {
    
    func configUI() {
        backgroundColor = .white
        qmui_borderColor = COLOR_LINE
        qmui_borderPosition = .top
        addSubview(textView)
        addSubview(publishBtn)
    }
    
    func configFrame() {
        
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-80)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
        publishBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.width.equalTo(80)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
    
    func configData() {
        
        keyboardManager = QMUIKeyboardManager(delegate: self)
        // 设置键盘只接受 self.textView 的通知事件，如果当前界面有其他 UIResponder 导致键盘产生通知事件，则不会被接受
        keyboardManager?.addTargetResponder(textView)
    }
    
    func textViewBecomeFirstResponder() {
        textView.becomeFirstResponder()
    }
    
    @objc func clickPublishBtnEvent() {
        delegate?.clickPublishEvent()
    }
}

extension THInputView: QMUIKeyboardManagerDelegate {
    
    func keyboardWillChangeFrame(with keyboardUserInfo: QMUIKeyboardUserInfo!) {
        
        QMUIKeyboardManager.handleKeyboardNotification(with: keyboardUserInfo, show: { (keyboardUserInfo: QMUIKeyboardUserInfo?) in
            QMUIKeyboardManager.animateWith(animated: true, keyboardUserInfo: keyboardUserInfo, animations: {
                self.bottom = SCREEN_HEIGHT - keyboardUserInfo!.endFrame.height
            }, completion: nil)
            
        }) { (keyboardUserInfo: QMUIKeyboardUserInfo?) in
            QMUIKeyboardManager.animateWith(animated: true, keyboardUserInfo: keyboardUserInfo, animations: {
                self.top = SCREEN_HEIGHT
            }, completion: nil)
        }
    }
}
