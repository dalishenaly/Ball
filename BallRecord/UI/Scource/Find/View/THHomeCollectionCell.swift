//
//  THHomeCollectionCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/4.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THHomeCollectionCell: UICollectionViewCell {

    lazy var coverView: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = UIColor.randomColor()
        return imgV
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "sdfasfasfasfasfadsf"
        label.numberOfLines = 2
        label.backgroundColor = UIColor.randomColor()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = COLOR_333333
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = UIColor.randomColor()
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
        button.addTarget(self, action: #selector(clickButtonEvent), for: .touchUpInside)
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
            make.top.equalTo(coverView.snp_bottom).offset(10)
            make.height.equalTo(titleLabel)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(9)
            make.width.height.equalTo(25)
            make.top.equalTo(titleLabel.snp_bottom).offset(10)
            make.bottom.equalTo(-12)
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
    
    func configData() {
        
    }
    
    @objc func clickButtonEvent(sender: UIButton) {
        
    }
}
