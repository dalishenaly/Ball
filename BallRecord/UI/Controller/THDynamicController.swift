//
//  THDynamicController.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/9.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THDynamicController: NSObject {

    static let INSTANCE = THDynamicController()
    /// 动态数据内存缓存
    private var dynamicCacheDict: [String: THDynamicModel] = [:]
    
    
    /// 缓存动态数据
    /// - Parameter dataSource: 笔记Model数组
    func cacheNotesDataSource(dataSource: [THDynamicModel]) {
        dataSource.forEach { (dynamicModel) in
            dynamicCacheDict[dynamicModel.vid] = dynamicModel
        }
    }
    
    
    /// 缓存单个动态数据
    /// - Parameter dynamicModel: 动态Model
    func cacheNote(dynamicModel: THDynamicModel) {
        dynamicCacheDict[dynamicModel.vid] = dynamicModel
    }
    
    
    /// 获取动态model
    /// - Parameter vid: vid
    func getdynamicModel(vid: String) -> THDynamicModel? {
        if dynamicCacheDict.keys.contains(vid) {
            return dynamicCacheDict[vid]
        } else {
            return nil
        }
    }
    
    /// 清空动态数据缓存
    func clearNotesDataSource() {
        dynamicCacheDict.removeAll()
    }
}
