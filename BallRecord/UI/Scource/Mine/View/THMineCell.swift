//
//  THMineCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/27.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THMineCell: UITableViewCell {
    
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        return imgV
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "111"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_666666
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var arrowView: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "cell_arrow_icon")
        return imgV
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

extension THMineCell {
    func configUI() {
        selectionStyle = .none
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowView)
    }
    
    func configFrame() {
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(18)
            make.width.height.equalTo(30)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(10)
            make.centerY.equalTo(iconView)
            make.width.height.equalTo(titleLabel)
        }
        
        arrowView.snp.makeConstraints { (make) in
            make.right.equalTo(-18)
            make.centerY.equalTo(iconView)
            make.width.height.equalTo(20)
        }
    }
    
    func configData() {
        
    }
}
