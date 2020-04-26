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
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = COLOR_333333
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = COLOR_999999
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
        label.font = UIFont.systemFont(ofSize: 14)
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
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: -2)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
//        button.addTarget(self, action: #selector(clickButtonEvent), for: .touchUpInside)
        return button
    }()
    lazy var commentBtn:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "find_home_commend"), for: .normal)
        button.setTitleColor(UIColor.colorWithString("5E6D82"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -2)
        return button
    }()
    lazy var shareBtn:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "find_home_share"), for: .normal)
        button.setTitleColor(UIColor.colorWithString("5E6D82"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
        return button
    }()
    lazy var lineView:UIView = {
        let view = UIView()
        view.backgroundColor = COLOR_LINE
        return view
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
        contentView.addSubview(lineView)
        contentView.addSubview(commentBtn)
        contentView.addSubview(shareBtn)
        contentView.addSubview(timeLabel)
    }
    
    func configFrame() {
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.width.height.equalTo(42)
            make.top.equalTo(20)
        }
        iconView.layer.cornerRadius = 21;
        iconView.layer.masksToBounds = true;
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(15)
            make.width.height.equalTo(nameLabel)
            make.top.equalTo(iconView.snp_top)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(15)
            make.width.height.equalTo(timeLabel)
            make.bottom.equalTo(iconView.snp_bottom).offset(-5)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(iconView.snp_bottom).offset(8)
            make.height.equalTo(titleLabel)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(-1)
            make.height.equalTo(1);
        }
        likeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.bottom.equalTo(lineView.snp_top).offset(-13)
            make.width.equalTo(40)
            make.height.equalTo(15)
        }
        commentBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp_centerX).offset(0)
            make.bottom.equalTo(lineView.snp_top).offset(-13)
            make.width.equalTo(40)
            make.height.equalTo(15)
        }
        shareBtn.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.bottom.equalTo(lineView.snp_top).offset(-13)
            make.width.equalTo(60)
            make.height.equalTo(15)
        }
        coverView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(likeBtn.snp_top).offset(-15)
            make.height.equalTo(190)
        }
    }
    
    func updateModel(model: THDynamicModel) {
        self.model = model
        coverView.setImage(urlStr: model.imageUrl, placeholder: placeholder_square)
        titleLabel.text = model.content
        iconView.setImage(urlStr: model.publisherIcon, placeholder: placeholder_round)
        nameLabel.text = model.publisherName
        timeLabel.text = model.releaseString
        
        let count = model.praiseCount > 0 ? "\(model.praiseCount)" : ""
        likeBtn.setTitle(count, for: .normal)
        likeBtn.isSelected = model.hasPraise ?? false
        
        commentBtn.setTitle("\(model.commentCount)", for: .normal)
        
//        titleLabel.snp.remakeConstraints { (make) in
//            make.left.equalTo(0)
//            make.right.equalTo(0)
//            make.top.equalTo(iconView.snp_bottom).offset(8)
//            make.height.equalTo(model.titlLableHeight)
//        }
    }
}
