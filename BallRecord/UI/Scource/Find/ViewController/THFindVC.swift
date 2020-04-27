//
//  THFindVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/17.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import QMUIKit

class ShopItem: NSObject {
    var h : CGFloat?
    var w : CGFloat?
    var price : String?
    var img : String?
}

class THFindVC: THBaseVC {
    
    var itemArray = [THDynamicModel]()
    
    var bannerArr = [THHomeBannerModel]()
    var currentTag = 0 // 选中的列表Tag
    var recommendPage = 0
    var recentPage = 0
    var focusPage = 0
    var recommendArray = [THDynamicModel]()
    var recentArray = [THDynamicModel]()
    var focusArray = [THDynamicModel]()
    let banner = THBannerView()
    
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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0.01;
        layout.minimumInteritemSpacing = 0.01;
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(THHomeCollectionCell.self, forCellWithReuseIdentifier: "THHomeCollectionCell")
        return collectionView
    }()
    lazy var collectionView2 : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0.01;
        layout.minimumInteritemSpacing = 0.01;
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(THHomeCollectionCell.self, forCellWithReuseIdentifier: "THHomeCollectionCell")
        return collectionView
    }()
    lazy var collectionView3 : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0.01;
        layout.minimumInteritemSpacing = 0.01;
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(THHomeCollectionCell.self, forCellWithReuseIdentifier: "THHomeCollectionCell")
        return collectionView
    }()

    let titleView = THFindTitleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        configFrame()
        configData(type: 0, page: 0, completion: nil)
        configRefrash()
    }

}

extension THFindVC {
    
    func configUI() {
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(collectionView)
        scrollView.addSubview(collectionView2)
        scrollView.addSubview(collectionView3)
        
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
    
    func configData(type: Int, page: Int, completion: (()->Void)?) {
        
        let param = ["type": type, "page": page]
        QMUITips.showLoading(in: view)
        THFindRequestManager.requestFindPageData(param: param, successBlock: { (response) in
            completion?()
            QMUITips.hideAllTips()
            
            if page == 0 {
                if type == 0 {
                    self.recommendArray.removeAll()
                } else if type == 1 {
                    self.recentArray.removeAll()
                } else {
                    self.focusArray.removeAll()
                } 
            }
            
            let model = THFindPageModel.yy_model(withJSON: response)
            if model?.list?.count ?? 0 == 0 {
                if type == 0 {
                    self.collectionView.mj_footer?.endRefreshingWithNoMoreData()
                } else if type == 1 {
                    self.collectionView2.mj_footer?.endRefreshingWithNoMoreData()
                } else {
                    self.collectionView3.mj_footer?.endRefreshingWithNoMoreData()
                }
            } else {
                THDynamicController.INSTANCE.cacheNotesDataSource(dataSource: model!.list!)
            }
            
            if type == 0 {
                self.bannerArr = model?.banner ?? []
                self.banner.updateData(array: self.bannerArr)
                self.recommendArray += model?.list ?? []
                self.collectionView.reloadData()
            } else if type == 1 {
                self.recentArray += model?.list ?? []
                self.collectionView2.reloadData()
            } else {
                self.focusArray += model?.list ?? []
                self.collectionView3.reloadData()
            }
            
            
        }) { (error) in
            QMUITips.hideAllTips()
            QMUITips.show(withText: error.localizedDescription)
            completion?()
        }
    }
    
    func configRefrash() {
        
        collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.recommendPage = 0
            self.configData(type: 0, page: self.recommendPage) {
                self.collectionView.mj_header?.endRefreshing()
                self.collectionView.mj_footer?.resetNoMoreData()
            }
        })
        collectionView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.recommendPage += 1
            self.configData(type: 0, page: self.recommendPage) {
                self.collectionView.mj_footer?.endRefreshing()
            }
        })
        collectionView.mj_header?.ignoredScrollViewContentInsetTop = collectionView.contentInset.top
        
        collectionView2.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.recentPage = 0
            self.configData(type: 1, page: self.recentPage) {
                self.collectionView2.mj_header?.endRefreshing()
                self.collectionView2.mj_footer?.resetNoMoreData()
            }
        })
        
        collectionView2.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.recentPage += 1
            self.configData(type: 1, page: self.recentPage) {
                self.collectionView2.mj_footer?.endRefreshing()
            }
        })
        
        collectionView3.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.focusPage = 0
            self.configData(type: 2, page: self.focusPage) {
                self.collectionView3.mj_header?.endRefreshing()
                self.collectionView3.mj_footer?.resetNoMoreData()
            }
        })
        
        collectionView3.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.focusPage += 1
            self.configData(type: 2, page: self.focusPage) {
                self.collectionView3.mj_footer?.endRefreshing()
            }
        })
    }

}
//https://3atv111.com
extension THFindVC: THFindTitleViewDelegate, UIScrollViewDelegate {
    
    func onClickButtonEvent(idx: Int) {
        currentTag = idx
        scrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH * CGFloat(idx), y: 0), animated: false)
        if idx == 0 {
            collectionView.mj_header?.beginRefreshing()
        } else if idx == 1 {
            collectionView2.mj_header?.beginRefreshing()
        } else {
            collectionView3.mj_header?.beginRefreshing()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.scrollView {
            if decelerate == false {
                self.scrollViewDidEndDecelerating(self.scrollView)
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let idx = self.scrollView.contentOffset.x / SCREEN_WIDTH
            if let button = titleView.viewWithTag(Int(idx + 55)) as? UIButton {
                titleView.clickButtonEvent(sender: button)
            }
        }
    }
}

extension THFindVC: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return recommendArray.count
        } else if collectionView == collectionView2 {
            return recentArray.count
        } else {
            return focusArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var model: THDynamicModel?
        if collectionView == self.collectionView {
            model = recommendArray[indexPath.item]
        } else if collectionView == collectionView2 {
            model = recentArray[indexPath.item]
        } else {
            model = focusArray[indexPath.item]
        }
        model = THDynamicController.INSTANCE.getdynamicModel(vid: model!.vid)
        let cell:THHomeCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "THHomeCollectionCell", for: indexPath) as! THHomeCollectionCell
        cell.updateModel(model: model!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        THLoginController.instance.pushLoginVC {
            var model: THDynamicModel?
            if collectionView == self.collectionView {
                model = self.recommendArray[indexPath.item]
            } else if collectionView == self.collectionView2 {
                model = self.recentArray[indexPath.item]
            } else {
                model = self.focusArray[indexPath.item]
            }
            let vc = THVideoDetailVC()
            vc.vid = model?.vid
            vc.aliVideoId = model?.vUrl
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var model: THDynamicModel?
        if collectionView == self.collectionView {
            model = recommendArray[indexPath.item]
        } else if collectionView == collectionView2 {
            model = recentArray[indexPath.item]
        } else {
            model = focusArray[indexPath.item]
        }
        let width = collectionView.bounds.size.width-30
        return CGSize(width: width, height: model!.caculateCellHeight(width: width, fontSize:15))
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
        button.setTitleColor(MAIN_COLOR, for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()
    lazy var recentBtn: UIButton = {
        let button = UIButton()
        button.tag = 56
        button.setTitle("最新", for: .normal)
        button.setTitleColor(COLOR_999999, for: .normal)
        button.setTitleColor(MAIN_COLOR, for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()
    lazy var facusBtn: UIButton = {
        let button = UIButton()
        button.tag = 57
        button.setTitle("关注", for: .normal)
        button.setTitleColor(COLOR_999999, for: .normal)
        button.setTitleColor(MAIN_COLOR, for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var indicator: UIView = {
        let view = UIView()
        view.backgroundColor = MAIN_COLOR
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
        
        if sender.tag == 57 {
            THLoginController.instance.pushLoginVC {
                self.selectBtn?.isSelected = false
                sender.isSelected = true
                self.selectBtn = sender
                UIView.animate(withDuration: 0.2) {
                    self.indicator.centerX = sender.centerX
                    self.delegate?.onClickButtonEvent(idx: sender.tag - 55)
                }
            }
        } else {
            selectBtn?.isSelected = false
            sender.isSelected = true
            self.selectBtn = sender
            UIView.animate(withDuration: 0.2) {
                self.indicator.centerX = sender.centerX
                self.delegate?.onClickButtonEvent(idx: sender.tag - 55)
            }
        }
    }
}
