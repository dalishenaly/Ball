//
//  THDateSelectView.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/27.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

@objc protocol THDateSelectViewDelegate {
    func dateSelectViewChangeValue(idx: Int)
}

class THDateSelectView: UIView {
    
    var currentIdx: Int?
    weak var delegate: THDateSelectViewDelegate?
    
    var dataArr =  [THTimeModel]()
    
    
    lazy var leftBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "leftArrow_icon"), for: .normal)
        button.addTarget(self, action: #selector(clickLeftBtnEvent), for: .touchUpInside)
        return button
    }()
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = COLOR_333333
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var rightBtn: UIButton = {
        let button = UIButton()
        button.tag = 5
        button.setImage(UIImage(named: "rightArrow_icon"), for: .normal)
        button.addTarget(self, action: #selector(clickRightBtnEvent), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        
        configUI()
        configFrame()
        configData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        addSubview(leftBtn)
        addSubview(timeLabel)
        addSubview(rightBtn)
    }
    
    func configFrame() {
        timeLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(180)
            make.height.equalTo(22)
        }
        
        leftBtn.snp.makeConstraints { (make) in
            make.right.equalTo(timeLabel.snp_left).offset(-10)
            make.centerY.equalTo(timeLabel)
            make.height.width.equalTo(22)
        }
        
        rightBtn.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp_right).offset(10)
            make.centerY.equalTo(timeLabel)
            make.height.width.equalTo(22)
        }
    }
    
    func configData() {
        
    }
    
    func updateDate(arr: [THTimeModel]) {
        if arr.count == 0 {
            self.leftBtn.isEnabled = false
            self.rightBtn.isEnabled = false
            return
        }
        if arr.count == 1 {
            self.leftBtn.isEnabled = false
            self.rightBtn.isEnabled = false
        }
        
        self.dataArr = arr
        let model = arr.last
        self.currentIdx = arr.count - 1
        timeLabel.text = model?.itemTime
        self.rightBtn.isEnabled = false
        
    }
    
    @objc func clickLeftBtnEvent() {
        
        self.currentIdx = (self.currentIdx ?? 1) - 1
        let model = self.dataArr[self.currentIdx ?? 0]
        timeLabel.text = model.itemTime
        
        self.rightBtn.isEnabled = true
        if self.currentIdx == 0 {
            self.leftBtn.isEnabled = false
        }
        
        delegate?.dateSelectViewChangeValue(idx: self.currentIdx ?? 0)
    }
    
    @objc func clickRightBtnEvent() {
        
        self.currentIdx = (self.currentIdx ?? 0) + 1
        let model = self.dataArr[self.currentIdx ?? 0]
        timeLabel.text = model.itemTime
        
        self.leftBtn.isEnabled = true
        if self.currentIdx == self.dataArr.count - 1 {
            self.rightBtn.isEnabled = false
        }
        
        delegate?.dateSelectViewChangeValue(idx: self.currentIdx ?? 0)
    }
}
