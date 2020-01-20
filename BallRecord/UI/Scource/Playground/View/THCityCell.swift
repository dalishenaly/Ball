//
//  THCityCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/3.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THCityCell: UITableViewCell {

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

extension THCityCell {
    
    func configUI() {
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowView)
    }
    
    func configFrame() {
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(arrowView.snp_left).offset(-10)
            make.height.equalTo(40)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
        arrowView.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-20)
            make.centerY.equalTo(contentView.snp_centerY)
            make.width.height.equalTo(20)
        }
    }
    
    func configData() {
        
    }
}


