//
//  ImageExt.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/8.
//  Copyright © 2019 maichao. All rights reserved.
//

import Foundation

extension UIImage {
    
    class func getImage(videoUrl: String) -> UIImage {
        var url: URL?
        if videoUrl.contains("http") {
            url = URL(string: videoUrl)
        } else {
            url = URL(fileURLWithPath: videoUrl)
        }
        
        let asset = AVURLAsset(url: url!)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let time: CMTime = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600) // 取第0秒， 一秒600帧
        var actualTime: CMTime = CMTimeMake(value: 0, timescale: 0)
        let cgImage: CGImage = try! generator.copyCGImage(at: time, actualTime: &actualTime)
        
        return UIImage(cgImage: cgImage)
    }
}
