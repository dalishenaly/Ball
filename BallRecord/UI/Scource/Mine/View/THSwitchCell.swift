//
//  THSwitchCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/27.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THSwitchCell: UITableViewCell {
    
    var switchVlaueChangeBlock: ((_ isOn: Bool) -> Void)?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_333333
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var swch: UISwitch = {
        let swch = UISwitch()
        swch.onTintColor = MAIN_COLOR
        swch.addTarget(self, action: #selector(switchChange(sender:)), for: .valueChanged)
        return swch
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configUI()
        configFrame()
        configData()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension THSwitchCell {
    func configUI() {
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        contentView.addSubview(swch)
    }
    
    func configFrame() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(swch.snp_left).offset(-10)
            make.top.equalTo(15)
            make.bottom.equalTo(-15)
            make.height.equalTo(22)
        }
        
        swch.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.centerY.equalTo(contentView)
            make.width.equalTo(60)
        }
    }
    
    func configData() {
        swch.isOn = LocalStoreUtil.INSTANCE.getWifiSwichStatus()
    }
    
    @objc func switchChange(sender: UISwitch) {
        switchVlaueChangeBlock?(sender.isOn)
    }
}
