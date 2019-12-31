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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension THMyFocusVC {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "THFansCell") as? THFansCell
        if cell == nil {
            cell = THFansCell(style: .default, reuseIdentifier: "THFansCell")
        }
        cell?.facusBtn.isHidden = isFans ?? false
        return cell!
    }
}
