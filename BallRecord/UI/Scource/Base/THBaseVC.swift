//
//  THBaseVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/17.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THBaseVC: UIViewController {

    var backButtonItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configBackBtn()
    }

}

extension THBaseVC {
    
    func navigationPushVC(vc: UIViewController, animated: Bool = true) {
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: animated)
    }
}

extension THBaseVC: UIGestureRecognizerDelegate {
    
    // 重写导航栏返回按钮方法
    func configBackBtn() -> Void {
        // 返回按钮
        let backButton = UIButton(type: .custom)
        // 给按钮设置返回箭头图片
        backButton.setImage(UIImage(named: "nav_back_icon"), for: .normal)
        // 设置frame
        backButton.frame = CGRect(x: 200, y: 13, width: 18, height: 18)
        backButton.addTarget(self, action: #selector(goBackItemClicked), for: .touchUpInside)
        // 自定义导航栏的UIBarButtonItem类型的按钮
        backButtonItem = UIBarButtonItem(customView: backButton)
        // 重要方法，用来调整自定义返回view距离左边的距离
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = -5
        
        navigationItem.backBarButtonItem?.image = nil
        navigationItem.backBarButtonItem?.title = ""
        navigationItem.backBarButtonItem = nil
        navigationItem.hidesBackButton = true
        
        if !self.isEqual(self.navigationController?.children[0]) {
            // 返回按钮设置成功
            navigationItem.leftBarButtonItems = [spaceItem, backButtonItem]
        }
        
        //启用滑动返回（swipe back）
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
    }
    
    //是否允许手势
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        if (gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer) {
            let VCcount: NSInteger = (navigationController?.viewControllers.count)!
            //只有二级以及以下的页面允许手势返回
            if VCcount > 1 {
                return true
            }
            return false
        }
        return true
    }
    
    @objc func goBackItemClicked() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
}

extension THBaseVC {
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
