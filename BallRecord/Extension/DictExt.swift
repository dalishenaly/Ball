//
//  DictExt.swift
//  BallRecord
//
//  Created by 买超 on 2020/1/5.
//  Copyright © 2020 maichao. All rights reserved.
//

extension Dictionary {
    
    /// 字典转换为JSONString
     /// - Parameter dictionary: 字典参数
    func getJSONStringFromDictionary() -> String {
         if (!JSONSerialization.isValidJSONObject(self)) {
             print("无法解析出JSONString")
             return ""
         }
         let data : NSData! = try? JSONSerialization.data(withJSONObject: self, options: []) as NSData?
         let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
         return JSONString! as String
    }
     
     
     /// 字典合并
     /// - Parameter other: 字典
     mutating func merge<S>(_ other: S)
         where S: Sequence, S.Iterator.Element == (key: Key, value: Value){
             for (k ,v) in other {
                 self[k] = v
         }
     }
}
