//
//  THBannerView.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/4.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import FSPagerView

class THBannerView: UIView {

    var bannerArr = [THHomeBannerModel]()
    
    lazy var viewPager: FSPagerView = {
        let viewPager = FSPagerView()
        viewPager.dataSource = self
        viewPager.delegate = self
        viewPager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "FSPagerViewCell")
        //设置自动翻页事件间隔，默认值为0（不自动翻页）
        viewPager.automaticSlidingInterval = 4.0
        //设置页面之间的间隔距离
        viewPager.interitemSpacing = 8.0
        //设置可以无限翻页，默认值为false，false时从尾部向前滚动到头部再继续循环滚动，true时可以无限滚动
        viewPager.isInfinite = true
        return viewPager
    }()
    lazy var pagerControl:FSPageControl = {
        let pageControl = FSPageControl()
        //设置下标位置
        pageControl.contentHorizontalAlignment = .center
        //设置下标指示器颜色（选中状态和普通状态）
        pageControl.setFillColor(COLOR_E5E9F2, for: .normal)
        pageControl.setFillColor(COLOR_5E6D82, for: .selected)
        return pageControl
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "推荐动态"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = COLOR_333333
        label.isHidden = true
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
  
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 205))
        
        configUI()
        configFrame()
        updateData(array: [])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        
        addSubview(viewPager)
        addSubview(pagerControl)
        addSubview(titleLabel)
    }
    
    func configFrame() {
        viewPager.frame = CGRect(x: 15, y: 10, width: SCREEN_WIDTH - 30, height: 143)
        pagerControl.frame = CGRect(x: 15, y: viewPager.frame.maxY + 6, width: SCREEN_WIDTH - 30, height: 10)
        titleLabel.frame = CGRect(x: 15, y: pagerControl.frame.maxY + 6, width: SCREEN_WIDTH - 30, height: 20)
    }
    
    func updateData(array: [THHomeBannerModel]) {
        self.bannerArr = array
        self.viewPager.reloadData()
    }
}

extension THBannerView: FSPagerViewDelegate, FSPagerViewDataSource {
    
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        //设置下标的个数
        pagerControl.numberOfPages = self.bannerArr.count
        return self.bannerArr.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let model = self.bannerArr[index]
        let cell: FSPagerViewCell = pagerView.dequeueReusableCell(withReuseIdentifier: "FSPagerViewCell", at: index)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.setCorner(cornerRadius: 8)
        cell.imageView?.sd_setImage(with: URL(string: model.imgUrl ?? ""), completed: nil)
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        pagerControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        pagerControl.currentPage = pagerView.currentIndex
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
        let model = self.bannerArr[index]
        let currentVC = getTopVC()
        let vc = THBaseWebViewVC(urlString: model.webUrl ?? "")
        vc.hidesBottomBarWhenPushed = true
        currentVC?.navigationController?.pushViewController(vc, animated: true)
//        THReplyListView.show()
    }
}
