//
//  RulerShapeView.swift
//  WHRuler
//
//  Created by Walden on 17/4/17.
//  Copyright © 2017年 Walden. All rights reserved.
//

import UIKit


class RulerView: UIView {
    
    /// 获取shapelayer
    var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        return shapeLayer
    }()

    
    /// 尺子的长度
    var rulerLength: Double = 300
    /// 刻度的宽度, 刻度之间的间隔
    var dialBlank: Double = 10.0
    /// 刻度分割最小的高度
    var dialMinHeight: Double = 6
    /// 刻度分割最大的高度
    var dialMaxHeight: Double = 13
    /// 刻度的颜色
    var dialColor: UIColor = UIColor.gray
    /// 文字颜色
    var textColor: UIColor = UIColor.darkText
    /// 刻度尺显示的刻度范围
    var dialRange: Range = Range(uncheckedBounds: (0, 0))
    /// 每个刻度表示的宽度
    var dialSpan: Int = 100
    
    
    // 配置
    func displayRuler() {
        layer.addSublayer(shapeLayer)
        //计算尺子长度
        rulerLength = Double((dialRange.upperBound - dialRange.lowerBound) / dialSpan) * dialBlank
        let bzier = UIBezierPath()
        
        let lineY = Double(bounds.size.height - 26)
        var x = 0.0
        let space = dialBlank
        let minHeight = dialMinHeight
        let maxHeight = dialMaxHeight
        
        let scope = (dialRange.lowerBound / dialSpan)...(dialRange.upperBound / dialSpan)
        for index in scope {
            
            var y: Double = minHeight
            if index % 5 == 0 {
                y = maxHeight
                let graduate = Double(index * dialSpan)
                addNumLabel(centerX: x, graduate: graduate)
            }
            bzier.move(to: CGPoint(x: x, y: lineY))
            bzier.addLine(to: CGPoint(x: x, y: lineY + y))
            
            x += space
        }
        
        // 底部的横线
        bzier.move(to: CGPoint(x: 0, y: lineY))
        bzier.addLine(to: CGPoint(x: rulerLength, y: lineY))
        
        // 顶部的横线
        bzier.move(to: CGPoint(x: 0, y: 0))
        bzier.addLine(to: CGPoint(x: rulerLength, y: 0))
        
        shapeLayer.path = bzier.cgPath
        shapeLayer.strokeColor = dialColor.cgColor
        shapeLayer.lineWidth = 0.3
    }
    
    func displayRulerContent(arr: [videoModel]) {
        
        arr.forEach { (model: videoModel) in
            
            let sting1 = model.startTime.components(separatedBy: " ").last ?? "00:00"
            let beginTime = sting1.components(separatedBy: ".").first!
            
            let shapeLayer = CAShapeLayer()
            layer.addSublayer(shapeLayer)
            
            let startTime = getSecondFromHHMMSS(HHMMSS: beginTime)
            
            let firstX = Double(startTime - dialRange.lowerBound) / Double(dialSpan) * dialBlank
            let width = Double(model.duration) / Double(dialSpan) * dialBlank
            let rect = CGRect(x: firstX, y: 0, width: width, height: 69)
            let bzier = UIBezierPath(rect: rect)
            bzier.stroke()
            
            shapeLayer.path = bzier.cgPath
            shapeLayer.fillColor = COLOR_F4F4F4.cgColor
            shapeLayer.lineWidth = 0.3
        }
    }
    
    /// 添加一个数字label
    func addNumLabel(centerX: Double, graduate: Double) {
        
        let label = UILabel()
        addSubview(label)
        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: 11)
        label.text = getHHMMFromSS(totalTime: Int(graduate))
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 0, width: 50, height: 13)
        label.center = CGPoint(x: centerX, y: Double(self.bounds.size.height - 6))
    }
    
    
    /// 根据给定的offset, 计算出据此OffSet最近的刻度offset
    func closestOffset(offset: CGPoint) -> CGPoint {
        let targetGraduated = lround(Double(offset.x) / dialBlank)
        return CGPoint(x: Double(targetGraduated) * dialBlank, y: 0.0)
    }
    
    /// 给个指定的contentOffset, 计算出具体的数字
    func calcCurrentFigure(offset: CGPoint) -> Double {
        let figure = Double(dialRange.lowerBound) + Double(offset.x) / rulerLength * Double(dialRange.upperBound - dialRange.lowerBound)
        return figure
    }

}


func getHHMMFromSS(totalTime: Int) -> String {
    let hourStr = NSString(format: "%02ld", totalTime/3600)
    let minStr = NSString(format: "%02ld", totalTime%3600/60)
    return NSString(format: "%@:%@", hourStr, minStr) as String
}


func getHHMMSSFromSS(totalTime: Int) -> String {
        let hourStr = NSString(format: "%02ld", totalTime/3600)
        let minStr = NSString(format: "%02ld", totalTime%3600/60)
        let secondStr = NSString(format: "%02ld", totalTime%60)
        return NSString(format: "%@:%@:%@", hourStr, minStr, secondStr) as String
    }


func getSSFromHHMM(HHMM: String) -> Int {
    let time1 = (HHMM.components(separatedBy: ":").first! as NSString).intValue * 3600
    let time2 = (HHMM.components(separatedBy: ":").last! as NSString).intValue * 60
    return Int(time1 + time2)
}

func getSecondFromHHMMSS(HHMMSS: String) -> Int {
    let arr = HHMMSS.components(separatedBy: ":")
    
    var second = 0
    for (idx, str) in arr.reversed().enumerated() {
        let time = str as NSString
        if idx == 0 {
            second += time.integerValue
        } else if idx == 1 {
            second += time.integerValue * 60
        } else {
            second += time.integerValue * 60 * 60
        }
    }
    return second
}






