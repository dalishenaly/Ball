//
//  THIndicateView.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/18.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THIndicateView: UIView {

    let triangleW: CGFloat = 10 // 三角形宽度
    let lineW: CGFloat = 2
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        MAIN_COLOR.setFill()
        
        //画最上面的三角
        context?.move(to: CGPoint(x: (self.width - triangleW)/2, y: 0))
        context?.addLine(to: CGPoint(x: self.width/2, y: 8))
        context?.addLine(to: CGPoint(x: self.width/2 + triangleW/2, y: 0))
        context?.fillPath()
        
        //画矩形
        context?.fill(CGRect(x: (self.width - 2)/2, y: CGFloat(5), width: lineW, height: self.height - 5))

    }

}
