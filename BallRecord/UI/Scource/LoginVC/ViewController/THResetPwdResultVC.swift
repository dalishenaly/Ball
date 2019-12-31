//
//  THResetPwdResultVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/10.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

enum ResetReuslt {
    case success
    case failure
}


class THResetPwdResultVC: THBaseVC {
    
    var resetReuslt: ResetReuslt?
    var timer: Timer?
    
    var second = 5
    
    let successTitle = "密码修改成功"
    let failureTitle = "密码修改失败"
    
    let successDesc = "您可以在下次使用新密码进行登录"
    let failureDesc = "发生了不可以预知的错误，请重试"
    
    var tips: String?
    var desc: String?
    
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        return imgV
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_333333
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = COLOR_999999
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var backBtn: UIButton = {
        let button = UIButton()
        button.setTitle("\(second)s后将返回登录页面，请重新登录", for: .normal)
        button.setTitleColor(MAIN_COLOR, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(clickBackBtnEvent), for: .touchUpInside)
        return button
    }()
    lazy var resetBtn: UIButton = {
        let button = UIButton()
        button.setTitle("重新修改", for: .normal)
        button.backgroundColor = MAIN_COLOR
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickResetBtnEvent), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        configFrame()
        configData()
    }

}

extension THResetPwdResultVC {
    
    func configUI() {
        view.addSubview(iconView)
        view.addSubview(titleLabel)
        view.addSubview(detailLabel)
        view.addSubview(backBtn)
        view.addSubview(resetBtn)
    }
    
    func configFrame() {
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.height.equalTo(123)
            make.top.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(iconView.snp_bottom).offset(10)
            make.height.equalTo(titleLabel)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(titleLabel.snp_bottom).offset(10)
            make.height.equalTo(detailLabel)
        }
        
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(detailLabel.snp_bottom).offset(10)
            make.height.equalTo(backBtn)
        }
        
        resetBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.bottom.equalTo(view.snp_bottom).offset(-120)
            make.height.equalTo(40)
        }
        
        resetBtn.setCorner(cornerRadius: 4)
    }
    
    func configData() {
        
        tips = resetReuslt == .success ? successTitle : failureTitle
        desc = resetReuslt == .success ? successDesc : failureDesc
        backBtn.isHidden = resetReuslt == .failure
        resetBtn.isHidden = resetReuslt == .success
        
        titleLabel.text = tips
        detailLabel.text = desc
        iconView.image = resetReuslt == .success ? UIImage(named: "success_icon") : UIImage(named: "failure_icon")
        
        if resetReuslt == .success {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerInterval), userInfo: nil, repeats: true)
            timer?.fire()
        }
    }
    
    @objc func clickResetBtnEvent() {
        
    }
    
    @objc func clickBackBtnEvent() {
        popToRootVCAndPushLoginVC()
    }
    
    @objc func onTimerInterval() {
        second -= 1
        if second <= 0{
            timer?.invalidate()
            timer = nil
            popToRootVCAndPushLoginVC()
        }
        backBtn.setTitle("\(second)s后将返回登录页面，请重新登录", for: .normal)
    }
    
    func popToRootVCAndPushLoginVC() {
        if let viewCtrs = self.navigationController?.viewControllers, viewCtrs.count > 0 {
            var ctrs = [UIViewController]()
            ctrs.append(viewCtrs.first!)
            let loginVC = THLoginVC()
            loginVC.hidesBottomBarWhenPushed = true
            ctrs.append(loginVC)
            self.navigationController?.setViewControllers(ctrs, animated: true)
        }
    }
}


