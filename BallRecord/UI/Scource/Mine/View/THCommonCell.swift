//
//  THCommonCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/27.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THCommonCell: UITableViewCell {
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 5
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_333333
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .right
        label.textColor = COLOR_999999
        label.setContentHuggingPriority(.required, for: .horizontal)
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

extension THCommonCell {
    func configUI() {
        selectionStyle = .none
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(detailLabel)
        stackView.addArrangedSubview(arrowView)
    }
    
    func configFrame() {
        
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.height.equalTo(52)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(22)
            make.width.equalTo(titleLabel)
            make.top.equalTo(15)
            make.bottom.equalTo(-15)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(stackView)
            make.height.equalTo(detailLabel)
            make.width.equalTo(detailLabel)
        }
        
        arrowView.snp.makeConstraints { (make) in
            make.centerY.equalTo(stackView)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
    }
    
    func configData() {
        
    }
}
