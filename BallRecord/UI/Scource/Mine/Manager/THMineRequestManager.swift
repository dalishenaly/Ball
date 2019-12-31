//
//  THMineRequestManager.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/9.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THMineRequestManager: NSObject {

    /// 请求视频详情页数据
    static func requestMineData(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/user/mine")
            .getRequest(params: nil, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    /// 收藏视频
    static func requestCollection(param:[String: Any], successBlock: @escaping successHandler, errorBlock: @escaping errorHandler) {
        
        THBaseNetworkManager.shared(subUrl: "/api/home/collection")
            .postRequest(params: nil, successBlock: successBlock, errorBlock: errorBlock)
    }
}
