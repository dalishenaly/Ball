//
//  THIconCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/28.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THIconCell: UITableViewCell {
    
    var iconView = UIImageView()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_324057
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

extension THIconCell {
    
    func configUI() {
        selectionStyle = .none
        contentView.addSubview(iconView)
        contentView.addSubview(arrowView)
        contentView.addSubview(titleLabel)
    }
    
    func configFrame() {
        iconView.snp.makeConstraints { (make) in
            make.height.width.equalTo(50)
            make.left.equalTo(16)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
        arrowView.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-16)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(8)
            make.right.equalTo(arrowView.snp_left).offset(-8)
            make.centerY.equalTo(contentView)
            make.height.equalTo(titleLabel)
        }
        
        iconView.setCorner(cornerRadius: 25)
        
    }
    
    func configData() {
        
    }
}
