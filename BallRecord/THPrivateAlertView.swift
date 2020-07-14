//
//  THPrivateAlertView.swift
//  BallRecord
//
//  Created by 二美子 on 2020/7/14.
//  Copyright © 2020 maichao. All rights reserved.
//

import UIKit
import SnapKit
let kw = UIScreen.main.bounds.width
let kh = UIScreen.main.bounds.height

func realWidth(width: CGFloat) -> CGFloat {
    return (kw/375) * width
}

class THPrivateAlertService: NSObject {
    
    static let shared = THPrivateAlertService() //线程不安全

    var maskrView = UIView()
    var privateAlertView = THPrivateAlertView()
    
    func show(with contents: [String], in view:UIView, agreeCallback: @escaping()->Void,disAgreeCallback: @escaping()->Void,userProCallback: @escaping()->Void,privateProCallback: @escaping()->Void) {
        let maskView = UIView()
        self.maskrView = maskView
        view.addSubview(maskView)
        maskView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        maskView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        maskView.layoutIfNeeded()
//        let tap = UITapGestureRecognizer(target: self, action: #selector(maskViewTapAction(tap:)))
//        maskView.addGestureRecognizer(tap)
        let privateView = THPrivateAlertView(frame: CGRect.zero, contents: contents)
        view.addSubview(privateView)
        self.privateAlertView = privateView
        privateAlertView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(kw - 60)
            make.height.equalTo(realWidth(width: 400))
        }
        privateAlertView.layer.cornerRadius = 5
        privateAlertView.layer.masksToBounds = true
        self.animationWithView(view: privateAlertView, duration: 0.5)
        privateView.agreeCallBack = {
            self.dismiss()
            agreeCallback()
        }
        privateView.disAgreeCallBack = {
            disAgreeCallback()
        }
        privateView.userProtocol = {
            userProCallback()
        }
        privateView.privateProtocol = {
            privateProCallback()
        }
    }
    
    func animationWithView(view: UIView,duration: TimeInterval) {
        let animation = CAKeyframeAnimation.init(keyPath: "transform")
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        var values = [NSValue]()
        values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)))
        values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)))
        values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values
        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName(rawValue: "easeInEaseOut"))
        view.layer.add(animation, forKey: nil)
    }
    
    @objc func maskViewTapAction(tap: UITapGestureRecognizer) {
        self.dismiss()
    }
    
    func dismiss() {
        self.privateAlertView.removeFromSuperview()
        self.maskrView.removeFromSuperview()
    }

}

class THPrivateAlertView: UIView {
    var userProtocol: (()->())?
    var privateProtocol: (()->())?
    
    var agreeCallBack: (()->())?
    var disAgreeCallBack: (()->())?

    let margin: CGFloat = 10
    var contents = [String]()
    
    var titleLabel = UILabel()
    var disAgreeBtn = UIButton()
    var agreeBtn = UIButton()

    lazy var contentTableView: UITableView = {
        let tableview = UITableView(frame: CGRect.zero, style: .grouped)
        let frame = CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude)
        tableview.tableHeaderView = UIView(frame: frame)
        tableview.backgroundColor = .white
        tableview.separatorStyle = .none
        tableview.delegate = self
        tableview.dataSource = self
        tableview.showsVerticalScrollIndicator = false
        tableview.estimatedRowHeight = 60
        tableview.register(THAgreeContentCell.self, forCellReuseIdentifier: "AgreeContentCell")
        return tableview
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, contents: [String]) {
        self.init(frame: frame)
        self.contents = contents
        self.setUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.backgroundColor = UIColor.white
        self.addSubview(titleLabel)
        self.addSubview(contentTableView)
        self.addSubview(disAgreeBtn)
        self.addSubview(agreeBtn)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(margin)
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
        }
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.text = "温馨提示"
        titleLabel.textColor = .black
        
        contentTableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(margin)
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(-60)
        }
        
        disAgreeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(contentTableView.snp.bottom).offset(margin+5)
            make.left.equalTo(margin)
            make.bottom.equalTo(-margin)
            make.width.equalTo(120)
        }
        disAgreeBtn.layer.cornerRadius = 6
        disAgreeBtn.layer.masksToBounds = true
        disAgreeBtn.backgroundColor = COLOR_999999
        disAgreeBtn.setTitle("不同意", for: .normal)
        disAgreeBtn.addTarget(self, action: #selector(disAgreeBtnAction(btn:)), for: .touchUpInside)
        
        agreeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(contentTableView.snp.bottom).offset(margin+5)
            make.right.bottom.equalTo(-margin)
            make.width.equalTo(120)
        }
        agreeBtn.layer.cornerRadius = 6
        agreeBtn.layer.masksToBounds = true
        agreeBtn.backgroundColor = MAIN_COLOR
        agreeBtn.setTitle("同意", for: .normal)
        agreeBtn.addTarget(self, action: #selector(agreeBtnAction(btn:)), for: .touchUpInside)
    }
    
    @objc func disAgreeBtnAction(btn: UIButton) {
        if self.disAgreeCallBack != nil {
            self.disAgreeCallBack!()
        }
    }
    
    @objc func agreeBtnAction(btn: UIButton) {
        if self.agreeCallBack != nil {
            self.agreeCallBack!()
        }
    }

}
extension THPrivateAlertView: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: THAgreeContentCell = tableView.dequeueReusableCell(withIdentifier: "AgreeContentCell") as! THAgreeContentCell
        cell.contentLabel.text = self.contents[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView: THAgreeFootView = THAgreeFootView(frame: CGRect(x: 0, y: 0, width: self.width, height: 60))
        footView.userProtocol = {
            if self.userProtocol != nil {
                self.userProtocol!()
            }
        }
        
        footView.privateProtocol = {
            if self.privateProtocol != nil {
                self.privateProtocol!()
            }
        }
        
        return footView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
}

class THAgreeContentCell: UITableViewCell {
    
    let margin: CGFloat = 10
    var contentLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.contentView.addSubview(contentLabel)
        contentLabel.textColor = UIColor.gray
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.numberOfLines = 0
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(margin)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-margin)
        }
    }
    
}

class THAgreeFootView: UIView {
    
    var userProtocol: (()->())?
    var privateProtocol: (()->())?

    let margin: CGFloat = 10
    var agreementLabel = YYLabel()
    let agreementText = "点击同意即表示您已阅读并同意《用户协议》与《隐私政策》"

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        let text = NSMutableAttributedString.init(string: agreementText)
        text.yy_lineSpacing = 5
        text.yy_font = UIFont.systemFont(ofSize: 15)
        text.yy_color = UIColor.black

        text.yy_setTextHighlight(NSMakeRange(14, 6), color: MAIN_COLOR, backgroundColor: UIColor.clear) { (containerView, text, range, rect) in
            if self.userProtocol != nil{
                self.userProtocol!()
            }
        }
        
        text.yy_setTextHighlight(NSMakeRange(agreementText.count - 6, 6), color: MAIN_COLOR, backgroundColor: UIColor.clear) { (containerView, text, range, rect) in
            if self.privateProtocol != nil {
                self.privateProtocol!()
            }
        }
        
        agreementLabel.numberOfLines = 0
        agreementLabel.preferredMaxLayoutWidth = self.width - 2 * margin
        agreementLabel.attributedText = text
        self.addSubview(agreementLabel)
        agreementLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
}


