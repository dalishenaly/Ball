//
//  THInfoEditCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/30.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import QMUIKit

class THInfoEditCell: UITableViewCell {
    
    var valueChangedBlock: ((_ text: String) -> Void)?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_333333
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var textField: QMUITextField = {
        let textField = QMUITextField()
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.textAlignment = .right
        textField.textColor = COLOR_999999
        return textField
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

extension THInfoEditCell {
    func configUI() {
        selectionStyle = .none
        addSubview(titleLabel)
        addSubview(textField)
    }
    
    func configFrame() {
        
        titleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(22)
            make.left.equalTo(16)
            make.top.equalTo(15)
            make.bottom.equalTo(-15)
            make.width.equalTo(titleLabel)
        }
        
        textField.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.height.equalTo(titleLabel)
            make.right.equalTo(-16)
            make.left.equalTo(titleLabel.snp_right).offset(10)
        }
    }
    
    func configData() {
        textField.addTarget(self, action: #selector(textFieldShouldChanged), for: .editingChanged)
    }
    
}

extension THInfoEditCell {
    
    @objc func textFieldShouldChanged() {
        
        valueChangedBlock?(textField.text ?? "")
    }
}
