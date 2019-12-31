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

struct detailModel {
    var title: String?
    var desc: String?
}

class THPlaygroundDetailVC: THBaseVC {
    
    lazy var itemArray = [ShopItem]()
    
    var detailData = [detailModel(title: "球场地址", desc: "aklshflkah"), detailModel(title: "球场地址", desc: "aklshflkah"), detailModel(title: "球场地址", desc: "aklshflkah"), detailModel(title: "球场地址", desc: "aklshflkah"), detailModel(title: "球场地址", desc: "aklshflkah"), detailModel(title: "联系电话", desc: "aklshflkah"), detailModel(title: "营业时间", desc: "aklshflkah"), detailModel(title: "收费标准", desc: "aklshflkah"), detailModel(title: "球场简介", desc: "aklshflkahaklshflkahaklshflkahaklshflkahaklshflkahaklshflkahaklshflkahaklshflkahaklshflkahaklshflkahaklshflkahaklshflkah")]
    
    
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
    lazy var facusBtn: UIButton = {
        let button = UIButton()
        button.tag = 55
        button.setTitle("关注", for: .normal)
        button.setTitleColor(UIColor.colorWithString("5E6D82"), for: .normal)
        button.setTitleColor(UIColor.colorWithString("324057"), for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
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
        return scrollView
    }()
    
    lazy var detailView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.colorWithString("#F9FAFC")
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0.01))
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0.01))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        return tableView
    }()
    lazy var dynamicView : UICollectionView = {
        let layout = THFlowLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
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
        tableView.backgroundColor = UIColor.colorWithString("#F9FAFC")
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
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
        view.addSubview(facusBtn)
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
        
        facusBtn.snp.makeConstraints { (make) in
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
            make.left.equalTo(56)
            make.right.equalTo(-56)
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
        
    }
    
    func configData() {
        getDataSource()
    }
    
    func getDataSource() {
        
        let path = Bundle.main.path(forResource: "shop", ofType: "plist")
        let arr = NSArray(contentsOfFile: path!)
        
        for dic in arr! {
            let shop = ShopItem()
            let dict = dic as! NSDictionary
            shop.h = dict["h"] as? CGFloat
            shop.w = dict["w"] as? CGFloat
            shop.img = dict["img"] as? String
            shop.price = dict["price"] as? String
            itemArray.append(shop)
        }
        dynamicView.reloadData()
    }
    
    @objc func clickButtonEvent() {
        
    }
    
    @objc func clickWriteCommentBtnEvent() {
        textView.becomeFirstResponder()
    }
    
    @objc func clickPublishBtnEvent() {
        print(#function)
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == detailView {
            if indexPath.section == 0 {
                var cell = tableView.dequeueReusableCell(withIdentifier: "THPlaygroundVideoCell") as? THPlaygroundVideoCell
                if cell == nil {
                    cell = THPlaygroundVideoCell(style: .default, reuseIdentifier: "THPlaygroundVideoCell")
                }
                
                cell?.clickItemBlock = { [weak self] (idx: Int) in
                    let vc = THVideoCatVC()
                    self?.navigationPushVC(vc: vc)
                }
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "THCommentCell") as? THCommentCell
        if cell == nil {
           cell = THCommentCell(style: .default, reuseIdentifier: "THCommentCell")
        }
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

extension THPlaygroundDetailVC: THCollectionViewFlowLayoutDelegate {
    
    func th_setCellHeght(layout: THFlowLayout, indexPath: NSIndexPath, itemWidth: CGFloat) -> CGFloat {
        let item = itemArray[indexPath.item]
        let heigth = itemWidth * item.h! / item.w!;
        return 300//heigth
    }
}

extension THPlaygroundDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:THHomeCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "THHomeCollectionCell", for: indexPath) as! THHomeCollectionCell
        setshadow(cell: cell)
        return cell
    }
    
    
    func setshadow(cell: UICollectionViewCell) {
        cell.contentView.layer.cornerRadius = 8.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.contentView.backgroundColor = .white
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowRadius = 2.0   //  阴影扩散半径
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false

        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
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
    lazy var facusBtn: UIButton = {
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
        addSubview(facusBtn)
        addSubview(indicator)
        addSubview(line)
    }
    
    func configFrame() {
        let width = (SCREEN_WIDTH / 4)
        recommendBtn.frame = CGRect(x: 0, y: 0, width: width, height: 44)
        recentBtn.frame = CGRect(x: width, y: 0, width: width, height: 44)
        facusBtn.frame = CGRect(x: width*2, y: 0, width: width, height: 44)
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
