//
//  THPlaygroundDetailCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/6.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THPlaygroundDetailCell: UITableViewCell {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_333333
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_999999
        return label
    }()
    
    let line: UIView = UIView()
    
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

extension THPlaygroundDetailCell {
    
    func configUI() {
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(line)
        
        line.backgroundColor = COLOR_F4F4F4
    }
    
    func configFrame() {
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(16)
            make.top.equalTo(contentView).offset(16)
            make.height.width.equalTo(titleLabel)
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp_right).offset(10)
            make.right.equalTo(contentView).offset(-30)
            make.top.equalTo(titleLabel)
            make.height.equalTo(descLabel)
            make.bottom.equalTo(contentView).offset(-16)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
            make.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
    
    func configData() {
        
    }
}
