//
//  THHeaderViewCell.swift
//  BallRecord
//
//  Created by 买超 on 2019/11/27.
//  Copyright © 2019 maichao. All rights reserved.
//

import UIKit

@objc protocol THHeaderViewCellDelegate {
    func onClickMyDynamic()
    func onClickMyRough()
    func onClickMyNews()
    func onClickConfigEvent()
    func onClickMoreEvent()
}

class THHeaderViewCell: UITableViewCell {
    
    weak var delegate: THHeaderViewCellDelegate?
    
    @IBOutlet weak var iconTopCos: NSLayoutConstraint!
    @IBOutlet weak var configBtnTopCos: NSLayoutConstraint!
    
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var myDynamicView: UIView!
    @IBOutlet weak var myRoughView: UIView!
    @IBOutlet weak var myNewsView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.isUserInteractionEnabled = true
        nameLabel.textColor = COLOR_333333
        phoneLabel.textColor = COLOR_999999
        iconTopCos.constant = STATUS_BAR_HEIGHT + 40
        configBtnTopCos.constant = STATUS_BAR_HEIGHT + 20
        iconView.image = placeholder_header
        iconView.setCorner(cornerRadius: 35)
        addGesture()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addGesture() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(clickMyDynamic))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(clickMyRough))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(clickMyNews))
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(clickLogin))
        myDynamicView.addGestureRecognizer(tap1)
        myRoughView.addGestureRecognizer(tap2)
        myNewsView.addGestureRecognizer(tap3)
        nameLabel.addGestureRecognizer(tap4)
    }
    
    @objc func clickMyDynamic() {
        THLoginController.instance.pushLoginVC {
            self.delegate?.onClickMyDynamic()
        }
    }
    @objc func clickMyRough() {
        THLoginController.instance.pushLoginVC {
            self.delegate?.onClickMyRough()
        }
    }
    @objc func clickMyNews() {
        THLoginController.instance.pushLoginVC {
            self.delegate?.onClickMyNews()
        }
    }
    @objc func clickLogin() {
        THLoginController.instance.pushLoginVC(hasLogin: nil)
    }
    
    @IBAction func clickMoreEvent(_ sender: Any) {
        THLoginController.instance.pushLoginVC {
            self.delegate?.onClickMoreEvent()
        }
    }
    @IBAction func clickConfigEvent(_ sender: Any) {
        THLoginController.instance.pushLoginVC {
            self.delegate?.onClickConfigEvent()
        }
    }
}
