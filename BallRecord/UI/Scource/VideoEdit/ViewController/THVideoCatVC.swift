//
//  THVideoCatVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/17.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import QMUIKit

@objcMembers
class videoModel: NSObject {
    var startTime = "2019-12-25 16:20:04.945"   //  58804
    var endTime = "2019-12-25 18:08:23.843" //65303
    var duration = 6499.0
}

class CatVideoModel: NSObject {
    var videoName: String = ""
    ///  剪切临时Temp路径
    var tempVideoPath: String = ""
    var coverImage: UIImage?
    var coverImgData: Data?
    ///  保存Document后的路径 (相对路径，需拼接沙盒目录，因为二次安装app沙盒目录会变)
    var videoPath: String = ""
}

class THVideoCatVC: THBaseVC {
    
    let videoPath = "https://xy2.v.netease.com/r/video/20190110/bea8e70d-ffc0-4433-b250-0393cff10b75.mp4" //"https://1252068037.vod2.myqcloud.com/46d0b624vodcq1252068037/aee3f0db5285890797118433949/XaYvA7egCYUA.mp4"
    let videoBox = WAVideoBox()//   视频处理类
    
    var catVideoArr = [CatVideoModel]()
    
    let videoView = UIView()
    
    let videoPartView = THVideoPartView()
    let dateSelectView = THDateSelectView()
    let sweetRuler = SweetRuler(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 120))

    
    lazy var player: SJVideoPlayer = {
        let player = SJVideoPlayer()
        player.showMoreItemToTopControlLayer = false
        player.rotationManager.isDisabledAutorotation = true
        return player
    }()
    
    lazy var catBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = MAIN_COLOR
        button.setTitle("截取10秒", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        configFrame()
        configData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let url = URL(string: videoPath) {
            let asset = SJVideoPlayerURLAsset(url: url)
            player.urlAsset = asset;
        }
        
        self.videoPartView.updateDataSource()
    }

}

extension THVideoCatVC {
    
    func configUI() {
        title = "视频截取"
        
        view.addSubview(sweetRuler)
        sweetRuler.delegate = self
        
        view.addSubview(videoView)
        view.addSubview(dateSelectView)
        view.addSubview(videoPartView)
        view.addSubview(catBtn)
        videoView.addSubview(player.view)
        videoPartView.hiddenDelete = true
        
        addRightItem()
        configPlayer()
    }
    
    func addRightItem() {
        let item1 = UIBarButtonItem(title: "下一步", style: .plain, target: self, action: #selector(clickNextItem))
        item1.tintColor = MAIN_COLOR
        navigationItem.rightBarButtonItem = item1
    }
    
    func configPlayer() {
        player.defaultLoadFailedControlLayer.topContainerView.isHidden = true
        player.defaultEdgeControlLayer.topContainerView.isHidden = true
//        player.defaultEdgeControlLayer.bottomAdapter.removeItem(forTag: SJEdgeControlLayerBottomItem_FullBtn)
        player.defaultEdgeControlLayer.bottomAdapter.removeItem(forTag: SJEdgeControlLayerBottomItem_Separator)
        player.defaultEdgeControlLayer.bottomAdapter.exchangeItem(forTag: SJEdgeControlLayerBottomItem_DurationTime, withItemForTag: SJEdgeControlLayerBottomItem_Progress)
        let durationItem = player.defaultEdgeControlLayer.bottomAdapter.item(forTag: SJEdgeControlLayerBottomItem_DurationTime)
        durationItem?.insets = SJEdgeInsetsMake(8, 16)
        player.defaultEdgeControlLayer.bottomAdapter.reload()
    }
    
    
    func configFrame() {
        
        videoView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(200)
            make.top.equalTo(self.view)
        }
        
        dateSelectView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(videoView.snp_bottom).offset(20)
            make.height.equalTo(30)
        }
        
        videoPartView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(videoPartView.height)
            make.bottom.equalTo(self.view)
        }
        
        player.view.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        catBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(230)
            make.height.equalTo(40)
            make.bottom.equalTo(videoPartView.snp_top).offset(-30)
        }
        catBtn.setCorner(cornerRadius: 2)
        
        sweetRuler.top = 200 + 70
    }
    
    func configData() {
        let model2 = videoModel()
        model2.startTime = "2019-12-25 18:20:04.945"
        model2.endTime = "2019-12-25 18:33:23.843"
        model2.duration = 799.0
        
        let arr = [videoModel(), model2]
        
        let firstModel = arr.first
        let lastModel = arr.last
        
        let sting1 = firstModel?.startTime.components(separatedBy: " ").last ?? "00:00"
        let time1 = (sting1.components(separatedBy: ":").first! as NSString).intValue
        let beginTime = sting1.components(separatedBy: ".").first! as NSString
        
        let sting2 = lastModel?.endTime.components(separatedBy: " ").last ?? "24:00"
        let time2 = (sting2.components(separatedBy: ":").first! as NSString).intValue + 1
        
        sweetRuler.figureRange = Range(uncheckedBounds: (Int(time1 * 3600), Int(time2 * 3600)))
        sweetRuler.setSelectFigure(figure: getSecondFromHHMMSS(HHMMSS: beginTime as String))
        sweetRuler.setContentArr(arr: arr)
    }
    
    @objc func clickNextItem() {
        if THVideoCacheManager.INSTANCE.catVideoArr.count > 0 {
            player.pause()
            navigationPushVC(vc: THVideoEditVC())
        } else {
            QMUITips.show(withText: "请先截取一段视频")
        }
    }
    
    @objc func clickButtonEvent(sender: UIButton) {
        
        QMUITips.showLoading(in: view)
        
        if !FileManager.default.fileExists(atPath: DownloadVideoPath) {
            try? FileManager.default.createDirectory(atPath: DownloadVideoPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let videoId = dateFormatter.string(from: Date())
        let catVideoPath = DownloadVideoPath + "/" + "\(videoId).mp4"
        
        player.export(withBeginTime: player.currentTime, duration: 10, presetName: AVAssetExportPresetMediumQuality, progress: { (player, process) in
            print("---- %.2f%", process * 100)
        }, completion: { (player, savePath, coverImg) in
            QMUITips.hideAllTips()
            print("视频剪切 success savePath: %@", savePath)
            copyItemAtPath(fromPath: savePath.path, toPath: catVideoPath)
            
            let model = CatVideoModel()
            model.videoName = "\(videoId).mp4"
            model.tempVideoPath = catVideoPath
            model.coverImage = coverImg
            THVideoCacheManager.INSTANCE.catVideoArr.append(model)
            
            self.videoPartView.updateDataSource()
            
        }) { (player, error) in
            QMUITips.hideAllTips()
            print("视频剪切 error: %@", error)
        }
        
    }
    
    override func goBackItemClicked() {
        if THVideoCacheManager.INSTANCE.catVideoArr.count > 0 {
            let alert = UIAlertController(title: "确定要退出吗？", message: "退出后,剪辑的视频将不可恢复", preferredStyle: .alert)
            let sure = UIAlertAction(title: "确定", style: .default) { (action) in
                THVideoCacheManager.INSTANCE.clearVideoPart()
                super.goBackItemClicked()
            }
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(sure)
            present(alert, animated: true, completion: nil)
        } else {
            super.goBackItemClicked()
        }
    }
}

extension THVideoCatVC: SweetRulerDelegate {
    
    ///刻度尺代理方法
    func sweetRuler(ruler: SweetRuler, figure: Int){
        
        print("\t\tfigure: \(figure)")
    }

}

