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

extension THBaseVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openMenu() {
                
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .restricted || status == .denied {
            let alert = UIAlertController(title: "提示", message: "请在设备的'设置'中开启相册访问权限", preferredStyle: .alert)
            let camera = UIAlertAction(title: "确定", style: .default) { (action) in
                UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            }
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(camera)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "相机", style: .default) { (action) in
                self.openCameraOrLibrary(sourceType: .camera)
            }
            let album = UIAlertAction(title: "相册", style: .default) { (action) in
                self.openCameraOrLibrary(sourceType: .photoLibrary)
            }
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(camera)
            alert.addAction(album)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
//            self.openCameraOrLibrary(sourceType: .photoLibrary)
        }
    }
    
    /// 打开相机相册
    /// - Parameter sourceType: UIImagePickerController.SourceType
    func openCameraOrLibrary(sourceType: UIImagePickerController.SourceType) -> Void {
                
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        //代理
        imagePicker.delegate = self
        //是否可编辑
        imagePicker.allowsEditing=false
        imagePicker.modalPresentationStyle = .fullScreen
        //打开相机
        present(imagePicker, animated: true,  completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let type: String = info[UIImagePickerController.InfoKey.mediaType] as! String
        //当选择的类型是图片
        if type == "public.image" {
            //获得照片
            var image: UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let timeInterval:TimeInterval = NSDate().timeIntervalSince1970
            let name = "qzImage" + "\(timeInterval).jpg"
            THBaseNetworkManager.shared(subUrl: "/api/upload").uploadImage(imageData: image.pngData()!, fileName: name, successBlock: { (result) in
                
                print("=====")
            }) { (error) in
                
                print("=====")
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        print("save image error")
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
