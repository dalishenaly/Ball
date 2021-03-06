//
//  THRoughCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/28.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THRoughCell: UITableViewCell {
    
    var deleteBlock:(()->Void)?
    var model: THVideoDraftModel?
    var recordModel: THDynamicModel?
    
    var iconView = videoCoverView()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "本地视频"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = COLOR_333333
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = MAIN_COLOR
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var deleteBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "delete_icon"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickDeleteBtnEvent), for: .touchUpInside)
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
    

}

extension THRoughCell {
    func configUI() {
        selectionStyle = .none
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(deleteBtn)
    }
    
    func configFrame() {
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(16)
            make.bottom.equalTo(-16)
            make.height.equalTo(80)
            make.width.equalTo(iconView.snp_height).multipliedBy(1.5)
        }
        
        deleteBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(10)
            make.right.equalTo(deleteBtn.snp_left).offset(-10)
            make.bottom.equalTo(iconView.snp_centerY).offset(-7.5)
            make.height.equalTo(titleLabel)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            make.top.equalTo(iconView.snp_centerY).offset(7.5)
            make.height.equalTo(detailLabel)
        }
        
        iconView.setCorner(cornerRadius: 8)
    }
    
    func configData() {
        
    }
    
    @objc func clickDeleteBtnEvent() {
        deleteBlock?()
    }
    
    func updateData(model: THVideoDraftModel) {
        self.model = model
        
        detailLabel.text = model.dateStr
        if model.coverImgPath != "" {
            let imgFilePath = documentPath + "/" + (model.coverImgPath)
            iconView.image = UIImage(contentsOfFile: imgFilePath)!
        }
    }
    
    func updateRecord(model: THDynamicModel) {
        self.recordModel = model
        titleLabel.text = "珍藏视频"
        iconView.setImage(urlStr: model.imageUrl, placeholder: placeholder_square)
    }
}

class videoCoverView: UIImageView {
    
    lazy var playView: UIImageView = {
        let imgV = UIImageView(image: UIImage(named: "Dynamic_play_icon"))
        imgV.contentMode = .center
        return imgV
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        configUI()
        configFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        addSubview(playView)
    }
    
    func configFrame() {
        playView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
}
