//
//  THDateSelectView.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/27.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THDateSelectView: UIView {
    
    lazy var leftBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "leftArrow_icon"), for: .normal)
        button.addTarget(self, action: #selector(clickLeftBtnEvent), for: .touchUpInside)
        return button
    }()
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "2019年12月12日 周几"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = COLOR_333333
        label.textAlignment = .center
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
    
    @objc func clickLeftBtnEvent() {
        print(#function)
    }
    
    @objc func clickRightBtnEvent() {
        print(#function)
    }
}
