//
//  THFeedBackVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/29.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import QMUIKit
import SnapKit

class THFeedBackVC: THBaseTableViewVC {
    
    var dataArr = [THDialogNewsModel]()
    var page = 0
    var toolBarBottom: Constraint?
    var textViewH: Constraint?
    
    var keyboardManager: QMUIKeyboardManager?
    let toolbarView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 80))
        view.qmui_borderColor = COLOR_LINE;
        view.qmui_borderPosition = .top
        view.backgroundColor = .white
        return view
    }()
    lazy var textView: QMUITextView = {
        let textView = QMUITextView(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH - 80, height: 80))
        textView.delegate = self
        textView.placeholder = "请输入您想要反馈的"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = COLOR_F4F4F4
        textView.setCorner(cornerRadius: 8, masksToBounds: true, borderColor: COLOR_LINE, borderWidth: 0.5)
        textView.inputAccessoryView = UIView()
        return textView
    }()
    lazy var publishBtn: UIButton = {
        let button = UIButton()
        button.setTitle("发送", for: .normal)
        button.setTitleColor(UIColor.colorWithString("5E6D82"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickPublishBtnEvent), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configRefresh()
    }
    
    override func configUI() {
        
        title = "意见反馈"
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        view.addSubview(toolbarView)
        toolbarView.addSubview(textView)
        toolbarView.addSubview(publishBtn)
        
        keyboardManager = QMUIKeyboardManager(delegate: self)
        // 设置键盘只接受 self.textView 的通知事件，如果当前界面有其他 UIResponder 导致键盘产生通知事件，则不会被接受
        keyboardManager?.addTargetResponder(textView)
    }
    
    override func configFrame() {
        
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(toolbarView.snp_top)
        }
        
        toolbarView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(toolbarView)
            toolBarBottom = make.bottom.equalTo(view).constraint
        }
        
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(toolbarView).offset(15)
            make.right.equalTo(toolbarView).offset(-80)
            make.top.equalTo(toolbarView).offset(10)
            make.bottom.equalTo(toolbarView).offset(-10)
            textViewH = make.height.equalTo(35).constraint
        }
        
        publishBtn.snp.makeConstraints { (make) in
            make.right.equalTo(toolbarView)
            make.width.equalTo(80)
            make.height.equalTo(55)
            make.bottom.equalTo(toolbarView)
        }
    }
    
    override func configData() {
        
        requestData(nil)
    }
    
    func configRefresh() {
            tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
                self.headerRefreshing()
            })
            
//            tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
//                self.footerRefreshing()
//            })
        }
        
        func headerRefreshing() {
            page += 1
            requestData {
                self.tableView.mj_header.endRefreshing()
//                self.tableView.mj_footer.resetNoMoreData()
            }
        }
        
        func footerRefreshing() {
            page += 1
            requestData {
                self.tableView.mj_footer.endRefreshing()
            }
        }
        
        func requestData(_ completion: (()->Void)?) {
            let param = ["page": self.page]
            THMineRequestManager.requestFeedbackData(param: param, successBlock: { (result) in
                completion?()
                
                let modelArr = NSArray.yy_modelArray(with: THDialogNewsModel.self, json: result) as? [THDialogNewsModel] ?? [THDialogNewsModel]()
                if self.page == 0 {
                    self.dataArr.removeAll()
                }
//                if modelArr.count <= 0 {
////                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
//                }
                
                self.dataArr = modelArr + self.dataArr
                self.tableView.reloadData()
            }) { (error) in
                completion?()
            }
        }
    
    
}

extension THFeedBackVC {
    
    @objc func clickPublishBtnEvent() {
        if self.textView.text.count <= 0 {
            QMUITips.show(withText: "请输入反馈意见")
            return
        }
        let param = ["content": self.textView.text ?? ""]
        THMineRequestManager.requestSubmitFeedbackData(param: param, successBlock: { (result) in
            let model = THDialogNewsModel()
            model.content = self.textView.text ?? ""
            model.type = 1
            self.dataArr.append(model)
            self.textView.resignFirstResponder()
            self.textView.text = ""
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }
}


extension THFeedBackVC: QMUITextViewDelegate, QMUIKeyboardManagerDelegate {
    
    func textView(_ textView: QMUITextView!, newHeightAfterTextChanged height: CGFloat) {
        
        UIView.animate(withDuration: 0.2) {
            self.textViewH?.update(offset: height > 95 ? 95 : height)
        }
    }
    
    
    func keyboardWillChangeFrame(with keyboardUserInfo: QMUIKeyboardUserInfo!) {
        
        QMUIKeyboardManager.handleKeyboardNotification(with: keyboardUserInfo, show: { (keyboardUserInfo: QMUIKeyboardUserInfo?) in
            QMUIKeyboardManager.animateWith(animated: true, keyboardUserInfo: keyboardUserInfo, animations: {
                self.toolBarBottom?.update(offset: -keyboardUserInfo!.endFrame.height)
                self.view.layoutIfNeeded()
                self.tableView.qmui_scrollToBottom()
            }, completion: nil)
            
        }) { (keyboardUserInfo: QMUIKeyboardUserInfo?) in
            QMUIKeyboardManager.animateWith(animated: true, keyboardUserInfo: keyboardUserInfo, animations: {
                self.toolBarBottom?.update(offset: 0)
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

extension THFeedBackVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.dataArr[indexPath.row]
        if model.type == 1 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "THMineDialogCell") as? THMineDialogCell
            if cell == nil {
                cell = THMineDialogCell(style: .default, reuseIdentifier: "THMineDialogCell")
            }
            cell?.titleLabel.text = model.content
            let userInfo = THLoginController.instance.userInfo
            cell?.iconView.setImage(urlStr: userInfo?.avatar, placeholder: placeholder_round)
            return cell!
        }
        var cell = tableView.dequeueReusableCell(withIdentifier: "THSystemDialogCell") as? THSystemDialogCell
        if cell == nil {
            cell = THSystemDialogCell(style: .default, reuseIdentifier: "THSystemDialogCell")
        }
        cell?.titleLabel.text = model.content
        return cell!
    }
}

class THInPutToolView: UIView {
    
    
}
