//
//  THCommentHeaderCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/26.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THCommentHeaderCell: UITableViewCell {
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "应建立在对股票投资具有充分的客观认识的基础上，通过认真地比较分析以后而进行"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_324057
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = COLOR_8492A6
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = UIColor.randomColor()
        return imgV
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "gao gao"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = COLOR_64BBFA
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12小时前"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = COLOR_324057
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var replyBtn: UIButton = {
        let button = UIButton()
        button.tag = 55
        button.setTitle("关注", for: .normal)
        button.setTitleColor(UIColor.colorWithString("5E6D82"), for: .normal)
        button.setTitleColor(UIColor.colorWithString("324057"), for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickReplyBtnEvent(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var allReplyLabel: UILabel = {
        let label = UILabel()
        label.text = "全部回复"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = COLOR_324057
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var replyCountLabel: UILabel = {
        let label = UILabel()
        label.text = "(120)"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_324057
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

extension THCommentHeaderCell {
    
    func configUI() {
        selectionStyle = .none
        contentView.addSubview(contentLabel)
        contentView.addSubview(line)
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(replyBtn)
        contentView.addSubview(allReplyLabel)
        contentView.addSubview(replyCountLabel)
    }
    
    func configFrame() {
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
            make.top.equalTo(contentView).offset(20)
            make.height.equalTo(contentLabel)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.equalTo(contentLabel)
            make.right.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp_bottom).offset(20)
            make.height.equalTo(0.5)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(line)
            make.top.equalTo(line.snp_bottom).offset(20)
            make.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(8)
            make.top.equalTo(iconView)
            make.height.width.equalTo(nameLabel)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.width.height.equalTo(dateLabel)
            make.bottom.equalTo(iconView)
        }
        
        replyBtn.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-16)
            make.centerY.equalTo(iconView)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        allReplyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView)
            make.top.equalTo(iconView.snp_bottom).offset(35)
            make.width.height.equalTo(allReplyLabel)
            make.bottom.equalTo(contentView)
        }
        
        replyCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(allReplyLabel.snp_right).offset(4)
            make.width.height.equalTo(replyCountLabel)
            make.bottom.equalTo(allReplyLabel)
        }
        
        iconView.layer.cornerRadius = 20
        iconView.layer.masksToBounds = true
    }
    
    func configData() {
        
    }
    
    @objc func clickLikeBtnEvent(sender: UIButton) {
        
    }
    
    @objc func clickReplyBtnEvent(sender: UIButton) {
        
    }
}
