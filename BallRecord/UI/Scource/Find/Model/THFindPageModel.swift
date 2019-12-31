//
//  THFindPageModel.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/9.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THFindPageModel: NSObject {
    
    var type: Int?
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

class THHomeBannerModel: NSObject {
    var type: Int?
    var imageUrl: String?
    var webUrl: String?
}

class THDynamicModel: NSObject {
    
    var vid: String = ""
    var vUrl: String = ""
    var imageUrl: String = ""
    var title: String = ""
    var publisherIcon: String = ""
    var publisherName: String = ""
    var praiseCount: String = ""
    
    
    func caculateCellHeight(width: CGFloat, font: UIFont) -> CGFloat {
        
        var cellH: CGFloat = 0
        //  图片高度
        let imageH = width * 1.2
        cellH += imageH
        cellH += 10
        //  图片高度
        let text: NSString = title as NSString
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
