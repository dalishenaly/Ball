//
//  THMyDynamicVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/27.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THMyDynamicVC: THBaseVC {

    lazy var dataArray = [THDynamicModel]()
    var page: Int = 0
    lazy var collectionView : UICollectionView = {
        let layout = THFlowLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(THHomeCollectionCell.self, forCellWithReuseIdentifier: "THHomeCollectionCell")
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的动态"
        
        configUI()
        configFrame()
        configRefresh()
        configData()
    }
    
    func configRefresh() {
        collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.headerRefreshing()
        })
        collectionView.mj_header?.beginRefreshing()
        
        collectionView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.footerRefreshing()
        })
        collectionView.mj_footer?.ignoredScrollViewContentInsetBottom = isiPhoneX() ? 34 : 0
    }
    
    
//    override func configData() {
//        requestData(completion: nil)
//    }
    
    func headerRefreshing() {
        page = 0
        requestData {
            self.collectionView.mj_header?.endRefreshing()
            self.collectionView.mj_footer?.resetNoMoreData()
        }
    }
    
    func footerRefreshing() {
        page += 1
        requestData {
            self.collectionView.mj_footer?.endRefreshing()
        }
    }
    
    func requestData(completion: (()->Void)?) {
        QMUITips.showLoading(in: view)
        let param = ["page": page]
        THMineRequestManager.requestMyDynamicData(param: param, successBlock: { (result) in
            QMUITips.hideAllTips()
            completion?()
            let modelArr = NSArray.yy_modelArray(with: THDynamicModel.self, json: result) as! [THDynamicModel]
            if self.page == 0 {
                self.dataArray.removeAll()
            }
            if modelArr.count <= 0 {
                self.collectionView.mj_footer?.endRefreshingWithNoMoreData()
            }
            self.dataArray += modelArr

            self.collectionView.reloadData()
        }) { (error) in
            QMUITips.hideAllTips()
            completion?()
        }
    }
}

extension THMyDynamicVC {
    
    func configUI() {
        view.addSubview(collectionView)
    }
    
    func configFrame() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    func configData() {
    }
    
}

extension THMyDynamicVC: THCollectionViewFlowLayoutDelegate {
    
    func th_setCellHeght(layout: THFlowLayout, indexPath: NSIndexPath, itemWidth: CGFloat) -> CGFloat {
        /// 获取宽度
        let width: CGFloat = self.collectionView.frame.size.width
        /// 获取列间距总和
        let colMagin: CGFloat = 10
        let cellWidth: CGFloat = (width - 10 - 10 - colMagin) / 2
        
        let item = self.dataArray[indexPath.item]
        

        return item.caculateCellHeight(width: cellWidth, font: UIFont.systemFont(ofSize: 13))
    }
}

extension THMyDynamicVC: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:THHomeCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "THHomeCollectionCell", for: indexPath) as! THHomeCollectionCell
        setshadow(cell: cell)
        let model = self.dataArray[indexPath.item]
        cell.updateModel(model: model)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataArray[indexPath.item]
        let vc = THVideoDetailVC()
        vc.vid = model.vid
        vc.aliVideoId = model.vUrl
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
