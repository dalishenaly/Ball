//
//  THMineVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/17.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit


struct mineCellModel {
    var iconName: String = ""
    var title: String = ""
    var clsName: String = ""
}

class THMineVC: THBaseVC {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.estimatedRowHeight = SCREEN_HEIGHT
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.colorWithString("#F9FAFC")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0.1))
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0.1))
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    let cellModelArr = [mineCellModel(iconName: "record_icon", title: "打球记录", clsName: "THInputCodeVC"),
                       mineCellModel(iconName: "collect_icon", title: "我的收藏"),
                       mineCellModel(iconName: "facus_icon", title: "我的关注", clsName: "THMyFocusVC"),
                       mineCellModel(iconName: "fans_icon", title: "我的粉丝", clsName: "THMyFocusVC"),
                       mineCellModel(iconName: "feedBack_icon", title: "意见反馈", clsName: "THFeedBackVC"),
                       mineCellModel(iconName: "protocol_icon", title: "用户协议"),
                       mineCellModel(iconName: "privacy_icon", title: "隐私政策"),
                       mineCellModel(iconName: "about_icon", title: "关于我们", clsName: "THAboutVC")]

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configFrame()
        configData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }

}

extension THMineVC {
    func configUI() {
        
        navigationController?.navigationBar.isHidden = true

        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        let clazzName: String = String(describing: THHeaderViewCell.self)
        let nib = UINib(nibName: clazzName, bundle: Bundle(for: THHeaderViewCell.self))
        tableView.register(nib, forCellReuseIdentifier: clazzName)
        
        view.addSubview(tableView)
    }
    
    func configFrame() {
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    
    func configData() {
        
    }
}

extension THMineVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = cellModelArr[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "THMineCell") as? THMineCell
        if cell == nil {
            cell = THMineCell(style: .default, reuseIdentifier: "THMineCell")
        }
        cell?.titleLabel.text = cellModel.title
        cell?.iconView.image = UIImage(named: cellModel.iconName)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell: THHeaderViewCell? = tableView.dequeueReusableCell(withIdentifier: "THHeaderViewCell") as? THHeaderViewCell
        cell?.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellModel = cellModelArr[indexPath.row]
        if let vc = stringToVC(vcName: cellModel.clsName) {
            navigationPushVC(vc: vc)
        }
    }
}

extension THMineVC: THHeaderViewCellDelegate {
    
    func onClickConfigEvent() {
//        THShareSheetView.showAlert()
        let vc = THSettingVC()
        navigationPushVC(vc: vc)
    }
    
    func onClickMoreEvent() {
//        let vc1 = THRegisterVC()
        let vc = THPersonalInfoVC()
        navigationPushVC(vc: vc)
    }
    
    func onClickMyDynamic() {
        let vc = THMyDynamicVC()
        navigationPushVC(vc: vc)
    }
    
    func onClickMyRough() {
        let vc = THRoughVC()
        navigationPushVC(vc: vc)
    }
    
    func onClickMyNews() {
        let vc = THMyNewsVC()
        navigationPushVC(vc: vc)
    }
}


