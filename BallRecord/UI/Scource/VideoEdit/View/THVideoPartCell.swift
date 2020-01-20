//
//  THVideoPartCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/17.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THVideoPartCell: UICollectionViewCell {
    
    var deleteBlock:(() -> Void)?
    
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = UIColor.randomColor()
        return imgV
    }()
    
    lazy var numLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var deleteBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "deleteVideoPart_icon"), for: .normal)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
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

extension THVideoPartCell {
    func configUI() {
        contentView.addSubview(iconView)
        contentView.addSubview(numLabel)
        contentView.addSubview(deleteBtn)
        
        setCorner(cornerRadius: 4)
    }
    
    func configFrame() {
        iconView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        numLabel.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
            make.width.height.equalTo(numLabel)
        }
        
        deleteBtn.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.right.equalTo(-5)
            make.width.height.equalTo(deleteBtn)
        }
    }
    
    func configData() {
        
    }
    
    @objc func clickButtonEvent(sender: UIButton) {
        deleteBlock?()
    }
}
