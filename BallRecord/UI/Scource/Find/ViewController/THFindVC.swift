//
//  THFindVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/17.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import SJVideoPlayer
import SafariServices

class ShopItem: NSObject {
    var h : CGFloat?
    var w : CGFloat?
    var price : String?
    var img : String?
}

class THFindVC: THBaseVC {
    
    lazy var itemArray = [THDynamicModel]()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var collectionView : UICollectionView = {
        let layout = THFlowLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.register(THHomeCollectionCell.self, forCellWithReuseIdentifier: "THHomeCollectionCell")
        return collectionView
    }()
    lazy var collectionView2 : UICollectionView = {
        let layout = THFlowLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.register(THHomeCollectionCell.self, forCellWithReuseIdentifier: "THHomeCollectionCell")
        return collectionView
    }()
    lazy var collectionView3 : UICollectionView = {
        let layout = THFlowLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.register(THHomeCollectionCell.self, forCellWithReuseIdentifier: "THHomeCollectionCell")
        return collectionView
    }()
    
    lazy var player: SJVideoPlayer = {
        let player = SJVideoPlayer()
        player.showMoreItemToTopControlLayer = false
        player.rotationManager.isDisabledAutorotation = true
        return player
    }()

    let titleView = THFindTitleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        configFrame()
        configData()
    }

}

extension THFindVC {
    
    func configUI() {
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(collectionView)
        scrollView.addSubview(collectionView2)
        scrollView.addSubview(collectionView3)
        
        let banner = THBannerView()
        banner.top = -banner.height
        collectionView.addSubview(banner)
        
        
        collectionView.contentInset = UIEdgeInsets(top: banner.height, left: 0, bottom: 0, right: 0)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        
        titleView.delegate = self
        navigationItem.titleView = titleView
        
    }
    
    func configFrame() {
        scrollView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView)
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }
        collectionView2.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView).offset(SCREEN_WIDTH)
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }
        collectionView3.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView).offset(SCREEN_WIDTH*2)
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }
        
        
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH * 3, height: scrollView.height)
    }
    
    func configData() {
        
        getDataSource()
//        THFindRequestManager.requestFindPageData(param: [:], successBlock: { (response) in
//            print(response)
//
//        }) { (error) in
//
//        }

    }
    
    func getDataSource() {
        
        let path = Bundle.main.path(forResource: "shop", ofType: "plist")
        let arr = NSArray(contentsOfFile: path!)
        
        for dic in arr! {
//            let shop = ShopItem()
//            let dict = dic as! NSDictionary
//            shop.h = dict["h"] as? CGFloat
//            shop.w = dict["w"] as? CGFloat
//            shop.img = dict["img"] as? String
//            shop.price = dict["price"] as? String
//            itemArray.append(shop)
            
            let model = THDynamicModel()
            let dict = dic as! NSDictionary
            model.title = (dict["price"] as? String)!
            itemArray.append(model)
        }
        collectionView.reloadData()
    }
}

extension THFindVC: THFindTitleViewDelegate, UIScrollViewDelegate {
    
    func onClickButtonEvent(idx: Int) {
        scrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH * CGFloat(idx), y: 0), animated: false)
        
        print("*** scrollView 转换 停止滚动 \(scrollView.contentOffset.x)")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            self.scrollViewDidEndDecelerating(self.scrollView)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        print("*** scrollView 转换 停止滚动 \(self.scrollView.contentOffset.x)")
        let idx = self.scrollView.contentOffset.x / SCREEN_WIDTH
        if let button = titleView.viewWithTag(Int(idx + 55)) as? UIButton {
            titleView.clickButtonEvent(sender: button)
        }
    }
}

extension THFindVC: THCollectionViewFlowLayoutDelegate {
    
    func th_setCellHeght(layout: THFlowLayout, indexPath: NSIndexPath, itemWidth: CGFloat) -> CGFloat {
        /// 获取宽度
        let width: CGFloat = self.collectionView.frame.size.width
        /// 获取列间距总和
        let colMagin: CGFloat = 10
        let cellWidth: CGFloat = (width - 10 - 10 - colMagin) / 2
        
        let item = itemArray[indexPath.item]
        

        return item.caculateCellHeight(width: cellWidth, font: UIFont.systemFont(ofSize: 13))
    }
}

extension THFindVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:THHomeCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "THHomeCollectionCell", for: indexPath) as! THHomeCollectionCell
        setshadow(cell: cell)
        let item = itemArray[indexPath.item]
        cell.titleLabel.text = item.title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = THVideoDetailVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func setshadow(cell: UICollectionViewCell) {
        cell.contentView.layer.cornerRadius = 8.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.contentView.backgroundColor = .white
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowRadius = 2.0   //  阴影扩散半径
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false

        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    }
}


@objc protocol THFindTitleViewDelegate {
    func onClickButtonEvent(idx: Int)
}

class THFindTitleView: UIView {
    
    weak var delegate: THFindTitleViewDelegate?
    
    var selectBtn: UIButton?
    
    lazy var recommendBtn: UIButton = {
        let button = UIButton()
        button.tag = 55
        button.setTitle("推荐", for: .normal)
        button.setTitleColor(COLOR_999999, for: .normal)
        button.setTitleColor(COLOR_333333, for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()
    lazy var recentBtn: UIButton = {
        let button = UIButton()
        button.tag = 56
        button.setTitle("最新", for: .normal)
        button.setTitleColor(COLOR_999999, for: .normal)
        button.setTitleColor(COLOR_333333, for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()
    lazy var facusBtn: UIButton = {
        let button = UIButton()
        button.tag = 57
        button.setTitle("关注", for: .normal)
        button.setTitleColor(COLOR_999999, for: .normal)
        button.setTitleColor(COLOR_333333, for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var indicator: UIView = {
        let view = UIView()
        view.backgroundColor = COLOR_333333
        return view
    }()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 210, height: 44))
        configUI()
        configFrame()
        configData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        addSubview(recommendBtn)
        addSubview(recentBtn)
        addSubview(facusBtn)
        addSubview(indicator)
    }
    
    func configFrame() {
        recommendBtn.frame = CGRect(x: 0, y: 0, width: 70, height: 44)
        recentBtn.frame = CGRect(x: 70, y: 0, width: 70, height: 44)
        facusBtn.frame = CGRect(x: 140, y: 0, width: 70, height: 44)
        selectBtn = recommendBtn
        selectBtn?.isSelected = true
        
        indicator.frame = CGRect(x: 0, y: 42, width: 20, height: 2)
        indicator.centerX = recommendBtn.centerX
    }
    
    func configData() {
        
    }
    
    @objc func clickButtonEvent(sender: UIButton) {
        
        selectBtn?.isSelected = false
        sender.isSelected = true
        self.selectBtn = sender
        UIView.animate(withDuration: 0.2) {
            self.indicator.centerX = sender.centerX
            self.delegate?.onClickButtonEvent(idx: sender.tag - 55)
        }
        
    }
}
