//
//  THCommentCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/26.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THCommentCell: UITableViewCell {
    
    var model: THCommentModel?
    var vidOrCid: String?
    var isVideo: Bool?
    
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        return imgV
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "gao gao"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = COLOR_0076FF
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
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
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12小时前"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = COLOR_324057
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var replyBtn: UIButton = {
        let button = UIButton()
        button.setTitle("    10回复    ", for: .normal)
        button.backgroundColor = COLOR_F4F4F4
        button.setTitleColor(COLOR_666666, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(clickReplyBtnEvent(sender:)), for: .touchUpInside)
        return button
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
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configUI()
        configFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension THCommentCell {
    
    func configUI() {
        selectionStyle = .none
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeBtn)
        contentView.addSubview(replyBtn)
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
            make.bottom.equalTo(contentView).offset(-8)
        }
        
        replyBtn.snp.makeConstraints { (make) in
            make.left.equalTo(dateLabel.snp_right).offset(8)
            make.centerY.equalTo(dateLabel)
            make.width.equalTo(replyBtn)
            make.height.equalTo(20)
        }
        
        likeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-16)
            make.centerY.equalTo(nameLabel)
            make.height.width.equalTo(likeBtn)
        }
        
        iconView.layer.cornerRadius = 20
        iconView.layer.masksToBounds = true
        
        replyBtn.setCorner(cornerRadius: 10)
    }
    
    func updateModel(model: THCommentModel) {
        self.model = model
        iconView.setImage(urlStr: model.commentIcon ?? "", placeholder: placeholder_round)
        nameLabel.text = model.commentName
        contentLabel.text = model.commentText
        dateLabel.text = model.commentTime
        likeBtn.isSelected = model.hasPraise
        let count = model.praiseCount
        let countStr = (count > 0) ? "\(count)" : ""
        likeBtn.setTitle(countStr, for: .normal)
        likeBtn.setTitle(countStr, for: .selected)
        
        let replyCount = model.replyCount
        let replyCountStr = (replyCount > 0) ? "\(replyCount)" : ""
        replyBtn.setTitle("    " + replyCountStr + "回复" + "    ", for: .normal)
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
        
        //  TODO: 评论点赞接口
        let praise = sender.isSelected ? "1" : "0"
        let param = ["vid": self.vidOrCid ?? "", "praise": praise, "commentId": model?.commentId ?? ""]
        if self.isVideo ?? false {
            THFindRequestManager.requestVideoPraise(param: param, successBlock: { (result) in }) { (error) in }
        } else {
            THPlaygroundManager.requestPlaygroundPraise(param: param, successBlock: { (result) in }) { (error) in }
        }
        
    }
    
    @objc func clickReplyBtnEvent(sender: UIButton) {
        THReplyListView.show(model: self.model ?? THCommentModel(), vidOrCid: self.vidOrCid ?? "", isVideo: self.isVideo ?? false)
    }
}
