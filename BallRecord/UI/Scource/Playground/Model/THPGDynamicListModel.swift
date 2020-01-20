//
//  THPGDynamicListModel.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/30.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
@objcMembers
class THPGDynamicListModel: NSObject {
    var videoList: [THDynamicModel]?
    
    ///  容器类 指定key 对应的类
    ///
    ///  - returns: 字典 static
    class func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["videoList": THDynamicModel.self]
    }
}

