//
//  THMainTabbarVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/17.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THMainTabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configChildVC()
    }
    
    
    func configChildVC() {
        
        self.viewControllers = [
            THBaseNavVC(rootViewController: THFindVC())
                .setTabBarItem(title: "发现",
                               image: UIImage(named: "tabbar_find_normal"),
                               selectedImage: UIImage(named: "tabbar_find_selected")),
            THBaseNavVC(rootViewController: THPlaygroundVC())
                .setTabBarItem(title: "球场",
                               image: UIImage(named: "tabbar_ground_normal"),
                               selectedImage: UIImage(named: "tabbar_ground_selected")),
            THBaseNavVC(rootViewController: THMineVC())
                .setTabBarItem(title: "我的",
                               image: UIImage(named: "tabbar_mine_normal"),
                               selectedImage: UIImage(named: "tabbar_mine_selected"))
        ]
        
        // 选中
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : MAIN_COLOR], for: .selected)
        

        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().isTranslucent = false
        
        view.backgroundColor = .white
        
        tabBar.tintColor = MAIN_COLOR
    }

}

extension THMainTabbarVC {
    
    func sj_topViewController() -> UIViewController {
        if self.selectedIndex == NSNotFound {
            return self.viewControllers!.first!
        }
        return self.selectedViewController!
    }
    
    override var shouldAutorotate: Bool {
        return self.sj_topViewController().shouldAutorotate
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.sj_topViewController().supportedInterfaceOrientations
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.sj_topViewController().preferredInterfaceOrientationForPresentation
    }
}


