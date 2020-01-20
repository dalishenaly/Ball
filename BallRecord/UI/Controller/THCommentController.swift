//
//  THCommentController.swift
//  BallRecord
//
//  Created by 买超 on 2020/1/7.
//  Copyright © 2020 maichao. All rights reserved.
//

import UIKit

class THCommentController: NSObject {

    static let INSTANCE = THCommentController()
    /// 评论数据内存缓存
    private var commentCacheDict: [String: THCommentModel] = [:]
    
    
    /// 缓存评论数据
    /// - Parameter dataSource: 笔记Model数组
    func cacheNotesDataSource(dataSource: [THCommentModel]) {
        dataSource.forEach { (dynamicModel) in
            commentCacheDict[dynamicModel.commentId] = dynamicModel
        }
    }
    
    
    /// 缓存单个评论数据
    /// - Parameter dynamicModel: 动态Model
    func cacheNote(dynamicModel: THCommentModel) {
        commentCacheDict[dynamicModel.commentId] = dynamicModel
    }
    
    
    /// 获取评论model
    /// - Parameter commentId: commentId
    func getCommentModel(commentId: String) -> THCommentModel? {
        if commentCacheDict.keys.contains(commentId) {
            return commentCacheDict[commentId]
        } else {
            return nil
        }
    }
    
    /// 清空评论数据缓存
    func clearNotesDataSource() {
        commentCacheDict.removeAll()
    }
}
