//
//  THBottomAlert.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/18.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

class THBottomAlert: UIView {

    var actionBlock: (()->Void)?
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        actionBtn.setCorner(cornerRadius: 2)
        
        if #available(iOS 11.0, *) {
            contentView.layer.cornerRadius = 18
            contentView.layer.maskedCorners = CACornerMask(arrayLiteral: [CACornerMask.layerMinXMinYCorner, CACornerMask.layerMaxXMinYCorner])
        } else {
            contentView.addCorner(with: [.topRight, .topLeft], cornerSize: CGSize(width: 18, height: 18))
        }
    }

    
    @IBAction func clickCancelBtn(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func clickActionBtn(_ sender: Any) {
        actionBlock?()
        dismiss()
    }
    
    @discardableResult class func show() -> THBottomAlert {
        let alert = THBottomAlert.loadNib()
        if let window = UIApplication.shared.delegate?.window {
            window?.addSubview(alert)
        }
        return alert
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    
    override func draw(_ rect: CGRect) {
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
    }

}
