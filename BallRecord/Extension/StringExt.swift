//
//  StringExt.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/17.
//  Copyright © 2019 maichao. All rights reserved.
//

import Foundation

extension String {
    
    /// 文件是否存在
    func filePathExists() -> Bool {
       return FileManager.default.fileExists(atPath: self)
    }
}
