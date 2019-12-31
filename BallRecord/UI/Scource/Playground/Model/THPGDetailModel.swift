//
//  THPlaygroundDetailModel.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/30.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THPGDetailModel: NSObject {
    var videoList: [THPGVideoModel]? //视频列表组
    var introduction: THPGIntroModel?   //球场简介
}

class THPGVideoModel: NSObject {
    var cvid: Int? //    int    视频id
    var imageUrl: String? //    string    视频图片链接
    var title: String? //    string    视频标题
    var playCount: String? //    string    视频播放次数
}

class THPGIntroModel: NSObject {
    var location: String? //    string    球场地址
    var phoneNumber: String? //    string    联系电话
    var businessTime: String? //    string    营业时间
    var chargeStandard: String? //    string    收费标准
    var courtIntroduce: String? //    string    球场简介
}

