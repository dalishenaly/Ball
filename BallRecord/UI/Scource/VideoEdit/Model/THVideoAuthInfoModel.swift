//
//  THVideoAuthInfoModel.swift
//  BallRecord
//
//  Created by 买超 on 2020/1/8.
//  Copyright © 2020 maichao. All rights reserved.
//

import UIKit

@objcMembers
class THVideoAuthInfoModel: NSObject {

    var RequestId: String?  // 25818875-5F78-4A13-BEF6-D7393642CA58",
    var VideoId: String?  // 93ab850b4f6f44eab54b6e91d24d81d4",
    var UploadAddress: String?  // eyJTZWN1cml0eVRva2VuIjoiQ0FJU3p3TjF",
    var UploadAuth: String?  // eyJFbmRwb2ludCI6Im"
}

@objcMembers
class THVideoPlayInfoListModel: NSObject {
    
    var PlayInfoList: PlayInfoListModel?
}


@objcMembers
class PlayInfoListModel: NSObject {
    
    var PlayInfo: [PlayInfoModel]?
    
    class func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["PlayInfo": PlayInfoModel.self]
    }
}


@objcMembers
class PlayInfoModel: NSObject {
    var PlayURL: String?
}

@objcMembers
class UploadVideoModel: NSObject {
    var vid: String?
}

@objcMembers
class THVideoInfoModel: NSObject {
    
    var cover: String?
    var url: String?
}
