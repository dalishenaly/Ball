//
//  THLikeVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/29.
//  Copyright © 2019 maichao. All rights reserved.
//  点赞列表VC

import UIKit

class THPraiseNewsVC: THBaseTableViewVC {

    var dataArr = [THPraiseNewsModel]()
    
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "点赞"
        configRefresh()
    }
    
    func configRefresh() {
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.headerRefreshing()
        })
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.footerRefreshing()
        })
        tableView.mj_footer.ignoredScrollViewContentInsetBottom = isiPhoneX() ? 34 : 0
    }
    
    
    override func configData() {
        requestData(completion: nil)
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
        let param = ["page": page]
        THMineRequestManager.requestMyPraiseData(param: param, successBlock: { (result) in
            completion?()
            let modelArr = NSArray.yy_modelArray(with: THPraiseNewsModel.self, json: result) as? [THPraiseNewsModel] ?? []
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

extension THPraiseNewsVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "THCommentNewsCell") as? THCommentNewsCell
        if cell == nil {
            cell = THCommentNewsCell(style: .default, reuseIdentifier: "THCommentNewsCell")
        }
        cell?.updateModel(model: model)
        cell?.replyBtn.isHidden = true
        return cell!
    }
    
    
}
