//
//  THMineDialogCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/29.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THMineDialogCell: UITableViewCell {

    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        return imgV
    }()
    
    lazy var view: UIView = {
        let view = UIView()
        view.backgroundColor = MAIN_COLOR
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .white
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

extension THMineDialogCell {
    
    func configUI() {
        selectionStyle = .none
        
        contentView.addSubview(iconView)
        contentView.addSubview(view)
        view.addSubview(titleLabel)
    }
    
    func configFrame() {
        
        iconView.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.width.height.equalTo(40)
            make.top.equalTo(8)
        }
        
        view.snp.makeConstraints { (make) in
            make.top.equalTo(iconView)
            make.right.equalTo(iconView.snp_left).offset(-8)
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
