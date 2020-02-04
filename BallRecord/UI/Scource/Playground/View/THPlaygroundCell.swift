//
//  THPlaygroundCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/4.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THPlaygroundCell: UITableViewCell {

    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = UIColor.randomColor()
        return imgV
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "北京航空航天大学"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = COLOR_333333
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "五道口西800号"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = COLOR_999999
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var likeCountLabel: UILabel = {
        let label = UILabel()
        label.text = "1111人关注"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = COLOR_8D97AE
        return label
    }()
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "  23km  "
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.backgroundColor = MAIN_COLOR
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

extension THPlaygroundCell {
    
    func configUI() {
        selectionStyle = .none
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(likeCountLabel)
        contentView.addSubview(distanceLabel)
    }
    
    func configFrame() {
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(25)
            make.bottom.equalTo(-10)
            make.width.height.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(17)
            make.right.equalTo(-15)
            make.top.equalTo(iconView).offset(8)
            make.height.equalTo(titleLabel)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp_bottom).offset(8)
            make.height.equalTo(detailLabel)
        }
        
        likeCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.right.equalTo(distanceLabel.snp_left).offset(-8)
            make.bottom.equalTo(iconView).offset(-8)
            make.height.equalTo(likeCountLabel)
        }
        
        distanceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(titleLabel)
            make.width.equalTo(distanceLabel).offset(5)
            make.bottom.equalTo(likeCountLabel)
            make.height.equalTo(18)
        }
        
        iconView.setCorner(cornerRadius: 10)
        distanceLabel.setCorner(cornerRadius: 4)
    }
    
    func configData() {
        
    }
    
    func updateModel(model: THPGModel) {
        iconView.setImage(urlStr: model.imageUrl, placeholder: placeholder_square)
        titleLabel.text = model.name
        detailLabel.text = model.location
        likeCountLabel.text = "\(model.collectionCount)人关注"
        if model.distince == 0 {
            distanceLabel.isHidden = true
        } else {
            distanceLabel.text = "  \(model.distince)km  "
            distanceLabel.isHidden = false
        }
    }
}
