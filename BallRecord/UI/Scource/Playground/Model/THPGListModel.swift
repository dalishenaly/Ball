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

class THPGModel: NSObject {
    var cid: Int? //    int    列表id
    var imageUrl: Int? //    int    列表图片
    var title: Int? //    int    视频标题
    var location: Int? //    int    视频位置
    var collectionCount: Int? //    int    收藏个数
    var distance: Int? //    int    距离（当选择热度的时候，这个值是空）
    var isCollection: Bool? //    bool    是否已关注
}
