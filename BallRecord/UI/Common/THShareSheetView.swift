//
//  THShareSheetView.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/1.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THShareSheetView: UIView {
    let shareText = "球志让您随时随地观看、编辑制作、分享自己打球的精彩时刻。"

    @IBOutlet weak var stackBGView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var weChatView: UIView!
    @IBOutlet weak var timeLineView: UIView!
    @IBOutlet weak var qqView: UIView!
    @IBOutlet weak var weiboView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    @IBAction func clickCancelEvent(_ sender: Any) {
        
        removeFromSuperview()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stackBGView.setCorner(cornerRadius: 8)
        cancelBtn.setCorner(cornerRadius: 8)
        
        addGesture()
    }
    
    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickWeChatView))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(clickTimeLineView))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(clickQQView))
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(clickWeiBoView))

        weChatView.addGestureRecognizer(tap)
        timeLineView.addGestureRecognizer(tap2)
        qqView.addGestureRecognizer(tap3)
        weiboView.addGestureRecognizer(tap4)
    }
    
    override func draw(_ rect: CGRect) {
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
    }
    
    static func showAlert() {
        let shareView = THShareSheetView.loadNib()
        if let window = UIApplication.shared.delegate?.window {
            window?.addSubview(shareView)
        }
    }
    
    @objc func clickWeChatView() {
        let params: NSMutableDictionary = NSMutableDictionary()
        params.ssdkSetupShareParams(byText: shareText, images: "http://www.mob.com/images/logo_black.png", url: URL(string: "www.baidu.com"), title: "baidu", type: .auto)
        ShareSDK.share(.subTypeWechatSession, parameters: params) { (state: SSDKResponseState, userData: [AnyHashable : Any]?, contentEntity: SSDKContentEntity?, error: Error?) in
            
            switch state {
                case .success:
                    break
                case .fail:
                    break
                case .cancel:
                    break
                default:
                    break
            }
        }
    }
    
    @objc func clickTimeLineView() {
        let params: NSMutableDictionary = NSMutableDictionary()
        params.ssdkSetupShareParams(byText: "", images: [], url: URL(string: ""), title: "", type: .auto)
        ShareSDK.share(.subTypeWechatTimeline, parameters: params) { (state: SSDKResponseState, userData: [AnyHashable : Any]?, contentEntity: SSDKContentEntity?, error: Error?) in
            
            switch state {
                case .success:
                    break
                case .fail:
                    break
                case .cancel:
                    break
                default:
                    break
            }
        }
    }
    
    @objc func clickQQView() {
        let params: NSMutableDictionary = NSMutableDictionary()
        params.ssdkSetupShareParams(byText: shareText, images: "http://www.mob.com/images/logo_black.png", url: URL(string: "www.baidu.com"), title: "baidu", type: .auto)
        ShareSDK.share(.subTypeQQFriend, parameters: params) { (state: SSDKResponseState, userData: [AnyHashable : Any]?, contentEntity: SSDKContentEntity?, error: Error?) in
            
            switch state {
                case .success:
                    break
                case .fail:
                    break
                case .cancel:
                    break
                default:
                    break
            }
        }
    }
    
    @objc func clickWeiBoView() {
        let params: NSMutableDictionary = NSMutableDictionary()
        params.ssdkSetupShareParams(byText: "", images: [], url: URL(string: ""), title: "", type: .auto)
        ShareSDK.share(.typeSinaWeibo, parameters: params) { (state: SSDKResponseState, userData: [AnyHashable : Any]?, contentEntity: SSDKContentEntity?, error: Error?) in
            
            switch state {
                case .success:
                    break
                case .fail:
                    break
                case .cancel:
                    break
                default:
                    break
            }
        }
    }
    
    func shareReusltHandle() {
        
    }
}


extension UIView {
    
    static func loadNib(_ nibNmae :String? = nil) -> Self{
        return Bundle.main.loadNibNamed(nibNmae ?? "\(self)", owner: nil, options: nil)?.first as! Self
    }
    
    
    func setCornerWith(rectCorner: UIRectCorner, Radius: CGFloat) {
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: Radius, height: Radius))
        let shareLayer = CAShapeLayer()
        shareLayer.frame = bounds
        shareLayer.path = path.cgPath
        self.layer.mask = shareLayer
    }
}


extension UIView {
    
    private struct AssociatedKey {
        static var identifier: String = "identifier"
        static var isSpeed: String = "isSpeed"
    }
       
    public var identifier: String {
       get {
           return objc_getAssociatedObject(self, &AssociatedKey.identifier) as? String ?? ""
       }
       set {
           objc_setAssociatedObject(self, &AssociatedKey.identifier, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
       }
    }
    
    public var isSpeed: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.isSpeed) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.isSpeed, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
