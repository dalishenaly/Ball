//
//  THPublishDynamicVC.swift
//  BallRecord
//
//  Created by 买超 on 2019/12/13.
//  Copyright © 2019 maichao. All rights reserved.
//

import QMUIKit

class THPublishDynamicVC: THBaseVC {
    
    var draftModel: THVideoDraftModel?
    var editVideoPath: String?  //  合成视频所储存的路径
    var draftId: String?    //  草稿id
    
    
    
    var duration: Int?
    var vid: String?
    var aliVideoId: String?
    var videoPath: String?
    var coverPath: String?
    
    
    let textView = QMUITextView()
    lazy var coverView: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        return imgV
    }()
    
    lazy var imgBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "shipin_icon")
        return imgV
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:10"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var publishBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = MAIN_COLOR
        button.setTitle("发布", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(clickButtonEvent(sender:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        configFrame()
        configData()
    }

}

extension THPublishDynamicVC {
    
    func configUI() {
        
        title = "发布"
        view.addSubview(textView)
        view.addSubview(coverView)
        view.addSubview(publishBtn)
        
        coverView.addSubview(imgBottomView)
        imgBottomView.addSubview(iconView)
        imgBottomView.addSubview(timeLabel)
        
        textView.placeholder = "添加你此刻的想法吧（最多100字）"
        textView.maximumTextLength = 200
        textView.font = UIFont.systemFont(ofSize: 16)
        
    }
    
    func configFrame() {
        
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(15)
            make.height.equalTo(110)
        }
        
        coverView.snp.makeConstraints { (make) in
            make.left.equalTo(textView)
            make.top.equalTo(textView.snp_bottom).offset(15)
            make.height.equalTo(60)
            make.width.equalTo(coverView.snp_height).multipliedBy(1.5)
        }
        
        publishBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(coverView.snp_bottom).offset(70)
            make.width.equalTo(230)
            make.height.equalTo(40)
        }
        
        imgBottomView.snp.makeConstraints { (make) in
            make.left.equalTo(coverView)
            make.right.equalTo(coverView)
            make.bottom.equalTo(coverView)
            make.height.equalTo(15)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(imgBottomView).offset(3)
            make.centerY.equalTo(imgBottomView)
            make.width.height.equalTo(14)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(8)
            make.right.equalTo(imgBottomView)
            make.top.bottom.equalTo(imgBottomView)
        }
        
        textView.setCorner(cornerRadius: 4)
        coverView.setCorner(cornerRadius: 4)
        publishBtn.setCorner(cornerRadius: 4)
    }
    
    func configData() {
        
        THVideoRequestManager.requestPlay(videoId: self.aliVideoId ?? "", successBlock: { (response) in
            print("=")
            let model = THVideoInfoModel.yy_model(withJSON: response)
            self.coverView.setImage(urlStr: model?.cover ?? "", placeholder: placeholder_square)

        }) { (error) in
            QMUITips.hideAllTips()
            QMUITips.show(withText: error.localizedDescription)
        }
        timeLabel.text = getMMSSFromSS(totalTime: self.duration ?? 0)
    }
    
    
    func getMMSSFromSS(totalTime: Int) -> String {
        let minStr = NSString(format: "%02ld", totalTime%3600/60)
        let secondStr = NSString(format: "%02ld", totalTime%60)
        return NSString(format: "%@:%@", minStr, secondStr) as String
    }
    
    @objc func clickButtonEvent(sender: UIButton) {
        
        if textView.text.count <= 0 {
            QMUITips.show(withText: "请输入内容")
            return
        }
        QMUITips.showLoading(in: view)
        let param = ["vid": self.vid ?? "", "submitContent": textView.text ?? ""]
        THPlaygroundManager.requestPublishVideo(param: param, successBlock: { (result) in
            QMUITips.hideAllTips()
            QMUITips.show(withText: "发布成功")
        }) { (error) in
            QMUITips.hideAllTips()
            QMUITips.show(withText: error.localizedDescription)
        }
    }
    
//    func publish() {
//        
//        uploadCover()
//        uploadVideo()
//        
//        uploader?.start()
//    }
}
