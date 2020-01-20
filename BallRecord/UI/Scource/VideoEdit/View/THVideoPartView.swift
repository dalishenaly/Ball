//
//  THVideoPartView.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/17.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit
import QMUIKit

class THVideoPartView: UIView {

    var deleteItemBlock:(()->Void)?
    
    /// 隐藏删除按钮
    var hiddenDelete: Bool = false
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: (self.height - 20) * 1.5, height: self.height - 20)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.bounces = false
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = COLOR_F4F4F4
        collectionView.register(THVideoPartCell.self, forCellWithReuseIdentifier: "THVideoPartCell")
        return collectionView
    }()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 90))
        configUI()
        configFrame()
        configData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension THVideoPartView {
    func configUI() {

        addSubview(collectionView)
    }
    
    func configFrame() {
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.right.equalTo(self).offset(-20)
            make.left.equalTo(self).offset(20)
            make.bottom.equalTo(self)
        }
        
        collectionView.setCorner(cornerRadius: 4)
    }
    
    func configData() {
        
        updateDataSource()
    }
    
    func updateDataSource() {
        collectionView.reloadData()
    }
}

extension THVideoPartView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return THVideoCacheManager.INSTANCE.catVideoArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = THVideoCacheManager.INSTANCE.catVideoArr[indexPath.item]
        
        let cell:THVideoPartCell = collectionView.dequeueReusableCell(withReuseIdentifier: "THVideoPartCell", for: indexPath) as! THVideoPartCell
        
        if model.videoPath != "" {
            let videoPath = documentPath + "/" + model.videoPath
            let coverImg = THVideoEditController.getVideoCoverImage(url: videoPath)
            cell.iconView.image = coverImg
        } else {
            cell.iconView.image = model.coverImage
        }
        cell.numLabel.text = "\(indexPath.item+1)"
        cell.deleteBtn.isHidden = hiddenDelete
        cell.deleteBlock = {
            if THVideoCacheManager.INSTANCE.catVideoArr.count > 1 {
                THVideoCacheManager.INSTANCE.removeVideoPart(video: model)
                collectionView.reloadData()
                self.deleteItemBlock?()
            } else {
                QMUITips.show(withText: "至少保留一个视频片段")
            }
            
        }
        return cell
    }
    
}
