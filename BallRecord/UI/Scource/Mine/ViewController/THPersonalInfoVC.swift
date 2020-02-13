//
//  THPersonalInfoVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/28.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class PersonalModel: NSObject {
    var title: String?
    var content: String = ""
    var key: String?
    init(title: String?, key: String?) {
        super.init()
        self.key = key
        self.title = title
    }
    
    init(title: String?) {
        super.init()
        self.title = title
    }
    
    init(title: String?, content: String?) {
        super.init()
        self.title = title
        self.content = content ?? ""
    }
}


class THPersonalInfoVC: THBaseTableViewVC {
    
    var shouldEdit: Bool?
    
    var rightItem: UIBarButtonItem?
    
    let dataArr = [[PersonalModel(title: "头像", key: "avatar"),
                     PersonalModel(title: "昵称", key: "username"),
                     PersonalModel(title: "性别", key: "sex")],
                    [PersonalModel(title: "所在地", key: "address"),
                     PersonalModel(title: "签名", key: "signature")]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "个人信息"
        rightItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(clickRightItem(item:)))
        navigationItem.rightBarButtonItem = rightItem

    }
    
    override func configData() {
        super.configData()
        
        if let model = THLoginController.instance.userInfo {
            let dict = model.yy_modelToJSONObject() as! [String: Any]
            let arr = self.dataArr.flatMap{$0}
            for item in arr {
                if let key = item.key, key != "" {
                    item.content = dict[key] as! String
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func savePersonalInfo() {
        var param = [String: String]()
        let arr = dataArr.flatMap{$0}
        for item in arr {
            if let key = item.key, key != "" {
                param[key] = item.content
            }
        }
        QMUITips.showLoading(in: view)
        THMineRequestManager.requestEditUserInfo(param: param, successBlock: { (result) in
            QMUITips.hideAllTips()
            QMUITips.show(withText: "保存成功")
            self.shouldEdit = false
            self.tableView.reloadData()
        }) { (error) in
            QMUITips.hideAllTips()
            QMUITips.show(withText: error.localizedDescription)
        }
    }
}

extension THPersonalInfoVC {
    
    @objc func clickRightItem(item: UIBarButtonItem) {
        if item.title == "编辑" {
            item.title = "保存"
            shouldEdit = true
            tableView.reloadData()
        } else {
            item.title = "编辑"
            savePersonalInfo()
        }
    }
    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let type: String = info[UIImagePickerController.InfoKey.mediaType] as! String
        //当选择的类型是图片
        if type == "public.image" {
            //获得照片
            let image: UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let timeInterval:TimeInterval = NSDate().timeIntervalSince1970
            let name = "qzImage" + "\(timeInterval).jpg"
            THBaseNetworkManager.shared(subUrl: "/api/upload").uploadImage(imageData: image.pngData()!, fileName: name, successBlock: { (result) in
                
                let dict = result as? [String: String]
                let url = dict?["url"] ?? ""
                
                let arr = self.dataArr[0]
                let model = arr[0]
                model.content = url
                self.tableView.reloadData()
                
                print("=====")
            }) { (error) in
                
                print("=====")
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension THPersonalInfoVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = dataArr[section]
        return arr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arr = dataArr[indexPath.section]
        let model = arr[indexPath.row]
        
        if model.title == "头像" {
            var cell = tableView.dequeueReusableCell(withIdentifier: "THPersonalHeaderCell") as? THPersonalHeaderCell
            if cell == nil {
                cell = THPersonalHeaderCell(style: .default, reuseIdentifier: "THPersonalHeaderCell")
            }
            cell?.titleLabel.text = model.title
            cell?.iconView.setImage(urlStr: model.content, placeholder: placeholder_header)
            cell?.clickIconBlock = {
                self.openMenu()
            }
            cell?.iconView.isUserInteractionEnabled = shouldEdit ?? false
            return cell!
        }
        
        if model.title == "昵称" || model.title == "签名" {
            var cell = tableView.dequeueReusableCell(withIdentifier: "THInfoEditCell") as? THInfoEditCell
            if cell == nil {
                cell = THInfoEditCell(style: .default, reuseIdentifier: "THInfoEditCell")
            }
            
            cell?.titleLabel.text = model.title
            cell?.textField.text = model.content
            cell?.textField.isEnabled = shouldEdit ?? false
            cell?.textField.maximumTextLength = model.title == "昵称" ? 6 : 18
            if model.title == "签名" {
                cell?.textField.placeholder = "请输入18个字来介绍自己"
            }
            
            cell?.valueChangedBlock = { (text: String) in
                model.content = text
            }
            return cell!
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "THCommonCell") as? THCommonCell
        if cell == nil {
            cell = THCommonCell(style: .default, reuseIdentifier: "THCommonCell")
        }
        cell?.titleLabel.text = model.title
        if model.title == "性别" {
            cell?.detailLabel.text = model.content == "0" ? "男" : "女"
        } else {
            cell?.detailLabel.text = model.content
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        }
        return 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shouldEdit ?? false {
            let arr = dataArr[indexPath.section]
            let model = arr[indexPath.row]
            if model.title == "性别" {
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let man = UIAlertAction(title: "男", style: .default) { (action: UIAlertAction) in
                    model.content = "1"
                    tableView.reloadData()
                }
                let woman = UIAlertAction(title: "女", style: .default) { (action: UIAlertAction) in
                    model.content = "2"
                    tableView.reloadData()
                }
                let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                alert.addAction(man)
                alert.addAction(woman)
                alert.addAction(cancel)
                present(alert, animated: true, completion: nil)
            }
            if model.title == "所在地" {
                let vc = THCitySelectVC()
                vc.cityType = .province
                vc.citySelectBlock = { city in
                    model.content = city
                    tableView.reloadData()
                }
                navigationPushVC(vc: vc)
            }
        }
    }
}
