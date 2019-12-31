//
//  THMyDynamicVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/27.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THMyDynamicVC: THBaseTableViewVC {

    lazy var player: SJVideoPlayer = {
        let player = SJVideoPlayer()
        player.showMoreItemToTopControlLayer = false
        player.rotationManager.isDisabledAutorotation = true
        return player
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的动态"
    }
}

extension THMyDynamicVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "THVideoCell") as? THVideoCell
        if cell == nil {
            cell = THVideoCell(style: .default, reuseIdentifier: "THVideoCell")
        }
        cell?.delegate = self
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = THVideoDetailVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        player.stop()
        tableView.sj_removeCurrentPlayerView()
    }
}

extension THMyDynamicVC: THVideoCellDelegate {
    
    func videoCellClickedOnTheCover(cell: THVideoCell, cover: UIImageView) {
        let indexPath = tableView.indexPath(for: cell)
        playerNeedPlayNewAssetAtIndexPath(indexPath: indexPath)
    }
    
    func playerNeedPlayNewAssetAtIndexPath(indexPath: IndexPath?) {
        guard let idxPath = indexPath else { return }
        let playModel = SJPlayModel.uiTableViewCellPlayModel(withPlayerSuperviewTag: videoCoverImageTag, at: idxPath, tableView: tableView)
        
        let url = URL(string: "https://xy2.v.netease.com/r/video/20190110/bea8e70d-ffc0-4433-b250-0393cff10b75.mp4")
        player.urlAsset = SJVideoPlayerURLAsset(url: url!, playModel: playModel)
    }
}
