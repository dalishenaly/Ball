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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.backgroundColor = UIColor.white
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
        
    }
    
    func configUI() {
        
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
    
    func configData() {
        
    }
    
}

extension THPlaygroundVC: THPlaygroundTitleViewDelegate, THCityMenuViewDelegate {
    
    func onClickTitleView(index: Int, isSelected: Bool) {
        
        if index == 0 {
            cityMenuView.isHidden = !cityMenuView.isHidden
        } else {
            
        }
        
    }
    
    func cityMenuViewDidSelectRowAt(indexPath: IndexPath) {
        
    }
    
}

extension THPlaygroundVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "THPlaygroundCell") as? THPlaygroundCell
        if cell == nil {
            cell = THPlaygroundCell(style: .default, reuseIdentifier: "THPlaygroundCell")
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
        let vc = THPlaygroundDetailVC()
        navigationPushVC(vc: vc)
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
        button.setTitle("呼和浩特市", for: .selected)
        button.setImage(UIImage(named: "down_arrow"), for: .normal)
        button.setImage(UIImage(named: "up_arrow"), for: .selected)
        button.setTitleColor(COLOR_333333, for: .normal)
        button.setTitleColor(MAIN_COLOR, for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()
    lazy var recentBtn: UIButton = {
        let button = UIButton()
        button.tag = 56
        button.setTitle("热度", for: .normal)
        button.setTitleColor(COLOR_333333, for: .normal)
        button.setTitleColor(MAIN_COLOR, for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()
    lazy var facusBtn: UIButton = {
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
        addSubview(recentBtn)
        addSubview(facusBtn)
    }
    
    func configFrame() {
        cityBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.width.equalTo(cityBtn)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        recentBtn.snp.makeConstraints { (make) in
            make.left.equalTo(cityBtn.snp_right).offset(20)
            make.width.equalTo(recentBtn)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        facusBtn.snp.makeConstraints { (make) in
            make.left.equalTo(recentBtn.snp_right).offset(20)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.width.equalTo(facusBtn)
        }
    }
    
    func configData() {
        
    }
    
    @objc func clickButtonEvent(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.tag != 55 && cityBtn.isSelected {
            cityBtn.isSelected = false
            delegate?.onClickTitleView(index: cityBtn.tag - 55, isSelected: cityBtn.isSelected)
        }
        delegate?.onClickTitleView(index: sender.tag - 55, isSelected: sender.isSelected)
        cityBtn.layoutButtonWithEdgInsetStyle(.ImageRight, 5)
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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH*0.8), style: UITableView.Style.plain)
        tableView.estimatedRowHeight = SCREEN_HEIGHT
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        tableView.backgroundColor = UIColor.white
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

    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        tap.delegate = self
        addGestureRecognizer(tap)
    }
    
    @objc func dismiss() {
        self.isHidden = true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "THCityCell") as? THCityCell
        if cell == nil {
            cell = THCityCell(style: .default, reuseIdentifier: "THCityCell")
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
        delegate?.cityMenuViewDidSelectRowAt(indexPath: indexPath)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is THCityMenuView {
            return true
        }
        return false
    }
}
