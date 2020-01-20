//
//  THSelectMusicAlert.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/18.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

struct musicTypeModel {
    var iconName: String?
    var titleName: String?
}

@objcMembers
class musicModel: NSObject {
    
    var titleName: String = ""
    var url: String = "http://ball.moonsky.cn/sanshi.mp3"
    /// bgm下载临时Temp目录下的路径
    var musicTempPath: String = ""
    /// bgm保存在Document目录下的路径 (相对路径，需拼接沙盒目录，因为二次安装app沙盒目录会变)
    var musicPath: String = ""
    var hasDownload: Bool = false
    
    init(titleName: String) {
        super.init()
        self.titleName = titleName
    }
}

class THSelectMusicAlert: UIView {

    var sureBlock: ((_ musicPath: String)->Void)?
    var selectedMusicTypeCell: THMusicTypeCell?
    var selectedMusicCell: THMusicCell?
    var selectedMusicTypeIdx: Int = 0
    
    let musicTypeArr = [musicTypeModel(iconName: "jingdan_icon", titleName: "经典"),
                        musicTypeModel(iconName: "donggan_icon", titleName: "动感"),
                        musicTypeModel(iconName: "kaixin_icon", titleName: "开心"),
                        musicTypeModel(iconName: "beishang_icon", titleName: "悲伤")]
    
    let musicArr = [[musicModel(titleName: "快乐1")],
                    [musicModel(titleName: "动感1"), musicModel(titleName: "动感2")],
                    [musicModel(titleName: "开心1"), musicModel(titleName: "开心2")],
                    [musicModel(titleName: "悲伤1"), musicModel(titleName: "悲伤2"), musicModel(titleName: "悲伤3")]]
    
    
    var bgmArr = [THBGMTypeModel]()
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        
        
        configUI()
        configFrame()
    }
    
    func configUI() {
        if #available(iOS 11.0, *) {
            contentView.layer.cornerRadius = 18
            contentView.layer.maskedCorners = CACornerMask(arrayLiteral: [CACornerMask.layerMinXMinYCorner, CACornerMask.layerMaxXMinYCorner])
        } else {
            contentView.addCorner(with: [.topRight, .topLeft], cornerSize: CGSize(width: 18, height: 18))
        }
        
        topCollectionView.qmui_borderColor = COLOR_LINE;
        topCollectionView.qmui_borderWidth = 1
        topCollectionView.qmui_borderPosition = [.top, .bottom]
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: topCollectionView.height)
        topCollectionView.collectionViewLayout = layout
        topCollectionView.register(THMusicTypeCell.self, forCellWithReuseIdentifier: "THMusicTypeCell")
        topCollectionView.showsHorizontalScrollIndicator = false
        
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false

    }
    
    func configFrame() {
        
        topCollectionView.reloadData()
        tableView.reloadData()
    }
    
    func updateBGMList(arr: [THBGMTypeModel]) {
        self.bgmArr = arr
        self.topCollectionView.reloadData()
        self.tableView.reloadData()
    }
    
    @IBAction func clickSureEvent(_ sender: Any) {
        
        if let musicModel = selectedMusicCell?.model {
            sureBlock?(musicModel.musicTempPath ?? "")
            dismiss()
        } else {
            QMUITips.show(withText: "请选择音乐")
        }
    }
    
    @IBAction func clickCancelBtn(_ sender: Any) {
        dismiss()
    }
    
    override func draw(_ rect: CGRect) {
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
    }
    
    @discardableResult class func show(arr: [THBGMTypeModel]) -> THSelectMusicAlert {
        let alert = THSelectMusicAlert.loadNib()
        alert.updateBGMList(arr: arr)
        if let window = UIApplication.shared.delegate?.window {
            window?.addSubview(alert)
        }
        return alert
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    

}

extension THSelectMusicAlert: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bgmArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = self.bgmArr[indexPath.item]
        let cell:THMusicTypeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "THMusicTypeCell", for: indexPath) as! THMusicTypeCell
        
        var iconName = "jingdan_icon"
        if model.audioType == "动感" {
            iconName = "donggan_icon"
        } else if model.audioType == "开心" {
            iconName = "kaixin_icon"
        } else if model.audioType == "悲伤" {
            iconName = "beishang_icon"
        }
        
        cell.iconView.image = UIImage(named: iconName)
        cell.titleLabel.text = model.audioType
        
        if self.selectedMusicTypeCell == nil {
            if indexPath.item == 0 {
                cell.changeBackgroundColor(selected: true)
                self.selectedMusicTypeCell = cell
            } else {
                cell.changeBackgroundColor(selected: false)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedMusicTypeCell?.changeBackgroundColor(selected: false)
        let cell = collectionView.cellForItem(at: indexPath) as? THMusicTypeCell
        cell?.changeBackgroundColor(selected: true)
        self.selectedMusicTypeCell = cell
        self.selectedMusicTypeIdx = indexPath.item
        tableView.reloadData()
    }
    
}

extension THSelectMusicAlert: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.bgmArr.count == 0 {
            return 0
        }
        let model = self.bgmArr[selectedMusicTypeIdx]
        return model.subList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let typeModel = self.bgmArr[selectedMusicTypeIdx]
        let model = typeModel.subList![indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "THMusicCell") as? THMusicCell
        if cell == nil {
            cell = THMusicCell(style: .default, reuseIdentifier: "THMusicCell")
        }
        cell?.reloadBlock = {
            tableView.reloadData()
        }
        cell?.updateModel(model: model)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let typeModel = self.bgmArr[selectedMusicTypeIdx]
        let model = typeModel.subList![indexPath.row]
        if model.hasDownload ?? false {
            selectedMusicCell?.updateSeletStatus(selected: false)
            let cell = tableView.cellForRow(at: indexPath) as? THMusicCell
            cell?.updateSeletStatus(selected: true)
            selectedMusicCell = cell
        }
    }
    
}
