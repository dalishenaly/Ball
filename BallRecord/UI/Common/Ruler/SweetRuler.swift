//
//  WHRulerScrollView.swift
//  WHRuler
//
//  Created by Walden on 17/4/17.
//  Copyright © 2017年 Walden. All rights reserved.
//

import UIKit

protocol SweetRulerDelegate: NSObjectProtocol {
    ///刻度尺代理方法
    func sweetRuler(ruler: SweetRuler, figure: Int)
}

class SweetRuler: UIView {
    
    weak var delegate: SweetRulerDelegate?
    
    /// 刻度尺表示的范围
    var figureRange = Range(uncheckedBounds: (16 * 3600, 18 * 3600))
    /// 尺子的长度
    var rulerLength: Double = 300
    /// 刻度的宽度, 刻度之间的间隔
    var dialBlank: Double = 20.0
    /// 刻度分割最小的高度
    var dialMinHeight: Double = 6
    /// 刻度分割最大的高度
    var dialMaxHeight: Double = 13
    /// 刻度的颜色
    var dialColor: UIColor = UIColor.gray
    /// 每个刻度表示的宽度
    var dialSpan: Int = 360
    /// 文字颜色
    var textColor: UIColor = UIColor.darkText
    var videoArr = [videoModel]()
    
    private var selectFigure: Int = 0
    
    // 当前的中点
    var currentPoint: Double?
    
    
    /// 懒加载rlerView, 并进行简单配置
    lazy var rulerView = { () -> RulerView in
        let rulerView = RulerView()
        return rulerView
    }()
    
    /// 懒加载 scrollView
    lazy var scrollView = { () -> UIScrollView in
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    /// 中间蓝线
    lazy var indicate: THIndicateView = {
        let indicate = THIndicateView(frame: CGRect(x: 100, y: 100, width: 10, height: 100))
        return indicate
    }()
    
    lazy var indicateTimeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = MAIN_COLOR
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configUI() {
        backgroundColor = UIColor.white
        
        addSubview(scrollView)
        scrollView.addSubview(rulerView)
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.3)   //降低手指离开屏幕后scrollView的滚动速度
        
        addSubview(indicate)
        addSubview(indicateTimeLabel)
    }
    
    
    func setSelectFigure(figure: Int) {
        selectFigure = figure
        let x = Double(Double(selectFigure - figureRange.lowerBound) / Double(figureRange.upperBound - figureRange.lowerBound) * rulerLength)
        let offset = CGPoint(x: x, y: 0)
        scrollView.setContentOffset(offset, animated: false)
        calcTargetOffset(scrollView: scrollView)
    }
    
    func setContentArr(arr: [videoModel]) {
        videoArr = arr
        rulerView.displayRulerContent(arr: arr)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = bounds
        
        indicateTimeLabel.frame = CGRect(x: bounds.size.width/2 - 100, y: 0, width: 200, height: 15)
        indicate.frame = CGRect(x: bounds.size.width/2 - 5, y: 25 - 7, width: 10, height: bounds.size.height - 25 - 26 + 7)
        
        let rulerY = Double(Double(frame.size.height) - 95)
        rulerLength = Double(figureRange.upperBound - figureRange.lowerBound) / Double(dialSpan) * dialBlank
        rulerView.frame = CGRect(x: Double(frame.size.width/2), y: rulerY, width: rulerLength, height: 95)
        rulerView.dialRange = figureRange
        rulerView.rulerLength = rulerLength
        rulerView.dialBlank = dialBlank
        rulerView.dialMinHeight = dialMinHeight
        rulerView.dialMaxHeight = dialMaxHeight
        rulerView.dialColor = dialColor
        rulerView.dialSpan = dialSpan
        rulerView.textColor = textColor
        
        rulerView.displayRuler()
        
        rulerView.displayRulerContent(arr: self.videoArr)
        
        scrollView.contentSize = CGSize(width: rulerView.rulerLength + Double(frame.size.width), height: 30.0)
        
        //设置起始位置
        let x = Double(Double(selectFigure - figureRange.lowerBound) / Double(figureRange.upperBound - figureRange.lowerBound) * rulerLength)
        let offset = CGPoint(x: x, y: 0)
        scrollView.setContentOffset(offset, animated: false)
        calcTargetOffset(scrollView: scrollView)
        
        print("contentSize: \(scrollView.contentSize)")
        print("rulerView.frame: \(rulerView.frame)")
    }
    
}


extension SweetRuler: UIScrollViewDelegate {
    
    // 拖拽结束走的方法
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        scrollViewDidEndDecelerating(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
//        calcTargetOffset(scrollView: scrollView)
        
        var inVideo = false
        let figure = Int(rulerView.calcCurrentFigure(offset: scrollView.contentOffset))
        videoArr.forEach { (model: videoModel) in
            
            let sting = model.startTime.components(separatedBy: " ").last ?? "00:00"
            let beginTime = sting.components(separatedBy: ".").first!
            let startSecond = getSecondFromHHMMSS(HHMMSS: beginTime)
            
            if startSecond < figure && figure < startSecond + Int(model.duration) {
                inVideo = true
                return
            }
        }
        
        if inVideo == false {
            
            let arr = videoArr.filter {
                let sting = $0.startTime.components(separatedBy: " ").last ?? "00:00"
                let beginTime = sting.components(separatedBy: ".").first!
                let startSecond = getSecondFromHHMMSS(HHMMSS: beginTime)
                return figure < startSecond
            }
            if let nextModel = arr.first {
                let sting = nextModel.startTime.components(separatedBy: " ").last ?? "00:00"
                let beginTime = sting.components(separatedBy: ".").first!
                let startSecond = getSecondFromHHMMSS(HHMMSS: beginTime)
                setSelectFigure(figure: startSecond)
            } else {
                let sting = videoArr.last?.endTime.components(separatedBy: " ").last ?? "00:00"
                let endTime = sting.components(separatedBy: ".").first!
                let endSecond = getSecondFromHHMMSS(HHMMSS: endTime)
                setSelectFigure(figure: endSecond)
            }
            
        } else {
            calcTargetOffset(scrollView: scrollView)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        calcTargetOffset(scrollView: scrollView)
    }
    
    
    
    /// 拖拽结束后, 重新计算应该滑动到的位置, 并用动画滑动到指定位置
    func calcTargetOffset(scrollView: UIScrollView) {
        
        var figure = Int(rulerView.calcCurrentFigure(offset: scrollView.contentOffset))
        if figure < figureRange.lowerBound {
            figure = figureRange.lowerBound
        }
        if figure > figureRange.upperBound {
            figure = figureRange.upperBound
        }
        
        indicateTimeLabel.text = getHHMMSSFromSS(totalTime: figure)
        delegate?.sweetRuler(ruler: self, figure: figure)
    }
    
}












