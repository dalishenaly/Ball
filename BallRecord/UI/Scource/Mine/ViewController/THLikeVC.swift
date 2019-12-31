//
//  THLikeVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/29.
//  Copyright © 2019 maichao. All rights reserved.
//  点赞列表VC

import UIKit

class THLikeVC: THBaseTableViewVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension THLikeVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "THCommentNewsCell") as? THCommentNewsCell
        if cell == nil {
            cell = THCommentNewsCell(style: .default, reuseIdentifier: "THCommentNewsCell")
        }
        return cell!
    }
}
