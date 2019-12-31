//
//  THVideoDetailVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/26.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import SJVideoPlayer
import QMUIKit
import IQKeyboardManager

class THVideoDetailVC: THBaseVC {
    
    var keyboardManager: QMUIKeyboardManager?
    
    let toolbarView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 80))
        view.qmui_borderColor = COLOR_F4F4F4;
        view.qmui_borderPosition = .top
        view.backgroundColor = .white
        return view
    }()
    
    lazy var textView: QMUITextView = {
        let textView = QMUITextView(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH - 80, height: 80))
        textView.placeholder = "优质评论将会被优先展示"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .groupTableViewBackground
        textView.setCorner(cornerRadius: 8, masksToBounds: true, borderColor: COLOR_LINE, borderWidth: 0.5)
//        textView.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12);
        textView.inputAccessoryView = UIView()
        return textView
    }()
    
    lazy var publishBtn: UIButton = {
        let button = UIButton()
        button.setTitle("发布", for: .normal)
        button.setTitleColor(UIColor.colorWithString("5E6D82"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickPublishBtnEvent), for: .touchUpInside)
        return button
    }()
    
    
    lazy var playerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.randomColor()
        view.isUserInteractionEnabled = true
        return view
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
    
    lazy var player: SJVideoPlayer = {
        let player = SJVideoPlayer()
        player.showMoreItemToTopControlLayer = false
        player.rotationManager.isDisabledAutorotation = true
        return player
    }()

    lazy var commentBar: THCommentBottomBar = {
        let bar = THCommentBottomBar()
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        configFrame()
        configData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        IQKeyboardManager.shared().isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
        IQKeyboardManager.shared().isEnabled = true
    }

}

extension THVideoDetailVC {
    
    func configUI() {
        view.addSubview(playerContainerView)
        view.addSubview(tableView)
        view.addSubview(commentBar)
        playerContainerView.addSubview(player.view)
        
        view.addSubview(toolbarView)
        toolbarView.addSubview(textView)
        toolbarView.addSubview(publishBtn)
        
        commentBar.delegate = self
        keyboardManager = QMUIKeyboardManager(delegate: self)
        // 设置键盘只接受 self.textView 的通知事件，如果当前界面有其他 UIResponder 导致键盘产生通知事件，则不会被接受
        keyboardManager?.addTargetResponder(textView)
    }
    
    func configFrame() {
        playerContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view)
            make.height.equalTo(view.snp_width).multipliedBy(5/8.0)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(playerContainerView.snp_bottom)
            make.bottom.equalTo(commentBar.snp_top)
        }
        
        commentBar.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(40)
            make.bottom.equalTo(view)
        }
        
        player.view.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(toolbarView).offset(15)
            make.right.equalTo(toolbarView).offset(-80)
            make.top.equalTo(toolbarView).offset(10)
            make.bottom.equalTo(toolbarView).offset(-10)
        }
        
        publishBtn.snp.makeConstraints { (make) in
            make.right.equalTo(toolbarView)
            make.width.equalTo(80)
            make.top.equalTo(toolbarView)
            make.bottom.equalTo(toolbarView)
        }
    }
    
    func configData() {
     
        if let url = URL(string: "https://xy2.v.netease.com/r/video/20190110/bea8e70d-ffc0-4433-b250-0393cff10b75.mp4") {
            let asset = SJVideoPlayerURLAsset(url: url)
            player.urlAsset = asset;
        }
    }
    
    @objc func clickPublishBtnEvent() {
        print(#function)
    }

}

extension THVideoDetailVC: THCommentBottomBarDelegate, QMUIKeyboardManagerDelegate {
    
    func onTapCommentView() {
        textView.becomeFirstResponder()
    }
    
    func keyboardWillChangeFrame(with keyboardUserInfo: QMUIKeyboardUserInfo!) {
        
        QMUIKeyboardManager.handleKeyboardNotification(with: keyboardUserInfo, show: { (keyboardUserInfo: QMUIKeyboardUserInfo?) in
            QMUIKeyboardManager.animateWith(animated: true, keyboardUserInfo: keyboardUserInfo, animations: {
                self.toolbarView.bottom = SCREEN_HEIGHT - keyboardUserInfo!.endFrame.height
            }, completion: nil)
            
        }) { (keyboardUserInfo: QMUIKeyboardUserInfo?) in
            QMUIKeyboardManager.animateWith(animated: true, keyboardUserInfo: keyboardUserInfo, animations: {
                self.toolbarView.top = SCREEN_HEIGHT
            }, completion: nil)
        }
    }
}

extension THVideoDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "THCommentHeaderCell") as? THCommentHeaderCell
            if cell == nil {
                cell = THCommentHeaderCell(style: .default, reuseIdentifier: "THCommentHeaderCell")
            }
            return cell!
        }
        
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


@objc protocol THCommentBottomBarDelegate {
    func onTapCommentView()
}


class THCommentBottomBar: UIView {
    
    weak var delegate: THCommentBottomBarDelegate?
    
    init() {
        super.init(frame: CGRect.zero)
        
        configUI()
        configFrame()
        configData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var inputCmtView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        imgV.isUserInteractionEnabled = true
        imgV.image = UIImage(named: "write_comment")
        return imgV
    }()
    
    lazy var titleLabel: UILabel = {
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
    
    lazy var collectBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "collect_normal"), for: .normal)
        button.setImage(UIImage(named: "collect_selected"), for: .selected)
        button.addTarget(self, action: #selector(clickCollectBtnEvent(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var likeBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "like_normal"), for: .normal)
        button.setImage(UIImage(named: "like_selected"), for: .selected)
        button.addTarget(self, action: #selector(clickLikeBtnEvent(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "23"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = COLOR_324057
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    
    func configUI() {
        
        qmui_borderColor = COLOR_F4F4F4
        qmui_borderPosition = .top
        
        addSubview(inputCmtView)
        inputCmtView.addSubview(iconView)
        inputCmtView.addSubview(titleLabel)
        addSubview(collectBtn)
        addSubview(likeBtn)
        addSubview(countLabel)
    }
    
    func configFrame() {
        
        inputCmtView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(5)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(collectBtn.snp_left).offset(-10)
            make.height.equalTo(30)
            make.bottom.equalTo(self).offset(-5)
        }
        
        likeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.centerY.equalTo(self)
            make.width.equalTo(40)
            make.height.equalTo(likeBtn)
        }
        
        collectBtn.snp.makeConstraints { (make) in
            make.right.equalTo(likeBtn.snp_left).offset(-8)
            make.centerY.equalTo(self)
            make.width.equalTo(40)
            make.height.equalTo(collectBtn)
        }
        
        countLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(likeBtn.snp_right)
            make.top.equalTo(likeBtn)
            make.width.height.equalTo(countLabel)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(inputCmtView).offset(10)
            make.centerY.equalTo(inputCmtView)
            make.width.height.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(5)
            make.right.equalTo(inputCmtView)
            make.centerY.equalTo(inputCmtView)
            make.height.equalTo(titleLabel)
        }
        
        inputCmtView.setCorner(cornerRadius: 15, masksToBounds: true, borderColor: COLOR_LINE, borderWidth: 0.5)
    }
    
    func configData() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapCommentView))
        inputCmtView.addGestureRecognizer(tap)
    }
    
    
    @objc func clickCollectBtnEvent(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @objc func clickLikeBtnEvent(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @objc func onTapCommentView() {
        delegate?.onTapCommentView()
    }
}
