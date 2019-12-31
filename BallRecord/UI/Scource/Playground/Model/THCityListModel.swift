//
//  THCityListModel.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/30.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THCityListModel: NSObject {
    var citys: [THCityModel]?
    
    ///  容器类 指定key 对应的类
    ///
    ///  - returns: 字典 static
    class func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["citys": THCityModel.self]
    }
}

class THCityModel: NSObject {
    var cityId: Int?
    var cityName: String?
}

