//
//  THSystemNewsVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/29.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THSystemNewsVC: THBaseTableViewVC {

    var dataArr = [THDialogNewsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "系统消息"
        tableView.separatorStyle = .none
    }
    
    override func configData() {
        
        THMineRequestManager.requestSystemNewsData(param: [:], successBlock: { (result) in
            self.dataArr = NSArray.yy_modelArray(with: THDialogNewsModel.self, json: result) as? [THDialogNewsModel] ?? [THDialogNewsModel]()
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }

}

extension THSystemNewsVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "THSystemDialogCell") as? THSystemDialogCell
        if cell == nil {
            cell = THSystemDialogCell(style: .default, reuseIdentifier: "THSystemDialogCell")
        }
        cell?.titleLabel.text = model.content
        
        return cell!
    }
}
