//
//  THSettingVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/27.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import QMUIKit

class THSettingVC: THBaseTableViewVC {
    
    let titleArr = ["账号与安全", "允许3G/4G下播放视频", "清理缓存", "给球志打分"]
    
    lazy var logoutBtn: UIButton = {
        let button = UIButton()
        button.setTitle("退出登录", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = MAIN_COLOR
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickLogoutBtnEvent), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
        
        view.addSubview(logoutBtn)
        logoutBtn.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.height.equalTo(40)
            make.bottom.equalTo(-40)
        }
        logoutBtn.setCorner(cornerRadius: 4)
    }
    
    @objc func clickLogoutBtnEvent() {
        THLoginController.instance.logout()
    }
}

extension THSettingVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = titleArr[indexPath.row]
        
        if indexPath.row == 1 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "THSwitchCell") as? THSwitchCell
            if cell == nil {
                cell = THSwitchCell(style: .default, reuseIdentifier: "THSwitchCell")
            }
            cell?.titleLabel.text = title
            cell?.switchVlaueChangeBlock = { (isOn: Bool) in
                LocalStoreUtil.INSTANCE.saveWifiSwichStatus(value: isOn)
            }
            return cell!
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "THCommonCell") as? THCommonCell
        if cell == nil {
            cell = THCommonCell(style: .default, reuseIdentifier: "THCommonCell")
        }
        cell?.titleLabel.text = title
        if indexPath.row == 2 {
            cell?.arrowView.isHidden = true
            cell?.detailLabel.text = "\(fileSizeOfCache())M"
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = THAccountSafeVC()
            navigationPushVC(vc: vc)
        } else if indexPath.row == 2 {
            QMUITips.showLoading(in: view)
            clearCacheNow {
                QMUITips.hideAllTips()
                tableView.reloadData()
            }
        } else if indexPath.row == 3 {
            gotoAppStore(appId: "")
        }
    }
    
}
