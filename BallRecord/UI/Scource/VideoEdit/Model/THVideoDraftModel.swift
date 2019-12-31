//
//  THVideoDraftModel.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/19.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
//import MJExtension

/// 草稿箱目录（Documents/DraftPath）
let PublishDraft = documentPath + "/PublishDraft"

/// 草稿文件（数组集合）（Documents/DraftPath/drafts.plist）
let DraftPlistFilePath = PublishDraft + "/drafts.plist" //   草稿文件

/// 草稿箱model
@objcMembers
class THVideoDraftModel: NSObject {
    
    /// 草稿id
    private(set) var draftId: String = ""
    /// 草稿生成日期
    private(set) var dateStr: String = ""
    
    /// Documents下草稿文件夹名
//    var draftFileName: String?
    /// 视频路径 (相对路径，需拼接沙盒目录，因为二次安装app沙盒目录会变)
//    var videoPlistPath: String?
    /// 音乐路径 (相对路径，需拼接沙盒目录，因为二次安装app沙盒目录会变)
//    var bgmPath: String?

    /// 封面图
    var coverImgPath: String = ""
    /// bgm Path
    var bgmPath: String = ""
    /// 视频片段的集合
    var videoPartArr = [CatVideoModel]()
    
    /// bgm
    var editBgm = musicModel(titleName: "")
    
    
    /// bgm音量
    var bgmVolume: CGFloat = 0
    /// 原生音量
    var voiceVolume: CGFloat = 0.5
    
    ///  容器类 指定key 对应的类
    ///
    ///  - returns: 字典 static
    class func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["videoPartArr" : CatVideoModel.self]
    }
    
    
    override class func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["videoPartArr": CatVideoModel.self]
    }


    
    override init() {
        super.init()
        dateConfig()
    }
    
    private func dateConfig() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateStr = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        draftId = dateFormatter.string(from: date)
    }
    
}

extension THVideoDraftModel {
    
    func documentAppendPath(path: String) -> String {
        return documentPath + "/" + path
    }
    
    //  MARK: 保存草稿到本地
    func saveToLocal() {
        
        //判断是否需要创建草稿箱目录
        if !FileManager.default.fileExists(atPath: PublishDraft) {
            try? FileManager.default.createDirectory(atPath: PublishDraft, withIntermediateDirectories: true, attributes: nil)
        }
        //创建当前这条草稿目录（以草稿id命名）
        let draftIdPath = PublishDraft + "/" + draftId
        if !FileManager.default.fileExists(atPath: draftIdPath) {
            try? FileManager.default.createDirectory(atPath: draftIdPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        
        /// "～/PublishDraft"
        let draftFileName = URL(fileURLWithPath: PublishDraft).lastPathComponent
        
        
        //  保存视频    "～/PublishDraft/yyyyMMdd_HHmmss/xxx.mp4"
        videoPartArr.forEach { (model: CatVideoModel) in
            let videoPath = draftFileName + "/" + draftId + "/" + model.videoName
            //  将视频copy到Documents目录下
            copyItemAtPath(fromPath: model.tempVideoPath, toPath: documentAppendPath(path: videoPath))
            model.videoPath = videoPath
            model.tempVideoPath = ""
        }
        
        
        //  保存封面图   "～/PublishDraft/yyyyMMdd_HHmmss/coverImg.png"
        if videoPartArr.count > 0 {
            coverImgPath = draftFileName + "/" + draftId + "/coverImg.png"
            let coverImg = videoPartArr[0].coverImage
            (coverImg?.pngData() as NSData?)?.write(toFile: documentAppendPath(path: coverImgPath), atomically: true)
        }
        
        
        //  保存音乐    "～/PublishDraft/yyyyMMdd_HHmmss/xxx.mp3"
        if let musicUrl = URL(string: self.editBgm.musicTempPath) {
            bgmPath = draftFileName + "/" + draftId + "/\(musicUrl.lastPathComponent)"
            copyItemAtPath(fromPath: self.editBgm.musicTempPath, toPath: documentAppendPath(path: bgmPath))
        }
        
        
        
        //读取本地已存的草稿文件plist，转换为草稿数组
        let drafts = NSMutableArray(contentsOfFile: DraftPlistFilePath) ?? []
        let currentDraft = self.yy_modelToJSONObject()
        
        if drafts.count > 0 {
            var flag = false
            for idx in 0..<drafts.count{
                let model = THVideoDraftModel.yy_model(with: drafts[idx] as! [AnyHashable : Any])
                if model?.draftId == draftId {
                    drafts.replaceObject(at: idx, with: currentDraft)
                    flag = true
                    break
                }
            }
            if !flag {
                drafts.insert(currentDraft, at: 0)
            }
        } else {
            drafts.insert(currentDraft, at: 0)
        }
        //将草稿数组保存在草稿箱目录     "～/PublishDraft/drafts.plist"
        drafts.write(toFile: DraftPlistFilePath, atomically: true)
        
    }
    
    
    //  MARK: 获取本地草稿箱数据
    class func getLocalDraftModels() -> Array<THVideoDraftModel> {
        let draftsArr = NSArray(contentsOfFile: DraftPlistFilePath) ?? NSArray()
        let draftModels = NSMutableArray.yy_modelArray(with: THVideoDraftModel.self, json: draftsArr) as? Array<THVideoDraftModel>
        return draftModels ?? Array<THVideoDraftModel>()
    }
    
    
    //  MARK: 移除当前草稿
    func removeDraft() {
        THVideoDraftModel.removeDraft(draftId: draftId)
    }
    
    /// 根据草稿索引移除指定草稿
    class func removeDraft(indexs: IndexSet) {
        /// 移除指定草稿对应的文件夹
        let drafts = getLocalDraftModels()
        
        indexs.forEach { (idx) in
            let draftId = drafts[idx].draftId
            let draftFolder = PublishDraft + "/" + draftId
            do {
                try FileManager.default.removeItem(atPath: draftFolder)
            } catch {}
        }
        /// 保存移除指定草稿后的数据
        let draftsArr = NSMutableArray(contentsOfFile: DraftPlistFilePath)
        draftsArr?.removeObjects(at: indexs)
        draftsArr?.write(toFile: DraftPlistFilePath, atomically: true)
    }
    
    /// 根据草稿ID移除指定草稿
    class func removeDraft(draftId: String) {
        let draftFolder = PublishDraft + "/" + draftId
        if FileManager.default.fileExists(atPath: draftFolder) {
            //移除指草稿对应的文件夹
            do {
                try FileManager.default.removeItem(atPath: draftFolder)
            } catch {}
            
            //保存移除指定草稿后的数据
            let draftsArr = NSMutableArray(contentsOfFile: DraftPlistFilePath)
            draftsArr?.forEach({ (draft) in
                let model = THVideoDraftModel.yy_model(withJSON: draft)
                if model?.draftId == draftId {
                    draftsArr?.remove(draft)
                }
            })
            draftsArr?.write(toFile: DraftPlistFilePath, atomically: true)
        }
    }
}


//  MARK: 拷贝文件（目的文件存在会拷贝失败，需要先移除）
func copyItemAtPath(fromPath: String, toPath: String) {
    if !FileManager.default.fileExists(atPath: fromPath) {
        print("无法拷贝：原文件不存在")
        return
    }
    
    if FileManager.default.fileExists(atPath: toPath) {
        print("%@文件已存在,先删除",toPath)
        try? FileManager.default.removeItem(atPath: toPath)
    }
    
    //  创建文件夹
    let path = URL(fileURLWithPath: toPath).deletingLastPathComponent().absoluteString
    if !FileManager.default.fileExists(atPath: path) {
        try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
    
    try? FileManager.default.copyItem(atPath: fromPath, toPath: toPath)
}
