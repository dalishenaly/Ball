//
//  THFansCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/27.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THFansCell: UITableViewCell {
    
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        return imgV
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "good"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_324057
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var facusBtn: UIButton = {
        let button = UIButton()
        button.setTitle("已关注", for: .normal)
        button.setTitleColor(COLOR_999999, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = COLOR_F4F4F4
//        button.addTarget(self, action: #selector(clickFacusBtnEvent), for: .touchUpInside)
        return button
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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}

extension THFansCell {
    func configUI() {
        selectionStyle = .none
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(facusBtn)
    }
    
    func configFrame() {
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(15)
            make.bottom.equalTo(-15)
            make.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(8)
            make.right.equalTo(facusBtn.snp_left).offset(-8)
            make.centerY.equalTo(contentView)
            make.height.equalTo(titleLabel)
        }
        
        facusBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(contentView)
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
        
        iconView.setCorner(cornerRadius: 20)
        
        facusBtn.setCorner(cornerRadius: 8, borderColor: COLOR_LINE, borderWidth: 1)
    }
    
    func configData() {
        
    }
    
    @objc func clickFacusBtnEvent() {
        
    }
}

