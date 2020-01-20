//
//  THAboutVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/9.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THAboutVC: THBaseVC {
    
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "aboutMine_icon")
        return imgV
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "球  志"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = COLOR_324057
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.text = "版本号："
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_666666
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.text = "商务合作请联系"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_666666
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "电话：18548910804"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_666666
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "邮箱：641316732@qq.com"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_666666
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        configFrame()
        configData()
    }

}

extension THAboutVC {
    
    func configUI() {
        title = "关于我们"
        
        view.addSubview(iconView)
//        view.addSubview(titleLabel)
        view.addSubview(versionLabel)
        view.addSubview(tipsLabel)
        view.addSubview(phoneLabel)
        view.addSubview(emailLabel)
        
    }
    
    func configFrame() {
        
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(100)
            make.height.equalTo(135)
            make.top.equalTo(30)
        }
        
//        titleLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(view)
//            make.right.equalTo(view)
//            make.top.equalTo(iconView.snp_bottom).offset(10)
//            make.height.equalTo(titleLabel)
//        }
        versionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(iconView.snp_bottom).offset(10)
            make.height.equalTo(versionLabel)
        }
        
        tipsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(phoneLabel.snp_top).offset(-10)
            make.height.equalTo(tipsLabel)
        }
        phoneLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(emailLabel.snp_top).offset(-10)
            make.height.equalTo(phoneLabel)
        }
        emailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view).offset(-44)
            make.height.equalTo(emailLabel)
        }
        
        iconView.setCorner(cornerRadius: 8)
    }
    
    func configData() {
        
        versionLabel.text = "版本号：" + appVersion
    }
}
