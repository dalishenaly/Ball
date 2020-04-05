//
//  THCommendVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/29.
//  Copyright © 2019 maichao. All rights reserved.
//  评论列表VC

import UIKit
import IQKeyboardManager

class THCommentNewsVC: THBaseTableViewVC {

    var keyboardManager: QMUIKeyboardManager?
    var dataArr = [THCommentNewsModel]()
    var page = 0
    var replyCommentId: String?
    var replyVid: String?
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "评论"
        configRefresh()
        
        view.addSubview(toolbarView)
        toolbarView.addSubview(textView)
        toolbarView.addSubview(publishBtn)
        
        keyboardManager = QMUIKeyboardManager(delegate: self)
        // 设置键盘只接受 self.textView 的通知事件，如果当前界面有其他 UIResponder 导致键盘产生通知事件，则不会被接受
        keyboardManager?.addTargetResponder(textView)
        
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared().isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared().isEnabled = true
    }
    
    func configRefresh() {
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.headerRefreshing()
        })
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.footerRefreshing()
        })
        tableView.mj_footer?.ignoredScrollViewContentInsetBottom = isiPhoneX() ? 34 : 0
    }
    
    
    override func configData() {
        requestData(completion: nil)
    }
    
    func headerRefreshing() {
        page = 0
        requestData {
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.resetNoMoreData()
        }
    }
    
    func footerRefreshing() {
        page += 1
        requestData {
            self.tableView.mj_footer?.endRefreshing()
        }
    }
    
    func requestData(completion: (()->Void)?) {
        let param = ["page": page]
        THMineRequestManager.requestMyCommentData(param: param, successBlock: { (result) in
            completion?()
            let modelArr = NSArray.yy_modelArray(with: THCommentNewsModel.self, json: result) as? [THCommentNewsModel] ?? [THCommentNewsModel]()
            if self.page == 0 {
                self.dataArr.removeAll()
            }
            if modelArr.count <= 0 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
            self.dataArr += modelArr
            
            self.tableView.reloadData()
        }) { (error) in
            completion?()
        }
    }
    
    @objc func clickPublishBtnEvent() {
        if textView.text.count <= 0 {
            QMUITips.show(withText: "请输入评论")
            return
        }
        
        let param = ["replyText": textView.text ?? "", "vid": self.replyVid ?? "", "commentId": self.replyCommentId ?? ""]
        QMUITips.showLoading(in: view)
        THFindRequestManager.requestCommentOrReply(param: param, successBlock: { (result) in
            QMUITips.hideAllTips()
            QMUITips.show(withText: "评论成功")
            self.textView.resignFirstResponder()
            self.textView.text = ""
            self.tableView.mj_header?.beginRefreshing()
        }) { (error) in
            QMUITips.hideAllTips()
        }
        
    }
}

extension THCommentNewsVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "THCommentNewsCell") as? THCommentNewsCell
        if cell == nil {
            cell = THCommentNewsCell(style: .default, reuseIdentifier: "THCommentNewsCell")
        }
        
        cell?.delegate = self
        cell?.updateModel(model: model)
        
        return cell!
    }
}

extension THCommentNewsVC: THCommentNewsCellDelegate, QMUIKeyboardManagerDelegate {
    
    func clickReplyBtnEvent(commentId: String, vid: String) {
        self.replyCommentId = commentId
        self.replyVid = vid
        textView.becomeFirstResponder()
    }
    
    func keyboardWillChangeFrame(with keyboardUserInfo: QMUIKeyboardUserInfo!) {
        
        QMUIKeyboardManager.handleKeyboardNotification(with: keyboardUserInfo, show: { (keyboardUserInfo: QMUIKeyboardUserInfo?) in
            QMUIKeyboardManager.animateWith(animated: true, keyboardUserInfo: keyboardUserInfo, animations: {
                self.toolbarView.bottom = SCREEN_HEIGHT - keyboardUserInfo!.endFrame.height - NAVIGATIONBAR_HEIGHT
            }, completion: nil)
            
        }) { (keyboardUserInfo: QMUIKeyboardUserInfo?) in
            QMUIKeyboardManager.animateWith(animated: true, keyboardUserInfo: keyboardUserInfo, animations: {
                self.toolbarView.top = SCREEN_HEIGHT
            }, completion: nil)
        }
    }
}



