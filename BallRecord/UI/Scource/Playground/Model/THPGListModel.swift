//
//  THPlaygroundListModel.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/30.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THPGListModel: NSObject {
    var list: [THPGModel]?
    
    ///  容器类 指定key 对应的类
    ///
    ///  - returns: 字典 static
    class func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["list": THPGModel.self]
    }
}

@objcMembers
class THPGModel: NSObject {
    
    var cid: String = "" //列表id
    var imageUrl: String? //
    var name: String? //
    var location: String? //球场位置
    var collectionCount: Int = 0 //收藏个数
    var distince: Int = 0 //    int    距离（当选择热度的时候，这个值是空）
}
