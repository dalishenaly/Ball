//
//  THVideoDetailModel.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/9.
//  Copyright © 2019 maichao. All rights reserved.
//  视频详情Model

import UIKit

@objcMembers
class THVideoDetailModel: NSObject {
    var content: String?
    var publisherIcon: String?    //发布者的头像
    var publisherName: String?    //发布者的名字
    var publisherUid: String?    //发布者的用户id
    var publishTime: String?    //发布时间
    var playCount: Int = 0    //播放次数
    var praiseCount: Int = 0
    var hasConcerned: Bool = false    //是否已关注
    var hasPraise: Bool = false    //是否已点赞
    var hasCollection: Bool = false    //是否已收藏
    var vid: String?
    var vUrl: String?
    var imageUrl: String?
    
    
    var shareImage: String?    //分享的图片
    var shareUrl: String?    //分享的链接
    var commentList: [THCommentModel]?    //评论列表
    
    ///  容器类 指定key 对应的类
    ///
    ///  - returns: 字典 static
    class func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["commentList": THCommentModel.self]
    }
}

@objcMembers
class THCommentModel: NSObject {
    var commentId: String = ""    //评论id
    var commentIcon: String?    //评论者头像
    var commentName: String?    //评论者姓名
    var commentText: String?    //评论内容
    var commentUid: Int = 0    //评论者uid
    var commentTime: String?    //评论时间
    var praiseCount: Int = 0    //点赞个数
    var replyCount: Int = 0    //回复个数
    var hasPraise: Bool = false    //是否点赞
    
    func updateModelPraiseState(hasPraise: Bool) {
        self.hasPraise = hasPraise
        THCommentController.INSTANCE.cacheNote(dynamicModel: self)
    }
}
