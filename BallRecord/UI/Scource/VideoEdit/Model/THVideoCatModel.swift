//
//  THVideoCatModel.swift
//  BallRecord
//
//  Created by 买超 on 2020/1/12.
//  Copyright © 2020 maichao. All rights reserved.
//

import UIKit

@objcMembers
class THVideoInterceptModel: NSObject {

    var correntTime: String? //    当前日期
    var videoList: Dictionary<String, Any>?   //    array    视频片段列表
    var itemList: [THTimeModel]?    //    array    日期列表
    
    class func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["itemList": THTimeModel.self]
    }
}

@objcMembers
class THCatVideoModel: NSObject {
        
    var fragmentId: String? //    int    视频片段id
    var startTime: Int = 0 //    string    视频片段开始时间
    var endTime: Int = 0 //    string    视频片段结束时间
    var duration: Int = 0 //    int    视频片段时长
    var image: String? //    string    视频片段图片
    var videoUrl: String? //    string    视频片段视频地址
}

@objcMembers
class THTimeModel: NSObject {

    var timeId: String? //    int    日期id
    var itemTime: String? //    string    显示日期
}
