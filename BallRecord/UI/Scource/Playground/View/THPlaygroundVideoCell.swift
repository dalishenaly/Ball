//
//  THPlaygroundVideoCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/16.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THPlaygroundVideoCell: UITableViewCell {
    
    var clickItemBlock: ((_ idx: Int)->Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateModel(modelArr: [THPGVideoModel]) {
        let itemW = (SCREEN_WIDTH - 75) / 2
        var itemH: CGFloat = 0
        for idx in 0..<modelArr.count {
            let lie = idx%2
            let hang = idx/2
            let itemX = 25 + (itemW + 25) * CGFloat(lie)
            var itemY = 25 + (itemH + 25) * CGFloat(hang)
            let item = THVideoItemView()
            item.tag = 66+idx
            let tap = UITapGestureRecognizer(target: self, action: #selector(onTapVideoItem(gesture:)))
            item.addGestureRecognizer(tap)
            
            contentView.addSubview(item)
            item.snp.makeConstraints { (make) in
                make.left.equalTo(itemX)
                make.width.equalTo(itemW)
                make.top.equalTo(itemY)
                make.height.equalTo(item)
                if idx == modelArr.count - 1 {
                    make.bottom.equalTo(-20)
                }
            }
            item.updateModel(model: modelArr[idx])
            layoutIfNeeded()
            itemH = item.height
        }
    }
    
    @objc func onTapVideoItem(gesture: UITapGestureRecognizer) {
        if let view = gesture.view {
            clickItemBlock?(view.tag - 66)
        }
    }

}

class THVideoItemView: UIView {
    
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        return imgV
    }()
    
    lazy var playView: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "play_icon")
        return imgV
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "1234"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_324057
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "45678"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = MAIN_COLOR
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
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
        
        addSubview(iconView)
        addSubview(playView)
        addSubview(titleLabel)
        addSubview(countLabel)
    }
    
    func configFrame() {
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(iconView.snp_width).multipliedBy(0.6)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(iconView.snp_bottom).offset(4)
            make.height.equalTo(titleLabel)
            make.right.equalTo(playView.snp_left).offset(-4)
        }
        
        playView.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(20)
        }
        
        countLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(titleLabel.snp_bottom).offset(4)
            make.bottom.equalTo(self).offset(-4)
            make.height.equalTo(countLabel)
        }
        
        iconView.setCorner(cornerRadius: 4)
        self.setCorner(cornerRadius: 4)
    }
    
    func configData() {
        
    }
    
    func updateModel(model: THPGVideoModel) {
        iconView.setImage(urlStr: model.imageUrl, placeholder: placeholder_square)
        titleLabel.text = model.title
        countLabel.text = model.playCount ?? "0" + "次播放"
    }

}

