//
//  THFindPageModel.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/9.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
@objcMembers
class THFindPageModel: NSObject {
    
    var type: Int = 0
    var banner: [THHomeBannerModel]?
    var list: [THDynamicModel]?
    
    ///  容器类 指定key 对应的类
    ///
    ///  - returns: 字典 static
    class func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["banner": THHomeBannerModel.self,
                "list": THDynamicModel.self]
    }
}
@objcMembers
class THHomeBannerModel: NSObject {
    var material_id: Int?
    var imgUrl: String?
    var webUrl: String?
}

@objcMembers
class THDynamicModel: NSObject {
    
    var vid: String = ""
    var vUrl: String = ""
    var imageUrl: String = ""
    var content: String = ""
    var publisherIcon: String = ""
    var publisherName: String = ""
    var praiseCount: Int = 0
    var hasPraise: Bool?
//    "praiseName": "",
//    "praiseTime": "2020-01-07 15:48:35",
//    "vid": 1,
//    "vUrl": "",
//    "imageUrl": "",
//    "content": "\u7403\u573a\u98de\u4eba",
//    "praiseCount": 0
    func caculateCellHeight(width: CGFloat, font: UIFont) -> CGFloat {
        
        var cellH: CGFloat = 0
        //  图片高度
        let imageH = width * 1.2
        cellH += imageH
        cellH += 10
        //  图片高度
        let text: NSString = content as NSString
        let size = CGSize(width: width, height:1000) //CGSizeMake(width,1000)
        let dic = NSDictionary(object: font, forKey : kCTFontAttributeName as! NSCopying)
        let textSize = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key:Any], context:nil).size
        let lineH = font.lineHeight * 2
        cellH += (textSize.height > lineH ? lineH : textSize.height)
        cellH += 10
        //  头像高度
        cellH += 25
        cellH += 12
        return cellH
    }
}
