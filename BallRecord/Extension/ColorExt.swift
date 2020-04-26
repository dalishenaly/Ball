//
//  ColorExt.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/17.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit


let MAIN_COLOR = #colorLiteral(red: 0.4235294118, green: 0.7019607843, blue: 0.4862745098, alpha: 1)
let COLOR_333333 = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
let COLOR_666666 = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
let COLOR_999999 = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
let COLOR_8D97AE = #colorLiteral(red: 0.5529411765, green: 0.5921568627, blue: 0.6823529412, alpha: 1)
let COLOR_F4F4F4 = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
let COLOR_LINE = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
let COLOR_D6E7FD = #colorLiteral(red: 0.8392156863, green: 0.9058823529, blue: 0.9921568627, alpha: 1)
let COLOR_B3D0FB = #colorLiteral(red: 0.7019607843, green: 0.8156862745, blue: 0.9843137255, alpha: 1)
let COLOR_E7E7E7 = #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1)

let BTN_PRESSED = #colorLiteral(red: 1, green: 0.768627451, blue: 0.003921568627, alpha: 1)
let BTN_DISABLE = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
let SHADOW: UIColor = .black  //
let BTN_GET_CODE_ENABLE = #colorLiteral(red: 0.09019607843, green: 0.6666666667, blue: 0.9490196078, alpha: 1)  // 17AAF2
let BTN_GET_CODE_DISABLE = #colorLiteral(red: 0.7529411765, green: 0.8, blue: 0.8549019608, alpha: 1)  // C0CCDA
let BTN_NAV_BACK = #colorLiteral(red: 0.368627451, green: 0.4274509804, blue: 0.5098039216, alpha: 1)  // 5E6D82
let BTN_NAV_TITLE = #colorLiteral(red: 0.1960784314, green: 0.2509803922, blue: 0.3411764706, alpha: 1)  // 324057

let COLOR_FFDD00 = #colorLiteral(red: 1, green: 0.8666666667, blue: 0, alpha: 1)
let COLOR_FFF5B3 = #colorLiteral(red: 1, green: 0.9607843137, blue: 0.7019607843, alpha: 1)
let COLOR_FFDD00_10 = #colorLiteral(red: 1, green: 0.8666666667, blue: 0, alpha: 0.1)
let COLOR_5E6D82 = #colorLiteral(red: 0.368627451, green: 0.4274509804, blue: 0.5098039216, alpha: 1)
let COLOR_324057 = #colorLiteral(red: 0.1960784314, green: 0.2509803922, blue: 0.3411764706, alpha: 1)
let COLOR_E5E9F2 = #colorLiteral(red: 0.8980392157, green: 0.9137254902, blue: 0.9490196078, alpha: 1)
let COLOR_222222 = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
let COLOR_C0CCDA = #colorLiteral(red: 0.7529411765, green: 0.8, blue: 0.8549019608, alpha: 1)
let COLOR_8492A6 = #colorLiteral(red: 0.5176470588, green: 0.5725490196, blue: 0.6509803922, alpha: 1)
let COLOR_FFC300 = #colorLiteral(red: 1, green: 0.7647058824, blue: 0, alpha: 1)
let COLOR_475669 = #colorLiteral(red: 0.2784313725, green: 0.337254902, blue: 0.4117647059, alpha: 1)
let COLOR_FF8026 = #colorLiteral(red: 1, green: 0.5019607843, blue: 0.1490196078, alpha: 1)
let COLOR_0076FF = #colorLiteral(red: 0, green: 0.462745098, blue: 1, alpha: 1)
let COLOR_259EF5 = #colorLiteral(red: 0.1450980392, green: 0.6196078431, blue: 0.9607843137, alpha: 1)
let COLOR_FA6400 = #colorLiteral(red: 0.9803921569, green: 0.3921568627, blue: 0, alpha: 1)
let COLOR_F7B500 = #colorLiteral(red: 0.968627451, green: 0.7098039216, blue: 0, alpha: 1)
let COLOR_18AAF2 = #colorLiteral(red: 0.09411764706, green: 0.6666666667, blue: 0.9490196078, alpha: 1)
let COLOR_F5F7FA = #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1)
let COLOR_99A9BF = #colorLiteral(red: 0.6, green: 0.662745098, blue: 0.7490196078, alpha: 1)
let COLOR_F9FAFC = #colorLiteral(red: 0.9764705882, green: 0.9803921569, blue: 0.9882352941, alpha: 1)
let COLOR_FC4447 = #colorLiteral(red: 0.9882352941, green: 0.2666666667, blue: 0.2784313725, alpha: 1)
let COLOR_FFF2EA = #colorLiteral(red: 1, green: 0.9490196078, blue: 0.9176470588, alpha: 1)


extension UIColor {
    
    /**
     将16进制数字转换成颜色
     
     - parameter colorString: 16进制字符串
     
     - returns: 返回相对应的颜色
     */
    class func colorWithString(_ colorString:String, alpha: Float) -> UIColor{
        
        var cString:String = colorString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.count != 6) {
            return UIColor.gray
        }
        
        //截取传进来的字符串 To(截取到哪一位) From(从哪一位开始截取)
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        //创建颜色的值,并将十六进制转换成十进制
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(alpha))
        
    }

    /**
     将16进制数字转换成颜色
     
     - parameter colorString: 16进制字符串
     
     - returns: 返回相对应的颜色
     */
    class func colorWithString(_ colorString:String) -> UIColor{
        
        return self.colorWithString(colorString, alpha: 1)
    }
    
    class func randomColor() -> UIColor {
        let r = CGFloat(arc4random()%255)/255.0
        let g = CGFloat(arc4random()%255)/255.0
        let b = CGFloat(arc4random()%255)/255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}
