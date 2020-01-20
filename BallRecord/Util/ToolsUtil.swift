//
//  ToolsUtil.swift
//  fq
//
//  Created by 买超 on 2019/11/4.
//  Copyright © 2019 natloc. All rights reserved.
//

import UIKit

/// 拨打电话，弹出提示，拨打完电话回到原来的应用
/// - Parameter phoneNumber: 电话号码字符串
func makePhone(phoneNumber: String) {
    if let url = URL(string: "telprompt://" + phoneNumber) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}


/// 处理自适应富文本设置行间距
/// - Parameter text: 文本
/// - Parameter textColor: 文本颜色
/// - Parameter fontSize: 文本字号
/// - Parameter lineHeight: 行高
/// - Parameter width: label宽度
func handleTextLineHeight(text: String, textColor: UIColor, fontSize:CGFloat, lineHeight: CGFloat, width: CGFloat) -> NSMutableAttributedString {
    
    let font = UIFont.systemFont(ofSize: fontSize)
    let str = text as NSString
    let size = str.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font:font], context: nil)
    
    let attrStr = NSMutableAttributedString(string: text)
    var attributes = [NSAttributedString.Key.foregroundColor : textColor,
                      NSAttributedString.Key.font : font]
    if size.height >= 2 * font.lineHeight {
        //  多行
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        attributes[NSAttributedString.Key.baselineOffset] = (lineHeight - font.lineHeight) / 4 as NSObject
    }
    
    attrStr.addAttributes(attributes, range: NSRange(location: 0, length: attrStr.length))
    
    return attrStr
}


// MARK: - 查找顶层控制器、
/// 获取顶层控制器 根据window
func getTopVC() -> UIViewController? {
    let window = getCurrentShowWindow()
    let vc = window?.rootViewController
    return getTopVC(withCurrentVC: vc)
}

/// 获取TabbarVC
func getTabbarVC() -> THMainTabbarVC? {
    let window = getCurrentShowWindow()
    let vc = window?.rootViewController as? THMainTabbarVC
    return vc
}

/// 获取UIApplication keyWindow
func getCurrentShowWindow() -> UIWindow? {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let window = appDelegate.window
    return window
}

/// 展示NavVC
/// - Parameter index: index
@discardableResult func showNavVC(index: Int) -> THBaseNavVC {
    let rootVC = getTabbarVC()
    rootVC?.selectedIndex = index
    let navVC: THBaseNavVC = rootVC?.children[index] as! THBaseNavVC
    navVC.popToRootViewController(animated: true)
    return navVC
}

/// 根据控制器获取 顶层控制器
func getTopVC(withCurrentVC VC :UIViewController?) -> UIViewController? {
    if VC == nil {
//        LogUtil.debug("找不到顶层控制器")
        return nil
    }
    if let presentVC = VC?.presentedViewController {
        //modal出来的 控制器
        return getTopVC(withCurrentVC: presentVC)
    } else if let tabVC = VC as? UITabBarController {
        // tabBar 的跟控制器
        if let selectVC = tabVC.selectedViewController {
          return getTopVC(withCurrentVC: selectVC)
        }
        return nil
    } else if let naiVC = VC as? UINavigationController {
        // 控制器是 nav
        return getTopVC(withCurrentVC:naiVC.visibleViewController)
    } else {
        // 返回顶控制器
        return VC
    }
}


/// 创建一个函数来将控制器的名字转成具体的类
func stringToVC(vcName:String) -> UIViewController? {
    //获取命名空间
    guard let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
        print("获取失败")
        return nil
    }
    //拼接完整的类
    guard let vcClass = NSClassFromString(namespace + "." + vcName) else {
        print("拼接失败")
        return nil
    }
    //转换成UIViewController
    guard let vcType = vcClass as? UIViewController.Type else {
        print("转换失败")
        return nil
    }
    //根据类型创建对应的控制器
    let vc = vcType.init()
    return vc
}


//  MARK: 查询缓存
func fileSizeOfCache()-> Int {
    // 取出cache文件夹目录 缓存文件都在这个目录下
    let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
    // 缓存目录路径
    // 取出文件夹下所有文件数组
    let fileArr = FileManager.default.subpaths(atPath: cachePath!)
    // 快速枚举出所有文件名 计算文件大小
    var size = 0
    if (fileArr?.count)! > 0 {
        for file in fileArr! {
            // 把文件名拼接到路径中
            let path = (cachePath! as NSString).appending("/\(file)")
            // 取出文件属性
            if FileManager.default.fileExists(atPath: path) {
                let floder = try! FileManager.default.attributesOfItem(atPath: path)
                // 用元组取出文件大小属性
                for (abc, bcd) in floder {
                    // 累加文件大小
                    if abc == FileAttributeKey.size {
                        size += (bcd as AnyObject).integerValue
                    }
                }
            } else {
            }
        }
    }
    let mm = size / 1024 / 1024
    return mm
}

// 清除缓存方法
func clearCacheNow(completion:(()->Void)?) -> Void {
    // 取出cache文件夹目录 缓存文件都在这个目录下
    let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
    // 取出文件夹下所有文件数组
    let fileArr = FileManager.default.subpaths(atPath: cachePath!)
    // 遍历删除
    for file in fileArr! {
        let path = (cachePath! as NSString).appending("/\(file)")
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch {
                
            }
        }
    }
    
    completion?()
}


//MARK: - UIView转UIImage
func getImageFromView(view: UIView) -> UIImage {
// 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(view.size, false, UIScreen.main.scale)
    let context = UIGraphicsGetCurrentContext()
    view.layer.render(in: context!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}

/// 跳转 AppStore
let APP_STORE_URL: String = "itms-apps://itunes.apple.com/app/id"
func gotoAppStore(appId: String){
    if let url = URL(string: APP_STORE_URL + appId), UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}


var milliStamp : CLongLong {
    let timeInterval: TimeInterval = NSDate().timeIntervalSince1970
    let millisecond = CLongLong(round(timeInterval*1000))
    return millisecond
}

class ToolsUtil: NSObject {

}
