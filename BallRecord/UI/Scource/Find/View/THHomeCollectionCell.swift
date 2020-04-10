//
//  THHomeCollectionCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/4.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THHomeCollectionCell: UICollectionViewCell {

    var model: THDynamicModel?
    var coverView = videoCoverView()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "sdfasfasfasfasfadsf"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = COLOR_333333
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        return imgV
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "dfsdfs"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = COLOR_666666
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var likeBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "like_normal"), for: .normal)
        button.setImage(UIImage(named: "like_selected"), for: .selected)
        button.setTitleColor(UIColor.colorWithString("5E6D82"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        button.addTarget(self, action: #selector(clickButtonEvent), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
        configFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension THHomeCollectionCell {
    
    func configUI() {
        contentView.addSubview(coverView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(likeBtn)
    }
    
    func configFrame() {
        coverView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(self.snp_width).multipliedBy(1.2)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(9)
            make.right.equalTo(-9)
            make.top.equalTo(coverView.snp_bottom).offset(7)
            make.height.equalTo(titleLabel)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(9)
            make.width.height.equalTo(25)
            make.top.equalTo(titleLabel.snp_bottom).offset(7)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(9)
            make.width.height.equalTo(nameLabel)
            make.centerY.equalTo(iconView)
        }
        
        likeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-9)
            make.centerY.equalTo(iconView)
            make.width.height.equalTo(likeBtn)
        }
        
    }
    
    func updateModel(model: THDynamicModel) {
        self.model = model
        coverView.setImage(urlStr: model.imageUrl, placeholder: placeholder_square)
        titleLabel.text = model.content
        iconView.setImage(urlStr: model.publisherIcon, placeholder: placeholder_round)
        nameLabel.text = model.publisherName
        
        let count = model.praiseCount > 0 ? "\(model.praiseCount)" : ""
        likeBtn.setTitle(count, for: .normal)
        likeBtn.isSelected = model.hasPraise ?? false
        
        titleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(9)
            make.right.equalTo(-9)
            make.top.equalTo(coverView.snp_bottom).offset(7)
            make.height.equalTo(model.titlLableHeight)
        }
    }
}
