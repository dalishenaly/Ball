//
//  THVideoCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/26.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import SJVideoPlayer
import SnapKit


let videoCoverImageTag = 101


@objc protocol THVideoCellDelegate {
    func videoCellClickedOnTheCover(cell: THVideoCell, cover: UIImageView)
}

class THVideoCell: UITableViewCell {
    
    weak open var delegate: THVideoCellDelegate?
    
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = UIColor.randomColor()
        return imgV
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "大桥"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_324057
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "12小时前"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = COLOR_324057
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "应建立在对股票投资具有充分的客观认识的基础上，通过认真地比较分析以后而进行的投资活动。"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_324057
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var coverImageView: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = UIColor.randomColor()
        imgV.isUserInteractionEnabled = true
        imgV.contentMode = .scaleAspectFill;
        imgV.clipsToBounds = true;
        imgV.tag = videoCoverImageTag
        return imgV
    }()
    
    lazy var likeBtn: UIButton = {
        let button = UIButton()
        button.tag = 55
        button.setTitle("精选", for: .normal)
        button.setTitleColor(UIColor.colorWithString("5E6D82"), for: .normal)
        button.setTitleColor(UIColor.colorWithString("324057"), for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()
    lazy var commonBtn: UIButton = {
        let button = UIButton()
        button.tag = 55
        button.setTitle("精选", for: .normal)
        button.setTitleColor(UIColor.colorWithString("5E6D82"), for: .normal)
        button.setTitleColor(UIColor.colorWithString("324057"), for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()
    lazy var shareBtn: UIButton = {
        let button = UIButton()
        button.tag = 55
        button.setTitle("精选", for: .normal)
        button.setTitleColor(UIColor.colorWithString("5E6D82"), for: .normal)
        button.setTitleColor(UIColor.colorWithString("324057"), for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
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
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}

extension THVideoCell {
    
    func configUI() {
        selectionStyle = .none
        
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(coverImageView)
        contentView.addSubview(likeBtn)
//        addSubview(iconView)
//        addSubview(iconView)
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
            make.width.equalTo(nameLabel)
            make.height.equalTo(20)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.bottom.equalTo(iconView)
            make.width.equalTo(detailLabel)
            make.height.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
            make.top.equalTo(iconView.snp_bottom).offset(8)
            make.height.equalTo(titleLabel)
        }
        
        coverImageView.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp_bottom).offset(8)
            make.height.equalTo(coverImageView.snp_width).multipliedBy(9/16.0)
        }
        
        likeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(coverImageView.snp_bottom)
            make.left.equalTo(coverImageView)
            make.width.equalTo(50)
            make.height.equalTo(likeBtn)
            make.bottom.equalTo(contentView)
        }
        
        iconView.layer.cornerRadius = 20
        iconView.layer.masksToBounds = true
        
        
    }
    
    func configData() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickCoverEvent))
        coverImageView.addGestureRecognizer(tap)
    }
    
    
    @objc func clickCoverEvent() {
        delegate?.videoCellClickedOnTheCover(cell: self, cover: coverImageView)
    }
    
    
    @objc func clickButtonEvent(sender: UIButton) {
        
    }
}
