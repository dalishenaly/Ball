//
//  THCommentHeaderCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/26.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THCommentHeaderCell: UITableViewCell {
    
    var model: THVideoDetailModel?
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = ""
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
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = COLOR_333333
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = COLOR_999999
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var focusBtn: UIButton = {
        let button = UIButton()
        button.setTitle("关注", for: .normal)
        button.backgroundColor = COLOR_D6E7FD
        button.setCorner(cornerRadius: 4, masksToBounds: true, borderColor: COLOR_B3D0FB, borderWidth: 1)
        button.setTitleColor(COLOR_666666, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(clickFocusBtnEvent(sender:)), for: .touchUpInside)
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
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = COLOR_666666
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

extension THCommentHeaderCell {
    
    func configUI() {
        selectionStyle = .none
        contentView.addSubview(contentLabel)
        contentView.addSubview(line)
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(focusBtn)
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
        
        focusBtn.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-16)
            make.centerY.equalTo(iconView)
            make.width.equalTo(80)
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
    
    func updateModel(model: THVideoDetailModel) {
        self.model = model
        
        contentLabel.text = model.content
        iconView.setImage(urlStr: model.publisherIcon ?? "", placeholder: placeholder_round)
        nameLabel.text = model.publisherName
        dateLabel.text = (model.publishTime ?? "") + " \(model.playCount)播放"
        
        if model.hasConcerned {
            focusBtn.setTitle("已关注", for: .normal)
            focusBtn.backgroundColor = COLOR_E7E7E7
            focusBtn.setCorner(cornerRadius: 4, masksToBounds: true, borderColor: COLOR_LINE, borderWidth: 1)
        } else {
            focusBtn.setTitle("关注", for: .normal)
            focusBtn.backgroundColor = COLOR_D6E7FD
            focusBtn.setCorner(cornerRadius: 4, masksToBounds: true, borderColor: COLOR_B3D0FB, borderWidth: 1)
        }
    }
    
    @objc func clickFocusBtnEvent(sender: UIButton) {
        if model?.hasConcerned ?? false {
            model?.hasConcerned = false
            focusBtn.setTitle("关注", for: .normal)
            focusBtn.backgroundColor = COLOR_D6E7FD
            focusBtn.setCorner(cornerRadius: 4, masksToBounds: true, borderColor: COLOR_B3D0FB, borderWidth: 1)
        } else {
            model?.hasConcerned = true
            focusBtn.setTitle("已关注", for: .normal)
            focusBtn.backgroundColor = COLOR_E7E7E7
            focusBtn.setCorner(cornerRadius: 4, masksToBounds: true, borderColor: COLOR_LINE, borderWidth: 1)
        }
        
        let concern = model?.hasConcerned ?? false ? "1" : "0"
        let param = ["publisherUid": model?.publisherUid ?? "", "concern" : concern]
        THFindRequestManager.requestConcerna(param: param, successBlock: { (result) in
        }) { (error) in
        }
    }
}
