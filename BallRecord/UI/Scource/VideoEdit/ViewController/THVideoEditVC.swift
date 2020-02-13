//
//  THVideoEditVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/17.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import QMUIKit

class THVideoEditVC: THBaseVC {
    
    var fromDraft: Bool?
    
    var hasOperation: Bool = true
    
    var cid: String?
    let videoBox = WAVideoBox()
    let uploader = THAliVideoUploader()
    
    var draftModel: THVideoDraftModel?
    var bgmArr: [THBGMTypeModel]?
    
    var tempVideoPath: String?
    
    var voiceVolume: CGFloat = 1  //  默认1
    var bgmVolume: CGFloat = 0    //  默认0
    var selectedBgmPath: String?
    
    let videoView = UIView()
    var selectBTN: UIButton?
    
    //  背景音乐播放器
    var BGMPlayer: AVAudioPlayer?

    
    //  视频播放器
    lazy var player: SJVideoPlayer = {
        let player = SJVideoPlayer()
        player.showMoreItemToTopControlLayer = false
        player.rotationManager.isDisabledAutorotation = true
        player.defaultLoadFailedControlLayer.delegate = self
        return player
    }()
    
    lazy var videoBtn: UIButton = {
        let button = UIButton()
        button.tag = 55
        button.setTitle("视频", for: .normal)
        button.setTitleColor(COLOR_666666, for: .normal)
        button.setTitleColor(MAIN_COLOR, for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var musicBtn: UIButton = {
        let button = UIButton()
        button.tag = 56
        button.setTitle("音乐", for: .normal)
        button.setTitleColor(COLOR_666666, for: .normal)
        button.setTitleColor(MAIN_COLOR, for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var indicator: UIView = {
        let view = UIView()
        view.backgroundColor = MAIN_COLOR
        return view
    }()
    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = COLOR_F4F4F4
        return view
    }()
    
    let videoEditView = THVideoView()
    let bgmEditView = THMusicView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uploader.delegate = self
        configUI()
        configFrame()
        configData()
        requestBGMData()
        
        //  将视频片段进行合成
        THVideoCacheManager.INSTANCE.getVideoPathFromAllVideoPart { (videoPath: String, error: Error?) in
            print("videoPath: %@", videoPath)
            
            self.tempVideoPath = videoPath
            let asset = SJVideoPlayerURLAsset(url: URL(fileURLWithPath: self.tempVideoPath ?? ""))
            self.player.urlAsset = asset;
            self.player.playerVolume = Float(self.voiceVolume)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.vc_viewDidAppear()
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

extension THVideoEditVC {
    
    func configUI() {
        title = "编辑"
        view.addSubview(videoView)
        view.addSubview(videoBtn)
        view.addSubview(musicBtn)
        view.addSubview(indicator)
        view.addSubview(line)
        view.addSubview(videoEditView)
        view.addSubview(bgmEditView)
        videoView.addSubview(player.view)
        
        addRightItem()
        configPlayer()
        
        self.videoEditView.videoPartView.deleteItemBlock = {
            //  将视频片段进行合成
            THVideoCacheManager.INSTANCE.getVideoPathFromAllVideoPart { (videoPath: String, error: Error?) in
                print("videoPath: %@", videoPath)
                self.hasOperation = true
                self.tempVideoPath = videoPath
                let asset = SJVideoPlayerURLAsset(url: URL(fileURLWithPath: self.tempVideoPath ?? ""))
                self.player.urlAsset = asset;
                self.player.playerVolume = Float(self.voiceVolume)
            }
        }
    }
    
    func configPlayer() {
        player.defaultLoadFailedControlLayer.topContainerView.isHidden = true
        player.defaultEdgeControlLayer.topContainerView.isHidden = true
        player.defaultEdgeControlLayer.bottomAdapter.removeItem(forTag: SJEdgeControlLayerBottomItem_FullBtn)
        player.defaultEdgeControlLayer.bottomAdapter.removeItem(forTag: SJEdgeControlLayerBottomItem_Separator)
        player.defaultEdgeControlLayer.bottomAdapter.exchangeItem(forTag: SJEdgeControlLayerBottomItem_DurationTime, withItemForTag: SJEdgeControlLayerBottomItem_Progress)
        let durationItem = player.defaultEdgeControlLayer.bottomAdapter.item(forTag: SJEdgeControlLayerBottomItem_DurationTime)
        durationItem?.insets = SJEdgeInsetsMake(8, 16)
        player.defaultEdgeControlLayer.bottomAdapter.reload()
        
        player.playbackObserver.playbackStatusDidChangeExeBlock = { (player: SJBaseVideoPlayer) in
            if player.timeControlStatus == .playing {
                self.BGMPlayer?.play()
            } else {
                self.BGMPlayer?.stop()
            }
        }
        player.playbackObserver.currentTimeDidChangeExeBlock = { (player: SJBaseVideoPlayer) in
            if abs((self.BGMPlayer?.currentTime ?? 0) - player.currentTime) > 0.2 {
                self.BGMPlayer?.currentTime = player.currentTime
            }
        }
    }
    
    func addRightItem() {
        
        let item1 = UIBarButtonItem(title: "下一步", style: .plain, target: self, action: #selector(clickNextItem))
        item1.tintColor = MAIN_COLOR
        let item2 = UIBarButtonItem(title: "保存草稿", style: .plain, target: self, action: #selector(clickSaveItem))
        item2.tintColor = COLOR_666666
        navigationItem.rightBarButtonItems = [item1, item2]
    }
    
    
    func configFrame() {
        
        videoView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 200)
        videoBtn.frame = CGRect(x: SCREEN_WIDTH/2 - 100, y: videoView.frame.maxY, width: 100, height: 40)
        musicBtn.frame = CGRect(x: SCREEN_WIDTH/2, y: videoView.frame.maxY, width: 100, height: 40)
        line.frame = CGRect(x: 0, y: videoBtn.frame.maxY, width: SCREEN_WIDTH, height: 1)
        indicator.frame = CGRect(x: 0, y: videoBtn.frame.maxY - 4, width: 45, height: 4)
        indicator.centerX = videoBtn.centerX
        
        selectBTN = videoBtn
        selectBTN?.isSelected = true
        
        videoEditView.frame = CGRect(x: 0, y: line.frame.maxY, width: SCREEN_WIDTH, height: view.height - line.frame.maxY)
        bgmEditView.frame = CGRect(x: 0, y: line.frame.maxY, width: SCREEN_WIDTH, height: view.height - line.frame.maxY)
        bgmEditView.isHidden = true
        player.view.frame = videoView.bounds
    }
    
    func configData() {
        bgmEditView.delegate = self
        
        if let model = draftModel {
            //  更新视频界面信息
            THVideoCacheManager.INSTANCE.catVideoArr = model.videoPartArr
            videoEditView.videoPartView.updateDataSource()
            
            if model.bgmPath != "" {
                //  预先设置bgm音乐
                BGMPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: documentPath + "/" + model.bgmPath))
                BGMPlayer?.delegate = self
                BGMPlayer?.volume = Float(model.bgmVolume)
                BGMPlayer?.prepareToPlay()
            }
            
            //  更新音乐界面信息
            bgmEditView.voiceSlider.value = Float(model.voiceVolume)
            bgmEditView.bgmSlider.value = Float(model.bgmVolume)
            bgmEditView.updateUIData()
            
            self.cid = model.cid
            self.voiceVolume = model.voiceVolume
            self.bgmVolume = model.bgmVolume
        }
        
    }
    
    func requestBGMData() {
        
        THPlaygroundManager.requestBGMListData(param: nil, successBlock: { (result) in
            self.bgmArr = NSArray.yy_modelArray(with: THBGMTypeModel.self, json: result) as? [THBGMTypeModel] ?? []
            print("-----")
        }) { (error) in
            print("-----")
        }
    }
    
    
    func updateDraftModel() {
        if draftModel == nil {
            draftModel = THVideoDraftModel()
        }
        draftModel!.cid = cid ?? ""
        draftModel!.voiceVolume = voiceVolume
        draftModel!.bgmVolume = bgmVolume
        draftModel!.videoPartArr = THVideoCacheManager.INSTANCE.catVideoArr
        draftModel!.tempBgmPath = self.selectedBgmPath ?? ""
    }
    
    @objc func clickSaveItem() {
        
        updateDraftModel()
        self.draftModel!.saveToLocal()
        QMUITips.show(withText: "您的视频已保存到草稿箱")
        self.hasOperation = false
    }
    
    @objc func clickNextItem() {
        //  合成视频
        QMUITips.showLoading(in: view)
        
        self.videoBox.clean()
        self.videoBox.appendVideo(byPath: self.tempVideoPath)
        videoBox.dubbedSound(bySoundPath: self.selectedBgmPath, volume: self.voiceVolume, mixVolume: bgmVolume, insertTime: 0)
        
        videoBox.asyncFinishEdit(byFilePath: self.tempVideoPath, progress: { (process) in

        }) { (error) in
            QMUITips.hideAllTips()
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.tempVideoPath ?? "")) {
                UISaveVideoAtPathToSavedPhotosAlbum(self.tempVideoPath ?? "", self, #selector(self.video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
            } else {
                QMUITips.show(withText: "保存视频过程中发生错误")
                self.showAlert(title: "您的视频已做好快珍藏到打球记录吧！", btnTitle: "珍藏到打球记录") {
                    QMUITips.showLoading(in: self.view)
                    /// 获取阿里云上传凭证，票据，videoId
                    let fileName = "\(milliStamp).mp4"
                    THVideoRequestManager.requestUploadAuth(title: "精彩瞬间", fileName: fileName, successBlock: { (result) in
                        let model = THVideoAuthInfoModel.yy_model(withJSON: result)
                        /// 视频上传到阿里云
                        self.uploader.uploadFile(filePath: self.tempVideoPath ?? "", uploadAuth: model?.UploadAuth ?? "", uploadAddress: model?.UploadAddress ?? "", videoId: model?.VideoId ?? "")
                        
                    }) { (error) in
                        QMUITips.hideAllTips()
                        QMUITips.show(withText: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    //保存相册结果回调
    @objc func video(videoPath: String, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        
        if error == nil {
            QMUITips.show(withText: "您的视频已保存到相册")
            self.showAlert(title: "您的视频已做好快珍藏到打球记录吧！", btnTitle: "珍藏到打球记录") {
                QMUITips.showLoading(in: self.view)
                /// 获取阿里云上传凭证，票据，videoId
                let fileName = "\(milliStamp).mp4"
                THVideoRequestManager.requestUploadAuth(title: "精彩瞬间", fileName: fileName, successBlock: { (result) in
                    let model = THVideoAuthInfoModel.yy_model(withJSON: result)
                    /// 视频上传到阿里云
                    self.uploader.uploadFile(filePath: self.tempVideoPath ?? "", uploadAuth: model?.UploadAuth ?? "", uploadAddress: model?.UploadAddress ?? "", videoId: model?.VideoId ?? "")
                    
                }) { (error) in
                    QMUITips.hideAllTips()
                    QMUITips.show(withText: error.localizedDescription)
                }
            }
        } else {
            QMUITips.show(withText: "保存视频过程中发生错误")
        }
    }
    
    func showAlert(title: String, btnTitle: String, sureBlock:(() -> Void)?) {
        let alert = THBottomAlert.show()
        alert.titleLabel.text = title
        alert.actionBtn.setTitle(btnTitle, for: .normal)
        alert.actionBlock = sureBlock
    }
    
    @objc func clickButtonEvent(sender: UIButton) {
        
        selectBTN?.isSelected = false
        selectBTN = sender
        selectBTN?.isSelected = true
        indicator.centerX = sender.centerX
        
        if sender.tag == 55 {
            bgmEditView.isHidden = true
            videoEditView.isHidden = false
        } else {
            videoEditView.isHidden = true
            bgmEditView.isHidden = false
        }
    }
    
    override func goBackItemClicked() {
        
        if fromDraft ?? false {
            THVideoCacheManager.INSTANCE.clearVideoPart()
            super.goBackItemClicked()
            return
        }
        if !hasOperation {
            super.goBackItemClicked()
            return
        }
        
        let alert = UIAlertController(title: nil, message: "退出后,剪辑的视频将不可恢复", preferredStyle: .alert)
        let save = UIAlertAction(title: "保存", style: .default) { (action) in
            self.updateDraftModel()
            self.draftModel!.saveToLocal()
            super.goBackItemClicked()
        }
        let noSave = UIAlertAction(title: "不保存", style: .default) { (action) in
            super.goBackItemClicked()
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(save)
        alert.addAction(noSave)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

extension THVideoEditVC: THAliVideoUploaderDelegate {
    
    func uploadFinishCallbackFunc(fileInfo: UploadFileInfo?, result: VodUploadResult?, videoId: String?) {
        /// 珍藏到打球记录
        let param = ["placeId": self.cid ?? "", "videoUrl": videoId ?? ""]
        THPlaygroundManager.requestCollectVideo(param: param, successBlock: { (collectResult) in
            QMUITips.hideAllTips()
            
            let collectModel = UploadVideoModel.yy_model(withJSON: collectResult)
            self.showAlert(title: "视频已经珍藏到打球记录发布到球志动态吧！", btnTitle: "发布到球志动态吧") {
                let vc = THPublishDynamicVC()
                vc.vid = collectModel?.vid
                vc.aliVideoId = videoId
                vc.duration = THVideoCacheManager.INSTANCE.catVideoArr.count * 10
                self.navigationPushVC(vc: vc)
            }
        }) { (error) in
            QMUITips.hideAllTips()
        }
        
    }
    
    func uploadFailedCallbackFunc(fileInfo: UploadFileInfo?, code: String?, message: String?, videoId: String?) {
        QMUITips.hideAllTips()
        QMUITips.show(withText: message)
    }
    
    func uploadProgressCallbackFunc(fileInfo: UploadFileInfo?, uploadedSize: Int, totalSize: Int, videoId: String?) {
        
    }
    
    func uploadTokenExpiredCallbackFunc(completion: ((String)->Void)?, videoId: String?) {
        THVideoRequestManager.requestVideoPlayAuth(videoId: videoId ?? "", successBlock: { (result) in
            completion?("")
        }) { (error) in
            completion?("")
        }
    }
}

extension THVideoEditVC: SJNotReachableControlLayerDelegate {
    func backItemWasTapped(for controlLayer: SJControlLayer) {
        navigationController?.popViewController(animated: true)
    }
    
    func reloadItemWasTapped(for controlLayer: SJControlLayer) {
        //  将视频片段进行合成
        THVideoCacheManager.INSTANCE.getVideoPathFromAllVideoPart { (videoPath: String, error: Error?) in
            print("videoPath: %@", videoPath)
            
            self.tempVideoPath = videoPath
            let asset = SJVideoPlayerURLAsset(url: URL(fileURLWithPath: self.tempVideoPath ?? ""))
            self.player.urlAsset = asset;
            self.player.playerVolume = Float(self.voiceVolume)
        }
    }
}

extension THVideoEditVC: THMusicViewDelegate, AVAudioPlayerDelegate{
    func choiceBgmEvent() {
        
        if self.bgmArr?.count ?? 0 <= 0 {
            QMUITips.show(withText: "暂无背景音乐可用")
            return
        }
        let alert = THSelectMusicAlert.show(arr: self.bgmArr!)
        alert.sureBlock = { (musicPath: String) in
            self.sureBgmEvent(bgmPath: musicPath)
        }
    }
    
    func sureBgmEvent(bgmPath: String) {
        if bgmPath != "" {
            self.hasOperation = true
            self.BGMPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: bgmPath))
            self.BGMPlayer?.delegate = self
            self.BGMPlayer?.volume = 0.5
            self.BGMPlayer?.prepareToPlay()
            //  播放音频，同时调用视频播放，实现同步播放
            self.player.seek(toTime: 0) { (isSuccess) in
                self.BGMPlayer?.play()
            }
            
            //  更新音乐界面信息
            self.bgmEditView.bgmSlider.value = Float(0.5)
            self.bgmEditView.updateUIData()
            self.bgmVolume = 0.5
            self.selectedBgmPath = bgmPath
        }
    }
    
    func voiceValueChange(value: Float) {
        self.hasOperation = true
        voiceVolume = CGFloat(value)
        player.playerVolume = value
    }
    
    func bgmValueChange(value: Float) {
        self.hasOperation = true
        bgmVolume = CGFloat(value)
        self.BGMPlayer?.volume = value
    }
    
}


//  MARK: - Class THVideoView
class THVideoView: UIView {
    
    let videoPartView = THVideoPartView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(videoPartView)
        videoPartView.top = 35
        videoPartView.updateDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//  MARK: - Class THMusicView
@objc protocol THMusicViewDelegate {
    func voiceValueChange(value: Float)
    func bgmValueChange(value: Float)
    func sureBgmEvent(bgmPath: String)
    func choiceBgmEvent()
}

class THMusicView: UIView {
    weak var delegate: THMusicViewDelegate?
    
    lazy var voiceLabel: UILabel = {
        let label = UILabel()
        label.text = "视频原声"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_666666
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var bgmLabel: UILabel = {
        let label = UILabel()
        label.text = "背景音乐"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_666666
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var voiceSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 1    //  原声默认为1
        slider.minimumTrackTintColor = MAIN_COLOR
        slider.maximumTrackTintColor = COLOR_F4F4F4
        slider.addTarget(self, action: #selector(sliderValueChangeEvent(sender:)), for: .valueChanged)
        return slider
    }()
    
    lazy var bgmSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.minimumTrackTintColor = MAIN_COLOR
        slider.maximumTrackTintColor = COLOR_F4F4F4
        slider.addTarget(self, action: #selector(sliderValueChangeEvent(sender:)), for: .valueChanged)
        return slider
    }()
    
    lazy var voicePerLabel: UILabel = {
        let label = UILabel()
        label.text = "100%"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_666666
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    lazy var bgmPerLabel: UILabel = {
        let label = UILabel()
        label.text = "0%"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = COLOR_666666
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var choseBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = MAIN_COLOR
        button.setTitle("选择背景音乐", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
        configFrame()
        updateUIData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        addSubview(voiceLabel)
        addSubview(bgmLabel)
        addSubview(voiceSlider)
        addSubview(bgmSlider)
        addSubview(voicePerLabel)
        addSubview(bgmPerLabel)
        addSubview(choseBtn)
    }
    
    func configFrame() {
        voiceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.width.height.equalTo(voiceLabel)
            make.top.equalTo(50)
        }
        
        voiceSlider.snp.makeConstraints { (make) in
            make.left.equalTo(voiceLabel.snp_right).offset(10)
            make.right.equalTo(voicePerLabel.snp_left).offset(-10)
            make.height.equalTo(voiceLabel)
            make.centerY.equalTo(voiceLabel)
        }
        
        voicePerLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-30)
            make.centerY.equalTo(voiceLabel)
            make.width.equalTo(50)
            make.height.equalTo(voicePerLabel)
        }
        
        bgmLabel.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.width.height.equalTo(bgmLabel)
            make.top.equalTo(voiceLabel.snp_bottom).offset(30)
        }
        
        bgmSlider.snp.makeConstraints { (make) in
            make.left.equalTo(bgmLabel.snp_right).offset(10)
            make.right.equalTo(bgmPerLabel.snp_left).offset(-10)
            make.height.equalTo(bgmLabel)
            make.centerY.equalTo(bgmLabel)
        }
        
        bgmPerLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-30)
            make.centerY.equalTo(bgmSlider)
            make.width.equalTo(50)
            make.height.equalTo(bgmPerLabel)
        }
        
        choseBtn.snp.makeConstraints { (make) in
            make.left.equalTo(75)
            make.right.equalTo(-75)
            make.top.equalTo(bgmLabel.snp_bottom).offset(50)
            make.height.equalTo(45)
        }
        
        choseBtn.setCorner(cornerRadius: 2)
    }
    
    func updateUIData() {
        let str = String(format: "%.0f", self.voiceSlider.value * 100)
        voicePerLabel.text = "\(str)%"
        
        let str2 = String(format: "%.0f", self.bgmSlider.value * 100)
        bgmPerLabel.text = "\(str2)%"
    }
    
    @objc func clickButtonEvent(sender: UIButton) {
        
        delegate?.choiceBgmEvent()
    }
    
    @objc func sliderValueChangeEvent(sender: UISlider) {
        let str = String(format: "%.0f", sender.value * 100)
        if sender == self.voiceSlider {
            voicePerLabel.text = "\(str)%"
            delegate?.voiceValueChange(value: sender.value)
        } else {
            bgmPerLabel.text = "\(str)%"
            delegate?.bgmValueChange(value: sender.value)
        }
    }
}
