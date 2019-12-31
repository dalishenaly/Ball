//
//  THReplyListModel.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/9.
//  Copyright © 2019 maichao. All rights reserved.
//  回复listmodel

import UIKit

class THReplyListModel: NSObject {
    var replyList: [THReplyModel]?
    
    ///  容器类 指定key 对应的类
    ///
    ///  - returns: 字典 static
    class func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["replyList": THReplyModel.self]
    }
    
}

class THReplyModel: NSObject {
    var replyId: String?    //回复id（因为评论和回复可能太多，int类型怕不够长，建议使用string）
    var replyIcon: String?    //回复者头像
    var replyName: String?    //回复者姓名
    var replyUid: Int?    //回复者id
    var replyText: String?    //回复内容
    var publishTime : String?   //发布时间
}




