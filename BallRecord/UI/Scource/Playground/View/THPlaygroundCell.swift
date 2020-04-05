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
        imgV.layer.cornerRadius = 6
        imgV.layer.masksToBounds = true
        return imgV
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.white
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
//    lazy var detailLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 2
//        label.font = UIFont.systemFont(ofSize: 13)
//        label.textColor = COLOR_999999
//        label.setContentHuggingPriority(.required, for: .horizontal)
//        label.setContentCompressionResistancePriority(.required, for: .horizontal)
//        return label
//    }()
    lazy var likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.backgroundColor = BTN_DISABLE
        label.adjustsFontSizeToFitWidth = true
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
        iconView.addSubview(titleLabel)
//        iconView.addSubview(detailLabel)
        iconView.addSubview(likeCountLabel)
        iconView.addSubview(distanceLabel)
    }
    
    func configFrame() {
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.bottom.equalTo(0)
            make.right.equalTo(-15)
            make.height.equalTo(140)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp_left).offset(8)
            make.right.equalTo(-8)
            make.top.equalTo(10)
            make.height.equalTo(titleLabel)
        }
        
//        detailLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(titleLabel)
//            make.right.equalTo(titleLabel)
//            make.top.equalTo(titleLabel.snp_bottom).offset(8)
//            make.height.equalTo(detailLabel)
//        }
        
        likeCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp_left)
            make.right.equalTo(titleLabel.snp_right)
            make.top.equalTo(titleLabel.snp_bottom).offset(15)
            make.height.equalTo(likeCountLabel)
        }
        
        distanceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp_left)
            make.width.equalTo(80)
            make.top.equalTo(likeCountLabel.snp_bottom).offset(15)
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
//        detailLabel.text = model.location
        likeCountLabel.text = "\(model.collectionCount)人已收藏"
        if model.distince == 0 {
            distanceLabel.isHidden = true
        } else {
            distanceLabel.text = "  \(model.distince)km  "
            distanceLabel.isHidden = false
        }
    }
}
