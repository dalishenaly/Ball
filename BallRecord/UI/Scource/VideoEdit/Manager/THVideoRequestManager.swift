//
//  THVideoRequestManager.swift
//  BallRecord
//
//  Created by 买超 on 2020/1/8.
//  Copyright © 2020 maichao. All rights reserved.
//

import UIKit

class THVideoRequestManager: NSObject {
    
    /// 视频播放接口
    static func requestPlayInfo(videoId: String, successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        let param = ["videoId": videoId]
        THBaseNetworkManager.shared(subUrl: "/api/video/getPlayInfo")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 视频和封面链接接口
    static func requestPlay(videoId: String, successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        let param = ["videoId": videoId]
        THBaseNetworkManager.shared(subUrl: "/api/video/getPlay")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 视频播放凭证获取
    static func requestVideoPlayAuth(videoId: String, successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        let param = ["videoId": videoId]
        THBaseNetworkManager.shared(subUrl: "/api/video/getVideoPlayAuth")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 获取视频上传地址和凭证
    static func requestUploadAuth(title: String, fileName: String, successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        let param = ["title": title, "fileName": fileName]
        THBaseNetworkManager.shared(subUrl: "/api/video/createUploadVideo")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }

}
