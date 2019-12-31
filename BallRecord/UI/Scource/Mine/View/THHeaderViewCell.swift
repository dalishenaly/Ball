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
        nameLabel.textColor = COLOR_333333
        phoneLabel.textColor = COLOR_999999
        iconTopCos.constant = STATUS_BAR_HEIGHT + 40
        configBtnTopCos.constant = STATUS_BAR_HEIGHT + 20
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
        
        myDynamicView.addGestureRecognizer(tap1)
        myRoughView.addGestureRecognizer(tap2)
        myNewsView.addGestureRecognizer(tap3)
    }
    
    @objc func clickMyDynamic() {
        delegate?.onClickMyDynamic()
    }
    @objc func clickMyRough() {
        delegate?.onClickMyRough()
    }
    @objc func clickMyNews() {
        delegate?.onClickMyNews()
    }
    
    @IBAction func clickMoreEvent(_ sender: Any) {
        delegate?.onClickMoreEvent()
    }
    @IBAction func clickConfigEvent(_ sender: Any) {
        delegate?.onClickConfigEvent()
    }
}
