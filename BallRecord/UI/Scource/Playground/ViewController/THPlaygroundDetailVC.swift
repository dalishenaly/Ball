//
//  THPlaygroundDetailVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/6.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import QMUIKit
import IQKeyboardManager

class detailModel: NSObject {
    var title: String?
    var desc: String?
    var key: String?
    init(title: String, key: String) {
        super.init()
        self.title = title
        self.key = key
    }
}

class THPlaygroundDetailVC: THBaseVC {
    
    
    var dynPage = 0
    var cmtPage = 0
    var playgroundModel: THPGModel?
    var model: THPGDetailModel?
    var dynamicArr = [THDynamicModel]()
    var commentArr = [THCommentModel]()
    var cid: String?
    lazy var itemArray = [ShopItem]()
    
    var detailData = [detailModel(title: "球场地址", key: "location"),
                      detailModel(title: "联系电话", key: "phoneNumber"),
                      detailModel(title: "营业时间", key: "businessTime"),
                      detailModel(title: "收费标准", key: "chargeStandard"),
                      detailModel(title: "球场简介", key: "courtIntroduce")]
    
    
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
        textView.placeholder = "优质评论将会被优先展示"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .groupTableViewBackground
        textView.setCorner(cornerRadius: 8, masksToBounds: true, borderColor: COLOR_LINE, borderWidth: 0.5)
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
    
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = UIColor.randomColor()
        return imgV
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "五棵松"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = COLOR_333333
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "阿手机打发了沙发"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = COLOR_666666
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var focusBtn: UIButton = {
        let button = UIButton()
        button.setTitle("关注", for: .normal)
        button.backgroundColor = COLOR_D6E7FD
        button.setCorner(cornerRadius: 4, masksToBounds: true, borderColor: COLOR_B3D0FB, borderWidth: 1)
        button.setTitleColor(COLOR_666666, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(clickButtonEvent), for: .touchUpInside)
        return button
    }()

    let tagselectView = THTagSelectView()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    lazy var detailView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0.01))
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0.01))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.backgroundColor = .white
        return tableView
    }()
    lazy var dynamicView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0.01;
        layout.minimumInteritemSpacing = 0.01;
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(THHomeCollectionCell.self, forCellWithReuseIdentifier: "THHomeCollectionCell")
        return collectionView
    }()
    
    lazy var commentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var commentTView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.estimatedRowHeight = SCREEN_HEIGHT
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        return tableView
    }()
    
    lazy var writeCommentBtn: UIButton = {
        let button = UIButton()
        button.tag = 55
        button.setTitle("写评论", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = MAIN_COLOR
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickWriteCommentBtnEvent), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cid = self.playgroundModel?.cid
        self.iconView.setImage(urlStr: self.playgroundModel?.imageUrl, placeholder: placeholder_square)
        self.titleLabel.text = self.playgroundModel?.name
        self.detailLabel.text = self.playgroundModel?.location
        
        configUI()
        configFrame()
        configData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnabled = true
    }
}

extension THPlaygroundDetailVC {
    func configUI() {
        
        title = "球场简介"
        tagselectView.delegate = self
        
        view.addSubview(iconView)
        view.addSubview(titleLabel)
        view.addSubview(detailLabel)
        view.addSubview(focusBtn)
        view.addSubview(tagselectView)
        view.addSubview(scrollView)
        
        scrollView.addSubview(detailView)
        scrollView.addSubview(dynamicView)
        scrollView.addSubview(commentView)
        commentView.addSubview(commentTView)
        commentView.addSubview(writeCommentBtn)
        
        view.addSubview(toolbarView)
        toolbarView.addSubview(textView)
        toolbarView.addSubview(publishBtn)
        
        keyboardManager = QMUIKeyboardManager(delegate: self)
        // 设置键盘只接受 self.textView 的通知事件，如果当前界面有其他 UIResponder 导致键盘产生通知事件，则不会被接受
        keyboardManager?.addTargetResponder(textView)
    }
    
    func configFrame() {
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.height.equalTo(90)
            make.top.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(10)
            make.right.equalTo(-15)
            make.top.equalTo(iconView)
            make.height.equalTo(titleLabel)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp_bottom)
            make.height.equalTo(titleLabel)
        }
        
        focusBtn.snp.makeConstraints { (make) in
            make.left.equalTo(detailLabel)
            make.width.equalTo(70)
            make.height.equalTo(30)
            make.bottom.equalTo(iconView)
        }
        
        tagselectView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(iconView.snp_bottom).offset(30)
            make.height.equalTo(44)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(tagselectView.snp_bottom)
            make.bottom.equalTo(view)
        }
        
        detailView.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView)
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }
        dynamicView.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView).offset(SCREEN_WIDTH)
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }
        commentView.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView).offset(SCREEN_WIDTH*2)
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }
        
        commentTView.snp.makeConstraints { (make) in
            make.left.equalTo(commentView)
            make.right.equalTo(commentView)
            make.top.equalTo(commentView)
            make.bottom.equalTo(writeCommentBtn.snp_top).offset(-10)
        }
        
        writeCommentBtn.snp.makeConstraints { (make) in
            make.left.equalTo(26)
            make.right.equalTo(-26)
            make.height.equalTo(40)
            make.bottom.equalTo(-10)
        }
        
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH * 3, height: 0)
        
        
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
        
        writeCommentBtn.setCorner(cornerRadius: 20)
        
    }
    
    func configData() {
        //getDataSource()
        
        configRefresh()
        
        requestDetailData()
        requestDynamicData(nil)
        requestCommentData(nil)
    }
    
    func configRefresh() {
        
        dynamicView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.dynPage = 0
            self.requestDynamicData {
                self.dynamicView.mj_header?.endRefreshing()
                self.dynamicView.mj_footer?.resetNoMoreData()
            }
        })
        dynamicView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.dynPage += 1
            self.requestDynamicData {
                self.dynamicView.mj_footer?.endRefreshing()
            }
        })
        dynamicView.mj_footer?.ignoredScrollViewContentInsetBottom = isiPhoneX() ? 34 : 0
        
        commentTView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.cmtPage = 0
            self.requestCommentData {
                self.commentTView.mj_header?.endRefreshing()
                self.commentTView.mj_footer?.resetNoMoreData()
            }
        })
        commentTView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.cmtPage += 1
            self.requestCommentData {
                self.commentTView.mj_footer?.endRefreshing()
            }
        })
    }
    
    func requestDetailData() {
        let param = ["cid": self.cid ?? ""]
        QMUITips.showLoading(in: view)
        THPlaygroundManager.requestPlaygroundDetailData(param: param, successBlock: { (result) in
            QMUITips.hideAllTips()
            self.model = THPGDetailModel.yy_model(withJSON: result)
            
            if self.model?.isFan ?? false {
                self.focusBtn.setTitle("已关注", for: .normal)
                self.focusBtn.backgroundColor = COLOR_E7E7E7
                self.focusBtn.setCorner(cornerRadius: 4, masksToBounds: true, borderColor: COLOR_LINE, borderWidth: 1)
            } else {
                self.focusBtn.setTitle("关注", for: .normal)
                self.focusBtn.backgroundColor = COLOR_D6E7FD
                self.focusBtn.setCorner(cornerRadius: 4, masksToBounds: true, borderColor: COLOR_B3D0FB, borderWidth: 1)
            }
            
            
            if let dict = self.model?.information {
                for item in self.detailData {
                    item.desc = dict[item.key!] as? String ?? ""
                }
            }
            
            self.detailView.reloadData()
        }) { (error) in
            QMUITips.hideAllTips()
            QMUITips.show(withText: error.localizedDescription)
        }
    }
    
    func requestDynamicData(_ completion: (()->Void)?) {
        let param = ["cid": self.cid ?? "", "page": self.dynPage] as [String : Any]
        THPlaygroundManager.requestPlayGroundDynamicData(param: param, successBlock: { (result) in
            completion?()
            let modelArr = NSArray.yy_modelArray(with: THDynamicModel.self, json: result) as? [THDynamicModel] ?? [THDynamicModel]()
            
            if self.dynPage == 0 {
                self.dynamicArr.removeAll()
            }
            if modelArr.count <= 0 {
                self.dynamicView.mj_footer?.endRefreshingWithNoMoreData()
            }
            
            self.dynamicArr += modelArr
            self.dynamicView.reloadData()
            
        }) { (error) in
            completion?()
        }
    }
    
    func requestCommentData(_ completion: (()->Void)?) {
        let param = ["cid": self.cid ?? "", "page": self.cmtPage] as [String : Any]
        THPlaygroundManager.requestPlaygroundCommentData(param: param, successBlock: { (reuslt) in
            completion?()
            let modelArr = NSArray.yy_modelArray(with: THCommentModel.self, json: reuslt) as? [THCommentModel] ?? [THCommentModel]()
            
            THCommentController.INSTANCE.cacheNotesDataSource(dataSource: modelArr)
            if self.cmtPage == 0 {
                self.commentArr.removeAll()
            }
            if modelArr.count <= 0 {
                self.commentTView.mj_footer?.endRefreshingWithNoMoreData()
            }
            
            self.commentArr += modelArr
            self.commentTView.reloadData()
            
        }) { (error) in
            completion?()
        }
    }

    
    @objc func clickButtonEvent() {
        
        if focusBtn.titleLabel?.text == "关注" {
            self.focusBtn.setTitle("已关注", for: .normal)
            self.focusBtn.backgroundColor = COLOR_E7E7E7
            self.focusBtn.setCorner(cornerRadius: 4, masksToBounds: true, borderColor: COLOR_LINE, borderWidth: 1)
        } else {
            self.focusBtn.setTitle("关注", for: .normal)
            self.focusBtn.backgroundColor = COLOR_D6E7FD
            self.focusBtn.setCorner(cornerRadius: 4, masksToBounds: true, borderColor: COLOR_B3D0FB, borderWidth: 1)
        }
        
        let concern = focusBtn.titleLabel?.text == "关注" ? 0 : 1
        let param = ["cid": self.cid ?? "", "concern": concern] as [String : Any]
        THPlaygroundManager.requestPlaygroundFocus(param: param, successBlock: { (result) in
            
        }) { (error) in
            
        }
    }
    
    @objc func clickWriteCommentBtnEvent() {
        textView.becomeFirstResponder()
    }
    
    @objc func clickPublishBtnEvent() {
        print(#function)
        
        QMUITips.showLoading(in: view)
        if let content = textView.text {
            let param = ["content": content, "placeId": self.cid ?? ""]
            THPlaygroundManager.requestPlaygroundWriteComment(param: param, successBlock: { (result) in
                QMUITips.hideAllTips()
                self.textView.resignFirstResponder()
                self.textView.text = ""
                self.commentTView.mj_header?.beginRefreshing()
                QMUITips.show(withText: "提交成功待审核")
            }) { (error) in
                QMUITips.hideAllTips()
            }
        } else {
            QMUITips.show(withText: "请输入您的评论")
        }
    }
}

extension THPlaygroundDetailVC: THFindTitleViewDelegate, QMUIKeyboardManagerDelegate {
    
    func onClickButtonEvent(idx: Int) {
        
    }
    
    func keyboardWillChangeFrame(with keyboardUserInfo: QMUIKeyboardUserInfo!) {
        
        QMUIKeyboardManager.handleKeyboardNotification(with: keyboardUserInfo, show: { (keyboardUserInfo: QMUIKeyboardUserInfo?) in
            QMUIKeyboardManager.animateWith(animated: true, keyboardUserInfo: keyboardUserInfo, animations: {
                self.toolbarView.bottom = self.view.height - keyboardUserInfo!.endFrame.height
            }, completion: nil)
            
        }) { (keyboardUserInfo: QMUIKeyboardUserInfo?) in
            QMUIKeyboardManager.animateWith(animated: true, keyboardUserInfo: keyboardUserInfo, animations: {
                self.toolbarView.top = SCREEN_HEIGHT
            }, completion: nil)
        }
    }
}

extension THPlaygroundDetailVC: THTagSelectViewDelegate, UIScrollViewDelegate {
    
    func onClickButtonEvent(index: Int) {
        scrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH * CGFloat(index), y: 0), animated: false)
        
        print("*** scrollView 转换 停止滚动 \(scrollView.contentOffset.x)")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            self.scrollViewDidEndDecelerating(self.scrollView)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        print("*** scrollView 转换 停止滚动 \(self.scrollView.contentOffset.x)")
        let idx = self.scrollView.contentOffset.x / SCREEN_WIDTH
        if let button = tagselectView.viewWithTag(Int(idx + 55)) as? UIButton {
            tagselectView.clickButtonEvent(sender: button)
        }
    }
}


extension THPlaygroundDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == detailView {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == detailView {
            if section == 0 {
                return 1
            }
            return detailData.count
        }
        return self.commentArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == detailView {
            if indexPath.section == 0 {
                var cell = tableView.dequeueReusableCell(withIdentifier: "THPlaygroundVideoCell") as? THPlaygroundVideoCell
                if cell == nil {
                    cell = THPlaygroundVideoCell(style: .default, reuseIdentifier: "THPlaygroundVideoCell")
                }
                cell?.clickItemBlock = { (idx: Int) in
                    let model = self.model?.halfList?[idx]
                    if model?.recentCount == 0 {
                        QMUITips.show(withText: "暂无视频，请稍后再来")
                        return
                    }
                    let vc = THVideoCatVC()
                    vc.cid = self.cid
                    vc.cvid = model?.cvid ?? ""
                    self.navigationPushVC(vc: vc)
                }
                cell?.updateModel(modelArr: self.model?.halfList ?? [])
                return cell!
            }
            
            let model = detailData[indexPath.row]
            var cell = tableView.dequeueReusableCell(withIdentifier: "THPlaygroundDetailCell") as? THPlaygroundDetailCell
            if cell == nil {
                cell = THPlaygroundDetailCell(style: .default, reuseIdentifier: "THPlaygroundDetailCell")
            }
            cell?.titleLabel.text = model.title
            cell?.descLabel.text = model.desc
            return cell!
        }
        
        var model = self.commentArr[indexPath.row]
        model = THCommentController.INSTANCE.getCommentModel(commentId: model.commentId)!
        var cell = tableView.dequeueReusableCell(withIdentifier: "THCommentCell") as? THCommentCell
        if cell == nil {
           cell = THCommentCell(style: .default, reuseIdentifier: "THCommentCell")
        }
        cell?.updateModel(model: model)
        cell?.vidOrCid = self.cid
        cell?.isVideo = false
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == detailView {
            if section == 0 {
                return UIView()
            }
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 44))
            let label = UILabel(frame: CGRect(x: 16, y: 0, width: SCREEN_WIDTH - 16, height: 44))
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textColor = COLOR_333333
            label.text = "球场简介"
            view.backgroundColor = .white
            view.addSubview(label)
            return view
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == detailView {
            if section == 0 {
                return 0.01
            }
            return 44
        }
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

extension THPlaygroundDetailVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dynamicArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dynamicArr[indexPath.row]
        let cell:THHomeCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "THHomeCollectionCell", for: indexPath) as! THHomeCollectionCell
        cell.updateModel(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dynamicArr[indexPath.row]
        let vc = THVideoDetailVC()
        vc.vid = model.vid
        vc.aliVideoId = model.vUrl
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = dynamicArr[indexPath.row]
        let width = collectionView.bounds.size.width-30
        return CGSize(width: width, height: model.caculateCellHeight(width: width, fontSize:15))
    }
}


//  MARK: - THTagSelectView
@objc protocol THTagSelectViewDelegate {
    func onClickButtonEvent(index: Int)
}

class THTagSelectView: UIView {
    
    weak var delegate: THTagSelectViewDelegate?
    
    var selectBtn: UIButton?
    
    lazy var recommendBtn: UIButton = {
        let button = UIButton()
        button.tag = 55
        button.setTitle("球场", for: .normal)
        button.setTitleColor(COLOR_999999, for: .normal)
        button.setTitleColor(COLOR_333333, for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()
    lazy var recentBtn: UIButton = {
        let button = UIButton()
        button.tag = 56
        button.setTitle("动态", for: .normal)
        button.setTitleColor(COLOR_999999, for: .normal)
        button.setTitleColor(COLOR_333333, for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()
    lazy var focusBtn: UIButton = {
        let button = UIButton()
        button.tag = 57
        button.setTitle("评论", for: .normal)
        button.setTitleColor(COLOR_999999, for: .normal)
        button.setTitleColor(COLOR_333333, for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var indicator: UIView = {
        let view = UIView()
        view.backgroundColor = MAIN_COLOR
        return view
    }()
    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = COLOR_999999
        return view
    }()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 44))
        configUI()
        configFrame()
        configData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        addSubview(recommendBtn)
        addSubview(recentBtn)
        addSubview(focusBtn)
        addSubview(indicator)
        addSubview(line)
    }
    
    func configFrame() {
        let width = (SCREEN_WIDTH / 4)
        recommendBtn.frame = CGRect(x: 0, y: 0, width: width, height: 44)
        recentBtn.frame = CGRect(x: width, y: 0, width: width, height: 44)
        focusBtn.frame = CGRect(x: width*2, y: 0, width: width, height: 44)
        line.frame = CGRect(x: 0, y: 43.5, width: SCREEN_WIDTH, height: 0.5)
        selectBtn = recommendBtn
        selectBtn?.isSelected = true
        
        indicator.frame = CGRect(x: 0, y: 40, width: 34, height: 4)
        indicator.centerX = recommendBtn.centerX
    }
    
    func configData() {
        
    }
    
    @objc func clickButtonEvent(sender: UIButton) {
        
        selectBtn?.isSelected = false
        sender.isSelected = true
        self.selectBtn = sender
        UIView.animate(withDuration: 0.2) {
            self.indicator.centerX = sender.centerX
            self.delegate?.onClickButtonEvent(index: sender.tag - 55)
        }
        
    }
}
