//
//  THCityListModel.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/30.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

@objcMembers
class THCityListModel: NSObject {
    var citys: [THCityModel]?
    
    ///  容器类 指定key 对应的类
    ///
    ///  - returns: 字典 static
    class func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["citys": THCityModel.self]
    }
}

@objcMembers
class THCityModel: NSObject {
    var cityCode: Int = 0
    var city: String = ""
    var hasSelect: Bool = false
//    init(cityCode: Int, city: String) {
//        super.init()
//        self.cityCode = cityCode
//        self.city = city
//    }
}

