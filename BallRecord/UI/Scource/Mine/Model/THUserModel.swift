//
//  THUserModel.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/9.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

@objcMembers
class THUserModel: NSObject, NSCoding {
    var uid: String = ""
    var token: String = ""
    
    func encode(with aCoder: NSCoder) {
        yy_modelEncode(with: aCoder)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init()
        yy_modelInit(with: aDecoder)
    }
    
    override init() {
        super.init()
    }
}
