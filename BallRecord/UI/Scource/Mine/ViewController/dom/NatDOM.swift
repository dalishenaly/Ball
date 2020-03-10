//
//  NatDOM.swift
//  fq
//
//  Created by natloc on 2019/9/5.
//  Copyright © 2019 natloc. All rights reserved.
//

import Foundation


class NatDOM{
    
    /// 获取在 document 的 head 中追加元素的 js 语法字符串
    static func getAppendDocumentHeadElemJs(elem: NatDOM.Element?) -> String{
        var retStr: String = ""
        if nil != elem{
            retStr += "var elem = document.createElement('\(elem!.mName)');"
            
            elem?.mAttrDict.forEach{
                retStr += "elem.setAttribute('\($0.key)', '\($0.value)');"
            }
            
            if let innerHTML: String = elem?.mInnerHTML{
                retStr += "elem.innerHTML = '\(innerHTML)';"
            }
            
            retStr += "document.head.appendChild(elem);"
        }
        return retStr
    }
    
    
    /// 元素
    class Element{
        /// 元素名
        let mName: String
        
        /// 属性字典
        var mAttrDict: [String: String] = [:]
        
        var mInnerHTML: String = ""
        
        
        init?(name: String?){
            let argName: String = name?.trim() ?? ""
            if argName.isEmpty{
                return nil
            }
            
            mName = argName
            appendInnerHTML("*{ margin:0; }")
        }
        
        /// 添加属性
        @discardableResult func setAttr(key: String?, value: String?) -> Self{
            let argKey: String = key?.trim() ?? ""
            let argValue: String = value?.trim() ?? ""
            if argKey.isNotEmpty && argValue.isNotEmpty{
                mAttrDict[argKey] = argValue
            }
            return self
        }
        
        
        @discardableResult func setInnerHTML(_ text: String?) -> Self{
            mInnerHTML = text ?? ""
            return self
        }
        
        @discardableResult func appendInnerHTML(_ text: String?) -> Self{
            mInnerHTML += text ?? ""
            return self
        }
        
    }
    
    /// style 元素
    class StyleElement: Element{
        
        init(){
            super.init(name: "style")!
            self.setAttr(key: "type", value: "text/css")
        }
        
    }
    
    
    class ViewportMetaElement: Element{
        
        init(){
            super.init(name: "meta")!
            
            setAttr(key: "name", value: "viewport")
            setAttr(key: "content", value: "width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no")
        }
        
    }
    
    
}


extension String {
    /// 去除左右空白字符
    func trim() -> String{
        return self.trimmingCharacters(in: CharacterSet(arrayLiteral: " ", "\t", "\n"))
    }
    
    /// 是否非空字符串
    var isNotEmpty: Bool{ return !self.isEmpty }
}
