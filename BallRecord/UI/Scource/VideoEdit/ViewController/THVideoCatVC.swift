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
class CatVideoModel: NSObject {
    var videoName: String = ""
    var coverImage: UIImage?
    var coverImgData: Data?
    ///  剪切临时Temp路径
    var tempVideoPath: String = ""
    ///  保存Document后的路径 (相对路径，需拼接沙盒目录，因为二次安装app沙盒目录会变)
    var videoPath: String = ""
}

class THVideoCatVC: THBaseVC {
    
    let videoPath = "https://dhxy.v.netease.com/2019/0814/5757db881a2aff4543b7d9c846f3f415qt.mp4"//"https://xy2.v.netease.com/r/video/20190110/bea8e70d-ffc0-4433-b250-0393cff10b75.mp4" //"https://1252068037.vod2.myqcloud.com/46d0b624vodcq1252068037/aee3f0db5285890797118433949/XaYvA7egCYUA.mp4"
    let videoBox = WAVideoBox()//   视频处理类
    
    var cid: String?
    var cvid: String?
    var selectTimeId: String?
    var currentVideoBeginTime: Int?
    var currentVideoUrl: String?
    
    var catVideoArr = [CatVideoModel]()
    
    var model: THVideoInterceptModel?
    var catVideModel: THCatVideoModel?
    
    let videoView = UIView()
    
    let videoPartView = THVideoPartView()
    let dateSelectView = THDateSelectView()
    let sweetRuler = SweetRuler(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 120))

    
    lazy var player: SJVideoPlayer = {
        let player = SJVideoPlayer()
        player.showMoreItemToTopControlLayer = false
        player.rotationManager.isDisabledAutorotation = true
        player.defaultNotReachableControlLayer.delegate = self
        player.isEnabledFilmEditing = false
        return player
    }()
    
    lazy var catBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = MAIN_COLOR
        button.setTitle("截取15秒", for: .normal)
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
        
        if LocalStoreUtil.INSTANCE.getWifiSwichStatus() || THReachability.INSTANCE.net?.isReachableOnEthernetOrWiFi ?? false {
            requestData(timeId: nil)
        } else {
            if THReachability.INSTANCE.net?.isReachable ?? false {
                let alert = UIAlertController(title: "您正在使用移动网络", message: "继续观看会耗费流量", preferredStyle: .alert)
                let sure = UIAlertAction(title: "继续观看", style: .default) { (action) in
                    self.requestData(timeId: nil)
                }
                let cancel = UIAlertAction(title: "取消观看", style: .cancel) { (action) in
                    self.player.defaultNotReachableControlLayer.promptLabel.isHidden = true
                    self.player.defaultNotReachableControlLayer.reloadView.button.setTitle("继续观看", for: .normal)
                    self.player.switcher.switchControlLayer(forIdentitfier: SJControlLayer_NotReachableAndPlaybackStalled)
                    self.player.controlLayerNeedAppear()
                }
                alert.addAction(cancel)
                alert.addAction(sure)
                present(alert, animated: true, completion: nil)
            } else {
                QMUITips.show(withText: "当前网络不可用")
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.vc_viewDidAppear()
        self.videoPartView.updateDataSource()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.vc_viewWillDisappear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player.vc_viewDidDisappear()
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
        dateSelectView.delegate = self
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
        
        let shareItem = SJEdgeControlButtonItem(image: UIImage(named: "share_icon"), target: self, action: #selector(clickShareBtnEvent), tag: 77)
        player.defaultEdgeControlLayer.topAdapter.add(shareItem)
        player.defaultEdgeControlLayer.topAdapter.reload()
        player.playbackObserver.currentTimeDidChangeExeBlock = { (player: SJBaseVideoPlayer) in
            let currentSecond = Int(player.currentTime) + (self.currentVideoBeginTime ?? self.sweetRuler.figureRange.lowerBound)
            self.sweetRuler.setSelectFigure(figure: currentSecond)
        }
    }
    
    
    func configFrame() {
        let videoHeight = self.view.bounds.size.width/16*9
       videoView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(videoHeight)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        player.view.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        sweetRuler.top = 200 + 70
        catBtn.snp.makeConstraints { (make) in
            make.top.equalTo(sweetRuler.snp_bottom).offset(40);
            make.left.equalTo(26)
            make.right.equalTo(-26)
            make.height.equalTo(40)
        }
        catBtn.setCorner(cornerRadius: 20)

    }
    
    
    func requestData(timeId: String?) {
        let param = ["cid": self.cid ?? "", "cvid": self.cvid ?? "", "timeId": timeId ?? ""]
        THPlaygroundManager.requestPlaygroundVideoIntercept(param: param, successBlock: { (result) in
            print(result)
            self.model = THVideoInterceptModel.yy_model(withJSON: result)
            self.dateSelectView.updateDate(arr: self.model?.itemList ?? [])
            self.dateSelectView.timeLabel.text = self.model?.correntTime
            let timeModel = self.model?.itemList?.last
            let arr = NSArray.yy_modelArray(with: THCatVideoModel.self, json: self.model?.videoList?[timeModel?.timeId ?? ""]) as? [THCatVideoModel] ?? []
            self.catVideModel = arr.last
            
            self.requestVideoUrl()
            self.updateRulerData()
            
        }) { (error) in
            print(error)
        }
    }
    
    func requestVideoUrl() {
        
        guard let videoUrl = self.catVideModel?.videoUrl else { return }
        if videoUrl.contains("http") || videoUrl.contains(".mp4") {
            let asset = SJVideoPlayerURLAsset(url: URL(string: videoUrl)!)
            self.player.urlAsset = asset
            return
        }
        THVideoRequestManager.requestPlay(videoId: self.catVideModel?.videoUrl ?? "", successBlock: { (result) in
            let model = THVideoInfoModel.yy_model(withJSON: result)
            if let url = URL(string: model?.url ?? "") {
                self.currentVideoUrl = model?.url
                let asset = SJVideoPlayerURLAsset(url: url)
                self.player.urlAsset = asset;
            }
        }) { (error) in
            QMUITips.show(withText: "视频资源出错")
        }
    }
    func updateRulerData() {
        
        let begin = timeString(timeInterval: TimeInterval(self.catVideModel?.startTime ?? 0), format: "HH")
        let beginIntValue = (begin as NSString).intValue
        let end = timeString(timeInterval: TimeInterval(self.catVideModel?.endTime ?? 0), format: "HH")
        let endIntValue = (end as NSString).intValue + 1
        let beginTime = timeString(timeInterval: TimeInterval(self.catVideModel?.startTime ?? 0), format: "HH:mm:ss")
        
        self.currentVideoBeginTime = getSecondFromHHMMSS(HHMMSS: beginTime as String)
        sweetRuler.figureRange = Range(uncheckedBounds: (Int(beginIntValue * 3600), Int(endIntValue * 3600)))
        sweetRuler.setSelectFigure(figure: getSecondFromHHMMSS(HHMMSS: beginTime as String))
        if self.catVideModel != nil {
            sweetRuler.setContentArr(arr: [self.catVideModel!])
        }
        sweetRuler.layoutSubviews()
    }
    
    func configData() {

    }
    
    @objc func clickNextItem() {
        if THVideoCacheManager.INSTANCE.catVideoArr.count > 0 {
            player.pause()
            let vc = THVideoEditVC()
            vc.cid = self.cid
            vc.fromDraft = false
            navigationPushVC(vc: vc)
        } else {
            QMUITips.show(withText: "请先截取一段视频")
        }
    }
    
    @objc func clickButtonEvent(sender: UIButton) {
        guard self.catVideModel != nil else {
            QMUITips.show(withText: "没有视频资源")
            return
        }
        QMUITips.showLoading(in: view)
         
        if !FileManager.default.fileExists(atPath: DownloadVideoPath) {
            try? FileManager.default.createDirectory(atPath: DownloadVideoPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let videoId = dateFormatter.string(from: Date())
        let catVideoPath = DownloadVideoPath + "/" + "\(videoId).mp4"
        
        player.export(withBeginTime: player.currentTime, duration: 15, presetName: AVAssetExportPresetHighestQuality, progress: { (player, process) in

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
            QMUITips.show(withText: "视频截取失败")
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
    
    @objc func clickShareBtnEvent() {
        THShareSheetView.showAlert(title: "", shareUrl: "www.baidu.com")
    }
}

//  MARK: - SJNotReachableControlLayerDelegate, THDateSelectViewDelegate
extension THVideoCatVC: SJNotReachableControlLayerDelegate, THDateSelectViewDelegate {
    func backItemWasTapped(for controlLayer: SJControlLayer) {
        navigationController?.popViewController(animated: true)
    }
    
    func reloadItemWasTapped(for controlLayer: SJControlLayer) {
        self.requestData(timeId: nil)
    }
    
    func dateSelectViewChangeValue(idx: Int) {
        if self.model?.itemList?.count ?? 0 > idx {
            let timeModel = self.model?.itemList?[idx]
            let arr = NSArray.yy_modelArray(with: THCatVideoModel.self, json: self.model?.videoList?[timeModel?.timeId ?? ""]) as? [THCatVideoModel] ?? []
            
            if let model = arr.last {
                self.catVideModel = model
            }
            self.requestVideoUrl()
            self.updateRulerData()
            
        }
    }
}

extension THVideoCatVC: SweetRulerDelegate {
    func sweetRulerWillBeginDragging() {
        player.playbackObserver.currentTimeDidChangeExeBlock = nil
    }
    
    func sweetRulerWillEndDragging() {
        player.playbackObserver.currentTimeDidChangeExeBlock = { (player: SJBaseVideoPlayer) in
            let currentSecond = Int(player.currentTime) + (self.currentVideoBeginTime ?? self.sweetRuler.figureRange.lowerBound)
            self.sweetRuler.setSelectFigure(figure: currentSecond)
        }
    }
    
    ///刻度尺代理方法
    func sweetRuler(ruler: SweetRuler, figure: Int){
        let currentTime = figure - ruler.figureRange.lowerBound
        player.seek(toTime: TimeInterval(currentTime), completionHandler: nil)
        
    }

}


/// 时间戳转日期
///
/// - Parameter timeInterval: 时间戳
/// - Returns: 结果
func timeString(timeInterval: TimeInterval, format: String? = "yyyy-MM-d HH:mm:ss") -> String{
    
    let date = Date(timeIntervalSince1970: timeInterval)
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: date)
    
}
