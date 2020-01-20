//
//  THBGMListModel.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/30.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

@objcMembers
class THBGMListModel: NSObject {
    var audioList: [THBGMTypeModel]?
}

@objcMembers
class THBGMTypeModel: NSObject {
    var audioType: String?
    var subList: [THBGMModel]?
    
    ///  容器类 指定key 对应的类
    ///
    ///  - returns: 字典 static
    class func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["subList": THBGMModel.self]
    }
}

@objcMembers
class THBGMModel: NSObject {
    var audioName: String?
    var audioUrl: String?
    var hasDownload: Bool?
    
    /// bgm下载临时Temp目录下的路径
    var musicTempPath: String?
    /// bgm保存在Document目录下的路径 (相对路径，需拼接沙盒目录，因为二次安装app沙盒目录会变)
    var musicPath: String?
}

