//
//  THRoughVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/27.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THRoughVC: THBaseTableViewVC {

    var drafts = [THVideoDraftModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "草稿箱"

        drafts = THVideoDraftModel.getLocalDraftModels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        drafts = THVideoDraftModel.getLocalDraftModels()
        tableView.reloadData()
    }

}


extension THRoughVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drafts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = drafts[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "THRoughCell") as? THRoughCell
        if cell == nil {
            cell = THRoughCell(style: .default, reuseIdentifier: "THRoughCell")
        }
        cell?.updateData(model: model)
        cell?.deleteBlock = {
            let alert = UIAlertController(title: "确定要删除吗？", message: "删除后,视频将不可恢复", preferredStyle: .alert)
            let sure = UIAlertAction(title: "确定", style: .default) { (action) in
                model.removeDraft()
                self.drafts = THVideoDraftModel.getLocalDraftModels()
                tableView.reloadData()
            }
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(sure)
            self.present(alert, animated: true, completion: nil)
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let draftModel = drafts[indexPath.row]
        let vc = THVideoEditVC()
        vc.fromDraft = true
        vc.draftModel = draftModel
        navigationPushVC(vc: vc)
    }
}
