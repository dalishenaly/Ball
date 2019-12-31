//
//  THPlaygroundManager.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/9.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THPlaygroundManager: NSObject {

    /// 请求城市列表
    static func requestCityListData(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/court/cityChoose")
            .getRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    
    /// 请求球场列表
    static func requestPlaygroundListData(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/court/list")
            .getRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 请求球场详情
    static func requestPlaygroundDetailData(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/court/detail/court")
            .getRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 请求球场动态
    static func requestPlayGroundDynamicData(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "api/court/detail/dynamic")
            .getRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 请求球场评论
    static func requestPlaygroundCommentData(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/court/detail/comment")
            .getRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    
    /// 球场关注
    static func requestPlaygroundFocus(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/court/detail/concern")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 球场写评论
    static func requestPlaygroundWriteComment(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/court/detail/comment")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 请求背景音乐
    static func requestBGMListData(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/court/backgroundAudio")
            .getRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 动态发布
    static func requestPublishVideo(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/court/uploadVideo")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
}
