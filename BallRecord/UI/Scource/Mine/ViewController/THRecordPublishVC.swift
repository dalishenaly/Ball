//
//  THRecordVideoPublishVC.swift
//  BallRecord
//
//  Created by 买超 on 2020/1/7.
//  Copyright © 2020 maichao. All rights reserved.
//

import UIKit

class THRecordPublishVC: THBaseVC {

    var aliVideoId: String?
    var vid: String?
    
    lazy var player: SJVideoPlayer = {
        let player = SJVideoPlayer()
        player.showMoreItemToTopControlLayer = false
        player.rotationManager.isDisabledAutorotation = true
        player.defaultNotReachableControlLayer.delegate = self
        return player
    }()
    
    lazy var publishBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = MAIN_COLOR
        button.setTitle("发布", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickButtonEvent), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        configFrame()
        
        if LocalStoreUtil.INSTANCE.getWifiSwichStatus() || THReachability.INSTANCE.net?.isReachableOnEthernetOrWiFi ?? false {
            configData()
        } else {
            if THReachability.INSTANCE.net?.isReachable ?? false {
                let alert = UIAlertController(title: "您正在使用移动网络", message: "继续观看会耗费流量", preferredStyle: .alert)
                let sure = UIAlertAction(title: "继续观看", style: .default) { (action) in
                    self.configData()
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

extension THRecordPublishVC {
    
    func configUI() {
        
        view.addSubview(player.view)
        view.addSubview(publishBtn)
        
        configPlayer()
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
    }
    
    
    func configFrame() {
        
        player.view.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(200)
            make.top.equalTo(self.view)
        }
        
        publishBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(230)
            make.height.equalTo(40)
            make.bottom.equalTo(-80)
        }
        publishBtn.setCorner(cornerRadius: 2)
    }
    
    func configData() {
        THVideoRequestManager.requestPlay(videoId: self.aliVideoId ?? "", successBlock: { (result) in
            let model = THVideoInfoModel.yy_model(withJSON: result)
//            let videoPath = "https://xy2.v.netease.com/r/video/20190110/bea8e70d-ffc0-4433-b250-0393cff10b75.mp4"
            if let url = URL(string: model?.url ?? "") {
                let asset = SJVideoPlayerURLAsset(url: url)
                self.player.urlAsset = asset;
            }
        }) { (error) in
            QMUITips.show(withText: "播放资源出错")
        }
    }
    
    @objc func clickButtonEvent() {
        
        let vc = THPublishDynamicVC()
        vc.vid = self.vid
        vc.aliVideoId = self.aliVideoId
        self.navigationPushVC(vc: vc)
    }
}

extension THRecordPublishVC: SJNotReachableControlLayerDelegate {
    func backItemWasTapped(for controlLayer: SJControlLayer) {
        navigationController?.popViewController(animated: true)
    }
    
    func reloadItemWasTapped(for controlLayer: SJControlLayer) {
        self.configData()
    }
}
