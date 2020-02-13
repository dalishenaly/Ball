//
//  THPersonalHeaderCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/30.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THPersonalHeaderCell: UITableViewCell {

    var clickIconBlock: (()->Void)?
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_333333
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        imgV.isUserInteractionEnabled = true
        return imgV
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configUI()
        configFrame()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickIconEvent))
        iconView.addGestureRecognizer(tap)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension THPersonalHeaderCell {
    func configUI() {
        selectionStyle = .none
        addSubview(titleLabel)
        addSubview(iconView)
    }
    
    func configFrame() {
        
        titleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(22)
            make.left.equalTo(16)
            make.centerY.equalTo(iconView)
            make.width.equalTo(titleLabel)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.width.height.equalTo(50)
            make.right.equalTo(-16)
            make.bottom.equalTo(-10)
        }
        
        iconView.setCorner(cornerRadius: 25)
    }
    
    @objc func clickIconEvent() {
        clickIconBlock?()
    }
}
