//
//  THVideoCacheManager.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/20.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THVideoCacheManager: NSObject {

    static let INSTANCE = THVideoCacheManager()
    
    let videoBox = WAVideoBox()
    
    var catVideoArr = [CatVideoModel]()
    
    
    func getVideoPathFromAllVideoPart(completion: ((_ savePath: String, _ error: Error?)->Void)?) {
        videoBox.clean()
        catVideoArr.forEach { (model: CatVideoModel) in
            let path: String?
            if model.tempVideoPath.filePathExists() {
                path = model.tempVideoPath
            } else {
                path = documentPath + "/" + model.videoPath
            }
            let asset = AVAsset(url: URL(fileURLWithPath: path ?? ""))
            videoBox.appendVideo(by: asset)
        }
        let savePath = DownloadVideoPath + "/editVideo.mp4"
        videoBox.asyncFinishEdit(byFilePath: savePath) { (error: Error?) in
            completion?(savePath, error)
        }
    }
    
    /// 清空缓存中所有视频片段
    func clearVideoPart() {
        catVideoArr.removeAll()
    }
    
    
    /// 移除某个视频片段（视频Model）
    func removeVideoPart(video: CatVideoModel) {
        for (idx, item) in catVideoArr.enumerated() {
            if item.tempVideoPath == video.tempVideoPath {
                catVideoArr.remove(at: idx)
                break
            }
        }
    }
    
    /// 移除某个视频片段（视频idx）
    func removeVideoPart(idx: Int) {
        catVideoArr.remove(at: idx)
    }
    
}
