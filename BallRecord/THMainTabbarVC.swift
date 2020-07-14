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
        let userHasAgreePromiss = UserDefaults.standard.bool(forKey: "userHasAgreePromiss")
        if userHasAgreePromiss == false {
            let contents = ["        我们深知个人信息对您的重要性，并会尽全力保护您的个人信息安全可靠。我们致力于维持您对我们的信任，恪守以下原则，保护您的个人信息：权责一致原则、目的明确原则、选择同意原则、最少够用原则、确保安全原则、主体参与原则、公开透明原则等。同时，我们承诺，我们将按业界成熟的安全标准，采取相应的安全保护措施来保护您的个人信息。","1.我们如何收集和使用您的个人信息。","2.我们如何共享、转让、公开披露您的个人信息。","3.我们如何使用 Cookie 和同类技术。","4.我们如何共享、转让、公开披露您的个人信息。"]
            weak var weakSelf = self
            THPrivateAlertService.shared.show(with: contents, in:self.view , agreeCallback: {
                        UserDefaults.standard.set(true, forKey: "userHasAgreePromiss");
                        weakSelf?.configChildVC()
                   }, disAgreeCallback: {
                        exit(1)
                   }, userProCallback: {
                    //用户协议
                        let url = BASEURL + "/secret/userPolicy.html"
                        let vc = THBaseWebViewVC(urlString: url)
                        vc.title = "用户协议"
                        weakSelf?.present(vc, animated: true, completion: nil)
                   }, privateProCallback: {
                    //隐私协议
                        let url = BASEURL + "/secret/privacyPolicy.html"
                        let vc = THBaseWebViewVC(urlString: url)
                        vc.title = "隐私政策"
                        weakSelf?.present(vc, animated: true, completion: nil)
                   })
            return;
        }
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
    
    func sj_topViewController() -> UIViewController? {
        if self.selectedIndex == NSNotFound {
            return self.viewControllers?.first
        }
        return self.selectedViewController
    }
    
    override var shouldAutorotate: Bool {
        return self.sj_topViewController()?.shouldAutorotate ?? false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.sj_topViewController()?.supportedInterfaceOrientations ?? UIInterfaceOrientationMask.portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.sj_topViewController()?.preferredInterfaceOrientationForPresentation ?? UIInterfaceOrientation.portrait
    }
}


