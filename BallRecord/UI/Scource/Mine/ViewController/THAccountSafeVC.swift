//
//  THAccountSafeVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/28.
//  Copyright © 2019 maichao. All rights reserved.
//  账户与安全

import UIKit
import QMUIKit

class THAccountSafeVC: THBaseTableViewVC {

    var dataArr = [[PersonalModel(title: "手机号"),
                     PersonalModel(title: "设置密码")],
                    [PersonalModel(title: "去绑定")]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "账户与安全"
        
        let phoneModel = PersonalModel(title: "手机号")
        if THLoginController.instance.hasLogin ?? false {
            phoneModel.content = "phone"
        }
        
        let pwdModel = PersonalModel(title: "设置密码")
        let bindModel = PersonalModel(title: "去绑定", content: "去绑定")
        if THLoginController.instance.hasBind ?? false {
            bindModel.content = "已绑定"
        }
        
        dataArr = [[phoneModel, pwdModel], [bindModel]]
        
        tableView.reloadData()
    }

}

extension THAccountSafeVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = dataArr[section]
        return  arr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arr = dataArr[indexPath.section]
        let model = arr[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "THCommonCell") as? THCommonCell
        if cell == nil {
            cell = THCommonCell(style: .default, reuseIdentifier: "THCommonCell")
        }
        cell?.titleLabel.text = model.title
        cell?.detailLabel.text = model.content
        if indexPath.row == 0 {
            cell?.arrowView.isHidden = true
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 30))
            let label = UILabel(frame: CGRect(x: 16, y: 0, width: SCREEN_WIDTH, height: 30))
            label.text = "第三方"
            view.addSubview(label)
            return view
        }
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 30
        }
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arr = dataArr[indexPath.section]
        let model = arr[indexPath.row]
        
        if model.title == "设置密码" {
            let vc = THResetPasswordVC()
            navigationPushVC(vc: vc)
        }
        
        if model.title == "去绑定" {
            THBindAlert.show { (state: SSDKResponseState, user: SSDKUser?) in
                if state == .success {
                    
                    var platform = ""
                    if user?.platformType == SSDKPlatformType.typeWechat {
                        platform = "wechat"
                    } else if user?.platformType == SSDKPlatformType.typeQQ {
                        platform = "qq"
                    } else {
                        platform = "weibo"
                    }
                    let param = ["openid": user?.uid, "nickname": user?.nickname, "avatar": user?.icon, "type": platform]
                    
                    
                    model.content = "已绑定"
                    tableView.reloadData()
                    QMUITips.show(withText: "绑定成功！")
                } else {
                    QMUITips.show(withText: "绑定失败！")
                }
            }
        }
    }
}
