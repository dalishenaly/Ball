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
    
    var aliVideoId: String?
    var vid: String?
    
    var keyboardManager: QMUIKeyboardManager?
    var model: THVideoDetailModel?
    var commentArr = [THCommentModel]()
    var page = 0
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
        player.defaultNotReachableControlLayer.delegate = self
        player.isEnabledFilmEditing = false
        player.defaultEdgeControlLayer.topContainerView.isHidden = true
        return player
    }()

    lazy var commentBar: THCommentBottomBar = {
        let bar = THCommentBottomBar()
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "视频播放"
        configUI()
        configFrame()
        configData()
        configRefresh()
        requestComment(nil)
        
        if LocalStoreUtil.INSTANCE.getWifiSwichStatus() || THReachability.INSTANCE.net?.isReachableOnEthernetOrWiFi ?? false {
            requestVideoUrl()
        } else {
            if THReachability.INSTANCE.net?.isReachable ?? false {
                let alert = UIAlertController(title: "您正在使用移动网络", message: "继续观看会耗费流量", preferredStyle: .alert)
                let sure = UIAlertAction(title: "继续观看", style: .default) { (action) in
                    self.requestVideoUrl()
                }
                let cancel = UIAlertAction(title: "取消观看", style: .cancel) { (action) in
                    self.player.defaultNotReachableControlLayer.promptLabel.isHidden = true
                    self.player.defaultNotReachableControlLayer.reloadView.button.setTitle("继续观看", for: .normal)
                    self.player.switcher.switchControlLayer(forIdentitfier: SJControlLayer_NotReachableAndPlaybackStalled)
                    self.player.controlLayerNeedAppear()
                }
                alert.addAction(cancel)
                alert.addAction(sure)
                present(alert, animated: true, completion: nil)
            } else {
                QMUITips.show(withText: "当前网络不可用")
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        navigationController?.navigationBar.isHidden = true
        IQKeyboardManager.shared().isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.vc_viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.isHidden = false
        IQKeyboardManager.shared().isEnabled = true
        player.vc_viewWillDisappear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player.vc_viewDidDisappear()
    }
    
    deinit {
        
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
        
        let shareItem = SJEdgeControlButtonItem(image: UIImage(named: "share_icon"), target: self, action: #selector(clickShareBtnEvent), tag: 77)
        player.defaultEdgeControlLayer.topAdapter.add(shareItem)
        player.defaultEdgeControlLayer.topAdapter.reload()
        
    }
    
    func configFrame() {
        let playerHeight = view.bounds.size.width / 16 * 9
        playerContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view)
            make.height.equalTo(playerHeight)
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
        
        let param = ["vid": vid ?? ""]
        QMUITips.showLoading(in: view)
        THFindRequestManager.requestVideoDetailData(param: param, successBlock: { (result) in
            QMUITips.hideAllTips()
            self.model = THVideoDetailModel.yy_model(withJSON: result)
            self.commentBar.updateModel(model: self.model ?? THVideoDetailModel())
            self.tableView.reloadData()
        }) { (error) in
            QMUITips.hideAllTips()
            QMUITips.show(withText: error.localizedDescription)
        }
    }
    
    //  请求视频播放链接
    func requestVideoUrl() {
        THVideoRequestManager.requestPlay(videoId: self.aliVideoId ?? "", successBlock: { (result) in
            let model = THVideoInfoModel.yy_model(withJSON: result)
            if let url = URL(string: model?.url ?? "") {
                let asset = SJVideoPlayerURLAsset(url: url)
                self.player.urlAsset = asset;
            }
        }) { (error) in
            QMUITips.show(withText: "视频资源出错")
        }
    }
    
    
    func configRefresh() {
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.headerRefreshing()
        })
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.footerRefreshing()
        })
    }
    
    func headerRefreshing() {
        page = 0
        requestComment {
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.resetNoMoreData()
        }
    }
    
    func footerRefreshing() {
        page += 1
        requestComment {
            self.tableView.mj_footer?.endRefreshing()
        }
    }
    
    func requestComment(_ completion: (()->Void)?) {
        let param = ["vid": vid ?? "", "page": page] as [String : Any]
        THFindRequestManager.requestVideoCommentList(param: param, successBlock: { (result) in
            completion?()
            let modelArr = NSArray.yy_modelArray(with: THCommentModel.self, json: result) as? [THCommentModel] ?? [THCommentModel]()
            if self.page == 0 {
                self.commentArr.removeAll()
            }
            if modelArr.count <= 0 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
            self.commentArr += modelArr
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
        
        let param = ["replyText": textView.text ?? "", "vid": vid ?? ""]
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
    
    @objc func clickShareBtnEvent() {
        
        if player.isFullScreen  {
            player.rotate()
            THShareSheetView.showAlert(title: self.model?.content ?? "", shareUrl: "www.baidu.com")
        } else {
            THShareSheetView.showAlert(title: self.model?.content ?? "", shareUrl: "www.baidu.com")
        }
        
    }
    
    @objc func appNetChange() {
        
    }

}

extension THVideoDetailVC: THCommentBottomBarDelegate, QMUIKeyboardManagerDelegate {
    func onTapCommentCollect() {
        
        let collect = commentBar.collectBtn.isSelected ? "1" : "0"
        let param = ["vid": vid ?? "", "collect": collect]
        THFindRequestManager.requestCollection(param: param, successBlock: { (result) in
            
        }) { (error) in
            
        }
    }
    
    func onTapCommentLike() {
        
        let praise = commentBar.likeBtn.isSelected ? "1" : "0"
        let param = ["vid": vid ?? "", "praise": praise]
        THFindRequestManager.requestVideoPraise(param: param, successBlock: { (result) in
            
        }) { (error) in
            
        }
    }
    
    
    func onTapCommentView() {
        textView.becomeFirstResponder()
    }
    func onTapRemindBtn() {
        let remindVC = THRemindViewController()
        self.navigationController?.pushViewController(remindVC, animated: true)
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

extension THVideoDetailVC: SJNotReachableControlLayerDelegate {
    func backItemWasTapped(for controlLayer: SJControlLayer) {
        navigationController?.popViewController(animated: true)
    }
    
    func reloadItemWasTapped(for controlLayer: SJControlLayer) {
        self.requestVideoUrl()
    }
}

extension THVideoDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.model == nil {
            return 0
        }
        return self.commentArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "THCommentHeaderCell") as? THCommentHeaderCell
            if cell == nil {
                cell = THCommentHeaderCell(style: .default, reuseIdentifier: "THCommentHeaderCell")
            }
            if let model = self.model {
                cell?.updateModel(model: model)
            }
            return cell!
        }
        
        let model = self.commentArr[indexPath.row - 1]
        var cell = tableView.dequeueReusableCell(withIdentifier: "THCommentCell") as? THCommentCell
        if cell == nil {
            cell = THCommentCell(style: .default, reuseIdentifier: "THCommentCell")
        }
//        cell?.replyBtn.isHidden = true
        cell?.updateModel(model: model)
        cell?.vidOrCid = self.vid
        cell?.isVideo = true
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
    func onTapCommentCollect()
    func onTapCommentLike()
    func onTapRemindBtn()
}


class THCommentBottomBar: UIView {
    
    weak var delegate: THCommentBottomBarDelegate?
    var model: THVideoDetailModel?
    
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
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = COLOR_999999
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var remindBtn:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "report_bottom"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(clickRemindBtnEvent(sender:)), for: UIControl.Event.touchUpInside)
        return button
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
        label.text = ""
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
        addSubview(remindBtn)
        addSubview(countLabel)
    }
    
    func configFrame() {
        
        inputCmtView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(5)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(remindBtn.snp_left).offset(-10)
            make.height.equalTo(30)
            make.bottom.equalTo(self).offset(-5)
        }
        
        likeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-8)
            make.centerY.equalTo(self)
            make.width.equalTo(30)
            make.height.equalTo(likeBtn)
        }
        
        collectBtn.snp.makeConstraints { (make) in
            make.right.equalTo(likeBtn.snp_left).offset(-8)
            make.centerY.equalTo(self)
            make.width.equalTo(30)
            make.height.equalTo(collectBtn)
        }
        
        remindBtn.snp.makeConstraints { (make) in
            make.right.equalTo(collectBtn.snp_left).offset(-8)
            make.centerY.equalTo(self)
            make.width.equalTo(30)
            make.height.equalTo(remindBtn)
        }
        
        countLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(likeBtn.snp_right)
            make.top.equalTo(likeBtn)
            make.width.height.equalTo(countLabel)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(inputCmtView).offset(10)
            make.centerY.equalTo(inputCmtView)
            make.width.height.equalTo(21)
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
    
    func updateModel(model: THVideoDetailModel) {
        self.model = model
        likeBtn.isSelected = model.hasPraise
        collectBtn.isSelected = model.hasCollection
        
        let count = model.praiseCount
        let countStr = count > 0 ? "\(count)" : ""
        countLabel.text = countStr
    }
    
    @objc func clickRemindBtnEvent(sender:UIButton){
        delegate?.onTapRemindBtn()
    }
    @objc func clickCollectBtnEvent(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.onTapCommentCollect()
    }
    
    @objc func clickLikeBtnEvent(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            model?.praiseCount = (model?.praiseCount ?? 0) + 1
        } else {
            model?.praiseCount = (model?.praiseCount ?? 0) - 1
        }
        let count = model?.praiseCount ?? 0
        let countStr = count > 0 ? "\(count)" : ""
        countLabel.text = countStr
        delegate?.onTapCommentLike()
    }
    
    @objc func onTapCommentView() {
        delegate?.onTapCommentView()
    }
}
