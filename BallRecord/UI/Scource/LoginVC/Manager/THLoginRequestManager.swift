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
        
        THBaseNetworkManager.shared(subUrl: "/api/user/register")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 设置新密码
    static func requestSetNewPwd(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/user/setNewPassword")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    
    /// 账号密码登录
    static func requestLogin(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/user/login")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 发送验证码
    static func requestSendVcode(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/user/getVcode")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 第三方登录
    static func requestThirdLogin(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/user/thirdLogin")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 验证码登录
    static func requestVcodeLogin(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/user/register")
            .postRequest(params: param, successBlock: successBlock, errorBlock: errorBlock)
    }
}
