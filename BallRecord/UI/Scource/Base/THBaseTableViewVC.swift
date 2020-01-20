//
//  THBaseTableViewVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/27.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THBaseTableViewVC: THBaseVC {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0.5))
//        view.backgroundColor = COLOR_LINE
        tableView.tableFooterView = UIView(frame: CGRect.zero)//view
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

}

extension THBaseTableViewVC {
    @objc func configUI() {
        view.addSubview(tableView)
    }
    
    @objc func configFrame() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
//            make.bottom.equalTo(bottomLayoutGuide.snp.bottom)
        }
    }
    
    @objc func configData() {
        
    }
}

extension THBaseTableViewVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
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
