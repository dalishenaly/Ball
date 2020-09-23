//
//  THRemindViewController.swift
//  BallRecord
//
//  Created by 二美子 on 2020/7/25.
//  Copyright © 2020 maichao. All rights reserved.
//

import UIKit

class THRemindViewController: THBaseVC {
    
    let textArray = ["广告","重复","标题夸张","色情低俗","播放不了","视频播放卡顿","视频声音和画面不同步，视频无声音","内容不完整","内容质量差","仇恨、暴力等令人反感的内容","其他问题，我要吐槽"]
    var currentSelectIndex = -1;
    lazy var tableView:UITableView = {
        let tableV = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        let tableHeaderView = THRemindTableHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 44))
        tableV.tableHeaderView = tableHeaderView
        let tableFooterView = THRemindTableFooterView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 90))
        tableFooterView.delegate = self
        tableV.tableFooterView = tableFooterView
        tableV.showsVerticalScrollIndicator = false
        tableV.showsHorizontalScrollIndicator = false
        tableV.dataSource = self
        tableV.delegate = self
        tableV.separatorStyle = .none
        tableV.register(THRemindTableViewCell.self, forCellReuseIdentifier: "THRemindTableViewCell")
        return tableV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "举报"
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(view)
        }
    }
}
extension THRemindViewController:UITableViewDataSource,UITableViewDelegate,THRemindTableViewCellDelegate,THRemindTableFooterViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:THRemindTableViewCell = tableView.dequeueReusableCell(withIdentifier: "THRemindTableViewCell")  as! THRemindTableViewCell
        cell.configure(title: textArray[indexPath.row], index: indexPath.row,selectedStatus: (indexPath.row == self.currentSelectIndex ? true:false))
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func cellDidSelect(index: Int) {
        self.currentSelectIndex = index
        self.tableView.reloadData()
    }
    func submitButtonClick() {
        QMUITips.showLoading(in: view)
        let random = arc4random_uniform(6) + 2
        print(random)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(integerLiteral: Int(random)), execute: {
            QMUITips.hideAllTips()
            QMUITips.show(withText: "提交成功,请等待工作人员审核")
        })
    }
}
extension DispatchTime: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}
@objc protocol THRemindTableViewCellDelegate {
    func cellDidSelect(index:Int)
}

class THRemindTableViewCell: UITableViewCell {
    private let chooseButton = UIButton(type: UIButton.ButtonType.custom)
    private let chooseLabel = UILabel()
    private var currentIndex = 0;
    weak var delegate: THRemindTableViewCellDelegate?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .white
        chooseButton.frame = CGRect(x: 15, y: 0, width: 40, height: 40)
        chooseButton.setImage(UIImage(named: "report_unchoose"), for: UIControl.State.normal)
        chooseButton.setImage(UIImage(named: "report_choose"), for: UIControl.State.selected)
        chooseButton.addTarget(self, action: #selector(chooseButtonSelect(button:)), for: UIControl.Event.touchUpInside)
        self.contentView.addSubview(chooseButton)
        
        chooseLabel.frame = CGRect(x: 55, y:10 , width: UIScreen.main.bounds.size.width-60, height: 18)
        chooseLabel.textColor = COLOR_333333
        chooseLabel.font = UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(chooseLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(title:String,index:Int,selectedStatus:Bool){
        chooseLabel.text = title
        currentIndex = index
        if selectedStatus {
            chooseButton.isSelected = true
            chooseLabel.textColor = COLOR_0076FF
        }else{
            chooseButton.isSelected = false
            chooseLabel.textColor = COLOR_333333;
        }
    }
    @objc func chooseButtonSelect(button:UIButton){
        if button.isSelected == false {
            delegate?.cellDidSelect(index: currentIndex)
        }
    }
}
class THRemindTableHeaderView:UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 244/255.0, green: 245/255.0, blue: 247/255.0, alpha: 1)
        let label = UILabel(frame: CGRect(x: 15, y: 20, width: 200, height: 17))
        label.textColor = .lightText
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "选择举报原因"
        label.textColor = COLOR_999999
        self.addSubview(label)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
@objc protocol THRemindTableFooterViewDelegate {
    func submitButtonClick()
}
class THRemindTableFooterView:UIView{
    weak var delegate: THRemindTableFooterViewDelegate?
    override init(frame: CGRect) {
        super.init(frame:frame)
        let subButton = UIButton(type: UIButton.ButtonType.custom)
        subButton.frame = CGRect(x: (self.bounds.size.width-260)/2, y: 50, width: 260, height: 40)
        subButton.backgroundColor = COLOR_0076FF
        subButton.layer.cornerRadius = 4;
        subButton.layer.masksToBounds = true
        subButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        subButton.setTitle("提交", for: UIControl.State.normal)
        subButton.setTitleColor(.white, for: UIControl.State.normal)
        subButton.addTarget(self, action: #selector(submitButtonSelect(button:)), for: UIControl.Event.touchUpInside)
        self.addSubview(subButton)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func submitButtonSelect(button:UIButton){
        delegate?.submitButtonClick()
    }
}
