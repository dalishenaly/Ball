//
//  THMineRequestManager.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/9.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THMineRequestManager: NSObject {

    /// 请求我的
    static func requestMineData(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/user/mine")
            .getRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 请求个人信息
    static func requestPersonalInfo(param:[String: Any]?, successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/user/info")
            .getRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 绑定第三方
    static func requestBindingThird(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/user/bindingThird")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 修改用户信息
    static func requestEditUserInfo(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/user/setting")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 请求我的动态
    static func requestMyDynamicData(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/user/myDynamic")
            .getRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 请求我的消息（评论）
    static func requestMyCommentData(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/user/myComment")
            .getRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 请求我的消息（点赞）
    static func requestMyPraiseData(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/user/myPraise")
            .getRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 请求系统消息
    static func requestSystemNewsData(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/user/systemInfo")
            .getRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 请求我的收藏
    static func requestMyCollectionData(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/user/myCollection")
            .getRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 请求我的粉丝/我的关注
    static func requestMyFansOrConcernData(isFans: Bool, param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        let urlPath = isFans ? "/api/user/myFans" : "/api/user/myConcern"
        THBaseNetworkManager.shared(subUrl: urlPath)
            .getRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 请求意见反馈
    static func requestFeedbackData(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/user/feedback")
            .getRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 提交意见反馈
    static func requestSubmitFeedbackData(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/user/submitFeedback")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 请求我的打球记录
    static func requestMyBasketballRecord(param:[String: Any]?, successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/user/myBasketballRecord")
            .getRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
}
