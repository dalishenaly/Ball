//
//  THBaseNavVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/17.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THBaseNavVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    func setTabBarItem(title: String, image: UIImage?, selectedImage: UIImage?) -> Self{
        tabBarItem = UITabBarItem(
            title: title,
            image: image,
            selectedImage: selectedImage
        )
//        tabBarItem.setTitleTextAttributes([
//            .foregroundColor: COLOR_8492A6,
//            .font: UIFont.systemFont(ofSize: 10)
//            ], for: .normal)
//
//        tabBarItem.setTitleTextAttributes([
//            .foregroundColor: COLOR_222222,
//            .font: UIFont.systemFont(ofSize: 10)
//            ], for: .selected)
        
        
        view.backgroundColor = .white
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        return self
    }

}

extension THBaseNavVC {

    override var shouldAutorotate: Bool {
        return self.topViewController!.shouldAutorotate
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController!.supportedInterfaceOrientations
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.topViewController!.preferredInterfaceOrientationForPresentation
    }
    
    func childViewControllerForStatusBarStyle() -> UIViewController {
        return self.topViewController!
    }
    
    func childViewControllerForStatusBarHidden() -> UIViewController {
        return self.topViewController!
    }
}
