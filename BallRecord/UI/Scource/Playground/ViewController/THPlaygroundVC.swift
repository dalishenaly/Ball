//
//  THPlaygroundVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/17.
//  Copyright © 2019 maichao. All rights reserved.
//

import QMUIKit

class THPlaygroundVC: THBaseVC {

    let titleView = THPlaygroundTitleView()
    let cityMenuView = THCityMenuView()
    var cityModelArr = [THCityModel]()
    var playgroundModelArr = [THPGModel]()
    var selectCityModel: THCityModel?
    var type = "1"  //  热度
    var page = 0
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        configFrame()
        configData()
        configRefresh()
    }
    
    func configUI() {
        
        let model = THCityModel()
        model.city = "全国"
        model.cityCode = 0
        selectCityModel = model
        
        titleView.delegate = self
        navigationItem.titleView = titleView
        
        cityMenuView.delegate = self
        cityMenuView.isHidden = true
        self.tabBarController?.view.addSubview(cityMenuView)
        
        view.addSubview(tableView)
    }
    
    func configFrame() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
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
        requestPlaygroundData {
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.resetNoMoreData()
        }
    }
    
    func footerRefreshing() {
        page += 1
        requestPlaygroundData {
            self.tableView.mj_footer.endRefreshing()
        }
    }
    
//    func requestData(completion: (()->Void)?) {
//
//        THMineRequestManager.requestMyCommentData(param: [:], successBlock: { (result) in
//            completion?()
//            let modelArr = NSArray.yy_modelArray(with: THPraiseModel.self, json: result) as? [THPraiseModel] ?? []
//            if modelArr.count <= 0 {
//                self.tableView.mj_footer.endRefreshingWithNoMoreData()
//            }
//            self.dataArr += modelArr
//
//            self.tableView.reloadData()
//        }) { (error) in
//            completion?()
//        }
//    }
    
    func configData() {
        requestCityData()
        requestPlaygroundData(nil)
    }
    
    func requestPlaygroundData(_ completion: (()->Void)?) {
        QMUITips.showLoading(in: view)
        let longitude = THLocationManager.instance.longitude ?? 0
        let latitude = THLocationManager.instance.latitude ?? 0
        let param = ["type": type, "cityId": self.selectCityModel?.cityCode ?? 0, "longitude": "\(longitude)", "latitude": "\(latitude)", "page": self.page] as [String : Any]
        THPlaygroundManager.requestPlaygroundListData(param: param, successBlock: { (result) in
            completion?()
            QMUITips.hideAllTips()
            
            let modelArr = NSArray.yy_modelArray(with: THPGModel.self, json: result) as? [THPGModel] ?? [THPGModel]()
            if self.page == 0 {
                self.playgroundModelArr.removeAll()
            }
            if modelArr.count <= 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            
            self.playgroundModelArr += modelArr
            self.tableView.reloadData()
        }) { (error) in
            completion?()
            QMUITips.hideAllTips()
            QMUITips.show(withText: error.localizedDescription)
        }
    }
    
    
    func requestCityData() {
        THPlaygroundManager.requestCityListData(param: nil, successBlock: { (result) in
            self.cityModelArr = NSArray.yy_modelArray(with: THCityModel.self, json: result) as? [THCityModel] ?? [THCityModel]()
            if self.cityModelArr.count > 0 {
                let model = self.cityModelArr.first!
                model.hasSelect = true
                self.selectCityModel = model
            }
            self.cityMenuView.updateCityList(modelArr: self.cityModelArr)
        }) { (error) in
            
        }
    }
    
}

extension THPlaygroundVC: THPlaygroundTitleViewDelegate, THCityMenuViewDelegate {
    
    func onClickTitleView(index: Int, isSelected: Bool) {
        
        if index == 0 {
            cityMenuView.tableView.reloadData()
            cityMenuView.isHidden = !isSelected
        } else if index == 1 {
            titleView.distanceBtn.isSelected = false
            self.type = "1"
            tableView.mj_header.beginRefreshing()
//            requestPlaygroundData(nil)
        } else {
            titleView.hotBtn.isSelected = false
            self.type = "2"
            tableView.mj_header.beginRefreshing()
//            requestPlaygroundData(nil)
        }
    }
    
    func cityMenuViewDidSelectRowAt(indexPath: IndexPath) {
        self.selectCityModel?.hasSelect = false
        cityMenuView.isHidden = true
        
        self.selectCityModel = cityModelArr[indexPath.row]
        self.selectCityModel?.hasSelect = true
        
        titleView.cityBtn.isSelected = false
        titleView.cityBtn.titleLabel?.text = self.selectCityModel?.city
        titleView.cityBtn.setTitle(self.selectCityModel?.city, for: .normal)
        titleView.cityBtn.setTitle(self.selectCityModel?.city, for: .selected)
        
        requestPlaygroundData(nil)
    }
    
}

extension THPlaygroundVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playgroundModelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = playgroundModelArr[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "THPlaygroundCell") as? THPlaygroundCell
        if cell == nil {
            cell = THPlaygroundCell(style: .default, reuseIdentifier: "THPlaygroundCell")
        }
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
        THLoginController.instance.pushLoginVC {
            let model = self.playgroundModelArr[indexPath.row]
            let vc = THPlaygroundDetailVC()
            vc.playgroundModel = model
            self.navigationPushVC(vc: vc)
        }
    }
}



//  MARK: - class THPlaygroundTitleView
@objc protocol THPlaygroundTitleViewDelegate {
    
    func onClickTitleView(index: Int, isSelected: Bool)
}

class THPlaygroundTitleView: UIView {
    
    weak var delegate: THPlaygroundTitleViewDelegate?
    
    lazy var cityBtn: UIButton = {
        let button = UIButton()
        button.tag = 55
        button.setTitle("全国", for: .normal)
        button.setTitle("全国", for: .selected)
        button.setImage(UIImage(named: "down_arrow"), for: .normal)
        button.setImage(UIImage(named: "up_arrow"), for: .selected)
        button.setTitleColor(MAIN_COLOR, for: .normal)
        button.setTitleColor(MAIN_COLOR, for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()
    lazy var hotBtn: UIButton = {
        let button = UIButton()
        button.tag = 56
        button.isSelected = true
        button.setTitle("热度", for: .normal)
        button.setTitleColor(COLOR_333333, for: .normal)
        button.setTitleColor(MAIN_COLOR, for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()
    lazy var distanceBtn: UIButton = {
        let button = UIButton()
        button.tag = 57
        button.setTitle("距离", for: .normal)
        button.setTitleColor(COLOR_333333, for: .normal)
        button.setTitleColor(MAIN_COLOR, for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        configUI()
        configFrame()
        configData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        addSubview(cityBtn)
        addSubview(hotBtn)
        addSubview(distanceBtn)
    }
    
    func configFrame() {
        cityBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.width.equalTo(cityBtn)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        hotBtn.snp.makeConstraints { (make) in
            make.left.equalTo(cityBtn.snp_right).offset(20)
            make.width.equalTo(hotBtn)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        distanceBtn.snp.makeConstraints { (make) in
            make.left.equalTo(hotBtn.snp_right).offset(20)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.width.equalTo(distanceBtn)
        }
    }
    
    func configData() {
        
    }
    
    @objc func clickButtonEvent(sender: UIButton) {
        
        if sender.tag == 57 {
            THLoginController.instance.pushLoginVC {
                if sender.isSelected && sender.tag != 55 {
                    return
                }
                sender.isSelected = !sender.isSelected
                if sender.tag != 55 && self.cityBtn.isSelected {
                    self.cityBtn.isSelected = false
                    self.delegate?.onClickTitleView(index: self.cityBtn.tag - 55, isSelected: self.cityBtn.isSelected)
                }
                self.delegate?.onClickTitleView(index: sender.tag - 55, isSelected: sender.isSelected)
                self.cityBtn.layoutButtonWithEdgInsetStyle(.ImageRight, 5)
            }
        } else {
            if sender.isSelected && sender.tag != 55 {
                return
            }
            sender.isSelected = !sender.isSelected
            
            if sender.tag != 55 && cityBtn.isSelected {
                cityBtn.isSelected = false
                delegate?.onClickTitleView(index: cityBtn.tag - 55, isSelected: cityBtn.isSelected)
            }
            delegate?.onClickTitleView(index: sender.tag - 55, isSelected: sender.isSelected)
            cityBtn.layoutButtonWithEdgInsetStyle(.ImageRight, 5)
        }
        
        
    }
    
    func updateCityBtn(title: String) {
        cityBtn.setTitle(title, for: .selected)
        cityBtn.setTitle(title, for: .normal)
        
        cityBtn.layoutButtonWithEdgInsetStyle(.ImageRight, 5)
    }
    
    override func layoutSubviews() {
        cityBtn.layoutButtonWithEdgInsetStyle(.ImageRight, 5)
    }
}



@objc protocol THCityMenuViewDelegate {
    func cityMenuViewDidSelectRowAt(indexPath: IndexPath)
}

class THCityMenuView: UIView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    weak var delegate: THCityMenuViewDelegate?
    let bgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH*0.8))
    
    
    var modelArr = [THCityModel]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH*0.8), style: UITableView.Style.plain)
        tableView.estimatedRowHeight = SCREEN_HEIGHT
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    init() {
        super.init(frame: CGRect(x: 0, y: NAVIGATIONBAR_HEIGHT+0.5, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT))
        
        configUI()
        configFrame()
        addGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.2)
        addSubview(bgView)
        bgView.addSubview(tableView)
    }
    
    func configFrame() {
        
        bgView.addCorner(with: [.bottomLeft, .bottomRight], cornerSize: CGSize(width: 8, height: 8))
    }
    
    func updateCityList(modelArr: [THCityModel]) {
        self.modelArr = modelArr
        
        tableView.reloadData()
    }

    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        tap.delegate = self
        addGestureRecognizer(tap)
    }
    
    @objc func dismiss() {
        self.isHidden = true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.modelArr[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "THCityCell") as? THCityCell
        if cell == nil {
            cell = THCityCell(style: .default, reuseIdentifier: "THCityCell")
        }
        cell?.titleLabel.text = model.city
        let color = model.hasSelect ? MAIN_COLOR : COLOR_324057
        cell?.titleLabel.textColor = color
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
        self.delegate?.cityMenuViewDidSelectRowAt(indexPath: indexPath)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is THCityMenuView {
            return true
        }
        return false
    }
}
