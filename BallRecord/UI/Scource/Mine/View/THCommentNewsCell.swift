//
//  THCommentNewsCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/29.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

@objc protocol THCommentNewsCellDelegate {
    func clickReplyBtnEvent(commentId: String, vid: String)
}

class THCommentNewsCell: UITableViewCell {
    
    weak var delegate: THCommentNewsCellDelegate?
    var commentModel: THCommentNewsModel?
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        return imgV
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_324057
        return label
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_324057
        return label
    }()
    lazy var replyBtn: UIButton = {
        let button = UIButton()
        button.setTitle("回复", for: .normal)
        button.setTitleColor(MAIN_COLOR, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickReplyBtnEvent), for: .touchUpInside)
        return button
    }()
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = COLOR_F4F4F4
        return view
    }()
    lazy var newsLabel: UILabel = {
        let label = UILabel()
        label.text = "点赞了这个动态"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_324057
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var coverView: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = UIColor.randomColor()
        return imgV
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_324057
        label.numberOfLines = 0
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

extension THCommentNewsCell {
    
    func configUI() {
        selectionStyle = .none
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(replyBtn)
        contentView.addSubview(coverView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bgView)
        bgView.addSubview(newsLabel)
    }
    
    func configFrame() {
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.height.equalTo(50)
            make.top.equalTo(16)
        }
        
        replyBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.top.equalTo(iconView)
            make.width.equalTo(50)
            make.height.equalTo(replyBtn)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(8)
            make.right.equalTo(replyBtn.snp_left).offset(-8)
            make.top.equalTo(iconView)
            make.height.equalTo(nameLabel)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.right.equalTo(nameLabel)
            make.height.equalTo(dateLabel)
            make.bottom.equalTo(iconView)
        }
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(iconView)
            make.right.equalTo(replyBtn)
            make.top.equalTo(iconView.snp_bottom).offset(8)
            make.height.equalTo(bgView)
        }
        
        newsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.right.equalTo(-8)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.height.equalTo(newsLabel)
        }
        
        coverView.snp.makeConstraints { (make) in
            make.left.equalTo(bgView)
            make.top.equalTo(bgView.snp_bottom).offset(8)
            make.height.equalTo(60)
            make.width.equalTo(coverView.snp_height).multipliedBy(1.5)
            make.bottom.equalTo(contentView).offset(-8)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(coverView.snp_right).offset(8)
            make.right.equalTo(replyBtn)
            make.centerY.equalTo(coverView)
            make.height.lessThanOrEqualTo(coverView)
        }
        
        iconView.setCorner(cornerRadius: 25)
        coverView.setCorner(cornerRadius: 8)
        bgView.setCorner(cornerRadius: 4)
    }
    
    func configData() {
        
    }
    
    func updateModel(model: THPraiseNewsModel) {
        iconView.setImage(urlStr: model.praiseIcon, placeholder: placeholder_header)
        nameLabel.text = model.praiseName
        dateLabel.text = model.praiseTime
        coverView.setImage(urlStr: model.imageUrl, placeholder: placeholder_square)
        titleLabel.text = model.content
        replyBtn.isHidden = true
    }
    
    func updateModel(model: THCommentNewsModel) {
        self.commentModel = model
        iconView.setImage(urlStr: model.commentIcon, placeholder: placeholder_header)
        nameLabel.text = model.commentName
        dateLabel.text = model.commentTime
        newsLabel.text = model.commentContent
        coverView.setImage(urlStr: model.imageUrl, placeholder: placeholder_square)
        titleLabel.text = model.content
        replyBtn.isHidden = false
    }
    
    @objc func clickReplyBtnEvent() {
        delegate?.clickReplyBtnEvent(commentId: self.commentModel?.commentId ?? "", vid: self.commentModel?.vid ?? "")
    }
}
