//
//  THReplyLZCell.swift
//  BallRecord
//
//  Created by 买超 on 2020/1/3.
//  Copyright © 2020 maichao. All rights reserved.
//

import UIKit

class THReplyLZCell: UITableViewCell {

    var model: THCommentModel?
        
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
        view.backgroundColor = COLOR_LINE
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
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = COLOR_0076FF
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var LZFlagLabel: UILabel = {
        let label = UILabel()
        label.text = "楼主"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = COLOR_0076FF
        label.setCorner(cornerRadius: 4, masksToBounds: true, borderColor: COLOR_0076FF, borderWidth: 1)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12小时前"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = COLOR_999999
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
        button.addTarget(self, action: #selector(clickLikeBtnEvent(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var allReplyLabel: UILabel = {
        let label = UILabel()
        label.text = "全部评论"
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension THReplyLZCell {
    
    func configUI() {
        selectionStyle = .none
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(LZFlagLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(line)
        contentView.addSubview(allReplyLabel)
        contentView.addSubview(likeBtn)
    }
    
    func configFrame() {
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(16)
            make.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(8)
            make.top.equalTo(iconView)
            make.height.width.equalTo(nameLabel)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.right.equalTo(contentView).offset(-16)
            make.top.equalTo(nameLabel.snp_bottom).offset(8)
            make.height.equalTo(contentLabel)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentLabel)
            make.width.height.equalTo(dateLabel)
            make.top.equalTo(contentLabel.snp_bottom).offset(8)
        }
        
        likeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-16)
            make.centerY.equalTo(dateLabel)
            make.height.width.equalTo(likeBtn)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(dateLabel.snp_bottom).offset(20)
            make.height.equalTo(1)
        }
        
        allReplyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView)
            make.top.equalTo(line.snp_bottom).offset(20)
            make.height.equalTo(20)
            make.width.equalTo(allReplyLabel)
            make.bottom.equalTo(contentView)
        }
        
        iconView.layer.cornerRadius = 20
        iconView.layer.masksToBounds = true
    }
    
    func updateModel(model: THCommentModel) {
        self.model = model
        
        iconView.setImage(urlStr: model.commentIcon ?? "", placeholder: placeholder_round)
        nameLabel.text = model.commentName
        contentLabel.text = model.commentText
        dateLabel.text = (model.commentTime ?? "")
        
        likeBtn.isSelected = model.hasPraise
        let count = model.praiseCount
        let countStr = (count > 0) ? "\(count)" : ""
        likeBtn.setTitle(countStr, for: .normal)
        likeBtn.setTitle(countStr, for: .selected)
    }
    
    @objc func clickLikeBtnEvent(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            model?.praiseCount = (model?.praiseCount ?? 0) + 1
        } else {
            model?.praiseCount = (model?.praiseCount ?? 0) - 1
        }
        
        model?.updateModelPraiseState(hasPraise: sender.isSelected)
        let count = model?.praiseCount ?? 0
        let countStr = (count > 0) ? "\(count)" : ""
        likeBtn.setTitle(countStr, for: .normal)
        likeBtn.setTitle(countStr, for: .selected)
    }
    
}

