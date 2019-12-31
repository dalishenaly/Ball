//
//  THVideoEditController.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/18.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

/// mp3下载目录（temp/DownloadBgmPath）
let DownloadBgmPath = NSTemporaryDirectory() + "DownloadBgmPath"
/// 视频下载目录（temp/DownloadVideoPath）
let DownloadVideoPath = NSTemporaryDirectory() + "DownloadVideoPath"



/// 裁剪后的mp3目录（temp/CatBgmPath）
let CatBgmPath = NSTemporaryDirectory() + "CatBgmPath"

// 本地选择视频裁剪目录、录制视频合成目录、编辑界面裁剪目录(temp/THEdit/editVideo.mp4)
let THEditVideoPath = NSTemporaryDirectory() + "/THEdit/editVideo.mp4"

class THVideoEditController: NSObject {
    
    //  MARK: 视频裁剪
    class func cutVideoWithAsset(asset: AVAsset, videoRange: CMTimeRange, catVideoPath: String, completion:((_ outputUrl: String, _ error: Error?)-> Void)?) {
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough)
        let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: asset)
        if compatiblePresets.contains(AVAssetExportPresetMediumQuality) {
            //混合后的视频输出路径
            exportSession?.outputURL = URL(fileURLWithPath: catVideoPath)
            exportSession?.outputFileType = AVFileType.mp4
            //输出文件是否网络优化
            exportSession?.shouldOptimizeForNetworkUse = true
            //截取的起始点
            exportSession?.timeRange = videoRange;
            exportSession?.exportAsynchronously(completionHandler: {
                
                let status = exportSession?.status

                switch (status!) {
                case AVAssetExportSession.Status.completed:
                    completion?(catVideoPath, nil)
                    break

                case AVAssetExportSession.Status.failed:
                    completion?("", exportSession?.error)
                    break
                default:
                    break
                }
            })
        }
    }
    
    //  MARK: 音频裁剪 (只能保存mp4。不知道为什么)
    class func cutAudioWithAsset(asset: AVAsset, audioRange: CMTimeRange, catAudioPath: String, completion:((_ outputUrl: String, _ error: Error?)-> Void)?) {
        
        if FileManager.default.fileExists(atPath: catAudioPath) {
            try? FileManager.default.removeItem(atPath: catAudioPath)
        }
        
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
        let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: asset)
        if compatiblePresets.contains(AVAssetExportPresetMediumQuality) {
            
            exportSession?.outputURL = URL(fileURLWithPath: catAudioPath)
            exportSession?.outputFileType = AVFileType.m4a
            //输出文件是否网络优化
            exportSession?.shouldOptimizeForNetworkUse = true
            //截取的起始点
            exportSession?.timeRange = audioRange;
            exportSession?.exportAsynchronously(completionHandler: {
                
                let status = exportSession?.status

                switch (status!) {
                case AVAssetExportSession.Status.completed:
                    completion?(catAudioPath, nil)
                    break

                case AVAssetExportSession.Status.failed:
                    completion?("", exportSession?.error)
                    break
                default:
                    break
                }
            })
        }
    }

    
    //  MARK: 获取视频封面图
    class func getVideoCoverImage(url:String) -> UIImage {
        if url.isEmpty {
            //默认封面图
            return UIImage(named: "")!
        }
        var asset: AVURLAsset?
        if url.contains("http") {
            asset = AVURLAsset(url: URL(string: url)!, options: nil)
        } else {
            asset = AVURLAsset(url: URL(fileURLWithPath: url), options: nil)
        }
        
        let assetImg = AVAssetImageGenerator(asset: asset!)
        assetImg.appliesPreferredTrackTransform = true
        assetImg.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
        do{
            let cgimgref = try assetImg.copyCGImage(at: CMTime(seconds: 1, preferredTimescale: 50), actualTime: nil)
            return UIImage(cgImage: cgimgref)
        } catch {
            return UIImage(named: "")!
        }
    }
        
    
    //  MARK: 下载视频到本地相册
    class func saveVideoWithUrlStr(url: String) {
        guard let videoUrl = URL(string: url) else { return }
        
        if !FileManager.default.fileExists(atPath: DownloadVideoPath) {
            do {
                try FileManager.default.createDirectory(atPath: DownloadVideoPath, withIntermediateDirectories: true, attributes: nil)
                print("Succes to create folder")
            } catch {
                print("Error to create folder")
            }
        }
        
        let videoPath = DownloadBgmPath + "/" + videoUrl.lastPathComponent
        
        if FileManager.default.fileExists(atPath: videoPath) {  //先判断本地是否存在
            
            exportVideoToAlbum(videoPath: videoPath)
            
        } else {
            //  下载音乐
            THVideoEditController.downloadTask(urlStr: url, savePath: videoPath, downloadProgress: { (process: Progress) in
                
                let persent: CGFloat = 1.0 * CGFloat(process.completedUnitCount/process.totalUnitCount * 100)
                print("当前线程：%@，加载中%d%%", Thread.current, persent)
                
            }, completionHandler: { (savePath: String) in
                
                exportVideoToAlbum(videoPath: savePath)
                
            }) { (error: Error) in
                print("文件下载失败: %@", error)
            }
        }
    }
    
    //  MARK: 导入本地视频文件到系统相册中
    class func exportVideoToAlbum(videoPath: String) {
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath) {
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self, #selector(video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            print("保存失败")
        }
    }
    
    /// 保存相册结果回调
    @objc class func video(videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        if error != nil {
            print("保存视频过程中发生错误，错误信息:%@", error?.localizedDescription)
        } else {
            print("保存成功，请到相册查看")
        }
    }
    
    //  MARK: 导出视频中的音频.m4a
    class func exportVideoPath(videoPath: String, toM4aPath m4aPath: String, process:((_ progress: Float)->Void)?, success: (()->Void)?, failure: (()->Void)?) {
        
        var videoAsset: AVURLAsset?
        if videoPath.contains("http") {
            videoAsset = AVURLAsset(url: URL(string: videoPath)!, options: nil)
        } else {
            videoAsset = AVURLAsset(url: URL(fileURLWithPath: videoPath), options: nil)
        }
        //创建一个AVMutableComposition实例
        let composition = AVMutableComposition()
        //创建一个轨道,类型是AVMediaTypeAudio
        let track = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        print("mp4导m4a时所有track:%@",videoAsset!.tracks)
        let targetTrack = videoAsset!.tracks(withMediaType: AVMediaType.audio).first
        //获取videoAsset中的音频,插入轨道
        try? track?.insertTimeRange(CMTimeRange(start: CMTime.zero, duration: videoAsset!.duration), of: targetTrack!, at: CMTime.zero)
        
        //创建文件管理类,删除之前已经导出的同名文件(否则重名导出会失败)
        if FileManager.default.fileExists(atPath: m4aPath) {
            //删除已经存在的路径
            try? FileManager.default.removeItem(atPath: m4aPath)
        }
        
        //创建输出对象
        let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetPassthrough)
        exporter?.outputURL = URL(fileURLWithPath: m4aPath)
        exporter?.outputFileType = AVFileType.caf
        exporter?.shouldOptimizeForNetworkUse = true    //是否网络优化
        exporter?.exportAsynchronously(completionHandler: {
            DispatchQueue.main.async {
                if exporter?.status == AVAssetExportSession.Status.completed {    //导出完成
                    let fileSize = try? FileManager.default.attributesOfItem(atPath: m4aPath)[FileAttributeKey.size] as! NSNumber?
                    print("导出m4a路径:%@---导出文件大小%.2fM", m4aPath, (fileSize ?? 0).floatValue/1024.0/1024.0)
                    success?()
                } else if exporter?.status == AVAssetExportSession.Status.failed {
                    print("失败原因：%@", exporter?.error as Any)
                    failure?()
                }
            }
        })
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
            while exporter?.status == AVAssetExportSession.Status.exporting {
                DispatchQueue.main.async {
                    process?(exporter?.progress ?? 0)
                }
            }
        }
    }
    
    //导出视频中的音频.mp3(实现方案为：先导出为m4a再利用lame转换为mp3)
    class func exportVideoPath(videoPath: String, toMp3Path: String, process:((_ progress: Float)->Void)?, success: (()->Void)?, failure: (()->Void)?) {
        guard let mp3Url = URL(string: toMp3Path) else { return }
        
        let m4aPath = mp3Url.deletingPathExtension().appendingPathExtension("m4a").absoluteString
        exportVideoPath(videoPath: videoPath, toM4aPath: m4aPath, process: process, success: {
            if FileManager.default.fileExists(atPath: toMp3Path) {
                try? FileManager.default.removeItem(atPath: toMp3Path)
            }
            //  转换类型
            let converter = ExtAudioConverter()
            converter.inputFile = m4aPath
            converter.outputFile = toMp3Path
            converter.outputFormatID = kAudioFormatMPEGLayer3
            converter.outputFileType = kAudioFileMP3Type
            let result = converter.convert()
            result ? success?() : failure?()
            
        }, failure: failure)
    }
    
    /// 转换视频
    ///
    /// - Parameters:
    ///   - inputPath: 输入url
    ///   - outputPath:输出url
    func transformMoive(inputPath:String,outputPath:String){
        
        let avAsset:AVURLAsset = AVURLAsset(url: URL.init(fileURLWithPath: inputPath), options: nil)
        let assetTime = avAsset.duration
        let duration = CMTimeGetSeconds(assetTime)
        print("视频时长 \(duration)");
        let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: avAsset)
        if compatiblePresets.contains(AVAssetExportPresetLowQuality) {
            let exportSession:AVAssetExportSession = AVAssetExportSession.init(asset: avAsset, presetName: AVAssetExportPresetMediumQuality)!
            
            if FileManager.default.fileExists(atPath: outputPath) {
                try? FileManager.default.removeItem(atPath: outputPath)
            }
            exportSession.outputURL = URL.init(fileURLWithPath: outputPath)
            exportSession.outputFileType = AVFileType.mp4
            exportSession.shouldOptimizeForNetworkUse = true;
            exportSession.exportAsynchronously(completionHandler: {
                switch exportSession.status{
                case .failed:
                    print("失败...\(String(describing: exportSession.error?.localizedDescription))")
                    break
                case .cancelled:
                    print("取消")
                    break;
                case .completed:
                    print("转码成功")
                    //转码成功后获取视频视频地址
                    //上传
                    break;
                default:
                    print("..")
                    break;
                }
            })
        }
    }

    
    //  MARK: 下载音乐
    class func downloadMusic(url: String, completion: ((_ musicLocalPath: String)->Void)?) {
        
        guard let musicUrl = URL(string: url) else { return }
        
        if !FileManager.default.fileExists(atPath: DownloadBgmPath) {
            do {
                try FileManager.default.createDirectory(atPath: DownloadBgmPath, withIntermediateDirectories: true, attributes: nil)
                print("Succes to create folder")
            } catch {
                print("Error to create folder")
            }
        }
        
        
        let musicPath = DownloadBgmPath + "/" + musicUrl.lastPathComponent
        
        if FileManager.default.fileExists(atPath: musicPath) {  //先判断本地是否存在
            completion?(musicPath)
        } else {
            //  下载音乐
            THVideoEditController.downloadTask(urlStr: url, savePath: musicPath, downloadProgress: { (process: Progress) in
                
                let persent: CGFloat = 1.0 * CGFloat(process.completedUnitCount/process.totalUnitCount * 100)
                print("当前线程：%@，加载中%d%%", Thread.current, persent)
                
            }, completionHandler: { (savePath: String) in
                
                completion?(savePath)
                
            }) { (error: Error) in
                print("文件下载失败: %@", error)
            }
        }
    }
    
    
    //  MARK: 文件下载
    class func downloadTask(urlStr: String, savePath: String, downloadProgress: ((_ progress: Progress)->Void)?, completionHandler: ((_ savePath: String)->Void)?, errorHandler: ((_ error: Error)->())?) {
        
        guard let url = URL(string: urlStr) else { return }
        
        Alamofire.download(url) { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
            
            print(savePath)
            return (URL(fileURLWithPath: savePath), [.removePreviousFile, .createIntermediateDirectories])
            
        }.downloadProgress { (process: Progress) in
            
            downloadProgress?(process)
        }.response { (response: DefaultDownloadResponse) in
            print(response)
            if response.error == nil {
                completionHandler?(response.destinationURL?.absoluteString ?? "")
            } else {
                errorHandler?(response.error!)
            }
        }
    }
}
