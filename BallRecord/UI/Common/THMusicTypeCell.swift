//
//  THMusicTypeCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/18.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THMusicTypeCell: UICollectionViewCell {
    
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "jingdan_icon")
        imgV.backgroundColor = .lightGray
        imgV.contentMode = .center
        return imgV
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "快乐"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = COLOR_666666
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
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

extension THMusicTypeCell {
    
    func configUI() {
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
    }
    
    func configFrame() {
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.centerX.equalTo(contentView)
            make.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.top.equalTo(iconView.snp_bottom)
            make.bottom.equalTo(contentView)
        }
        
        iconView.setCorner(cornerRadius: 20)
    }
    
    func configData() {
        
    }
    
    func changeBackgroundColor(selected: Bool) {
        
        iconView.backgroundColor = selected ? MAIN_COLOR : UIColor.lightGray
        titleLabel.textColor = selected ? MAIN_COLOR : COLOR_666666
    }
}
