//
//  THMyFocusVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/27.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THMyFocusVC: THBaseTableViewVC {

    var isFans: Bool?
    var dataArr = [THFansModel]()
    
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        configRefresh()
        
        let str = isFans ?? false ? "我的粉丝" : "我的关注"
        title = str
    }
    
    func configRefresh() {
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.headerRefreshing()
        })
        tableView.mj_header.beginRefreshing()
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.footerRefreshing()
        })
        tableView.mj_footer.ignoredScrollViewContentInsetBottom = isiPhoneX() ? 34 : 0
    }
    
    
    override func configData() {
        
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
    
    func requestData(completion: (()->Void)?) {
        
        let param = ["page": self.page]
        THMineRequestManager.requestMyFansOrConcernData(isFans: isFans ?? false, param: param, successBlock: { (result) in
            completion?()
            let modelArr = NSArray.yy_modelArray(with: THFansModel.self, json: result) as! [THFansModel]
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

extension THMyFocusVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "THFansCell") as? THFansCell
        if cell == nil {
            cell = THFansCell(style: .default, reuseIdentifier: "THFansCell")
        }
        cell?.facusBtn.isHidden = isFans ?? false
        cell?.titleLabel.text = model.username
        cell?.iconView.sd_setImage(with: URL(string: model.avatar ?? ""), completed: nil)
        return cell!
    }
}
