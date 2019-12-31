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
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let draftModel = drafts[indexPath.row]
        let vc = THVideoEditVC()
        vc.draftModel = draftModel
        navigationPushVC(vc: vc)
        
    }
}
