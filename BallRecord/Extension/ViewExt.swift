//
//  ViewExt.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/27.
//  Copyright © 2019 maichao. All rights reserved.
//

import Foundation

extension UIView {
    
    func setCorner(cornerRadius: CGFloat, masksToBounds: Bool = true, borderColor: UIColor? = nil, borderWidth: CGFloat? = nil) {
        
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = masksToBounds
        
        if let color = borderColor {
            self.layer.borderColor = color.cgColor
        }
        if let width = borderWidth {
            self.layer.borderWidth = width
        }
    }
    
    /// 添加圆角和阴影 radius:圆角半径 shadowOpacity: 阴影透明度 (0-1) shadowColor: 阴影颜色
    func addRoundedOrShadow(radius:CGFloat, shadowOpacity:CGFloat, shadowColor:UIColor)  {
        
        self.layer.cornerRadius = radius
//        self.layer.masksToBounds = true
        let subLayer = CALayer()
        subLayer.frame = self.bounds
        subLayer.cornerRadius = radius
        subLayer.backgroundColor = UIColor.white.cgColor
        subLayer.masksToBounds = false
        subLayer.shadowColor = shadowColor.cgColor // 阴影颜色
        subLayer.shadowOffset = CGSize(width: 0, height: 0) // 阴影偏移,width:向右偏移3，height:向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = Float(shadowOpacity) //阴影透明度
        subLayer.shadowRadius = 3;//阴影半径，默认3
//        self.layer.addSublayer(subLayer)
        self.layer.insertSublayer(subLayer, at: 0)
//         self.superview?.layer.insertSublayer(subLayer, : subLayer)
     }
}


// MARK:- 标题
extension UITabBarItem{
    
    // MARK: 颜色
    
    /// 标题颜色：normal 状态
    var nat_titleColor: UIColor?{
        get{ return __nat_getTitleColor(state: .normal) }
        set(newValue){ __nat_setTitleColor(state: .normal, color: newValue) }
    }
    
    /// 标题颜色：selected 状态
    var nat_titleSelectedColor: UIColor?{
        get{ return __nat_getTitleColor(state: .selected) }
        set(newValue){ __nat_setTitleColor(state: .selected, color: newValue) }
    }
    
    /// 根据状态获取标题颜色
    private func __nat_getTitleColor(state: UIControl.State) -> UIColor?{
        self.titleTextAttributes(for: state)?[.foregroundColor] as? UIColor
    }
    
    /// 根据状态设置标题颜色
    private func __nat_setTitleColor(state: UIControl.State, color: UIColor?){
        var attrArr: [NSAttributedString.Key: Any] = self.titleTextAttributes(for: state) ?? [:]
        
        if nil == color{
            attrArr.removeValue(forKey: .foregroundColor)
        }else{
            attrArr[.foregroundColor] = color
        }
        
        self.setTitleTextAttributes(attrArr, for: state)
    }
    
    
    
    // MARK: 字体
    
    /// 标题字体：normal 状态
    var nat_titleFont: UIFont?{
        get{ return __nat_getTitleFont(state: .normal) }
        set(newValue){ __nat_setTitleFont(state: .normal, font: newValue) }
    }
    
    /// 标题字体：normal 状态
    var nat_titleSelectedFont: UIFont?{
        get{ return __nat_getTitleFont(state: .selected) }
        set(newValue){ __nat_setTitleFont(state: .selected, font: newValue) }
    }
    
    /// 根据状态获取标题字体
    private func __nat_getTitleFont(state: UIControl.State) -> UIFont?{
        self.titleTextAttributes(for: state)?[.font] as? UIFont
    }
    
    /// 根据状态设置标题字体
    private func __nat_setTitleFont(state: UIControl.State, font: UIFont?){
        var attrArr: [NSAttributedString.Key: Any] = self.titleTextAttributes(for: state) ?? [:]
        
        if nil == font{
            attrArr.removeValue(forKey: .font)
        }else{
            attrArr[.font] = font
        }
        
        self.setTitleTextAttributes(attrArr, for: state)
    }
    
    
}
