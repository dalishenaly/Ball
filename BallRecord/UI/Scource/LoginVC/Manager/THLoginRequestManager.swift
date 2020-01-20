//
//  THLoginRequestManager.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/9.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THLoginRequestManager: NSObject {

    
    /// 注册请求
    static func requestRegisterData(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/register")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 设置新密码
    static func requestSetNewPwd(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/setNewPassword")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    
    /// 账号密码登录
    static func requestLogin(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/login")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 发送验证码   0：注册发送；1：登录发送；2：找回密码发送
    static func requestSendVcode(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/verification")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 第三方登录
    static func requestThirdLogin(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/thirdLogin")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 验证码登录
    static func requestVcodeLogin(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/sign")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 刷新token
    static func requestRefreshToken(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/refreshToken")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
}
