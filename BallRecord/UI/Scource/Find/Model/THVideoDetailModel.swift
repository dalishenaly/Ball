//
//  THVideoDetailModel.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/9.
//  Copyright © 2019 maichao. All rights reserved.
//  视频详情Model

import UIKit

class THVideoDetailModel: NSObject {

    var publisherIcon: String?    //发布者的头像
    var publisherName: String?    //发布者的名字
    var publisherUid: String?    //发布者的用户id
    var publishTime: String?    //发布时间
    var playCount: Int?    //播放次数
    var hasConcerned: Bool?    //是否已关注
    var hasPrice: Bool?    //是否已点赞
    var shareImage: String?    //分享的图片
    var shareUrl: Bool?    //分享的链接
    var hasCollection: Bool?    //是否已收藏
    var commentList: [THCommentModel]?    //评论列表
    
    ///  容器类 指定key 对应的类
    ///
    ///  - returns: 字典 static
    class func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["commentList": THCommentModel.self]
    }
}

class THCommentModel: NSObject {
    var commentId: String?    //评论id
    var commentIcon: String?    //评论者头像
    var commentName: String?    //评论者姓名
    var commentText: String?    //评论内容
    var commentUid: Int?    //评论者uid
    var commentTime: String?    //评论时间
    var priceCount: Int?    //点赞个数
    var replyCount: Int?    //回复个数
    var hasPrice: Bool?    //是否点赞
}
