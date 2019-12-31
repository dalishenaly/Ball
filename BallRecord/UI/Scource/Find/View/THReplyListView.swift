//
//  THReplyListView.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/11.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import QMUIKit


class THReplyListView: UIView {
    
    lazy var topView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50))
        view.backgroundColor = .white
        view.qmui_borderColor = COLOR_LINE
        view.qmui_borderPosition = .bottom
        view.addCorner(with: [.topLeft, .topRight], cornerSize: CGSize(width: 8, height: 8))
        return view
    }()
    
    lazy var closeBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close_icon"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickCloseBtnEvent), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_324057
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.estimatedRowHeight = SCREEN_HEIGHT
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.backgroundColor = UIColor.colorWithString("#F9FAFC")
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        view.backgroundColor = .white
        view.qmui_borderColor = COLOR_LINE
        view.qmui_borderPosition = .top
        return view
    }()
    
    lazy var inputCmtView: UIView = {
        let view = UIView()
        view.backgroundColor = COLOR_F4F4F4
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        imgV.isUserInteractionEnabled = true
        imgV.backgroundColor = COLOR_F4F4F4
        imgV.image = UIImage(named: "write_comment")
        return imgV
    }()
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "写评论..."
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_324057
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    let inputPublishView = THInputView()
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        
        configUI()
        configFrame()
        configData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension THReplyListView {
    
    func configUI() {
        
        backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        addSubview(topView)
        addSubview(tableView)
        addSubview(bottomView)
        addSubview(inputPublishView)
        
        
        topView.addSubview(closeBtn)
        topView.addSubview(titleLabel)
        
        bottomView.addSubview(inputCmtView)
        inputCmtView.addSubview(iconView)
        inputCmtView.addSubview(placeholderLabel)
        
        inputPublishView.delegate = self
    }
    
    func configFrame() {
        
        topView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(self).offset(STATUS_BAR_HEIGHT)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(topView.snp_bottom)
            make.bottom.equalTo(bottomView.snp_top)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(45)
            make.bottom.equalTo(self)
        }
        
        
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(topView).offset(10)
            make.centerY.equalTo(topView)
            make.width.height.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(inputCmtView)
            make.width.height.equalTo(titleLabel)
        }
        
        inputCmtView.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-5)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(inputCmtView).offset(10)
            make.centerY.equalTo(inputCmtView)
            make.width.height.equalTo(25)
        }
        
        placeholderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(5)
            make.right.equalTo(inputCmtView)
            make.centerY.equalTo(inputCmtView)
            make.height.equalTo(placeholderLabel)
        }
        
        inputCmtView.setCorner(cornerRadius: 17.5, masksToBounds: true, borderColor: COLOR_LINE, borderWidth: 0.3)
    }
    
    func configData() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapInputView))
        self.inputCmtView.addGestureRecognizer(tap)
    }
    
    @objc func clickCloseBtnEvent() {
        removeFromSuperview()
    }
    
    @objc func onTapInputView() {
        self.inputPublishView.textViewBecomeFirstResponder()
    }
    
    class func show() {
        let shareView = THReplyListView()
        if let window = UIApplication.shared.delegate?.window {
            window?.addSubview(shareView)
        }
    }
}

extension THReplyListView: THInputViewDelegate {
    
    func clickPublishEvent() {
        
    }
}

extension THReplyListView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "THCommentCell") as? THCommentCell
        if cell == nil {
            cell = THCommentCell(style: .default, reuseIdentifier: "THCommentCell")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
