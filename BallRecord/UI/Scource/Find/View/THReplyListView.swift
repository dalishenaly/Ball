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
    
    var model: THCommentModel?
    var vidOrCid: String?
    var isVideo: Bool?
    
    var dataArr = [THCommentModel]()
    var page = 0
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
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
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
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = COLOR_999999
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
        configRefresh()
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
            make.width.height.equalTo(21)
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
    
    func configRefresh() {
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 0
            self.requestListData {
                self.tableView.mj_header?.endRefreshing()
                self.tableView.mj_footer?.resetNoMoreData()
            }
        })
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.page += 1
            self.requestListData {
                self.tableView.mj_footer?.endRefreshing()
            }
        })
    }
    
    func requestListData(_ completion: (()->Void)?) {
        
        if self.isVideo ?? false {
            let param = ["commentId": model?.commentId ?? "0"]
            THFindRequestManager.requestLookReply(param: param, successBlock: { (result) in
                completion?()
                let arr = NSArray.yy_modelArray(with: THCommentModel.self, json: result) as? [THCommentModel] ?? [THCommentModel]()
                if self.page == 0 {
                    self.dataArr.removeAll()
                }
                if arr.count <= 0 {
                    self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                }
                self.dataArr += arr
                self.tableView.reloadData()
                
            }) { (error) in
                completion?()
            }
        } else {
            let param = ["cid": self.vidOrCid ?? "", "page": self.page, "commentId": model?.commentId ?? "0"] as [String : Any]
            THPlaygroundManager.requestPlaygroundCommentData(param: param, successBlock: { (result) in
                completion?()
                let arr = NSArray.yy_modelArray(with: THCommentModel.self, json: result) as? [THCommentModel] ?? [THCommentModel]()
                if self.page == 0 {
                    self.dataArr.removeAll()
                }
                if arr.count <= 0 {
                    self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                }
                self.dataArr += arr
                self.tableView.reloadData()
                
            }) { (error) in
                completion?()
            }
        }
    }
    
    
    @objc func clickCloseBtnEvent() {
        removeFromSuperview()
    }
    
    @objc func onTapInputView() {
        self.inputPublishView.textViewBecomeFirstResponder()
    }
    
    class func show(model: THCommentModel, vidOrCid: String, isVideo: Bool) {
        let shareView = THReplyListView()
        shareView.model = model
        shareView.vidOrCid = vidOrCid
        shareView.isVideo = isVideo
        shareView.requestListData(nil)
        if let window = UIApplication.shared.delegate?.window {
            window?.addSubview(shareView)
        }
    }
    
    
    
    func updateModel() {
        
    }
    
}

extension THReplyListView: THInputViewDelegate {
    
    func clickPublishEvent() {
        if inputPublishView.textView.text.count <= 0 {
            QMUITips.show(withText: "请输入评论")
            return
        }
        QMUITips.showLoading(in: AppDelegate.WINDOW!)
<<<<<<< HEAD
        if self.isVideo ?? false {
            let param = ["replyText": inputPublishView.textView.text!, "vid": self.vidOrCid ?? "", "commentId": model?.commentId ?? ""]
            THFindRequestManager.requestCommentOrReply(param: param, successBlock: { (result) in
                QMUITips.hideAllTips()
                self.inputPublishView.textView.resignFirstResponder()
                self.inputPublishView.textView.text = ""
                self.tableView.mj_header.beginRefreshing()
                QMUITips.show(withText: "提交成功")
            }) { (error) in
                QMUITips.hideAllTips()
            }
        } else {
            let param = ["content": inputPublishView.textView.text!, "placeId": self.vidOrCid ?? "", "replyId": model?.commentId ?? ""]
            THPlaygroundManager.requestPlaygroundWriteComment(param: param, successBlock: { (result) in
                QMUITips.hideAllTips()
                self.inputPublishView.textView.resignFirstResponder()
                self.inputPublishView.textView.text = ""
                self.tableView.mj_header.beginRefreshing()
                QMUITips.show(withText: "提交成功")
            }) { (error) in
                QMUITips.hideAllTips()
            }
=======
        let param = ["content": inputPublishView.textView.text!, "placeId": self.vidOrCid ?? "", "replyId": model?.commentId ?? ""]
        THPlaygroundManager.requestPlaygroundWriteComment(param: param, successBlock: { (result) in
            QMUITips.hideAllTips()
            self.inputPublishView.textView.resignFirstResponder()
            self.inputPublishView.textView.text = ""
            self.tableView.mj_header?.beginRefreshing()
            QMUITips.show(withText: "提交成功")
        }) { (error) in
            QMUITips.hideAllTips()
>>>>>>> master
        }
        
    }
}

extension THReplyListView: UITableViewDelegate, UITableViewDataSource {
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "THReplyLZCell") as? THReplyLZCell
            if cell == nil {
                cell = THReplyLZCell(style: .default, reuseIdentifier: "THReplyLZCell")
            }
            if let model = self.model {
                cell?.updateModel(model: model)
            }
            return cell!
        }
        
        let model = self.dataArr[indexPath.row - 1]
        var cell = tableView.dequeueReusableCell(withIdentifier: "THCommentCell") as? THCommentCell
        if cell == nil {
            cell = THCommentCell(style: .default, reuseIdentifier: "THCommentCell")
        }
        cell?.replyBtn.isHidden = true
        cell?.likeBtn.isHidden = true
        cell?.updateModel(model: model)
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
