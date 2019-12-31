//
//  THSystemNewsVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/29.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THSystemNewsVC: THBaseTableViewVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
    }

}

extension THSystemNewsVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 1{
            var cell = tableView.dequeueReusableCell(withIdentifier: "THMineDialogCell") as? THMineDialogCell
            if cell == nil {
                cell = THMineDialogCell(style: .default, reuseIdentifier: "THMineDialogCell")
            }
            return cell!
        }
        var cell = tableView.dequeueReusableCell(withIdentifier: "THSystemDialogCell") as? THSystemDialogCell
        if cell == nil {
            cell = THSystemDialogCell(style: .default, reuseIdentifier: "THSystemDialogCell")
        }
        return cell!
    }
}
