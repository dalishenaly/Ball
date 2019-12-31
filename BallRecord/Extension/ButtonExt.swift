//
//  ButtonExt.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/3.
//  Copyright © 2019 maichao. All rights reserved.
//

import Foundation

enum XButtonEdgeInsetsStyle {
    case ImageTop //图片在上，文字在下
    case ImageLeft //图片在上，文字在下
    case ImageBottom //图片在上，文字在下
    case ImageRight //图片在上，文字在下
}

extension UIButton {
    /**
     ># Important:按钮图文位置设置
     知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
     *  如果只有title，那它上下左右都是相对于button的，image也是一样；
     *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     */
    func layoutButtonWithEdgInsetStyle(_ style: XButtonEdgeInsetsStyle,_ space:CGFloat){
        //获取image宽高
        let imageW = self.imageView?.frame.size.width
        let imageH = self.imageView?.frame.size.height
        //获取label宽高
        var lableW = self.titleLabel?.intrinsicContentSize.width
        let lableH = self.titleLabel?.intrinsicContentSize.height
        
        var imageEdgeInsets:UIEdgeInsets = .zero
        var lableEdgeInsets:UIEdgeInsets = .zero
        if self.frame.size.width <= lableW! { //如果按钮文字超出按钮大小，文字宽为按钮大小
            lableW = self.frame.size.width
        }
        //根据传入的 style 及 space 确定 imageEdgeInsets和labelEdgeInsets的值
        switch style {
        case .ImageTop:
            imageEdgeInsets = UIEdgeInsets(top: 0.0 - lableH! - space/2.0, left: 0, bottom: 0, right: 0.0 - lableW!)
            lableEdgeInsets = UIEdgeInsets(top: 0, left: 0.0 - imageW!, bottom: 0.0 - imageH! - space/2.0, right: 0)
        case .ImageLeft:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0.0 - space/2.0, bottom: 0, right: space/2.0)
            lableEdgeInsets = UIEdgeInsets(top: 0, left: space/2.0, bottom: 0, right: 0.0 - space/2.0)
        case .ImageBottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0.0 - lableH! - space/2.0, right: 0.0 - lableW!)
            lableEdgeInsets = UIEdgeInsets(top: 0.0 - imageH! - space/2.0, left: 0.0 - imageW!, bottom: 0, right: 0)
        case .ImageRight:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: lableW! + space/2.0, bottom: 0, right: 0.0 - lableW! - space/2.0)
            lableEdgeInsets = UIEdgeInsets(top: 0, left: 0.0 - imageW! - space/2.0, bottom: 0, right: imageW! + space/2.0)
        }
        //赋值
        self.titleEdgeInsets = lableEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
        
    }
}
