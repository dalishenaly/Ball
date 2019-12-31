//
//  THSystemDialogCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/29.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THSystemDialogCell: UITableViewCell {
    
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "systemNews_icon")
        return imgV
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "球志官方"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_324057
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var view: UIView = {
        let view = UIView()
        view.backgroundColor = COLOR_F4F4F4
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "应建立在对股票投资具有充分的客观认识的基础上，通过认真地比较分析以后而进行的投资活动。"
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = COLOR_333333
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
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

extension THSystemDialogCell {
    
    func configUI() {
        selectionStyle = .none
        
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(view)
        view.addSubview(titleLabel)
    }
    
    func configFrame() {
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.height.equalTo(40)
            make.top.equalTo(8)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(8)
            make.top.equalTo(iconView)
            make.width.height.equalTo(nameLabel)
        }
        
        view.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp_bottom).offset(8)
            make.left.equalTo(nameLabel)
            make.width.height.equalTo(view)
            make.bottom.equalTo(contentView).offset(-8)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.right.bottom.equalTo(-10)
            make.width.lessThanOrEqualTo(SCREEN_WIDTH * 0.6)
            make.height.equalTo(titleLabel)
        }
        
        iconView.setCorner(cornerRadius: 20)
        view.setCorner(cornerRadius: 10)
    }
    
    func configData() {
        
    }
}
