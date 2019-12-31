//
//  THMyNewsVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/27.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

struct THMyNewsModel {
    var iconName = ""
    var title = ""
}
class THMyNewsVC: THBaseTableViewVC {
    
    let titleArr = [THMyNewsModel(iconName: "pinglun_icon", title: "评论"),
                    THMyNewsModel(iconName: "dianzan_icon", title: "点赞"),
                    THMyNewsModel(iconName: "xitongxiaoxi_icon", title: "系统")]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "消息"
    }

}

extension THMyNewsVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = titleArr[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "THIconCell") as? THIconCell
        if cell == nil {
            cell = THIconCell(style: .default, reuseIdentifier: "THIconCell")
        }
        cell?.titleLabel.text = model.title
        cell?.iconView.image = UIImage(named: model.iconName)
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let vc = THCommentVC()
            navigationPushVC(vc: vc)
        } else if indexPath.row == 1 {
            let vc = THLikeVC()
            navigationPushVC(vc: vc)
        } else {
            let vc = THSystemNewsVC()
            navigationPushVC(vc: vc)
        }
        
    }
}
