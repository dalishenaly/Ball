//
//  THPlayRecordVC.swift
//  BallRecord
//
//  Created by 买超 on 2020/1/7.
//  Copyright © 2020 maichao. All rights reserved.
//  打球记录

import UIKit

class THPlayRecordVC: THBaseTableViewVC {

    var dataArr = [THDynamicModel]()
    var page = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "打球记录"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        configRefresh()
    }
    
    
    func configRefresh() {
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.headerRefreshing()
        })
        tableView.mj_header.beginRefreshing()
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.footerRefreshing()
        })
    }
    
    func headerRefreshing() {
        page = 0
        requestData {
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.resetNoMoreData()
        }
    }
    
    func footerRefreshing() {
        page += 1
        requestData {
            self.tableView.mj_footer.endRefreshing()
        }
    }

    func requestData(_ completion: (()->Void)?) {
        
        let param = ["page": page]
        THMineRequestManager.requestMyBasketballRecord(param: param, successBlock: { (result) in
            completion?()
            
            let modelArr = NSArray.yy_modelArray(with: THDynamicModel.self, json: result) as? [THDynamicModel] ?? [THDynamicModel]()
            if self.page == 0 {
                self.dataArr.removeAll()
            }
            if modelArr.count <= 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            
            self.dataArr += modelArr
            self.tableView.reloadData()
            
        }) { (error) in
            completion?()
            
        }
    }
}


extension THPlayRecordVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "THRoughCell") as? THRoughCell
        if cell == nil {
            cell = THRoughCell(style: .default, reuseIdentifier: "THRoughCell")
        }
        cell?.updateRecord(model: model)
        cell?.deleteBtn.isHidden = true
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataArr[indexPath.row]
        let vc = THRecordPublishVC()
        vc.aliVideoId = model.vUrl
        navigationPushVC(vc: vc)
    }
}
