//
//  THFindRequestManager.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/17.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THFindRequestManager: NSObject {
    
    /// 请求发现页数据
    static func requestFindPageData(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/home/listPage")
            .getRequest(params: nil, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 请求视频详情页数据
    static func requestVideoDetailData(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/home/videoDetail")
            .getRequest(params: nil, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 收藏视频
    static func requestCollection(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/home/collection")
            .postRequest(params: nil, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 关注
    static func requestConcerna(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/home/concern")
            .postRequest(params: nil, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 点赞
    static func requestPraise(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/home/praise")
            .postRequest(params: nil, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 评论回复
    static func requestCommentOrReply(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/home/commentOrReply")
            .postRequest(params: nil, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 查看回复
    static func requestLookReply(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/home/getReply")
            .getRequest(params: nil, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    
}
